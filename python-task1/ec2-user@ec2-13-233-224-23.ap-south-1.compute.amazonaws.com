import pymysql
import time

# Wait for MySQL to start properly
time.sleep(20)

connection = pymysql.connect(
    host="13.233.224.23",
    user="root",
    password="root",
    port=3306
)

cursor = connection.cursor()

# Create database
cursor.execute("CREATE DATABASE IF NOT EXISTS company")
cursor.execute("USE company")

# Create table
cursor.execute("""
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(50),
    salary INT
)
""")

# Insert dummy data
data = [
     ("vineetha", "IT", 65000),
    ("eswari", "HR", 150000),
    ("siva", "Finance", 72000),
     ("vijay", "IT", 80000),
    ("abhiram", "HR", 90000),
    ("moses", "Finance", 172000)
]

cursor.executemany("INSERT INTO employees (name, role, salary) VALUES (%s, %s, %s)", data)
connection.commit()

# Display all data
cursor.execute("SELECT * FROM employees")
rows = cursor.fetchall()

print("\nEmployee Table Data:\n----------------------")
for row in rows:
    print(row)

connection.close()