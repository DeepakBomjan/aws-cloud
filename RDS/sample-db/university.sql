-- Create the database
CREATE DATABASE university;

-- Connect to the database
\c university;

-- Create the students table
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE
);

-- Create the courses table
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    instructor VARCHAR(100)
);

-- Create the enrollments table
CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INTEGER REFERENCES students(student_id),
    course_id INTEGER REFERENCES courses(course_id),
    enrollment_date DATE
);

-- Insert sample data into the students table
INSERT INTO students (first_name, last_name, date_of_birth)
VALUES 
    ('John', 'Doe', '1995-03-15'),
    ('Jane', 'Smith', '1998-07-22'),
    ('Bob', 'Johnson', '1993-11-10');

-- Insert sample data into the courses table
INSERT INTO courses (course_name, instructor)
VALUES 
    ('Introduction to Computer Science', 'Dr. Smith'),
    ('Mathematics for Beginners', 'Prof. Johnson'),
    ('History of Art', 'Dr. Davis');

-- Insert sample data into the enrollments table
INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES 
    (1, 1, '2022-01-10'),
    (1, 2, '2022-01-12'),
    (2, 1, '2022-01-15'),
    (3, 3, '2022-01-20');
