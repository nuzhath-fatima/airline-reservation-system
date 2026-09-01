Personal Finance Tracker
Objective
Design and build a SQL-based personal finance tracker that manages users, accounts, income/expense categories, and transactions — with automatic account balance updates through a trigger.

Schema
Users — name, email
Accounts — account name/type (Bank, Cash, etc.), balance, linked to a user
Categories — category name (Salary, Rent, Groceries, etc.), type (Income/Expense)
Transactions — the actual money records, linked to a user, account, and category
Features
Full relational schema with foreign key constraints
Sample data covering multiple users, accounts, and transaction types
Reporting queries:
Total income vs expense per user
Expense breakdown by category
Current balance per account
Most recent transactions
Trigger (trg_after_transaction_insert): automatically updates an account's balance whenever a new transaction is inserted — adds the amount for Income, subtracts it for Expense.
Tools Used
Microsoft SQL Server (SSMS)
T-SQL
How to Run
Create a database: CREATE DATABASE FinanceTracker;
Run finance_tracker.sql in SSMS (or any SQL Server client) — it creates the schema, inserts sample data, creates the trigger, and includes the reporting queries.
