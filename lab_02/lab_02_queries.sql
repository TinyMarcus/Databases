-- 1. Список всех клиентов, которые купили товар, произведенный в России
-- (предикат сравнения в SELECT)
select distinct client.name_client, product.type_product, product.country
from client
         join client_product on client.id_client = client_product.id_client
         join
     product on product.id_product = client_product.id_product
where product.country = 'Россия'
order by client.name_client, product.type_product;


-- 2. Список всех клиентов, родившихся между 1 января 1990 и 2 марта 1992, отсортированный по дате
-- (предикат BETWEEN в SELECT)
select distinct client.name_client, client.birthday_client
from client
where birthday_client between '1990-01-01' and '1992-03-02'
order by birthday_client;


-- 3. Список всех клиентов, в номере телефона которых код равен '996'
-- (предикат LIKE в SELECT)
select distinct name_client, phone_client
from client
where phone_client like '%(996)%';


-- 4. Список клиентов, которые купили товар, цена которого превышает 100000 и который был куплен в магазине 3
-- (предикат IN с вложенным подзапросом в SELECT)
SELECT client.name_client, product.id_product, product.price, shop.id_shop
FROM client
         join client_product on client.id_client = client_product.id_client
         join
     product on product.id_product = client_product.id_product
         join shop on product.id_shop = shop.id_shop
WHERE product.id_product IN
      (
          SELECT product.id_product
          FROM product
          WHERE price > 100000
      )
  AND shop.id_shop = 3;


-- 5. Список всех клиентов, которые купили смартфон, но не купили планшет
-- (предикат EXISTS с вложенным подзапросом в SELECT)
select c.name_client, p.type_product
from client c
         join client_product cp on c.id_client = cp.id_client
         join product p on cp.id_product = p.id_product
where p.type_product != 'Планшет'
  and exists
    (
        select cl.id_client
        from client cl
                 join client_product clp on cl.id_client = clp.id_client
                 join product pr on clp.id_product = pr.id_product
        where pr.type_product = 'Смартфон'
          and cl.id_client = c.id_client
    );


-- 6. Список продуктов, цена которых больше цены любого продукта "Мультиварка"
-- (предикат сравнения с квантором в SELECT)
select product.id_product, product.type_product, price
from product
where price > ALL
      (
          select price
          from product
          where type_product like '%Мультиварка%'
      );


-- 7. Фактическое и посчитанное среднее значение цен по всем продуктам
-- (агрегатные функции в выражениях столбцов в SELECT)
select avg(totalprice) as actual, sum(totalprice) / count(id_product) as calc
from (
         select product.id_product, sum(product.price * quantity) as totalprice
         from client_product
                  join product on product.id_product = client_product.id_product
         group by product.id_product
     ) as totorders;


-- 8. Список id_товаров, их цены, средней цены (по всем товарам) и максимальной цены (по всем товарам)
-- (скалярные подзапросы в выражениях столбцов в SELECT)
select id_product,
       price,
       (
           select AVG(price)
           from product
       ) as AvgPrice,
       (
           select max(price)
           from product
       ) as MaxPrice,
       type_product
from product
where country = 'США';


-- 9. Список продуктов с количеством их покупок и оценочным указанием много куплено или нет
-- (простое выражение CASE в SELECT)
select client_product.id_product,
       client_product.quantity,
       case
           when client_product.quantity < 2 then 'небольшое количество'
           when client_product.quantity < 4 then 'умеренное количество'
           when client_product.quantity < 6 then 'большое количество'
           end qty
from client_product;


-- 10. Список типов продуктов с указанием качественной дороговизны каждого из них
-- (поисковое выражение CASE в SELECT)
select id_product,
       type_product,
       case
           when price < 20000 then 'Недорогой'
           when price < 100000 then 'Средний'
           when price < 200000 then 'Дорогой'
           else 'Очень дорогой'
           end as cost
from product;


-- 11. Список id_товаров, количество заказов и суммарная стоимость продажи
-- (Создание новой временной локальной таблицы в SELECT)
select product.id_product,
       sum(quantity)                        as sq,
       cast(sum(price * quantity) as money) as sr
into temp table bestselling
from client_product
         join product on client_product.id_product = product.id_product
where product.id_product is not null
group by product.id_product;

select *
from bestselling;

drop table bestselling;

select *
from information_schema.tables
where table_type = 'LOCAL TEMPORARY';


-- 12. Вывести список клиентов, их др и тип продукта, который они купили
-- (вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM в SELECT)
select name_client, birthday_client, type_product
from (
         select name_client, birthday_client, type_product
         from client c
                  join client_product cp on c.id_client = cp.id_client
                  join product p on cp.id_product = p.id_product
     ) as abc;


-- 13. Вывести имена клиентов, которые купили мультиварку в магазинах с id > 700
-- (вложенные подзапросы с уровнем вложенности 3 в SELECT)
select name_client
from client
where id_client in (
    select id_client
    from client_product
    where id_product in (
        select id_product
        from product
        where type_product like '%Мультиварка%'
          and id_shop in (
            select id_shop
            from shop
            where shop.id_shop > 700)
    )
);


-- 14. Вывести id товара, цену товара и тип товара с типом "Планшет" и который продали больше одной штуки
-- (предложения GROUP BY, но без предложения HAVING в SELECT)
select product.id_product, product.price, product.type_product
from product
         left outer join client_product on product.id_product = client_product.id_product
where type_product = 'Планшет'
  and client_product.quantity > 1
group by product.id_product, product.price, product.type_product
order by id_product;


-- 15. Список типов товаров со средней ценой каждого типа товара
-- (предложения GROUP BY и предложения HAVING в SELECT)
select type_product, avg(price) as avgprice
from product
group by type_product
having avg(price) >
       (
           select avg(price) as mprice
           from product
       );


-- 16. Однострочная вставка в таблицу product
-- (вставка в таблицу одной строки значений)
insert into product(id_product, type_product, country, price, id_shop)
values (2000, 'Мультиварка', 'США', 120000, 256);


-- 17. Многострочная вставка в таблицу client_product по фильтру (страна - США, тип продукта - видеокарта)
-- (вставка в таблицу результирующего набора данных вложенного подзапроса)
insert into client_product(id_client, id_product, quantity)
select (
           select max(id_product)
           from product
           where country = 'США'
       ),
       id_product,
       2
from product
where type_product = 'Видеокарта';

select *
from client_product;


-- 18. Обновление одного поля в таблице product по id
-- (простая инструкция UPDATE)
update product
set price = price / 1.5
where id_product = 1000;


-- 19. Обновление цены продукта с ID = 2000 на среднее значение столбца с ценами
-- (со скалярным подзапросом в предложении SET)
update product
set price =
        (
            select round(avg(price))
            from product
        )
where id_product = 2000;


-- 20. Удаление полей из таблицы client_product, у которых нет клиента
-- (простая инструкция DELETE)
delete
from seller
where id_seller is null;


-- 21. Удаление из таблицы заказов тех строк, в которых id_client больше 1500
-- (с вложенным коррелированным подзапросом в предложении WHERE)
delete
from client_product
where id_product in
      (
          select cp.id_product
          from client_product cp
                   join product p on cp.id_product = p.id_product
                   join client c on cp.id_client = c.id_client
          where cp.id_client > 1500
      );

select *
from client_product;
drop table client_product;
insert into seller
values (10001, 'Миша Германов', '1980-04-12', 'г.Москва, ул. Ротшильда 125', '+7-(996)-950-83-30',
        'misha19295@gmail.com', 15, 205);


-- 22. Среднее число стажа среди всех продавцов
-- (инструкция SELECT, использующая простое обобщенное табличное выражение)
with cte (id_slr, snrty)
         as
         (
             select id_seller, seniority
             from seller
             group by id_seller
         )
select avg(snrty) as average_seniority
from cte;


-- 23. Рекурсивный вывод суммы id всех магазинов из таблицы product
-- (рекурсивное обобщенное табличное выражение)
CREATE TABLE earth
(
    id        int not null primary key,
    parent_id int references earth (id),
    name      varchar(100)
);

INSERT INTO earth
    (id, parent_id, name)
VALUES (1, null, 'Планета Земля'),
       (2, 1, 'Континент Евразия'),
       (3, 1, 'Континент Южная Америка'),
       (4, 2, 'Европа'),
       (5, 4, 'Россия'),
       (6, 4, 'Германия'),
       (7, 4, 'Франция'),
       (8, 7, 'Париж'),
       (9, 5, 'Москва'),
       (10, 5, 'Воронеж'),
       (11, 6, 'Берлин'),
       (12, 3, 'Бразилия'),
       (13, 3, 'Аргентина'),
       (14, 12, 'Рио-Де-Жанейро'),
       (15, 13, 'Буэнос-Айрес');


WITH RECURSIVE r AS (
    SELECT id, parent_id, name
    FROM earth
    WHERE id = 9

    UNION ALL

    SELECT earth.id, earth.parent_id, earth.name
    FROM earth
             JOIN r
                  ON earth.id = r.parent_id
)

SELECT name
FROM r;

create table multi
(
    id int
);

drop table multi;
insert into multi
values (1),
       (2),
       (-4);
select *
from multi;


-- Умножение значений в столбце
with recursive recur as (
    select 0 as i,
           1 as result
    union all
    select i + 1 as i,
           result * (select id from multi where id is not null order by id limit 1 offset i)
    from recur
    where i < (select count(*) from multi)
)
select result
from recur
order by i desc
limit 1;


select *
from shop;
select *
from product
where id_product = 45;

-- Вывод всех продуктов, купленных в магазах, расположенных в Воронеже
WITH RECURSIVE r AS (
    SELECT product.type_product, product.id_product, shop.address_shop
    FROM product
             join shop on product.id_shop = shop.id_shop
    WHERE shop.address_shop like '%Воронеж%'

    UNION ALL

    SELECT product.type_product, product.id_product, shop.address_shop
    FROM product
             join shop on product.id_shop = shop.id_shop
             JOIN r ON product.id_product = r.id_product
)

SELECT *
FROM r;



with recursive recur as (
    select 1 as i,
           1 as result
    union all
    select i + 1 as i,
           result * (select id_shop from product order by id_shop limit 1 offset i)
    from recur
    where i < (select count(*) from product)
)
select result
from recur
order by i desc
limit 1;

-- 24. Вывести из таблицы client_product с заказами id каждого продукта и количество проданных всего штук
-- (оконные функции)
select distinct cp.id_product, sum(cp.quantity) over (partition by cp.id_product) as total
from client_product cp
order by cp.id_product;

select *
from client_product
where id_product = 50;


-- 25. Удаление дублирующихся строк из полученного запроса
-- (оконные функции для устранения дублей)
with double
         as
         (select c.id_client, c.name_client
          from client c
          where c.birthday_client between '1990-01-01' and '1990-01-10'
          union all
          select c.id_client, c.name_client
          from client c
          where c.birthday_client between '1990-01-01' and '1990-01-20'
          order by id_client)
select id_client, name_client
from (select id_client, name_client, row_number() over (partition by id_client, name_client) as rn
      from double) dbl
where dbl.rn = 1
order by id_client;