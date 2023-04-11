import sqlite3

# How to work with an existing database

# Create a SQL connection to our existing SQLite database
con = sqlite3.connect("db/db.db")

# In order to execute SQL statements and fetch results from SQL queries,
# we will need to use a database cursor. Call con.cursor() to create the Cursor:
cur = con.cursor()

# Execute a SQL statement using the Cursor's execute() method.
cur.execute("""
    INSERT INTO users VALUES
        ('José María Landa Chávez', 26),
        ('Manuel Landa Chávez', 29)
""")

# The INSERT statement implicitly opens a transaction, which needs to be committed before
# changes are saved in the database Call con.commit() on the connection object 
# to commit the transaction:
con.commit()

# The result of a "cursor.execute" can be iterated over by row
for row in cur.execute('SELECT * FROM users;'):
    print(row)

# Be sure to close the connection
con.close()

# How to create a new database

# Lets create a new database 
# Call sqlite3.connect() to create a connection to the database tutorial.db,
# implicitly creating it if it does not exist:
con2 = sqlite3.connect("tutorial.db")

cur2 = con2.cursor()

cur2.execute("CREATE TABLE movie(title, year, score)")

cur2.execute("""
    INSERT INTO movie VALUES
        ('Monty Python and the Holy Grail', 1975, 8.2),
        ('And Now for Something Completely Different', 1971, 7.5)
""")

con2.commit()

res = cur2.execute("SELECT score FROM movie")
print(res.fetchall())

con2.close()