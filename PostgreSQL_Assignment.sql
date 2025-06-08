-- Active: 1745789994448@@127.0.0.1@5432@bookstore_db

-- Create a "books" table.

CREATE TABLE books (
    id INT PRIMARY KEY UNIQUE,
    title VARCHAR(50) NOT NULL,
    author VARCHAR(50),
    price INT NOT NULL CHECK (price >= 0),
    stock INT NOT NULL CHECK (stock >= 0),
    published_year SMALLINT check (published_year >= 0)
);

-- Create a "customers" table.
CREATE TABLE customers (
    id INT PRIMARY KEY UNIQUE,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE,
    joined_date DATE
);

-- Create a "orders" table.
CREATE TABLE orders (
    id INT PRIMARY KEY UNIQUE,
    customers_id INT REFERENCES customers (id) NOT NULL,
    book_id INT REFERENCES books (id) NOT NULL,
    quantity INT CHECK (quantity > 0),
    order_date TIMESTAMP
);

-- insert books data into "books" table

INSERT INTO
    books (
        "id",
        title,
        author,
        price,
        stock,
        published_year
    )
VALUES (
        1,
        'The Pragmatic Programmer',
        'Andrew Hunt',
        40.00,
        10,
        1999
    ),
    (
        2,
        'Clean Code',
        'Robert C.Martin',
        35.00,
        5,
        2008
    ),
    (
        3,
        E'You Don\'t Know JS',
        'Kyle Simpson',
        30.00,
        8,
        2014
    ),
    (
        4,
        'Refactoring',
        'Martin Fowler',
        50.00,
        3,
        1999
    ),
    (
        5,
        'Database Design Principles',
        'Jane Smith',
        20.00,
        0,
        2018
    );

-- Insert data into customers table
INSERT INTO
    customers (id, name, email, joined_date)
VALUES (
        1,
        'Alice',
        'alice@email.com',
        '2023-01-10'
    ),
    (
        2,
        'Bob',
        'bob@email.com',
        '2022-05-15'
    ),
    (
        3,
        'Charlie',
        'charlie@email.com',
        '2023-06-20'
    )

-- insert data into orders table
INSERT INTO
    orders (
        id,
        customers_id,
        book_id,
        quantity,
        order_date
    )
VALUES (1, 1, 2, 1, '2024-03-10'),
    (2, 2, 1, 1, '2024-02-20'),
    (3, 1, 3, 2, '2024-03-05')

----------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------- Solutions -------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

--   1. Find books that are out of stock
SELECT * from books WHERE stock = 0;

--   2. Retrieve the most expensive book in the store

SELECT * from books WHERE price = ( SELECT max(price) FROM books );

--   3. Find the total number of orders placed by each customer.

SELECT name, count(*) as total_orders
from customers
    JOIN orders ON customers.id = orders.customers_id
GROUP BY
    customers.id
ORDER BY name;

--   4. Calculate the total revenue generated from book sales.

SELECT sum(price * quantity) AS total_revenue
FROM orders
    JOIN books ON books.id = orders.book_id;

--   5. List all customers who have placed more than one orders.

SELECT *
from (
        SELECT name, count(*) AS orders_count
        from orders
            JOIN customers ON customers.id = orders.customers_id
        GROUP BY
            customers.id
    )
WHERE
    orders_count > 1;

--   6. Find the average price of books in the store.
SELECT round(avg(price)) as avg_book_price from books;

--   7. Increase the price of all books published before 2000 by 10%.

UPDATE books SET price = price + (price * 10) / 100 WHERE id < 2000;

--   8. Delete customers who haven't placed any orders.

DELETE FROM customers
WHERE
    id NOT IN (
        SELECT customers_id
        FROM orders
    );