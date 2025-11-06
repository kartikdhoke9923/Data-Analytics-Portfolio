# 🏦 Online Banking App – SQL Data Analysis Project

## 📘 Overview
This project focuses on exploring and analyzing data from an **Online Banking Application** using SQL.  
The dataset contains customer transaction records, account details, and service usage information.  
Through this project, key business insights were derived about user behavior, transaction trends, and account performance.

---

## 🎯 Objectives
- Understand customer distribution across different account types.
- Identify transaction patterns and peak banking activity periods.
- Analyze customer retention and churn indicators.
- Generate key financial metrics such as total deposits, withdrawals, and balances.

---

## 🧠 Skills & Concepts Used
- **SQL Joins** (INNER, LEFT, RIGHT)
- **Aggregate Functions:** `SUM()`, `AVG()`, `COUNT()`, `MAX()`, `MIN()`
- **Subqueries** and **CTEs (Common Table Expressions)**
- **GROUP BY**, **HAVING**, and **ORDER BY** clauses
- **CASE statements** for conditional logic
- **Data Cleaning** and **Filtering**
- **Index Optimization** for query performance

---

## 🗂️ Dataset Description
The database schema includes the following key tables:

| Table Name | Description |
|-------------|-------------|
| `customers` | Contains customer personal details and registration information |
| `accounts` | Stores information about account types, balances, and account status |
| `transactions` | Records deposits, withdrawals, transfers, and timestamps |
| `loans` | Contains loan applications, approvals, and repayment details |
| `branches` | Holds bank branch location and service data |

---

## 🧾 Example Queries
Here are some example queries implemented in the project:

### 🔹 1. Total Deposits and Withdrawals per Account
```sql
SELECT 
    account_id,
    SUM(CASE WHEN transaction_type = 'Deposit' THEN amount ELSE 0 END) AS total_deposits,
    SUM(CASE WHEN transaction_type = 'Withdrawal' THEN amount ELSE 0 END) AS total_withdrawals
FROM transactions
GROUP BY account_id;
