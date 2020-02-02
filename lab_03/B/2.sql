-- Хранимая процедура с рекурсивным ОТВ
CREATE PROCEDURE FindSumIds()
LANGUAGE SQL
AS
$$
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
    into temp table res
    from recur
    order by i desc
    limit 1;
$$;

CALL FindSumIds();
DROP PROCEDURE FindSumIds();

select * from res;
DROP TABLE res;
