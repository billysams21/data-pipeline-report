
CREATE SCHEMA IF NOT EXISTS raw;

CREATE TABLE IF NOT EXISTS raw.customers (
    id INT PRIMARY KEY,
    name VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS raw.orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES raw.customers(id)
);

INSERT INTO raw.customers (id, name) VALUES
(1, 'Michael'),
(2, 'Jennifer'),
(3, 'Christopher')
ON CONFLICT (id) DO NOTHING;

INSERT INTO raw.orders (id, customer_id, order_date, amount) VALUES
(1, 1, '2023-01-15', 150.75),
(2, 1, '2023-01-20', 200.00),
(3, 2, '2023-02-10', 75.50),
(4, 3, '2023-02-12', 300.25),
(5, 3, '2023-02-15', 50.00)
ON CONFLICT (id) DO NOTHING;
