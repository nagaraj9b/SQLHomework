Use sakila;

/*1a. Display the first and last names of all actors from the table actor.*/

select first_name, last_name from actor;

/*1b. Display the first and last name of each actor in a single column in upper case letters. 
Name the column Actor Name.*/

select concat(Upper(first_name),' ', Upper(last_name)) as 'Actor Name' from Actor; 

/*2a. You need to find the ID number, first name, and last name of an actor, of whom
 you know only the first name, "Joe." What is one query would you use to obtain this information?*/
 
 select actor_id as ID, first_name as 'First Name', Last_name as 'Last Name' 
 from Actor where first_name = 'Joe';
 
/*2b. Find all actors whose last name contain the letters GEN:*/
select actor_id as ID, first_name as 'First Name', Last_name as 'Last Name' 
from Actor where last_name like '%Gen%';

/*2c. Find all actors whose last names contain the letters LI. This time, 
order the rows by last name and first name, in that order:*/
select actor_id as ID, first_name as 'First Name', Last_name as 'Last Name' 
from Actor where last_name like '%LI%' ORDER BY 3,2;

/*2d. Using IN, display the country_id and country columns of the following countries: 
Afghanistan, Bangladesh, and China:*/

Select Country_id, country from country where country in ('Afghanistan', 'Bangladesh', 'China'); 


/*3a. You want to keep a description of each actor. You don't think you will be performing queries on a 
description, so create a column in the table actor named description and use the data type BLOB 
(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).*/
ALTER TABLE actor
ADD COLUMN description BLOB ;

/*3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
Delete the description column.*/

ALTER TABLE ACTOR
DROP description;

/*4a. List the last names of actors, as well as how many actors have that last name.*/
select Last_name,count(*) 
from actor where last_name in (select last_name from actor) group by last_name;

/*4b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors */
select Last_name,count(*) from actor
 where last_name in (select last_name from actor) 
 group by last_name having count(*) >=  2 ;
/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
Write a query to fix the record.*/
Update Actor set first_name = 'HARPO' where actor_id = 172 ;

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO 
was the correct name after all! In a single query, if the first name of the actor 
is currently HARPO, change it to GROUCHO.*/

Update Actor set first_name = 'GROUCHO'  where  fIRST_NAME LIKE '%HARPO%';

/*5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html*/
CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`)
) ;
/*6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
Use the tables staff and address:*/
select first_name, last_name, address from staff S
join address A on s.address_id = A.address_id ;
/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
Use tables staff and payment.*/
select first_name, last_name, DATE_FORMAT(Payment_date, "%Y  %M")AS " PAYMENT-YEAR-MONTH" , sum(amount)
 from staff S join payment P on S.staff_id = P.staff_id where EXTRACT(YEAR_MONTH FROM payment_date) = '200508'group by 1,2;
/*6c. List each film and the number of actors who are listed for that film. 
Use tables film_actor and film. Use inner join.*/
select title as film, count(actor_id) from film_actor ff join film f on ff.film_id = f.film_id group by film;
/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/
select count(*) count from inventory i
join film f on i.film_id = f.film_id where f.title like 'HUNCHBACK IMPOSSIBLE';

/*6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
List the customers alphabetically by last name:*/
select first_name "Fist Name", last_name "Last Name", sum(amount) "Total Paid" 
from payment p join customer c on p.customer_id = c.customer_id group by 1,2 order by 2;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters K and Q have also 
soared in popularity. Use subqueries to display the titles of movies starting with the 
letters K and Q whose language is English.*/


select title, language_id from film where title like 'k%' or title like 'Q%' 
and Language_id in (select Language_id from Language where name = 'English');

/*7b. Use subqueries to display all actors who appear in the film Alone Trip.*/
select first_name, last_name from actor A join film_actor F on A.actor_id = F.actor_id 
where film_id in (Select film_id from film where title like 'Alone Trip');

/*7c. You want to run an email marketing campaign in Canada, for which you will need the names 
and email addresses of all Canadian customers. Use joins to retrieve this information.*/
select first_name, last_name, email
from customer c 
join address a 
on c.address_id = a.address_id 
join city cy 
on a.city_id = cy.city_id
join country cn
on cy.country_id = cn.country_id where country = 'canada';


/*7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/
SELECT title as film FROM film f 
join film_category fc 
on f.film_id = fc.film_id
join category c
on fc.category_id = c.category_id
where name = 'Family';
/*7e. Display the most frequently rented movies in descending order.*/

 select  title, count(rental_id) from 
 film f join
 inventory i 
 on 
 f.film_id = i.film_id
 join rental r 
 on i.inventory_id = r.inventory_id group by title order by 2 desc;


/*7f. Write a query to display how much business, in dollars, each store brought in.*/

 select  s.Store_id, sum(amount) as 'Sales in Dollars' from 
 Store s join
 inventory i 
 on 
 s.store_id = i.store_id
 join rental r 
 on i.inventory_id = r.inventory_id 
 join payment p
 on r.rental_id = p.rental_id group by 1;

/*7g. Write a query to display for each store its store ID, city, and country.*/

 select  s.Store_id, c.city, cy.country from 
 Store s join
 address a
 on 
 s.address_id = a.address_id
 join city c 
 on a.city_id = c.city_id 
 join country cy
 on c.country_id = cy.country_id ;	

/*7h. List the top five genres in gross revenue in descending order.
 (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/
 
 select name as 'Generes', sum(amount) from 
 category c
 join film_category fc 
on fc.category_id = c.category_id
join film f
on f.film_id = fc.film_id
join  inventory i 
 on  f.film_id = i.film_id
 join rental r 
 on i.inventory_id = r.inventory_id 
 join payment p
 on r.rental_id = p.rental_id group by 1 order by 2 desc LIMIT 5;
 
/*8a. In your new role as an executive, you would like to have an easy way of 
viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/

CREATE VIEW vw_top_five_genres as 
( select name as 'Generes', sum(amount) from 
 category c
 join film_category fc 
on fc.category_id = c.category_id
join film f
on f.film_id = fc.film_id
join  inventory i 
 on  f.film_id = i.film_id
 join rental r 
 on i.inventory_id = r.inventory_id 
 join payment p
 on r.rental_id = p.rental_id group by 1 order by 2 desc LIMIT 5);

/*8b. How would you display the view that you created in 8a?*/
SELECT * FROM sakila.vw_top_five_genres;

/*8c. You find that you no longer need the view top_five_genres.
 Write a query to delete it.*/
 
 Drop view vw_top_five_genres;