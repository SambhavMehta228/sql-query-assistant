"""
SQL Query Assistant using Vanna.AI and Streamlit
Provides natural language to SQL conversion with persistent model training state.
"""

import os
import json
import yaml
from datetime import datetime
import pandas as pd
import streamlit as st
from sqlalchemy import create_engine, text
from vanna.remote import VannaDefault
import time
import hashlib

# Configuration
VANNA_API_KEY = ""
MODEL_NAME = ""  # Fixed model name linked to API key
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1551",
    "dbname": "company_v2",
    "port": 3306
}

class SQLAssistant(VannaDefault):
    """SQL Assistant that handles database operations and natural language processing."""
    
    def __init__(self, api_key):
        """Initialize the SQL Assistant with API key and setup state tracking."""
        super().__init__(model=MODEL_NAME, api_key=api_key)
        self.engine = None
        self._schema = None
        self.model_state_file = "model_state.json"
        self.training_data_file = "training_data.json"
        self.examples_file = "training_examples.yaml"
        self._training_examples = []
        
    def _calculate_schema_hash(self):
        """Calculate a hash of the database schema to detect changes."""
        try:
            with self.engine.connect() as conn:
                schema_query = """
                SELECT 
                    TABLE_NAME, 
                    COLUMN_NAME,
                    COLUMN_TYPE,
                    IS_NULLABLE,
                    COLUMN_KEY
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_SCHEMA = 'company_v2'
                ORDER BY TABLE_NAME, COLUMN_NAME
                """
                df_schema = pd.read_sql(schema_query, conn)
                schema_str = df_schema.to_json()
                return hashlib.md5(schema_str.encode()).hexdigest()
        except Exception as e:
            st.error(f"Error calculating schema hash: {str(e)}")
            return None

    def _save_training_data(self):
        """Save training data and schema hash to file."""
        try:
            training_data = {
                'schema_hash': self._calculate_schema_hash(),
                'examples': self._training_examples,
                'last_trained': datetime.now().isoformat()
            }
            with open(self.training_data_file, 'w') as f:
                json.dump(training_data, f)
        except Exception as e:
            st.error(f"Error saving training data: {str(e)}")

    def _load_training_data(self):
        """Load training data and verify schema hasn't changed."""
        try:
            if not os.path.exists(self.training_data_file):
                return False
                
            with open(self.training_data_file, 'r') as f:
                training_data = json.load(f)
                
            current_hash = self._calculate_schema_hash()
            if current_hash != training_data.get('schema_hash'):
                st.warning("Database schema has changed. Retraining required.")
                return False
                
            self._training_examples = training_data.get('examples', [])
            return True
        except Exception as e:
            st.error(f"Error loading training data: {str(e)}")
            return False

    def is_model_trained(self):
        """Check if model was already trained by looking for state file."""
        if os.path.exists(self.model_state_file):
            with open(self.model_state_file, 'r') as f:
                state = json.load(f)
                return state.get('trained', False)
        return False

    def mark_model_trained(self):
        """Save the training state to disk with timestamp."""
        state = {
            'trained': True,
            'last_trained': datetime.now().isoformat(),
            'num_examples': len(self._training_examples)
        }
        with open(self.model_state_file, 'w') as f:
            json.dump(state, f)

    def verify_schema(self):
        """Verify that we're connected to the correct database with the expected schema."""
        try:
            with self.engine.connect() as conn:
                # Check if we're connected to company_v2
                result = conn.execute(text("SELECT DATABASE()")).fetchone()
                if result[0] != 'company_v2':
                    raise Exception("Connected to wrong database. Expected 'company_v2'")
                
                # Verify key tables exist
                tables_to_check = [
                    'departments',
                    'employees',
                    'job_grades',
                    'projects',
                    'skills',
                    'performance_reviews'
                ]
                
                for table in tables_to_check:
                    result = conn.execute(text(f"SHOW TABLES LIKE '{table}'")).fetchone()
                    if not result:
                        raise Exception(f"Required table '{table}' not found")
                
                # Verify key columns in employees table
                columns = conn.execute(text("SHOW COLUMNS FROM employees")).fetchall()
                required_columns = ['emp_id', 'first_name', 'last_name', 'manager_id', 'dept_id', 'job_title']
                column_names = [col[0] for col in columns]
                
                for col in required_columns:
                    if col not in column_names:
                        raise Exception(f"Required column '{col}' not found in employees table")
                
                return True
                
        except Exception as e:
            st.error(f"Schema verification failed: {str(e)}")
            return False

    def get_actual_schema(self):
        """Fetch and return the actual database schema."""
        try:
            with self.engine.connect() as conn:
                # Get table definitions
                tables_info = {}
                for table in ['departments', 'employees']:
                    # Get table structure
                    columns = conn.execute(text(f"SHOW CREATE TABLE {table}")).fetchone()[1]
                    tables_info[table] = columns
                    
                    # Get column information
                    columns_query = f"""
                    SELECT 
                        COLUMN_NAME, 
                        COLUMN_TYPE,
                        IS_NULLABLE,
                        COLUMN_KEY,
                        COLUMN_DEFAULT,
                        EXTRA
                    FROM INFORMATION_SCHEMA.COLUMNS 
                    WHERE TABLE_SCHEMA = 'company_v2' 
                    AND TABLE_NAME = '{table}'
                    ORDER BY ORDINAL_POSITION
                    """
                    columns_df = pd.read_sql(columns_query, conn)
                    tables_info[f"{table}_columns"] = columns_df.to_dict('records')
                    
                    # Get sample data using pandas
                    sample_df = pd.read_sql(f"SELECT * FROM {table} LIMIT 1", conn)
                    if not sample_df.empty:
                        tables_info[f"{table}_sample"] = sample_df.to_dict('records')[0]
                
                return tables_info
        except Exception as e:
            st.error(f"Error fetching schema: {str(e)}")
            return None

    def setup_database(self):
        """Setup database connection and ensure model is trained."""
        try:
            connection_string = f"mysql+pymysql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['dbname']}"
            self.engine = create_engine(connection_string)
            
            self.connect_to_mysql(**DB_CONFIG)
            
            # Verify schema before proceeding
            if not self.verify_schema():
                return False
            
            with self.engine.connect() as conn:
                conn.execute(text("SELECT 1"))
                conn.commit()
                st.success("⚡ Database connected successfully!")

            # Check if we need to train
            if not self.is_model_trained() or not self._load_training_data():
                st.info("🤖 Training model with examples...")
                if not self.train_model():
                    return False
                self._save_training_data()
                st.success("✨ Model trained successfully!")
            else:
                st.success("🎯 Using previously trained model")
            
            return True
            
        except Exception as e:
            st.error(f"❌ Setup failed: {str(e)}")
            return False

    def _load_training_examples(self):
        """Load and process training examples from YAML file according to Vanna.ai format."""
        try:
            if not os.path.exists(self.examples_file):
                st.error(f"Training examples file not found: {self.examples_file}")
                return []
                
            with open(self.examples_file, 'r') as f:
                data = yaml.safe_load(f)
                
            examples = []
            
            # Process documentation
            for doc in data.get('documentation', []):
                if isinstance(doc, dict) and 'text' in doc:
                    examples.append(('documentation', doc['text']))
            
            # Process DDL statements
            for ddl_group in data.get('ddl_statements', []):
                for statement in ddl_group.get('statements', []):
                    examples.append(('ddl', statement))
            
            # Process SQL examples
            for sql_group in data.get('sql_examples', []):
                for statement in sql_group.get('statements', []):
                    examples.append(('sql', statement))
            
            # Process question-SQL pairs
            for category in data.get('question_sql_pairs', []):
                for pair in category.get('pairs', []):
                    examples.append(('pair', (pair['question'], pair['sql'])))
            
            return examples
            
        except Exception as e:
            st.error(f"Error loading training examples: {str(e)}")
            return []

    def train_database_schema(self):
        """Train the model with the current database schema."""
        try:
            with self.engine.connect() as conn:
                # First, get the information schema
                schema_query = """
                SELECT 
                    TABLE_NAME, 
                    COLUMN_NAME,
                    COLUMN_TYPE,
                    IS_NULLABLE,
                    COLUMN_KEY,
                    COLUMN_COMMENT
                FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_SCHEMA = 'company_v2'
                """
                df_schema = pd.read_sql(schema_query, conn)
                
                # Train on table structures
                for table_name in df_schema['TABLE_NAME'].unique():
                    # Get columns for this table
                    table_cols = df_schema[df_schema['TABLE_NAME'] == table_name]
                    
                    # Create DDL statement
                    ddl = f"CREATE TABLE {table_name} (\n"
                    ddl += ",\n".join([
                        f"  {row['COLUMN_NAME']} {row['COLUMN_TYPE']} " + 
                        f"{'NOT NULL' if row['IS_NULLABLE'] == 'NO' else ''} " +
                        f"{'PRIMARY KEY' if row['COLUMN_KEY'] == 'PRI' else ''}"
                        for _, row in table_cols.iterrows()
                    ])
                    ddl += "\n);"
                    
                    # Train on DDL
                    super().train(ddl=ddl)
                    
                    # Add documentation about relationships
                    if 'manager_id' in table_cols['COLUMN_NAME'].values:
                        doc = f"In the {table_name} table, manager_id refers to emp_id of the employee's manager"
                        super().train(documentation=doc)
                    
                    if 'dept_id' in table_cols['COLUMN_NAME'].values:
                        doc = f"In the {table_name} table, dept_id is a foreign key to departments table"
                        super().train(documentation=doc)
                
            return True
        except Exception as e:
            st.error(f"Schema training failed: {str(e)}")
            return False

    def train_model(self):
        """Train the model according to Vanna.ai documentation format."""
        try:
            # Clear existing training data
            self.clear_training()
            
            # First, train with database schema
            self.train_database_schema()
            
            # Wait a bit to ensure schema training is processed
            time.sleep(2)
            
            # Load and train with examples
            examples = self._load_training_examples()
            self._training_examples = examples
            
            # Train in smaller batches
            batch_size = 3
            for i in range(0, len(examples), batch_size):
                batch = examples[i:i + batch_size]
                for example_type, content in batch:
                    try:
                        if example_type == 'documentation':
                            super().train(documentation=content)
                        elif example_type == 'ddl':
                            super().train(ddl=content)
                        elif example_type == 'sql':
                            super().train(sql=content)
                        elif example_type == 'pair':
                            question, sql = content
                            super().train(question=question, sql=sql)
                        time.sleep(0.5)
                    except Exception as e:
                        st.warning(f"Failed to train example type {example_type}. Error: {str(e)}")
                        continue
                time.sleep(1)
            
            # Mark as trained only if we successfully processed some examples
            if len(self._training_examples) > 0:
                self.mark_model_trained()
            return True
            return False

        except Exception as e:
            st.error(f"Training failed: {str(e)}")
            return False

    def get_sql_for_question(self, question):
        """Generate SQL query from natural language question."""
        try:
            response = super().generate_sql(question)
            
            if isinstance(response, str):
                return response
            elif isinstance(response, dict) and 'sql' in response:
                return response['sql']
            return None
        except Exception as e:
            st.error(f"Error generating SQL: {str(e)}")
            return None

    def execute_query(self, sql):
        """Execute SQL query and return results as a pandas DataFrame."""
        try:
            if not sql:
                return None
            
            with self.engine.connect() as conn:
                result = conn.execute(text(sql))
                return pd.DataFrame(result.fetchall(), columns=result.keys())
        except Exception as e:
            st.error(f"Error executing SQL: {str(e)}")
            return None

    def clear_training(self):
        """Clear all training examples and reset model state."""
        self._training_examples = []
        if os.path.exists(self.model_state_file):
            os.remove(self.model_state_file)
        if os.path.exists(self.training_data_file):
            os.remove(self.training_data_file)

    def get_schema_info(self):
        """Get the database schema information."""
        try:
            with self.engine.connect() as conn:
                # Get all tables
                tables = conn.execute(text("SHOW TABLES")).fetchall()
                schema_info = {}
                
                # Get columns for each table
                for table in tables:
                    table_name = table[0]
                    columns = conn.execute(text(f"SHOW COLUMNS FROM {table_name}")).fetchall()
                    schema_info[table_name] = [
                        {
                            'name': col[0],
                            'type': col[1],
                            'null': col[2],
                            'key': col[3],
                            'default': col[4],
                            'extra': col[5]
                        }
                        for col in columns
                    ]
                return schema_info
        except Exception as e:
            st.error(f"Error fetching schema: {str(e)}")
            return None

def main():
    """Main application entry point."""
    st.title("🚀 SQL Query Assistant")

    # Initialize SQL Assistant
    assistant = SQLAssistant(api_key=VANNA_API_KEY)

    # Setup database connection
    if not assistant.setup_database():
        st.error("❌ Failed to connect to database")
        return

    # Main query interface
    user_question = st.text_input("💭 What would you like to know?")

    if user_question:
        with st.spinner("🔄 Generating SQL query..."):
            sql_query = assistant.get_sql_for_question(user_question)
            
            if sql_query:
                st.code(sql_query, language="sql")
                
        if st.button("▶️ Run Query"):
            with st.spinner("⚡ Executing query..."):
                try:
                    results = assistant.execute_query(sql_query)
                    if isinstance(results, pd.DataFrame):
                        st.success("✅ Query executed successfully!")
                        st.dataframe(results)
                    else:
                        st.info("ℹ️ No results returned.")
                except Exception as e:
                    st.error(f"❌ Error: {str(e)}")

if __name__ == "__main__":
    main()
