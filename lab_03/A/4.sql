-- Функция с рекурсивным ОТВ
CREATE FUNCTION Recursion()
RETURNS INT AS $$
    with recursive recur as (
        select 0 as i,
               0 as result
        union all
        select i + 1 as i,
               result + (select id_shop from product order by id_shop limit 1 offset i)
        from recur
        where i < (select count(*) from product)
    )
    select result
    from recur
    order by i desc
    limit 1;
$$ LANGUAGE SQL;

select Recursion();
drop function Recursion();