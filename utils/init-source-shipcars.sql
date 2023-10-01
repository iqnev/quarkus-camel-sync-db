-- Create a database for the ship cars service
CREATE DATABASE shipcars;
\c shipcars;

CREATE TABLE customers
(
    customer_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    email         VARCHAR(100) UNIQUE,
    phone_number  VARCHAR(15),
    address       TEXT,
    created_at    timestamp default now()::timestamp without time zone,
    last_modified TIMESTAMP DEFAULT now()::timestamp without time zone
);

CREATE TABLE cars
(
    car_id        SERIAL PRIMARY KEY,
    make          VARCHAR(50),
    model         VARCHAR(50),
    year          INTEGER,
    vin           VARCHAR(17) UNIQUE,
    owner_id      INT REFERENCES customers (customer_id),
    created_at    timestamp default now()::timestamp without time zone,
    last_modified TIMESTAMP DEFAULT now()::timestamp without time zone
);

CREATE TABLE shipments
(
    shipment_id          SERIAL PRIMARY KEY,
    car_id               INT REFERENCES cars (car_id),
    ship_date            DATE,
    arrival_date         DATE,
    origin_location      VARCHAR(100),
    destination_location VARCHAR(100),
    status               VARCHAR(100),
    created_at           timestamp default now()::timestamp without time zone,
    last_modified        TIMESTAMP DEFAULT now()::timestamp without time zone
);

CREATE TABLE shipment_history
(
    history_id    SERIAL PRIMARY KEY,
    shipment_id   INT REFERENCES shipments (shipment_id),
    status        VARCHAR(100),
    status_date   TIMESTAMP,
    created_at    timestamp default now()::timestamp without time zone,
    last_modified TIMESTAMP DEFAULT now()::timestamp without time zone
);

INSERT INTO customers (first_name, last_name, email, phone_number, address)
VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Main St, Cityville'),
       ('Alice', 'Smith', 'alice.smith@example.com', '987-654-3210', '456 Elm St, Townsville'),
       ('Bob', 'Johnson', 'bob.johnson@example.com', '555-123-4567', '789 Oak St, Villagetown'),
       ('Eve', 'Williams', 'eve.williams@example.com', '777-888-9999', '101 Pine St, Hamletville');



INSERT INTO cars (make, model, year, vin, owner_id)
VALUES ('Toyota', 'Camry', 2020, '1HGCM82633A123456', 1),
       ('Ford', 'F-150', 2021, '1FTFW1EF2MFA78901', 2),
       ('Honda', 'Civic', 2019, '2HGFC2F59KH123456', 3);

INSERT INTO shipments (car_id, ship_date, arrival_date, origin_location, destination_location,
                       status)
VALUES (1, '2023-09-15', '2023-09-20', 'Los Angeles, CA', 'New York, NY', 'In Transit'),
       (2, '2023-09-18', '2023-09-25', 'Chicago, IL', 'Miami, FL', 'In Transit'),
       (3, '2023-09-20', '2023-09-22', 'San Francisco, CA', 'Seattle, WA', 'Delivered');

INSERT INTO shipment_history (shipment_id, status, status_date)
VALUES (1, 'In Transit', '2023-09-17 14:45:00'),
       (1, 'Arrived at Destination', '2023-09-20 09:15:00'),
       (2, 'In Transit', '2023-09-18 11:30:00'),
       (2, 'Arrived at Destination', '2023-09-25 12:00:00'),
       (3, 'Delivered', '2023-09-22 16:30:00');