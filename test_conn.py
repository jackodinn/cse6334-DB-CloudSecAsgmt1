import os
import pyodbc #type: ignore
from dotenv import load_dotenv

load_dotenv()

def test_sql_connection():
    # Use the exact driver name you found in the ODBC Data Source Administrator
    driver = "{ODBC Driver 17 for SQL Server}" 
    server = os.getenv('DB_SERVER')
    database = os.getenv('DB_NAME')
    user = os.getenv('DB_USER')
    password = os.getenv('DB_PASSWORD')

    conn_str = (
        f"DRIVER={driver};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={user};"
        f"PWD={password};"
        "Encrypt=yes;"
        "TrustServerCertificate=yes;"
    )

    print(f"Attempting to connect to {server}...")

    try:
        conn = pyodbc.connect(conn_str, timeout=5)
        cursor = conn.cursor()
        cursor.execute("SELECT @@VERSION")
        row = cursor.fetchone()
        print("\n✅ CONNECTION SUCCESSFUL!")
        print(f"SQL Server Version: {row[0]}")
        conn.close()
    except Exception as e:
        print("\n❌ CONNECTION FAILED")
        print(f"Error: {e}")

if __name__ == "__main__":
    test_sql_connection()