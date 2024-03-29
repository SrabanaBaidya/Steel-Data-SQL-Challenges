/*1. What are the details of all cars purchased in the year 2022?*/

select c.car_id,c.make,c.type,c.style,c.cost_$, s.purchase_date 
from cars as c 
join sales as s using(car_id)
where year (purchase_date) = "2022" ;

/*2. What is the total number of cars sold by each salesperson?*/

select sp.salesman_id, sp.name as salesman_name, count(s.car_id) as total_car_sold 
from sales as s
join salespersons as sp using(salesman_id)
group by 1 ;

/*3. What is the total revenue generated by each salesperson?*/

select sp.salesman_id, sp.name as salesman_name, sum(cost_$) as total_revenue
from salespersons as sp
join sales as s using(salesman_id)
join cars as c using(car_id)
group by 1 ;
 
/*4. What are the details of the cars sold by each salesperson?*/

select s.salesman_id, sp.name as salesman_name, c.car_id,c.make,c.type,c.style,c.cost_$
from sales as s
join salespersons as sp using(salesman_id)
join cars as c using(car_id) ;

/*5. What is the total revenue generated by each car type?*/

select car_id,type,concat(sum(cost_$),' ','$') as total_revenue
from cars c
inner join sales s using(car_id)
group by 1,2 ; 

/*6. What are the details of the cars sold in the year 2021 by salesperson 'Emily Wong'?*/

select sp.salesman_id, sp.name, c.car_id, c.make,c.type,c.style,
       c.cost_$,  s.purchase_date
from cars as c  
inner join sales as s using(car_id) 
inner join salespersons as sp using(salesman_id)   
where year (s.purchase_date) = "2021" and
      sp.name =  'Emily Wong' ;
      
 /*7. What is the total revenue generated by the sales of hatchback cars?*/

select c.style, sum(c.cost_$) as total_revenue
from sales as s 
inner join cars as c using (car_id)
where c.style = 'hatchback'
group by 1 ;


/*8. What is the total revenue generated by the sales of SUV cars in the year 2022?*/

select c.style, sum(c.cost_$) as total_revenue
from sales as s 
inner join cars as c using (car_id)
where c.style = 'SUV' and
year(s.purchase_date) = "2022"
group by style ;

/*9. What is the name and city of the salesperson 
who sold the most number of cars in the year 2023?*/

select sp.name, sp.city , count(s.car_id) as total_car_sold
from salespersons as sp
inner join sales as s using(salesman_id)
join cars as c using (car_id)
where year(purchase_date) = "2023"
group by 1,2 
order by total_car_sold desc
limit 1;

/*10. What is the name and age of the salesperson 
who generated the highest revenue in the year 2022?*/

select sp.name,sp.age, sum(c.cost_$) as highest_revenue
from sales as s 
inner join cars as c using (car_id)
join salespersons as sp using(salesman_id)
where year(s.purchase_date) = "2022"
group by 1,2 
order by highest_revenue desc
limit 1;
