ALTER TABLE ilyasov.public.shop
ADD CONSTRAINT PRKEY_shop PRIMARY KEY (id_shop),
ADD CONSTRAINT UNKEY_shop UNIQUE (address_shop),
ADD CONSTRAINT ID_SHOP_check CHECK (id_shop > 0),
ADD CONSTRAINT RATING_check CHECK (rating >= 0.0 and rating <= 5.0),
ADD CONSTRAINT ADR_SHOP_check CHECK (address_shop like 'г.%'),
ALTER COLUMN rating SET DEFAULT 0.0;


ALTER TABLE ilyasov.public.seller
ADD CONSTRAINT PRKEY_seller PRIMARY KEY (id_seller),
--ADD CONSTRAINT UNKEY_name_seller UNIQUE (name_seller),
--ADD CONSTRAINT UNKEY_phone_seller UNIQUE (phone_seller),
--ADD CONSTRAINT UNKEY_email_seller UNIQUE (email_seller),
ADD CONSTRAINT ID_SELLER_check CHECK (id_seller > 0),
ADD CONSTRAINT ID_SELLER_SHOP_check CHECK (id_shop > 0),
ADD CONSTRAINT SENIORITY_check CHECK (seniority >= 0),
ADD CONSTRAINT FRKEY_seller_shop FOREIGN KEY (id_shop) REFERENCES shop (id_shop),
ADD CONSTRAINT ADR_SELLER_check CHECK (address_seller like 'г.%'),
ALTER COLUMN seniority SET DEFAULT 0;


ALTER TABLE ilyasov.public.product
ADD CONSTRAINT PRKEY_product PRIMARY KEY (id_product),
--ADD CONSTRAINT UNKEY_name_product UNIQUE (name_product),
ADD CONSTRAINT ID_PRODUCT_check CHECK (id_product > 0),
ADD CONSTRAINT ID_PRODUCT_SHOP_check CHECK (id_shop > 0),
ADD CONSTRAINT PRICE_check CHECK (price >= 0),
ADD CONSTRAINT FRKEY_product_shop FOREIGN KEY (id_shop) REFERENCES shop (id_shop),
ALTER COLUMN price SET DEFAULT 0;


ALTER TABLE ilyasov.public.client_product
ADD CONSTRAINT ID_PRODUCT_check CHECK (id_product > 0),
ADD CONSTRAINT FRKEY_client_client_product FOREIGN KEY (id_client) REFERENCES client (id_client),
ADD CONSTRAINT FRKEY_product_client_product FOREIGN KEY (id_product) REFERENCES product (id_product),
ADD CONSTRAINT ID_CLIENT_check CHECK (id_client > 0);

ALTER TABLE ilyasov.public.client
ADD CONSTRAINT PRKEY_client PRIMARY KEY (id_client),
--ADD CONSTRAINT UNKEY_phone_client UNIQUE (phone_client),
--ADD CONSTRAINT UNKEY_email_client UNIQUE (email_client),
ADD CONSTRAINT ADR_CLIENT_check CHECK (address_client like 'г.%'),
ADD CONSTRAINT ID_CLIENT_check CHECK (id_client > 0);