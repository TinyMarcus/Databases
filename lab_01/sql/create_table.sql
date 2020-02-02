CREATE TABLE IF NOT EXISTS shop (
    id_shop int not null,
    rating float not null,
    address_shop varchar(80) not null
);

CREATE TABLE IF NOT EXISTS product (
    id_product int not null,
    type_product varchar(20) not null,
    country varchar(40) not null,
    price numeric not null,
    id_shop int not null
);

CREATE TABLE IF NOT EXISTS client (
    id_client int not null,
    name_client varchar(50) not null,
    birthday_client date not null,
    address_client varchar(80) not null,
    phone_client varchar(20) not null,
    email_client varchar(50) not null
);

CREATE TABLE IF NOT EXISTS seller (
    id_seller int not null,
    name_seller varchar(50) not null,
    birthday_seller date not null,
    address_seller varchar(80) not null,
    phone_seller varchar(20) not null,
    email_seller varchar(50) null,
    seniority smallint not null,
    id_shop int not null
);

CREATE TABLE IF NOT EXISTS client_product (
    id_client int not null,
    id_product int not null,
    quantity int not null
);