-- PostgreSQL Docker Volume Project
-- Database initialization script

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(100) NOT NULL
);

INSERT INTO users (name, role)
VALUES
    ('Amir', 'DevOps Student'),
    ('Docker', 'Container'),
    ('PostgreSQL', 'Database');
