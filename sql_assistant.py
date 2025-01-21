from vanna.remote import VannaDefault
import streamlit as st
import os
import pandas as pd
from sqlalchemy import create_engine, text

# API Keys configuration
VANNA_API_KEY = ""

# Database configuration
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "1551",
    "database": "company",
    "port": 3306
}

class SQLAssistant(VannaDefault):
    def __init__(self, api_key):
        # Initialize with the model you have access to
        super().__init__(model='zambhavvziiii', api_key=api_key)
        self.engine = None
        self.is_trained = False
        self._schema = None

    def setup_database(self):
        """Setup database connection with error handling"""
        try:
            # Create SQLAlchemy engine
            connection_string = f"mysql+pymysql://{DB_CONFIG['user']}:{DB_CONFIG['password']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
            self.engine = create_engine(connection_string)
            
            # Connect using Vanna's method
            self.connect_to_mysql(
                host=DB_CONFIG["host"],
                dbname=DB_CONFIG["database"],
                user=DB_CONFIG["user"],
                password=DB_CONFIG["password"],
                port=DB_CONFIG["port"]
            )
            
            # Test connection
            with self.engine.connect() as conn:
                conn.execute(text("SELECT 1"))
                conn.commit()

            # Get schema and train
            self.train_model()
            
            self.is_trained = True
            st.success("Connected to database and trained successfully!")
            return True
            
        except Exception as e:
            st.error(f"Setup failed: {str(e)}")
            return False

    def train_model(self):
        """Train the model with schema and examples"""
        try:
            # Simplified training with just examples
            examples = [
                ("How many employees are there?", 
                 "SELECT COUNT(*) as total_employees FROM employee"),
                ("Show employee count by department", 
                 "SELECT d.dname, COUNT(e.ssn) as emp_count FROM department d LEFT JOIN employee e ON d.dnumber = e.dno GROUP BY d.dname"),
                ("List employee names and departments", 
                 "SELECT e.fname, e.lname, d.dname FROM employee e JOIN department d ON e.dno = d.dnumber")
            ]
            
            # Train with each example
            for question, sql in examples:
                self.train(question=question, sql=sql)

            return True

        except Exception as e:
            st.error(f"Training failed: {str(e)}")
            return False

    def get_sql_for_question(self, question):
        """Generate SQL query from natural language question"""
        try:
            # Use generate_sql method from parent class
            response = super().generate_sql(question)
            
            # Handle different response formats
            if isinstance(response, str):
                return response
            elif isinstance(response, dict) and 'sql' in response:
                return response['sql']
            return None
        except Exception as e:
            st.error(f"Error generating SQL: {str(e)}")
            return None

    def execute_query(self, sql):
        """Execute SQL query and return results"""
        try:
            if not sql:
                return None
            
            # Execute using SQLAlchemy
            with self.engine.connect() as conn:
                result = conn.execute(text(sql))
                return pd.DataFrame(result.fetchall(), columns=result.keys())
        except Exception as e:
            st.error(f"Error executing SQL: {str(e)}")
            return None

def main():
    st.title("Database Query Assistant")

    # Initialize Assistant
    assistant = SQLAssistant(api_key=VANNA_API_KEY)

    # Setup database connection
    if assistant.setup_database():
        try:
            # User input section
            st.write("### Ask your question")
            user_question = st.text_input("Enter your question (e.g., 'How many employees are there?')")

            if user_question:
                with st.spinner("Generating SQL query..."):
                    sql_query = assistant.get_sql_for_question(user_question)
                    
                    if sql_query:
                        st.write("#### Generated SQL Query:")
                        st.code(sql_query, language="sql")
                        
                        if st.button("Execute Query"):
                            with st.spinner("Executing query..."):
                                results = assistant.execute_query(sql_query)
                                if results is not None:
                                    st.write("#### Query Results:")
                                    st.dataframe(results)

        except Exception as e:
            st.error(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    main() 