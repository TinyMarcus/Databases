-- Скалярная функция
CREATE FUNCTION AvgPrice()
RETURNS NUMERIC AS $$
    (SELECT AVG(price) FROM product);
$$ LANGUAGE SQL;

select AvgPrice();
drop function AvgPrice();
