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