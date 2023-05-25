1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
   Result set: model, speed, hd.

```sql
select model, speed, hd from pc where price < 500
```

2. List all printer makers. Result set: maker.

```sql
select distinct maker from product where type = 'Printer'
```

3. Find the model number, RAM and screen size of the laptops with prices over $1000.

```sql
select model, ram, screen from laptop where price > 1000
```

4. Find all records from the Printer table containing data about color printers.

```sql
select * from printer where color = 'y'
```

5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.

```sql
select
model, speed, hd
from pc
where cd in ('12x', '24x') and price < 600
```

6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops. Result set: maker, speed.

```sql
select distinct maker, speed
from product
inner join laptop
on product.model = laptop.model
where hd >= 10
```

7. Get the models and prices for all commercially available products (of any type) produced by maker B.

```sql
select product.model, pc.price
from product
inner join pc
on product.model = pc.model
where product.maker = 'B'
union
select product.model, laptop.price
from product
inner join laptop
on product.model = laptop.model
where product.maker = 'B'
union
select product.model, printer.price
from product
inner join printer
on product.model = printer.model
where product.maker = 'B'
```

8. Find the makers producing PCs but not laptops.

```sql
select maker from product
where type  = 'PC'
except
select maker from product
where type = 'Laptop'
```

9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.

```sql
select distinct maker from pc
inner join product
on product.model = pc.model
where speed >= 450
```

10. Find the printer models having the highest price. Result set: model, price.

```sql
select model, price from printer
where price = (select MAX(price) from printer)
```

11. Find out the average speed of PCs.

```sql
select AVG(speed) from pc
```

12. Find out the average speed of the laptops priced over $1000.

```sql
select AVG(speed) from laptop
where price > 1000
```

13. Find out the average speed of the PCs produced by maker A.

```sql
select AVG(speed) from pc
inner join product
on pc.model = product.model
where maker = 'A'
```

14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.

```sql
select ships.class, name, country from ships
inner join classes
on classes.class = ships.class
where numGuns >=10
```

15)Get hard drive capacities that are identical for two or more PCs.

```sql
select hd
from pc
group by hd
having COUNT(hd) >= 2
```

16. Get pairs of PC models with identical speeds and the same RAM capacity. Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
    Result set: model with the bigger number, model with the smaller number, speed, and RAM.

```sql
select distinct
pc1.model, pc2.model, pc1.speed, pc1.ram
from pc as pc1
inner join pc as pc2
on pc1.speed = pc2.speed  and pc1.ram = pc2.ram
where pc1.model > pc2.model
```

17. Get the laptop models that have a speed smaller than the speed of any PC.
    Result set: type, model, speed.

```sql
select
product.type, laptop.model, laptop.speed
from laptop
inner join product
on product.model = laptop.model
where speed < (select MIN(speed) from pc)
```

18. Find the makers of the cheapest color printers.
    Result set: maker, price.

```sql
select distinct maker, price from printer
inner join product
on product.model = printer.model and color = 'y'
where
price = (select MIN(price) from printer where color = 'y')
```

19. For each maker having models in the Laptop table, find out the average screen size of the laptops he produces.
    Result set: maker, average screen size.

```sql
select maker, AVG(screen) as Avg_screen from product
inner join laptop
on product.model = laptop.model
where type = 'Laptop'
group by maker
```

20. Find the makers producing at least three distinct models of PCs.
    Result set: maker, number of PC models.

```sql
select maker, count(model) from product
where type = 'PC'
group by maker
having count(model) >= 3
```

21. Find out the maximum PC price for each maker having models in the PC table. Result set: maker, maximum price.

```sql
select maker, max(price) from product
inner join pc
on product.model = pc.model
where type = 'PC'
group by maker
```

22. For each value of PC speed that exceeds 600 MHz, find out the average price of PCs with identical speeds.
    Result set: speed, average price.

```sql
select speed, avg(price) from PC
where speed > 600
group by speed
```

23. Get the makers producing both PCs having a speed of 750 MHz or higher and laptops with a speed of 750 MHz or higher.
    Result set: maker

```sql
select product.maker from product
inner join pc
on product.model = pc.model
where speed >= 750
intersect
select product.maker from product
inner join laptop
on product.model = laptop.model
where speed >= 750
```

24. List the models of any type having the highest price of all products present in the database.

```sql
with model_price as (
select model, price from laptop
union
select model, price from pc
union
select model, price from printer
)

select model from model_price
where price = (select max(price) from model_price)
```

25. Find the printer makers also producing PCs with the lowest RAM capacity and the highest processor speed of all PCs having the lowest RAM capacity.
    Result set: maker.

```sql
select maker from product
where type = 'Printer'
intersect
select maker from product
inner join PC on product.model = pc.model
where
    type = 'PC'
    and ram = (select min(ram) from pc)
    and speed = (select max (speed) from pc where ram = (select min(ram) from pc))
```

26. Find out the average price of PCs and laptops produced by maker A.
    Result set: one overall average price for all items.

```sql
with prices as (
select price from pc
inner join product
on product.model = pc.model
where maker = 'A'
union all
select price from laptop
inner join product
on product.model = laptop.model
where maker = 'A'
)

select avg(price) as AVG_price from prices
```

27. Find out the average hard disk drive capacity of PCs produced by makers who also manufacture printers.
    Result set: maker, average HDD capacity.

```sql
select maker, avg(hd) from product
inner join pc
on product.model = pc.model
where maker in (select maker from product where type = 'Printer')
group by maker
```

28. Using Product table, find out the number of makers who produce only one model.

```sql
with maker_qty as (
select maker, count(maker) as c from product
group by maker
)

select count(maker)
from maker_qty
where c = 1
```

29. Under the assumption that receipts of money (inc) and payouts (out) are registered not more than once a day for each collection point [i.e. the primary key consists of (point, date)], write a query displaying cash flow data (point, date, income, expense).
    Use Income_o and Outcome_o tables.

```sql
select
    case
        when Income_o.point is null then Outcome_o.point
        else Income_o.point
    end as point,
    case
        when Income_o.date is null then Outcome_o.date
        else Income_o.date
    end as date,
    inc,
    out
from
    Income_o full
    outer join Outcome_o on Income_o.point = Outcome_o.point
    and Income_o.date = Outcome_o.date
```
