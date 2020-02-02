-- Триггер AFTER

-- Создание триггерной функции
CREATE FUNCTION AfterTrigger() RETURNS trigger AS
$$
    BEGIN
        update seller set seniority = seniority + 1;
        return NEW;
    END;
$$ LANGUAGE plpgsql;

-- Создание триггера
CREATE TRIGGER CheckAfterTrigger
AFTER INSERT ON seller FOR EACH ROW
EXECUTE PROCEDURE AfterTrigger();

select * from seller order by id_seller;

insert into seller values (100000, 'ABC', '1999-02-02', 'г.АБС', '+7-(123)-125-12-51', NULL, 5, 123);