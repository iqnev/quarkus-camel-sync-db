CREATE DATABASE mydb;
\c mydb;


CREATE TABLE IF NOT EXISTS "user"
(
    user_id       serial PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL,
    password      VARCHAR(50)  NOT NULL,
    email         VARCHAR(255) NOT NULL,
    created_at    timestamp default now()::timestamp without time zone,
    last_modified TIMESTAMP DEFAULT now()::timestamp without time zone
);