# Personal Finance Tracker

## Objective

Design and build a SQL-based personal finance tracker that manages users, accounts, income/expense categories, and transactions — with automatic account balance updates through a trigger.

## Schema

- **Users** — name, email
- **Accounts** — account name/type (Bank, Cash, etc.), balance, linked to a user
- **Categories** — category name (Salary, Rent, Groceries, etc.), type (Income/Expense)
- **Transactions** — the actual money records, linked to a user, account, and category

## Features

- Full relational schema with foreign key constraints
- Sample data covering multiple users, accounts, and transaction types
- Reporting queries for income vs expense, category-wise spending, account balances, and recent transactions
- A trigger that automatically updates an account's balance whenever a new transaction is added

## Tools Used

- Microsoft SQL Server (SSMS)
- T-SQL
