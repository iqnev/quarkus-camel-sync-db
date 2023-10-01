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


-- Insert dummy test data into the "user" table
INSERT INTO "user" (username, password, email, created_at, last_modified)
VALUES ('john_doe', 'password123', 'john.doe@example.com', '2023-09-25 12:00:00',
        '2023-09-25 12:00:00'),
       ('jane_smith', 'secret456', 'jane.smith@example.com', '2023-09-26 14:30:00',
        '2023-09-26 14:30:00'),
       ('alice_miller', 'mypassword', 'alice.miller@example.com', '2023-09-27 09:15:00',
        '2023-09-27 09:15:00');
