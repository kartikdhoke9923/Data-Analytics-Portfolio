create database myfirstproject;
use myfirstproject;

-- open services.msc in run box and start mysql80 from my properties to start mysql 

create table Customers (
    Customer_id INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(13),
    City VARCHAR(50),
    State VARCHAR(50),
    Created_at   timestamp default current_timestamp
);
select * from customers;
create table Accounts (
    Account_id INT PRIMARY KEY,
    Customer_id INT,
    Account_type VARCHAR(20), -- e.g., 'Savings', 'Current'
    Balance DECIMAL(12,2),
    Opened_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
select * from Accounts;

CREATE TABLE Transactions (
    Transaction_id INT PRIMARY KEY,
    Account_id INT,
    Amount DECIMAL(10,2),
	Transaction_type VARCHAR(10), -- 'Credit' or 'Debit'
    date_ DATE,
    FOREIGN KEY (account_id) REFERENCES Accounts(account_id)
);
select * from Transactions;
-- alter table transactions rename column Delevestendate to date_;

CREATE TABLE Branches (
    Branch_id INT PRIMARY KEY,
    Branch_name VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50)
);
select * from Branches;

CREATE TABLE Account_branch (
    Account_id INT,
    Branch_id INT,
    foreign key  (Account_id) REFERENCES accounts(Account_id),
    FOREIGN KEY (Branch_id) REFERENCES Branches(Branch_id)
);
select * from Account_branch;

CREATE TABLE Login (
    login_id INT PRIMARY KEY,
    customer_id INT,
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255),
    last_login DATETIME,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id));

-- 1.Display all transactions sorted by date 
select * from transactions order by date_ ;
 
-- 2. Find customers in New York 
select name,city,state from customers where city='new york';

-- 3. Show transactions with amount > 300 
select * from transactions where amount>300;

-- 4. Get all savings accounts 
select * from Accounts where account_type ='savings';

-- 5. Count number of customers per city 
select count(city) as city_count,city from customers group by city;

-- 6. Total transaction amount by type
select sum(amount)  as Transaction_Amount, transaction_type from transactions group by transaction_type;

-- 7. Customers with more than 1 account 
select  
    c.Customer_id,
    c.Name,
    c.Email,
    COUNT(a.Account_id) AS Number_of_Accounts
from 
Customers c
join  Accounts a on c.Customer_id = a.Customer_id
group by
c.Customer_id, c.Name, c.Email
having 
COUNT(a.Account_id) > 1
order by 
Number_of_Accounts desc;

-- 9. List customer names and their account balances
select c.name,
	sum(ac.balance) as Total_BALance from
    customers c 
    join accounts ac on c.customer_id=ac.customer_id
    group by c.name;

-- 10. Show account and branch details 
select ac. Account_id,
	br.Branch_id ,
    br.Branch_name FROM Account_branch ac JOIN BRANCHES BR ON ac.branch_id=br.branch_id;
	
select ac. Account_id,
	ax.customer_id,	
	br.Branch_id ,
    c.name,
    br.Branch_name FROM Account_branch ac JOIN BRANCHES BR ON ac.branch_id=br.branch_id
    join accounts ax on ac.account_id=ax.account_id
    join customers c on ax.customer_id=c.customer_id ;	
    
-- 11. Transactions along with customer name 
select c.NAme,
    t.Transaction_id,
    t.Amount,
    t.Transaction_type
    from customers c 
    join accounts a on c.customer_id=a.customer_id
    join transactions t on t.Account_id=a.Account_id;
    
-- 12. List customers with balance > average balance 
select c.name,
	sum(ac.balance) as total_balance from
    customers c 
    join accounts ac on c.customer_id=ac.customer_id
    group by c.name
    having total_balance > (              -- total_balance or sum(ac.balance)
    select avg(balance) from accounts 
    );
    
 --  13. Find accounts with the highest balance 
 create view  balance_highest as
 select c.name,
	sum(ac.balance) as highest_balance from
    customers c 
    join accounts ac on c.customer_id=ac.customer_id
    group by c.name
    order by sum(ac.balance) desc  ;
select * from balance_highest;

-- 14. Total balance per customer 
select c.name,
	sum(ac.balance) as Total_BALance from
    customers c 
    join accounts ac on c.customer_id=ac.customer_id
    group by c.name;

-- 15. Latest transaction per account
select ac.account_type,
ac.account_id as account_,
	t.date_,
    t.amount,
    transaction_type
    from accounts ac 
    inner join 
    transactions t on t.Account_id=ac.Account_id
    order by date_ desc;

-- 16. Find customers with no transactions 
select DISTINCT c.customer_id,
t.amount as transaction_amount,
 c.name
from customers c
left join accounts a on c.customer_id = a.customer_id
left join transactions t on a.account_id = t.account_id
WHERE t.transaction_id is null;

-- 17. Show customers and number of transactions 

select c.NAme,
    count(c.name) as no_of_transaction,
    sum(t.Amount) as total_transaction
   
    from customers c 
    join accounts a on c.customer_id=a.customer_id
    join transactions t on t.Account_id=a.Account_id
    group by c.name;
    
-- 18. Branches with total account balances 
select ax.branch_id,
br.branch_name,
sum(a.balance) as total_account_balances from
account_branch ax join 
branches br on br.branch_id=ax.branch_id
join 
accounts a on a.account_id=ax.account_id 
group by br.branch_name,
ax.branch_id;
    
-- 19. Find the top 2 customers with the highest total credited amount in the last 3 months  

select c.name,
t.date_,
sum(t.amount) as total_credited_amount from
customers c left join 
accounts ab on c.customer_id=ab.customer_id
join transactions t on t.account_id= ab.account_id

where t.transaction_type = 'credit' and  t.date_ between '2022-01-05' and '2022-04-05'
group by c.name, t.date_
order by total_credited_amount desc limit 2 ;

select c.name,
t.date_,
sum(t.amount) as total_credited_amount from
customers c left join 
accounts ab on c.customer_id=ab.customer_id
join transactions t on t.account_id= ab.account_id
where t.transaction_type = 'credit' and  t.date_ <='2022-01-05'  - interval 30 day
group by c.name, t.date_
order by total_credited_amount desc limit 2 ;




-- 20. List all branches where the average account balance is below ₹5000 and at least one 
-- account had a debit transaction this month 
SELECT b.branch_id,
 b.branch_name,
t.transaction_type,
 avg(a.balance) as total_balance
FROM branches b
JOIN account_branch ab ON b.branch_id = ab.branch_id
join accounts a on ab.account_id=a.account_id
join transactions t on t.account_id=a.account_id
where t.transaction_type ='debit' 
group by b.branch_id,b.branch_name, t.transaction_type

having total_balance < 10000 and count(b.branch_name)>=1;



Call  SelectAllCustomers();
select * from customers;
select * from Account_branch;
select * from Branches;
select * from Transactions;
select * from Accounts;


-- Total balance per customer
select sum(a.balance) ,
c.name from customers c 
join 
accounts a on a.customer_id=c.customer_id
group by c.name;   





