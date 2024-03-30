/*1. What are the names of all the customers who live in New York?*/

select concat(FirstName, " " ,LastName) as customers_name , city
from customers
where city = "New York" ;

/*2. What is the total number of accounts in the Accounts table?*/

select  count(AccountID) as total_no_of_account
from accounts ;

/*3. What is the total balance of all checking accounts?*/

select round(sum(Balance)) as total_balance
from accounts
where AccountType = "checking" ;

/*4. What is the total balance of all accounts associated with customers who live in Los Angeles?*/

select  round(sum(a.balance)) as total_balance
from accounts as a
join customers as c on c.CustomerID = a.CustomerID 
where c.city = "Los Angeles" 
group by c.city;

/*5. Which branch has the highest average account balance?*/

select b.BranchName, round(avg(a.Balance)) as avg_balance
from accounts as a
join branches as b ON b.BranchID = a.BranchID
group by  b.BranchName
order by avg_balance desc 
limit 1;

/*6. Which customer has the highest current balance in their accounts?*/

select a.CustomerID, concat(FirstName," " ,LastName) as customers_name, 
      max(Balance) as total_balance
from accounts as a 
inner join customers as c on a.CustomerID = c.CustomerID 
group by 1 
order by total_balance desc
limit 1 ;

/*7. Which customer has made the most transactions in the Transactions table?*/


with cte as (
select c.CustomerID, concat(c.FirstName," " ,c.LastName) as  customers_name , 
       count(t.TransactionID) as total_Transactions, 
       dense_rank() over (order by count(t.TransactionID) desc) as rnk
from customers as c
inner join accounts as a on c.CustomerID = a.CustomerID
inner join transactions as t on a.AccountID = t.AccountID
group by c.customerID, customers_name )
 
 select CustomerID,  customers_name , total_Transactions
 from cte 
 where rnk = 1 ;


/*8.Which branch has the highest total balance across all of its accounts?*/

select  b.BranchName, round(sum(a.Balance)) as total_Balance
from accounts  as a 
join branches as b on b.BranchID = a.BranchID
group by  b.BranchName 
order by total_Balance  desc
limit 1 ;

/*9.Which customer has the highest total balance across all of their accounts, including savings and checking accounts?*/ 

with cte as
(select CustomerID,concat(FirstName, ' ' , LastName) as customers_name, round(sum(a.balance)) as total_balance
from customers c 
join accounts a using (CustomerID)
group by 1
order by total_balance desc)  

select CustomerID,customers_name, total_balance
from cte
limit 1;

-- Without cte

select  a.CustomerID, concat(c.FirstName," ",c.LastName) as Customers_name ,
        round(sum(balance)) as total_balance
from accounts a
join customers c on a.CustomerID = c.CustomerID
group by 1,2
order by total_balance desc 
limit 1 ;

/*10.Which branch has the highest number of transactions in the Transactions table?*/


with cte as (
select BranchName,  count(TransactionID) as total_trans,
       dense_rank () over(order by count(TransactionID) desc) as rnk 
from accounts a
join branches b using (BranchID)
join transactions t  using (AccountID)
group by BranchName )

select  BranchName, total_trans
from cte 
where rnk = 1 ;

