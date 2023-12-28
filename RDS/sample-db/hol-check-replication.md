## Sample Postgres database
```sql
-- Create the sample database
CREATE DATABASE sample_database;
\c sample_database;

-- Create tables
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    registration_date DATE
);

CREATE TABLE posts (
    post_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    created_at TIMESTAMP
);

-- Insert sample data
INSERT INTO users (username, email, registration_date)
VALUES
    ('john_doe', 'john.doe@example.com', '2023-01-01'),
    ('jane_smith', 'jane.smith@example.com', '2023-01-05');

INSERT INTO posts (user_id, title, content, created_at)
VALUES
    (1, 'Introduction to SQL', 'SQL is a powerful language for managing relational databases.', '2023-01-02'),
    (1, 'Advanced SQL Techniques', 'Learn advanced SQL techniques to optimize your database queries.', '2023-01-03'),
    (2, 'Database Design Best Practices', 'Explore best practices for designing efficient and scalable databases.', '2023-01-07');

```

## Update user table
```sql
-- Insert new users
INSERT INTO users (username, email, registration_date)
VALUES
    ('alice_wonder', 'alice.wonder@example.com', '2023-01-10'),
    ('bob_coder', 'bob.coder@example.com', '2023-01-15');

```

## Update Post table
```sql
-- Get the user IDs for the newly added users
WITH new_user_ids AS (
    SELECT user_id
    FROM users
    WHERE username IN ('alice_wonder', 'bob_coder')
)

-- Insert posts for the new users
INSERT INTO posts (user_id, title, content, created_at)
SELECT
    nu.user_id,
    'Post by ' || u.username || ' ' || generate_series,
    'This is the content of the post by ' || u.username,
    NOW() - INTERVAL '2 days' * generate_series
FROM new_user_ids nu
JOIN users u ON nu.user_id = u.user_id
CROSS JOIN generate_series(1, 5);

```



## Sample Database MySQL
```sql
-- Create the database
CREATE DATABASE IF NOT EXISTS blog_db;
USE blog_db;

-- Create the users table
CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into the users table
INSERT INTO users (username, email) VALUES
    ('john_doe', 'john.doe@example.com'),
    ('jane_smith', 'jane.smith@example.com'),
    ('bob_jones', 'bob.jones@example.com');

-- Create the posts table
CREATE TABLE IF NOT EXISTS posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert sample data into the posts table
INSERT INTO posts (title, content, user_id) VALUES
    ('Introduction to MySQL', 'This is a post about MySQL.', 1),
    ('Web Development Tips', 'Learn tips and tricks for web development.', 2),
    ('Database Design Best Practices', 'Explore best practices for database design.', 3);

-- Create the comments table
CREATE TABLE IF NOT EXISTS comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    text TEXT NOT NULL,
    user_id INT,
    post_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Insert sample data into the comments table
INSERT INTO comments (text, user_id, post_id) VALUES
    ('Great post!', 2, 1),
    ('I have a question about web development.', 3, 2),
    ('Thanks for sharing these best practices!', 1, 3);

```
### Insert data
```sql
-- Insert additional users
INSERT INTO users (username, email) VALUES
    ('mary_jones', 'mary.jones@example.com'),
    ('alex_smith', 'alex.smith@example.com');

-- Insert additional posts
INSERT INTO posts (title, content, user_id) VALUES
    ('Advanced MySQL Techniques', 'Explore advanced techniques in MySQL.', 1),
    ('Responsive Web Design', 'Learn about creating responsive web designs.', 2);

-- Insert additional comments
INSERT INTO comments (text, user_id, post_id) VALUES
    ('I found the advanced MySQL techniques very helpful!', 3, 4),
    ('Can you recommend any resources for responsive web design?', 4, 5);

```
