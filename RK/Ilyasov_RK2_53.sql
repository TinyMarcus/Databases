-- Рубежный контроль №2, Ильясов Идрис ИУ7-53Б, Вариант №2

-- Задание 1.
create table if not exists sweets_type
(
    id int primary key,
    name varchar(20) not null,
    composition varchar(50) not null,
    description varchar(100) not null
);

create table if not exists provider
(
    id int primary key,
    name varchar(20) not null,
    INN varchar(50) not null,
    address varchar(50) not null
);

create table if not exists trade_points
(
    id int primary key,
    name varchar(20) not null,
    address varchar(50) not null,
    reg_date date not null,
    rating float not null
);

create table if not exists provider_sweets
(
    provider_id int not null,
    sweets_id int not null,
    quantity int not null
);

create table if not exists provider_trade
(
    provider_id int not null,
    trade_id int not null,
    quantity int not null
);

create table if not exists sweets_trade
(
    sweets_id int not null,
    trade_id int not null,
    quantity int not null
);


alter table provider_sweets
    add constraint FRKEY_PROVIDER_SWEETS_TYPE foreign key (sweets_id) references sweets_type (id),
    add constraint FRKEY_PROVIDER_SWEETS_PROVIDER foreign key (provider_id) references provider (id);

alter table provider_trade
    add constraint FRKEY_PROVIDER_TRADE_POINTS foreign key (trade_id) references trade_points (id),
    add constraint FRKEY_PROVIDER_TRADE_PROVIDER foreign key (provider_id) references provider (id);

alter table sweets_trade
    add constraint FRKEY_SWEETS_TRADE_POINTS foreign key (trade_id) references trade_points (id),
    add constraint FRKEY_SWEETS_TRADE_SWEETS foreign key (sweets_id) references sweets_type (id);


insert into sweets_type values
(1, 'Сникерс', 'Шоколад, орехи', 'Батончик от популярной компании с орехами'),
(2, 'Марс', 'Шоколад, орехи', 'Батончик от популярной компании без орехов'),
(3, 'Баунти', 'Шоколад, кокос', 'Батончик от популярной компании с кокосом'),
(4, 'Левушка', 'Шоколад', 'Конфета детства'),
(5, 'Степ', 'Шоколад, орехи', 'Конфета с орехами');

insert into trade_points values
(1, '1 этаж УЛК', 'г.Москва, улица Рубцовская набережная, 21', '2012-12-10', 4.5),
(2, 'ТРЦ Июнь', 'г.Мытищи, улица Ленина, 27', '2015-10-08', 4.8),
(3, '5 этаж УЛК', 'г.Москва, улица Рубцовская набережная, 21', '2013-11-10', 3.5),
(4, 'ТРЦ РИО', 'г.Москва, Дмитровское шоссе, 15', '2008-12-10', 4.0),
(5, '2 этаж УЛК', 'г.Москва, улица Рубцовская набережная, 21', '2014-12-10', 4.5);

insert into provider values
(1, 'Конфетка', '123456789412', 'г.Москва, улица Ленина набережная, 30'),
(2, 'Вкуснятина', '820192858182', 'г.Мытищи, улица Пожарская, 27'),
(3, 'Пятерочка', '571829i49192', 'г.Москва, улица Текстильщиков, 21'),
(4, 'Левушка', '085717283832', 'г.Москва, улица Кеклол'),
(5, 'Нямка', '102958182838', 'г.Москва, улица Машинная, 21');

insert into sweets_trade values
(1, 2, 40),
(2, 1, 60),
(3, 4, 30),
(4, 5, 10),
(5, 3, 20),
(4, 2, 100);

insert into provider_sweets values
(1, 5, 30),
(2, 2, 70),
(3, 4, 20),
(4, 1, 80),
(5, 5, 90);

insert into provider_trade values
(1, 2, 5),
(2, 4, 2),
(3, 3, 2),
(4, 5, 6),
(5, 1, 4),
(5, 2, 3);

select * from provider;
select * from sweets_type;
select * from trade_points;
select * from provider_sweets;
select * from sweets_trade;
select * from provider_trade;


-- Задание 2.
-- 1) Инструкция SELECT, использующая предикат сравнения (WHERE)
-- Вывести id конфет, название конфет и описание конфет, которые доставляются (продаются)
-- в торговых точках, расположенных в городе Мытищи
select st.id, st.name, st.description
from sweets_type st join sweets_trade str on st.id = str.sweets_id join trade_points tp on str.trade_id = tp.id
where tp.address like 'г.Мытищи%';

-- 2) Инструкцию, использующую оконную функцию
-- Вывести id конфеты, суммарно поставленное количество конфет с этим id в тороговые точки
-- (т.е. для каждого id конфеты найти сумму количества по всей таблице)
select distinct st.sweets_id, sum(st.quantity) over (partition by st.sweets_id) as total
from sweets_trade st
order by st.sweets_id;

-- 3) Инструкция SELECT, использующая вложенные коррелированные
-- подзапросы в качестве производных таблиц в предложении FROM
-- Вывести id поставщика, его название и дату регистрации торговой точки, куда он поставлял конфеты
select id, name, reg_date
from
(
    select p.id, p.name, tp.reg_date
    from provider p join provider_trade pt on p.id = pt.provider_id
    join trade_points tp on pt.trade_id = tp.id
) as test;


-- Задание 3.
select * from information_schema.routines;

create procedure Task3(str varchar(20))
language sql
as
$$
    select routine_name, routine_type into table tbl
    from information_schema.routines
    where (routine_definition like '%' || str || '%');
$$;

call Task3('tbl');
drop procedure Task3(str varchar(20));
drop table tbl;

select * from tbl;