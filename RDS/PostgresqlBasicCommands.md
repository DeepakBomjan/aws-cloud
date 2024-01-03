1. list database
```sql
postgres=> \list

```
2. list table
```sql
postgres=> \dt
```

3. list users
```sql
postgres=> \du
```

4. Show current database
```sql
SELECT current_database();
```

5. Create owner and grant all privileges
```sql
CREATE ROLE hho WITH LOGIN PASSWORD 'changeme' CREATEDB CREATEROLE;

GRANT ALL PRIVILEGES ON DATABASE your_database TO hho;

```
6. Check User
```sql
SELECT current_user;
```
7. Grant membership 
```sql
GRANT hho TO postgres;
REVOKE hho FROM postgres;
ALTER USER postgres SET ROLE hho;
```
8. List tables spaces
```sql
SELECT * FROM pg_tablespace;
```

9. List schema
```sql
SELECT schema_name
FROM information_schema.schemata;

```


