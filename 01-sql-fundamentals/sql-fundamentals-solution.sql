-- ============================================================
-- SQL Basics - Assignment 01
-- Course  : Database Management Systems - MySQL Basics
-- Instructor: Ahmed Shahzad
-- ============================================================

-- ============================================================
-- QUESTION 1: DDL (Create Tables) + DML (Insert Data)
-- ============================================================

CREATE TABLE Authors (
    AuthorID    INT          PRIMARY KEY,
    FirstName   VARCHAR(100) NOT NULL,
    LastName    VARCHAR(100) NOT NULL,
    Nationality VARCHAR(100)
);

CREATE TABLE Books (
    BookID          INT          PRIMARY KEY,
    Title           VARCHAR(255) NOT NULL,
    AuthorID        INT,
    Genre           VARCHAR(100),
    PublicationYear INT,
    AvailableCopies INT         NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID)
);

-- Sample Data: Authors
INSERT INTO Authors (AuthorID, FirstName, LastName, Nationality) VALUES
(1,  'Mark',    'Twain',      'American'),
(2,  'J.K.',    'Rowling',    'British'),
(3,  'Gabriel', 'Marquez',    'Colombian'),
(4,  'Alice',   'Munro',      'Canadian'),
(5,  'Agatha',  'Christie',   'British'),
(6,  'Stephen', 'King',       'American'),
(7,  'Margaret','Atwood',     'Canadian'),
(8,  'Haruki',  'Murakami',   'Japanese'),
(9,  'George',  'Orwell',     'British'),
(10, 'Chinua',  'Achebe',     'Nigerian');

-- Sample Data: Books
INSERT INTO Books (BookID, Title, AuthorID, Genre, PublicationYear, AvailableCopies) VALUES
(1,  'The Adventures of Tom Sawyer',  1, 'Adventure',      1876, 5),
(2,  'Harry Potter and the Sorcerer', 2, 'Fantasy',        1997, 8),
(3,  'One Hundred Years of Solitude', 3, 'Magical Realism',1967, 3),
(4,  'Lives of Girls and Women',      4, 'Fiction',        1971, 5),
(5,  'Murder on the Orient Express',  5, 'Mystery',        1934, 6),
(6,  'The Shining',                   6, 'Horror',         1977, 4),
(7,  'The Handmaid''s Tale',          7, 'Dystopian',      1985, 7),
(8,  'Norwegian Wood',                8, 'Fiction',        1987, 2),
(9,  'Nineteen Eighty-Four',          9, 'Science Fiction',1949, 5),
(10, 'Things Fall Apart',            10, 'Fiction',        1958, 9),
(11, 'The Old Man and the Sea',       1, 'Adventure',      2001, 5),
(12, 'The Da Vinci Code',             6, 'Mystery',        2003, 5),
(13, 'Neuromancer',                   9, 'Science Fiction',1984, 3),
(14, 'The Dragon Reborn',             4, 'Fantasy',        1991, 2),
(15, 'Gone Girl',                     5, 'Thriller',       2012, 5);


-- ============================================================
-- QUESTION 2: SELECT & WHERE
-- Retrieve Title and PublicationYear of books published after 2000
-- ============================================================

SELECT Title, PublicationYear
FROM Books
WHERE PublicationYear > 2000;


-- ============================================================
-- QUESTION 3: DISTINCT
-- List all unique Genres in the Books table
-- ============================================================

SELECT DISTINCT Genre
FROM Books;


-- ============================================================
-- QUESTION 4: ORDER BY
-- Select Title and AuthorID, ordered alphabetically by Title
-- ============================================================

SELECT Title, AuthorID
FROM Books
ORDER BY Title ASC;


-- ============================================================
-- QUESTION 5: Comparison Operator
-- Find all books with exactly 5 AvailableCopies
-- ============================================================

SELECT *
FROM Books
WHERE AvailableCopies = 5;


-- ============================================================
-- QUESTION 6: Boolean Operator (AND)
-- Title and Genre of books published before 1990 AND Genre = 'Fantasy'
-- ============================================================

SELECT Title, Genre
FROM Books
WHERE PublicationYear < 1990
  AND Genre = 'Fantasy';


-- ============================================================
-- QUESTION 7: Boolean Operator (OR)
-- BookID and Title for books that are 'Mystery' OR 'Thriller'
-- ============================================================

SELECT BookID, Title
FROM Books
WHERE Genre = 'Mystery'
   OR Genre = 'Thriller';


-- ============================================================
-- QUESTION 8: Boolean Operator (NOT)
-- All books that are NOT 'Science Fiction' genre
-- ============================================================

SELECT *
FROM Books
WHERE NOT Genre = 'Science Fiction';


-- ============================================================
-- QUESTION 9: IN Operator
-- FirstName and LastName of authors whose Nationality is 'American' or 'British'
-- ============================================================

SELECT FirstName, LastName
FROM Authors
WHERE Nationality IN ('American', 'British');


-- ============================================================
-- QUESTION 10: LIKE Operator
-- Title of all books that start with the letter 'The'
-- ============================================================

SELECT Title
FROM Books
WHERE Title LIKE 'The%';


-- ============================================================
-- QUESTION 11: BETWEEN Operator
-- Title and PublicationYear of books published between 1995 and 2005 (inclusive)
-- ============================================================

SELECT Title, PublicationYear
FROM Books
WHERE PublicationYear BETWEEN 1995 AND 2005;


-- ============================================================
-- QUESTION 12: NOT NULL
-- BookID, Title, and Genre of books where Genre is specified (not NULL)
-- ============================================================

SELECT BookID, Title, Genre
FROM Books
WHERE Genre IS NOT NULL;


-- ============================================================
-- QUESTION 13: Combined Operators
-- Title, AuthorID, PublicationYear of books:
--   - published after 2010
--   - written by 'Canadian' authors
--   - AvailableCopies > 2
-- Ordered by PublicationYear DESC
-- ============================================================

SELECT b.Title, b.AuthorID, b.PublicationYear
FROM Books b
WHERE b.PublicationYear > 2010
  AND b.AvailableCopies > 2
  AND b.AuthorID IN (
      SELECT AuthorID
      FROM Authors
      WHERE Nationality = 'Canadian'
  )
ORDER BY b.PublicationYear DESC;

-- ============================================================
-- END OF ASSIGNMENT 01
-- ============================================================
