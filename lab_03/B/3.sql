-- DO $$
--     DECLARE TBL varchar(10000);
--     DECLARE client_cursor cursor for select name_client from client where name_client like 'Ж%';
--     BEGIN
--         OPEN client_cursor;
--         FETCH NEXT FROM client_cursor INTO TBL;
--         -- Проходим в цикле все записи из множества
--         WHILE FOUND is FALSE
--         LOOP
--             raise notice '%', TBL;
--             FETCH NEXT FROM client_cursor INTO TBL;
--         END LOOP;
--         CLOSE client_cursor;
--     END;
-- $$;

-- Хранимая процедура с курсором
CREATE PROCEDURE crsr()
LANGUAGE plpgsql AS
$$
    DECLARE
        client_cursor cursor for (select name_client, birthday_client from client where name_client like 'Ж%');
        tbl record;
    BEGIN
        OPEN client_cursor;
        FETCH NEXT FROM client_cursor INTO tbl;
        LOOP
            raise notice '%', tbl;
            FETCH NEXT FROM client_cursor INTO tbl;
            EXIT WHEN NOT FOUND;
        END LOOP;
        CLOSE client_cursor;
        DEALLOCATE client
    END;
$$;

CALL crsr();
DROP PROCEDURE crsr();

