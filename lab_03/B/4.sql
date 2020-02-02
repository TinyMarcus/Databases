-- Хранимая процедура доступа к метаданным
CREATE PROCEDURE MetaData()
LANGUAGE SQL
AS
$$
    select * into temp table access_data from information_schema.tables where table_type = 'BASE TABLE' and table_schema = 'public';
    -- select * into temp table access_data from information_schema.tables;
$$;

CALL MetaData();
drop procedure metadata();

select * from access_data;
drop table access_data;