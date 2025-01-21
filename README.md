# 🚀 SQL Query Assistant

A powerful natural language to SQL converter powered by Vanna.AI! Ask questions in plain English and get instant SQL queries and results from your MySQL database.

## ✨ Features

- 🗣️ Natural language to SQL conversion - just ask questions in plain English!
- 🤖 Smart AI model that learns from your database schema
- ⚡ Real-time query generation and execution
- 📊 Clean data visualization
- 🎯 Support for complex queries including JOINs and aggregations
- 🛡️ Built-in error handling and user feedback

## 🛠️ Prerequisites

- Python 3.7+
- MySQL Server
- Company database setup

## 🔧 Installation

1. Clone the repository:
```bash
git clone https://github.com/SambhavMehta228/sql-query-assistant.git
cd sql-query-assistant
```

2. Install required packages:
```bash
pip install streamlit vanna sqlalchemy pymysql pandas
```

3. Configure your database:
   - Make sure MySQL is running
   - Create a database named 'company_v2'
   - Update DB_CONFIG in sql_assistant.py if needed

4. Set up your Vanna API key:
   - Get your API key from Vanna.AI
   - Add it to the VANNA_API_KEY variable in sql_assistant.py

## 🚀 Usage

1. Run the application:
```bash
streamlit run sql_assistant.py
```

2. Open your web browser and navigate to http://localhost:8501

3. Start asking questions! Examples:
   - "How many employees are there in each department?"
   - "Show me the highest paid employees"
   - "List all projects and their team sizes"

## 📊 Database Structure

The application works with a company database that includes:
- Employees
- Departments
- Job Grades
- Projects
- Skills
- Performance Reviews

## 🌟 Features in Detail

1. **Smart Query Generation**
   - Converts natural language to SQL
   - Handles complex table relationships
   - Supports various query types

2. **Secure Database Integration**
   - Safe MySQL connection
   - Real-time query execution
   - Results in clean tabular format

3. **User-Friendly Interface**
   - 💭 Intuitive question input
   - ⚡ Real-time query generation
   - ✨ Interactive results display
   - 🎯 Clear success/error messages

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📝 License

[MIT License](LICENSE)

## 🙏 Acknowledgments

- Built with [Vanna.AI](https://vanna.ai/)
- Powered by Streamlit
- Uses SQLAlchemy for database operations
