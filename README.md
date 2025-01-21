# SQL Query Assistant

A natural language to SQL query converter built with Streamlit and Vanna.AI. This tool allows users to ask questions in plain English and get corresponding SQL queries and results from a MySQL database.

## Features

- Natural language to SQL conversion
- Interactive web interface using Streamlit
- Real-time SQL query generation
- Immediate query execution and results display
- Support for complex queries including JOINs and aggregations
- Error handling and user feedback

## Prerequisites

- Python 3.7+
- MySQL Server
- Company database setup

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd sql-query-assistant
```

2. Install required packages:
```bash
pip install streamlit vanna sqlalchemy pymysql pandas
```

3. Configure your database:
   - Make sure MySQL is running
   - Create a database named 'company'
   - Update DB_CONFIG in sql_assistant.py if needed

4. Set up your Vanna API key:
   - Get your API key from Vanna.AI
   - Add it to the VANNA_API_KEY variable in sql_assistant.py

## Usage

1. Run the application:
```bash
streamlit run sql_assistant.py
```

2. Open your web browser and navigate to the provided URL (usually http://localhost:8501)

3. Start asking questions! Example queries:
   - "How many employees are there?"
   - "Show employee count by department"
   - "List employee names and departments"

## Example Database Schema

The application is configured to work with a company database that includes:
- employee table
- department table
- dept_locations table
- project table
- works_on table

## Features in Detail

1. **Natural Language Processing**
   - Converts plain English questions to SQL queries
   - Handles complex relationships between tables
   - Supports various types of queries

2. **Database Integration**
   - Secure MySQL connection
   - Real-time query execution
   - Results displayed in a clean tabular format

3. **User Interface**
   - Clean and intuitive Streamlit interface
   - SQL query preview before execution
   - Interactive query execution
   - Clear error messages and feedback

## Contributing

Feel free to submit issues and enhancement requests!

## License

[Your chosen license]

## Acknowledgments

- Built with [Vanna.AI](https://vanna.ai/)
- Powered by Streamlit
- Uses SQLAlchemy for database operations
