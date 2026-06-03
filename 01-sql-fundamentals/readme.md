# SQL Fundamentals

## Overview

This project is based on a Library Management System database and focuses on fundamental SQL concepts used in relational databases.

The assignment includes creating tables, inserting sample data, and writing queries to retrieve and analyze information from the database.

## Database Schema

### Authors

| Column      | Type    |
| ----------- | ------- |
| AuthorID    | INT     |
| FirstName   | VARCHAR |
| LastName    | VARCHAR |
| Nationality | VARCHAR |

### Books

| Column          | Type    |
| --------------- | ------- |
| BookID          | INT     |
| Title           | VARCHAR |
| AuthorID        | INT     |
| Genre           | VARCHAR |
| PublicationYear | INT     |
| AvailableCopies | INT     |

## Concepts Covered

* CREATE TABLE
* INSERT INTO
* SELECT
* WHERE
* DISTINCT
* ORDER BY
* Comparison Operators
* Logical Operators (AND / OR)
* Aggregate Functions
* GROUP BY
* HAVING
* Basic Joins
* Subqueries

## Files

| File                              | Description             |
| --------------------------------- | ----------------------- |
| sql-fundamentals-requirements.pdf | Assignment requirements |
| sql-fundamentals-solution.sql     | Complete SQL solution   |

## Learning Outcomes

After completing this project, you will understand:

* Relational database structure
* Table creation and data insertion
* Data filtering and sorting
* Aggregation techniques
* Basic data analysis using SQL
* Working with relationships between tables

## Recommended Tool

Execute the SQL script using DBeaver connected to a MySQL database.
