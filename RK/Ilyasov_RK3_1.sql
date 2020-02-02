-- Рубежный контроль №3. Ильясов Идрис ИУ7-53Б. Вариант 2. Задание 1.

create table if not exists branch
(
    id int primary key,
    name varchar(50) not null,
    address varchar(20) not null,
    phone varchar(10) not null
);

create table if not exists workers
(
    id int primary key,
    surname varchar(50) not null,
    birthday date not null,
    division varchar(20) not null,
    branch_id int not null references branch (id)
);

insert into branch values
(1, 'Московский Филиал (ГО)', 'Герцена, 5', '456-78-23'),
(2, 'Новосибирский доп. офис', 'Пролетарская, 8', '543-62-34'),
(3, 'Саратовский доп. офис', 'Шухова, 44', '452-56-11'),
(4, 'Томский филиал', 'Герцена, 7', '987-46-74');

insert into workers values
(1, 'Иванов Иван Иванович', '1990-09-25', 'ИТ', 1),
(2, 'Петров Петр Петрович', '1987-11-12', 'Бухгалтерия', 3),
(3, 'Смирнов Иван Петрович', '1982-05-06', 'ИТ', 3);

select * from branch;
select * from workers;

-- Создать функцию, выводящую филиал с минимальным количеством сотрудников
CREATE FUNCTION Min_Count()
RETURNS VARCHAR(20) AS $$
    select test.name
    from (
        select distinct branch.name, min(count(workers.branch_id)) over (partition by workers.branch_id) as total
        from branch join workers on branch.id = workers.branch_id
        group by branch.name, workers.branch_id) as test
        order by total limit 1;
$$ LANGUAGE SQL;

select Min_Count();
drop function Min_Count();