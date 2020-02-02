-- Хранимая процедура с параметрами или без параметров
CREATE PROCEDURE FindMaxPrice()
LANGUAGE SQL
AS
$$
    SELECT MAX(Price) FROM PRODUCT;
$$;

CALL FindMaxPrice();
drop procedure FindMaxPrice();