
-- ============================================
-- BANKING APPLICATION DATABASE
-- Hexaware Case Study
-- MySQL 8.0
-- ============================================

CREATE DATABASE IF NOT EXISTS BankingDB;

USE BankingDB;

-- ============================================
-- 1. CUSTOMER TABLE
-- ============================================

CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    NationalID VARCHAR(30) UNIQUE NOT NULL
) ENGINE=InnoDB;


-- ============================================
-- 2. BRANCH TABLE
-- ============================================

CREATE TABLE Branch (
    BranchID INT AUTO_INCREMENT PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL
) ENGINE=InnoDB;


-- ============================================
-- 3. ACCOUNT TABLE
-- ============================================

CREATE TABLE Account (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    AccountType VARCHAR(20) NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    OpenedDate DATE NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active',

    CONSTRAINT chk_account_balance
        CHECK (Balance >= 0),

    CONSTRAINT fk_account_customer
        FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID)
) ENGINE=InnoDB;


-- ============================================
-- 4. TRANSACTION TABLE
-- ============================================

CREATE TABLE `Transaction` (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    TransactionType VARCHAR(20) NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate DATETIME NOT NULL,
    RelatedAccountID INT NULL,

    CONSTRAINT chk_transaction_amount
        CHECK (Amount > 0),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID)
) ENGINE=InnoDB;


-- ============================================
-- 5. CARD TABLE
-- ============================================

CREATE TABLE Card (
    CardID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT NOT NULL,
    CardNumberMasked VARCHAR(20) NOT NULL,
    ExpiryDate DATE NOT NULL,
    Status VARCHAR(20) NOT NULL,

    CONSTRAINT fk_card_account
        FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID)
) ENGINE=InnoDB;


-- ============================================
-- 6. FRAUDFLAG TABLE
-- ============================================

CREATE TABLE FraudFlag (
    FlagID INT AUTO_INCREMENT PRIMARY KEY,
    TransactionID INT NOT NULL,
    Reason VARCHAR(200) NOT NULL,
    FlaggedOn DATETIME NOT NULL,
    Reviewed BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_fraud_transaction
        FOREIGN KEY (TransactionID)
        REFERENCES `Transaction`(TransactionID)
) ENGINE=InnoDB;


-- ============================================
-- DATABASE CREATION COMPLETED
-- ============================================

SHOW TABLES;


-- ============================================
-- 1. CUSTOMER DATA
-- ============================================

INSERT INTO Customer
(CustomerID, FirstName, LastName, Email, NationalID)
VALUES
(1, 'Rahul', 'Sharma', 'rahul@gmail.com', 'NID10001'),
(2, 'Priya', 'Kumar', 'priya@gmail.com', 'NID10002'),
(3, 'Arun', 'Raj', 'arun@gmail.com', 'NID10003'),
(4, 'Sneha', 'Reddy', 'sneha@gmail.com', 'NID10004'),
(5, 'Karthik', 'Vel', 'karthik@gmail.com', 'NID10005'),
(6, 'Divya', 'Mohan', 'divya@gmail.com', 'NID10006');


-- ============================================
-- 2. BRANCH DATA
-- ============================================

INSERT INTO Branch
(BranchID, BranchName, City)
VALUES
(1, 'Main Branch', 'Chennai'),
(2, 'City Branch', 'Coimbatore'),
(3, 'Central Branch', 'Bangalore'),
(4, 'South Branch', 'Madurai');


-- ============================================
-- 3. ACCOUNT DATA
-- ============================================

INSERT INTO Account
(AccountID, CustomerID, AccountType, Balance, OpenedDate, Status)
VALUES
(101, 1, 'Savings', 50000.00, '2025-01-10', 'Active'),
(102, 1, 'Checking', 25000.00, '2025-03-15', 'Active'),
(103, 2, 'Savings', 75000.00, '2025-02-20', 'Active'),
(104, 3, 'Checking', 30000.00, '2025-04-05', 'Active'),
(105, 4, 'Savings', 90000.00, '2025-05-12', 'Frozen'),
(106, 5, 'Savings', 45000.00, '2025-06-18', 'Active'),
(107, 6, 'Checking', 15000.00, '2025-07-22', 'Active'),
(108, 2, 'Checking', 60000.00, '2025-08-10', 'Closed');


-- ============================================
-- 4. TRANSACTION DATA
-- ============================================

INSERT INTO `Transaction`
(TransactionID, AccountID, TransactionType, Amount,
 TransactionDate, RelatedAccountID)
VALUES
(1001, 101, 'Deposit', 10000.00,
 '2026-01-05 09:30:00', NULL),

(1002, 101, 'Withdrawal', 5000.00,
 '2026-01-06 11:15:00', NULL),

(1003, 102, 'Transfer', 3000.00,
 '2026-01-07 14:20:00', 103),

(1004, 103, 'Deposit', 15000.00,
 '2026-01-08 10:00:00', NULL),

(1005, 104, 'Withdrawal', 2000.00,
 '2026-01-09 16:45:00', NULL),

(1006, 105, 'Transfer', 25000.00,
 '2026-01-10 12:30:00', 106),

(1007, 106, 'Deposit', 8000.00,
 '2026-01-11 09:00:00', NULL),

(1008, 107, 'Withdrawal', 1000.00,
 '2026-01-12 17:15:00', NULL),

(1009, 101, 'Transfer', 45000.00,
 '2026-01-13 20:30:00', 107),

(1010, 103, 'Withdrawal', 7000.00,
 '2026-01-14 13:10:00', NULL);


-- ============================================
-- 5. CARD DATA
-- ============================================

INSERT INTO Card
(CardID, AccountID, CardNumberMasked, ExpiryDate, Status)
VALUES
(201, 101, '**** **** **** 4821', '2028-12-31', 'Active'),
(202, 102, '**** **** **** 1234', '2027-10-31', 'Active'),
(203, 103, '**** **** **** 5678', '2029-05-31', 'Active'),
(204, 104, '**** **** **** 9012', '2027-08-31', 'Blocked'),
(205, 105, '**** **** **** 3456', '2026-06-30', 'Expired'),
(206, 106, '**** **** **** 7890', '2028-03-31', 'Active');


-- ============================================
-- 6. FRAUD FLAG DATA
-- ============================================

INSERT INTO FraudFlag
(FlagID, TransactionID, Reason, FlaggedOn, Reviewed)
VALUES
(301, 1006, 'Unusually large transfer amount',
 '2026-01-10 12:35:00', FALSE),

(302, 1009, 'High value transaction detected',
 '2026-01-13 20:35:00', FALSE),

(303, 1005, 'Suspicious withdrawal pattern',
 '2026-01-09 16:50:00', TRUE);


-- ============================================
-- INSERTION COMPLETED
-- ============================================

SELECT * FROM Customer;

SELECT * FROM Branch;

SELECT * FROM Account;

SELECT * FROM Transaction;

SELECT * FROM Card;

SELECT * FROM FraudFlag;
