-- =========================================================
-- Personal Finance Tracker
-- SQL Developer Internship - Project Phase Submission
-- =========================================================

USE FinanceTracker;
GO

-- =========================================================
-- 1. SCHEMA
-- =========================================================

CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    account_name VARCHAR(50) NOT NULL,
    account_type VARCHAR(30) NOT NULL,
    balance DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    type VARCHAR(10) NOT NULL CHECK (type IN ('Income', 'Expense'))
);

CREATE TABLE Transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    category_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    transaction_date DATE NOT NULL,
    description VARCHAR(255),
    type VARCHAR(10) NOT NULL CHECK (type IN ('Income', 'Expense')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);
GO

-- =========================================================
-- 2. SAMPLE DATA
-- =========================================================

INSERT INTO Users (name, email) VALUES
('Nuzhath Fathima', 'nuzhath@email.com'),
('Ravi Kumar', 'ravi@email.com');

INSERT INTO Accounts (user_id, account_name, account_type, balance) VALUES
(1, 'HDFC Bank', 'Bank', 15000.00),
(1, 'Cash Wallet', 'Cash', 2000.00),
(2, 'SBI Bank', 'Bank', 8000.00);

INSERT INTO Categories (category_name, type) VALUES
('Salary', 'Income'),
('Freelance', 'Income'),
('Groceries', 'Expense'),
('Rent', 'Expense'),
('Travel', 'Expense'),
('Entertainment', 'Expense');

INSERT INTO Transactions (user_id, account_id, category_id, amount, transaction_date, description, type) VALUES
(1, 1, 1, 30000.00, '2026-08-01', 'Monthly salary', 'Income'),
(1, 2, 3, 1200.00, '2026-08-03', 'Grocery shopping', 'Expense'),
(1, 1, 4, 8000.00, '2026-08-05', 'House rent', 'Expense'),
(1, 2, 5, 500.00, '2026-08-10', 'Bus ticket', 'Expense'),
(2, 3, 2, 5000.00, '2026-08-08', 'Freelance project', 'Income'),
(2, 3, 6, 700.00, '2026-08-12', 'Movie night', 'Expense');
GO

-- =========================================================
-- 3. TRIGGER - auto-update account balance on new transaction
-- =========================================================

CREATE TRIGGER trg_after_transaction_insert
ON Transactions
AFTER INSERT
AS
BEGIN
    UPDATE Accounts
    SET balance = balance + i.amount
    FROM Accounts a
    JOIN inserted i ON a.account_id = i.account_id
    WHERE i.type = 'Income';

    UPDATE Accounts
    SET balance = balance - i.amount
    FROM Accounts a
    JOIN inserted i ON a.account_id = i.account_id
    WHERE i.type = 'Expense';
END;
GO

-- =========================================================
-- 4. REPORTING QUERIES
-- =========================================================

-- Total income and expense per user
SELECT
    u.name,
    SUM(CASE WHEN t.type = 'Income' THEN t.amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN t.type = 'Expense' THEN t.amount ELSE 0 END) AS total_expense
FROM Transactions t
JOIN Users u ON t.user_id = u.user_id
GROUP BY u.name;

-- Expense breakdown by category
SELECT
    c.category_name,
    SUM(t.amount) AS total_spent
FROM Transactions t
JOIN Categories c ON t.category_id = c.category_id
WHERE t.type = 'Expense'
GROUP BY c.category_name
ORDER BY total_spent DESC;

-- Current balance per account
SELECT
    a.account_name,
    a.balance AS current_balance
FROM Accounts a;

-- Recent transactions (latest 5)
SELECT TOP 5
    t.transaction_date,
    u.name,
    c.category_name,
    t.type,
    t.amount,
    t.description
FROM Transactions t
JOIN Users u ON t.user_id = u.user_id
JOIN Categories c ON t.category_id = c.category_id
ORDER BY t.transaction_date DESC;
