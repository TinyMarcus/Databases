-- Триггер INSTEAD OF

-- Создание триггерной функции
CREATE FUNCTION InsteadOfTrigger() RETURNS trigger AS
$$
    DECLARE
        command text := ' SET seniority = 100 WHERE id_seller = $1';
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            EXECUTE 'UPDATE ' || TG_TABLE_NAME || command USING OLD.id_seller;
        END IF;
        RETURN NULL;
        --INSERT INTO check_view VALUES (OLD.id_seller, OLD.name_seller, OLD.birthday_seller,
        --                               OLD.address_seller, OLD.phone_seller, OLD.email_seller,
        --                               0, OLD.id_shop);
        --UPDATE seller
        --SET seniority = 100
        --WHERE id_seller = (SELECT id_seller FROM OLD);
        --RETURN OLD;
        --UPDATE seller
        --SET seniority = seniority + 1;
        --raise notice 'Низя!';
        --return NULL;
        --return NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE VIEW check_view AS
    SELECT * FROM seller;

-- Создание триггера
CREATE TRIGGER CheckInsteadOfTrigger
INSTEAD OF DELETE ON check_view FOR EACH ROW
EXECUTE PROCEDURE InsteadOfTrigger();

-- Удаление функции, триггера и представления
drop function insteadoftrigger() cascade;
drop view check_view;

--- Для проверки
select * from check_view order by id_seller;
select * from seller order by id_seller;

delete from check_view where id_seller = 2;
delete from seller where id_seller = 1;

UPDATE seller
SET seniority = seniority - 1;

delete from seller;