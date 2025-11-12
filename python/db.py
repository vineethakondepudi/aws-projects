import mysql.connector

# Connect to MySQL container
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root123",
    port=3306
)

cursor = connection.cursor()

# 1️⃣ Create a new database
cursor.execute("CREATE DATABASE IF NOT EXISTS mydb;")
cursor.execute("USE mydb;")

# 2️⃣ Create a new table
cursor.execute("""
CREATE TABLE IF NOT EXISTS employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary FLOAT
);
""")

# 3️⃣ Insert sample data
insert_query = "INSERT INTO employees (name, department, salary) VALUES (%s, %s, %s)"
data = [
    ("vineetha", "IT", 65000),
    ("eswari", "HR", 150000),
    ("siva", "Finance", 72000),
     ("vijay", "IT", 80000),
    ("abhiram", "HR", 90000),
    ("moses", "Finance", 172000)
]
cursor.executemany(insert_query, data)
connection.commit()

# 4️⃣ Fetch and display data
cursor.execute("SELECT * FROM employees;")
rows = cursor.fetchall()

print("Employees Data:")
for row in rows:
    print(row)

# 5️⃣ Close the connection
cursor.close()
connection.close()
