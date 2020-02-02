-- Подставляемая табличная функция
CREATE FUNCTION ClientNames()
RETURNS SETOF tbl AS $$
    SELECT name_client, phone_client from client;
$$ LANGUAGE SQL;

select * from ClientNames();