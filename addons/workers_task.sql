CREATE TABLE IF NOT EXISTS workers
(
    id int,
    name_worker varchar(30)
);

CREATE TABLE IF NOT EXISTS holidays
(
    id int,
    id_worker int,
    date_holiday date,
    type_holiday int
);

CREATE TABLE IF NOT EXISTS type
(
    id int,
    type_holiday varchar(30)
);

ALTER TABLE workers
ADD CONSTRAINT PRKEY_workers PRIMARY KEY (id);

ALTER TABLE holidays
ADD CONSTRAINT PRKEY_holidays PRIMARY KEY (id),
ADD CONSTRAINT FRKEY_holidays FOREIGN KEY (id_worker) REFERENCES workers (id),
ADD CONSTRAINT FRKEY_holidays_type FOREIGN KEY (type_holiday) REFERENCES type (type_holiday);

ALTER TABLE type
ADD CONSTRAINT PRKEY_type PRIMARY KEY (id),
ADD CONSTRAINT FRKEY_holidays FOREIGN KEY (id) REFERENCES holidays (type_holiday);


insert into workers values
(1, 'Иванов Иван Иванович'),
(2, 'Петров Петр Петрович');

insert into holidays values
(1, 1, '2020-01-20', 1),
(2, 1, '2020-01-21', 1),
(3, 1, '2020-01-22', 1),
(4, 1, '2020-01-23', 1),
(5, 1, '2020-01-25', 3),
(6, 1, '2020-01-26', 3),
(7, 2, '2020-01-22', 2),
(8, 2, '2020-01-23', 2),
(9, 2, '2020-01-24', 2),
(10, 2, '2020-01-25', 2),
(11, 2, '2020-01-26', 2);

insert into holidays values
(1, 1, '2020-12-10', 3);

insert into type values
(1, 'За свой счет'),
(2, 'Ежегодный оплачиваемый'),
(3, 'Болезнь');

select * from workers;
select * from holidays;
select * from type;

drop table workers, holidays, type;

with first(id, id_worker, date_holiday, type_holiday, lead_date, lag_date)
as
(
	select *, lead(date_holiday) over(partition by id_worker, type_holiday order by date_holiday) as lead_date,
	lag(date_holiday) over(partition by id_worker, type_holiday order by date_holiday) as lag_date
	from holidays
),
second(id, id_worker, date_holiday, type_holiday, lead_date, lag_date, begin_holiday, end_holiday)
as
(
	select *,
	case
		when lag_date is NULL or (lag_date::date - date_holiday::date) > 1 then date_holiday
		else null
		end
	as begin,
	case
		when lead_date is NULL or (date_holiday::date - lead_date::date) > 1 then date_holiday
		else null
		end
	as end
	from first
),
third(id, id_worker, date_holiday, type_holiday, lead_date, lag_date, begin_holiday, end_holiday)
as
(
	select *
	from second
	where begin_holiday is not null or end_holiday is not null
),
fourth(id_worker, type_holiday, begin_holiday, end_holiday_tmp)
as
(
	select id_worker, type_holiday, begin_holiday,
	case
		when end_holiday is NULL then lead(end_holiday) over (partition by id_worker, type_holiday order by date_holiday)
		else end_holiday
		end
	as end_holiday_tmp
	from third
)
select name_worker, begin_holiday, end_holiday_tmp as end_holiday, t.type_holiday
from fourth join type t on fourth.type_holiday = t.id
join workers w on fourth.id_worker = w.id
where begin_holiday is not null
order by name_worker;


