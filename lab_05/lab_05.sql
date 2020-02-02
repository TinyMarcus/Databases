-- Копирование в JSON

COPY (SELECT to_json(seller) FROM seller) TO '/Users/ilyasov/Desktop/shops/seller.json';

-- Копирование из  json
CREATE TABLE TestSeller
(
 id_seller          int NOT NULL,
 name_seller        varchar(50) NOT NULL,
 birthday_seller    date NOT NULL,
 address_seller     varchar(80) NOT NULL,
 phone_seller       varchar(20) NULL,
 email_seller       varchar(50) NOT NULL,
 seniority          smallint NOT NULL,
 id_shop            int NOT NULL
);

CREATE OR REPLACE PROCEDURE load_from_json(path text)
AS
$$
    with open(path) as file:
        for line in file:
            plan = plpy.prepare("""INSERT INTO testseller
            (SELECT * FROM json_to_record($1)
            AS (id_seller int, name_seller varchar(50), birthday_seller date, address_seller varchar(80),
            phone_seller varchar(20), email_seller varchar(50), seniority smallint, id_shop int))""", ["json"])
            plan.execute([line])
$$
LANGUAGE plpythonu;

DROP PROCEDURE IF EXISTS validate_json(path text);
CREATE OR REPLACE PROCEDURE validate_json(path text)
AS
$$
    from jsonschema import validate
    import json

    schema = {
        "type": "object",
        "properties": {
            "id_seller": {
                "type": "integer",
                "minimum": 0
                },
            "name_seller": {
                "type": "string",
                "minLength": 5,
                "maxLength": 50
                },
            "birthday_seller": {
                "type": "string",
                "minLength": 10,
                "maxLength": 10
                },
            "address_seller": {
                "type": "string",
                "minLength": 20,
                "maxLength": 80
                },
            "phone_seller": {
                "type": "string",
                "pattern": "^[+]{1}[7]{1}-(\\([0-9]{3}\\))-?[0-9]{3}-[0-9]{2}-[0-9]{2}$"
                },
            "email_seller": {
                "type": "string"
                },
             "seniority": {
                "type": "number",
                "minimum": 0,
                },
             "id_shop": {
                "type": "integer",
                "minimum": 0
                }
            },
            "required": ["id_seller", "name_seller", "birthday_seller", "address_seller", "phone_seller",
                         "email_seller", "seniority", "id_shop"]
        }

    with open(path) as file:
        for line in file:
            dict = json.loads(line)
            validate(dict, schema)
$$
LANGUAGE plpython2u;

call validate_json('/Users/ilyasov/Desktop/shops/seller.json');

call load_from_json('/Users/ilyasov/Desktop/shops/seller.json');

select * from TestSeller;

drop table TestSeller;