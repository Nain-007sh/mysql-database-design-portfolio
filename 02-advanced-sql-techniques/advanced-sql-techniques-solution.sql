-- ============================================================
-- Advanced SQL Assignment 02 - MySQL
-- Course  : Database Management Systems
-- Instructor: Ahmed Shahzad
-- Focus   : Subqueries, Aggregates, CTEs (No JOINs)
-- ============================================================

-- ============================================================
-- QUESTION 1
-- Titles and prices of books published before 2000 and price > 25.00
-- Ordered by price DESC
-- ============================================================

SELECT title, price
FROM Books
WHERE publication_year < 2000
  AND price > 25.00
ORDER BY price DESC;


-- ============================================================
-- QUESTION 2
-- book_id, title, stock_quantity for books whose stock_quantity
-- is less than the average stock_quantity of 'Mystery' genre books
-- ============================================================

SELECT book_id, title, stock_quantity
FROM Books
WHERE stock_quantity < (
    SELECT AVG(stock_quantity)
    FROM Books
    WHERE genre = 'Mystery'
);


-- ============================================================
-- QUESTION 3
-- customer_id and email of customers who:
--   - placed at least 3 orders
--   - email contains 'example.com'
-- ============================================================

SELECT customer_id, email
FROM Customers
WHERE email LIKE '%example.com%'
  AND customer_id IN (
      SELECT customer_id
      FROM Orders
      GROUP BY customer_id
      HAVING COUNT(order_id) >= 3
  );


-- ============================================================
-- QUESTION 4
-- book_id and title of books:
--   - ordered more than 5 times in total (across all Order_Items)
--   - price < 30.00
-- ============================================================

SELECT book_id, title
FROM Books
WHERE price < 30.00
  AND book_id IN (
      SELECT book_id
      FROM Order_Items
      GROUP BY book_id
      HAVING SUM(quantity) > 5
  );


-- ============================================================
-- QUESTION 5
-- title, author_id, and price of books whose price is higher
-- than ANY book written by author_id = 101
-- ============================================================

SELECT title, author_id, price
FROM Books
WHERE price > ANY (
    SELECT price
    FROM Books
    WHERE author_id = 101
);


-- ============================================================
-- QUESTION 6
-- order_id for orders that contain more than one unique book_id
-- ============================================================

SELECT order_id
FROM Order_Items
GROUP BY order_id
HAVING COUNT(DISTINCT book_id) > 1;


-- ============================================================
-- QUESTION 7
-- Titles of books that:
--   - have 'History' genre
--   - were published in the same year as book_id = 105
-- ============================================================

SELECT title
FROM Books
WHERE genre = 'History'
  AND publication_year = (
      SELECT publication_year
      FROM Books
      WHERE book_id = 105
  );


-- ============================================================
-- QUESTION 8
-- book_id, title, genre of books that:
--   - stock_quantity < average stock_quantity of all books
--   - genre is 'Fiction' OR 'Biography'
-- ============================================================

SELECT book_id, title, genre
FROM Books
WHERE stock_quantity < (
        SELECT AVG(stock_quantity)
        FROM Books
    )
  AND genre IN ('Fiction', 'Biography');


-- ============================================================
-- QUESTION 9
-- For each book_id, total quantity sold where item_price > 15.00
-- Only show book_ids where total quantity sold > 10
-- ============================================================

SELECT book_id, SUM(quantity) AS total_quantity_sold
FROM Order_Items
WHERE item_price > 15.00
GROUP BY book_id
HAVING SUM(quantity) > 10;


-- ============================================================
-- QUESTION 10
-- customer_ids who:
--   - have 'gmail.com' in their email
--   - have placed at least one order
-- ============================================================

SELECT customer_id
FROM Customers
WHERE email LIKE '%gmail.com%'
  AND customer_id IN (
      SELECT DISTINCT customer_id
      FROM Orders
  );


-- ============================================================
-- QUESTION 11
-- order_ids where total_amount is among the TOP 5 highest
-- ============================================================

SELECT order_id
FROM Orders
WHERE total_amount IN (
    SELECT DISTINCT total_amount
    FROM Orders
    ORDER BY total_amount DESC
    LIMIT 5
);


-- ============================================================
-- QUESTION 12
-- author_id and nationality of authors who have written books
-- with price BETWEEN 20.00 AND 40.00
-- ============================================================

SELECT author_id, nationality
FROM Authors
WHERE author_id IN (
    SELECT DISTINCT author_id
    FROM Books
    WHERE price BETWEEN 20.00 AND 40.00
);


-- ============================================================
-- QUESTION 13
-- order_id and order_date for orders placed in the last 90 days
-- ============================================================

SELECT order_id, order_date
FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY);

-- ============================================================
-- END OF ASSIGNMENT 02
-- ============================================================
