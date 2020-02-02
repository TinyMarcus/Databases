-- Многооператорная табличная функция
CREATE FUNCTION ProductInfo()
RETURNS TABLE (type varchar(20), home varchar(15)) AS $$
    SELECT type_product, country from product;
$$ LANGUAGE SQL;

select * from ProductInfo();
drop function ProductInfo();