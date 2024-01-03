```sql
\c university;
SELECT * FROM students;
SELECT * FROM courses;
SELECT * FROM enrollments;

```


```sql
-- Schema Script
CREATE DATABASE crm;
\c crm;
-- ... (Copy and paste the rest of the schema script)

-- Data Script
-- ... (Copy and paste the entire data script)

```
```sql
\c crm
\dt  -- List tables
SELECT * FROM customers LIMIT 5;  -- View sample data
```
```sql
SELECT * FROM customers WHERE last_name = 'LastName1';
```