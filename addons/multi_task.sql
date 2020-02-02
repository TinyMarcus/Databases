create table if not exists multiplication (
    id int not null
);

select * from multiplication;

insert into multiplication values (5);

delete from multiplication where id = 0;

with tmp_1 as (select id from multiplication),
     tmp_2 as (select count(*) quantity,
                      sum(case when id > 0 then 1 else 0 end) positive,
                      sum(case when id < 0 then 1 else 0 end) negative from tmp_1)
select case when quantity <> positive + negative then 0 else
((case when negative % 2 = 1 then -1 else 1 end) * round(exp(sum(ln(abs(id)))))) end
from tmp_1, tmp_2
where id <> 0
group by quantity, positive, negative;

drop table multiplication;


