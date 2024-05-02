-- Create Customer table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    PhoneNumber VARCHAR(15)
);

-- Create Account table
CREATE TABLE Account (
    AccountNumber INT PRIMARY KEY,
    CustomerID INT,
    AccountType VARCHAR(50),
    Balance DECIMAL(15, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Create Transactions table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    Amount DECIMAL(15, 2),
    TransactionType VARCHAR(50),
    Date DATE,
    AccountNumber INT,
    FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber)
);

-- Create Loan table
CREATE TABLE Loan (
    LoanID INT PRIMARY KEY,
    LoanAmount DECIMAL(15, 2),
    InterestRate DECIMAL(5, 2),
    LoanType VARCHAR(50),
    AccountNumber INT,
    FOREIGN KEY (AccountNumber) REFERENCES Account(AccountNumber)
);

-- Create Employee table
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(255),
    Department VARCHAR(50)
);

-- Populate Customer table
INSERT INTO Customer (CustomerID, Name, Address, PhoneNumber) VALUES
(1001, 'RUKMINI', 'MANGALAGIRI, AMARAVATHI', '9848699878'),
(1002, 'PAVAN SURAJ', 'ETUKURU, GUNTUR', '8309211989'),
(1003, 'CHAITANYA', 'RATNAGIRI , GUNTUR', '8074918114');

-- Populate Account table
INSERT INTO Account (AccountNumber, CustomerID, AccountType, Balance) VALUES
(102568017564, 1001, 'CURRENT', 150400.23),
(107568902566, 1002, 'SAVINGS', 46800.45),
(101568203568, 1003, 'SAVINGS', 2399.87);

-- Populate Transactions table
INSERT INTO Transactions (TransactionID, Amount, TransactionType, Date, AccountNumber) VALUES
(100, 49999.99, 'DEPOSIT', '2024-04-11', 107568902566),
(101, 33900.02, 'WITHDRAWAL', '2024-04-13', 107568902566),
(102, 54900.78, 'TRANSFER', '2024-04-15', 107568902566);

-- Populate Loan table
INSERT INTO Loan (LoanID, LoanAmount, InterestRate, LoanType, AccountNumber) VALUES
(201, 600000, 5.5, 'EDUCATION LOAN', 101568203568),
(202, 500000, 9.0, 'VEHICLE LOAN', 101568203568),
(203, 50000, 12, 'PERSONAL LOAN', 102568017564);

-- Populate Employee table
INSERT INTO Employee (EmployeeID, Name, Department) VALUES
(1101, 'BHARADWAJA.UVDS', 'ACCOUNTS'),
(1201, 'DEVASISH.K', 'LOANS'),
(1102, 'SAMBA SHIVA.T', 'ACCOUNTS'),
(1301, 'VIVEK.N', 'CUSTOMER SERVICE'),
(2101, 'MANEESH.B', 'RECOVERY');

-- Create view for active customer accounts
CREATE VIEW ActiveCustomerAccounts AS
SELECT a.AccountNumber, a.AccountType, a.Balance, c.Name AS CustomerName
FROM Account a
INNER JOIN Customer c ON a.CustomerID = c.CustomerID
WHERE a.Balance > 0;

-- Create view for loan details with customer information
CREATE VIEW LoanDetailsWithCustomer AS
SELECT l.LoanID, l.LoanAmount, l.InterestRate, l.LoanType, a.AccountNumber, c.Name AS CustomerName
FROM Loan l
INNER JOIN Account a ON l.AccountNumber = a.AccountNumber
INNER JOIN Customer c ON a.CustomerID = c.CustomerID;

-- Create view for monthly account transactions
CREATE VIEW MonthlyAccountTransactions AS
SELECT t.TransactionID, t.Amount, t.TransactionType, t.Date, a.AccountNumber, c.Name AS CustomerName
FROM Transactions t
INNER JOIN Account a ON t.AccountNumber = a.AccountNumber
INNER JOIN Customer c ON a.CustomerID = c.CustomerID
WHERE MONTH(t.Date) = MONTH(CURDATE());

-- Create view for loan applications awaiting approval
CREATE VIEW LoanApplicationsPending AS
SELECT la.LoanApplicationID, la.ApplicationDate, c.Name AS CustomerName, l.LoanType
FROM Loan_Application la
INNER JOIN Customer c ON la.CustomerID = c.CustomerID
LEFT JOIN Loan l ON la.LoanID = l.LoanID
WHERE la.Status = 'Pending';

-- Create view for daily account balances
CREATE VIEW DailyAccountBalances AS
SELECT a.AccountNumber, c.Name AS CustomerName, DATE(t.Date) AS TransactionDate, SUM(t.Amount) AS DailyBalance
FROM Transactions t
INNER JOIN Account a ON t.AccountNumber = a.AccountNumber
INNER JOIN Customer c ON a.CustomerID = c.CustomerID
GROUP BY a.AccountNumber, c.Name, DATE(t.Date)
ORDER BY a.AccountNumber, DATE(t.Date);
