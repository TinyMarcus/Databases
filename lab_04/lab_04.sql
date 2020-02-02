CREATE EXTENSION plpython2u;
CREATE PROCEDURAL LANGUAGE 'plpython2u' HANDLER plpython_call_handler;

create extension plpythonu;
drop extension plpython2u, plpythonu;

--  1) Определяемая пользователем скалярная функция
-- поиск имя клиента по id
CREATE OR REPLACE FUNCTION get_name_client (id_ integer)
  RETURNS varchar
AS $$
f = plpy.execute("select * from client ORDER BY id_client")
for row_f in f:
    if row_f['id_client'] == id_:
        return row_f['name_client']

#    filter((lamdba x: x)(f['id_client']), id_)
return "NULL"
$$ LANGUAGE plpython2u;

select get_name_client(25);
drop function get_name_client(id_ integer);

-- 2) Пользовательская агрегатная функция
-- количество продавцов в заданном диапазоне стажа
CREATE OR REPLACE FUNCTION seller_sen_count(sen_min integer, sen_max integer)
RETURNS bigint AS $$
    f = plpy.execute("select * from seller ORDER BY id_seller")
    sum = 0
    for row_f in f:
        if row_f['seniority'] >= sen_min and row_f['seniority'] <= sen_max:
            sum += 1
    return sum
$$ LANGUAGE plpython2u;

select seller_sen_count(1, 2);
drop function seller_sen_count(sen_min integer, sen_max integer);

-- 3) Определяемая пользователем табличная функция
-- Количество продавцов в промежутке стажа
CREATE OR REPLACE FUNCTION get_seller_sen(sen_min integer, sen_max integer)
RETURNS TABLE(id_seller integer, name_seller varchar, phone_seller varchar, seniority smallint) AS $$
    f = plpy.execute("select * from seller ORDER BY id_seller")
    res = []
    sum = 0
    for row_f in f:
        if row_f['seniority'] >= sen_min and row_f['seniority'] <= sen_max:
            res.append(row_f)
    return res
$$ LANGUAGE plpython2u;

select get_seller_sen(1, 2);
drop function get_seller_sen(sen_min integer, sen_max integer);

-- 4) хранимая процедура
-- стоимость продукта умножить на k, если страна Россия
CREATE OR REPLACE PROCEDURE update_cost_product(k real)
LANGUAGE plpythonu AS $$
plan = plpy.prepare("""UPDATE product
                       SET price = price * k
                       WHERE country = 'Россия'""", ['integer'])

rv = plpy.execute(plan, [id_product])
$$;

CALL update_cost_product(10);
drop procedure update_cost_product(k real);

--  5) триггер
-- после добавления клиента пересчитать средний стаж продавца

CREATE TEMP TABLE IF NOT EXISTS seller_age (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	birthday date NOT NULL,
	address varchar NOT NULL,
	phone varchar NOT NULL,
	email varchar NOT NULL,
	seniority smallint NOT NULL
);

CREATE TEMP TABLE IF NOT EXISTS seller_age_copy (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	birthday date NOT NULL,
	address varchar NOT NULL,
	phone varchar NOT NULL,
	email varchar NOT NULL,
	seniority smallint NOT NULL,
	avgage smallint
);

INSERT INTO seller_age (id, name, birthday, address, phone, email, seniority)
-- SELECT *
-- FROM
-- 	(
		SELECT s.id_seller, s.name_seller, s.birthday_seller, s.address_seller, s.phone_seller, s.email_seller, s.seniority
	FROM seller AS s;

select * from seller_age;

CREATE OR REPLACE FUNCTION trigger_clients_age()
RETURNS trigger AS $$
plan = plpy.prepare("""
INSERT INTO seller_age_copy (id, name, birthday, address, phone, email, seniority, avgage)
SELECT *
FROM
	(
		SELECT s.id_seller, s.name_seller, s.birthday_seller, s.address_seller, s.phone_seller, s.email_seller, s.seniority,
		 AVG(s.seniority)
	FROM client_age AS s
	    order by s.id
	) AS tmp;""")
rv = plpy.execute(plan, [TD["old"]])
return TD['new']
$$ LANGUAGE plpython2u;

CREATE TRIGGER trigger_clients_age
AFTER INSERT ON seller_age FOR STATEMENT
EXECUTE PROCEDURE trigger_clients_age();

select * from seller_age;
select * from seller_age_copy;

drop table seller_age;
drop table seller_age_copy;

-- 6) Определяемый пользователем тип данных
-- Информация о клиенте: имя фильма, телефон
CREATE TYPE client_info AS (

  name_client varchar,
  phone_client varchar
);

DROP TYPE client_info;

CREATE TEMP TABLE test (
    info client_info
);

select * from test;

-- возвращает информацию о клиенте по id клиента
CREATE OR REPLACE FUNCTION get_client_info(id integer)
RETURNS client_info
AS $$
f = plpy.execute("select * from client")

for row_f in f:
    if (row_f['id_client'] == id):
	    return (row_f['name_client'], row_f['phone_client'])

$$ LANGUAGE plpython2u;

SELECT * FROM get_client_info(7);
drop function get_client_info(id integer);

select * from test;
drop table test;