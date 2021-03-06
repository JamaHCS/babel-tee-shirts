# drop database if exists babel;
drop database if exists tienda;
# create database if not exists babel;
create database if not exists tienda;
# use babel;
use tienda;

# CREATE USER 'jamahcs' IDENTIFIED BY 'Acceso.117';
GRANT ALL PRIVILEGES ON babel.* TO 'jamahcs';
GRANT ALL PRIVILEGES ON tienda.* TO 'jamahcs';

# CREATE USER 'verohcs' IDENTIFIED BY 'Acceso.117';
GRANT ALL PRIVILEGES ON tienda.* TO 'verohcs';
GRANT ALL PRIVILEGES ON babel.* TO 'verohcs';

# CREATE USER 'laravelsystem' IDENTIFIED BY 'Acceso.117';
GRANT ALL PRIVILEGES ON tienda.* TO 'laravelsystem';
GRANT ALL PRIVILEGES ON babel.* TO 'laravelsystem';

# SET GLOBAL log_bin_trust_function_creators = 1;
# EST zona horaria east usa
# cambio en la 450
# php artisan make:model users -cfsr

create table addresses
(
    id                    int         NOT NULL AUTO_INCREMENT,
    street                varchar(100),
    exteriorNumberAddress int,
    interiorNumberAddress int,
    suburb                varchar(50),
    city                  varchar(50),
    estate                varchar(50),
    cp                    varchar(10) not null,
    created_at            timestamp default now(),
    updated_at            timestamp default now(),
    user_id               bigint    default null,
    provider_id           int       default null,
    constraint pk4 primary key (id)
);

create table offices
(
    id         int NOT NULL AUTO_INCREMENT,
    nameOffice varchar(30),
    phone      bigint,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    address_id int,
    constraint pk5 primary key (id),
    constraint fk4 foreign key (address_id) references addresses (id)
);

insert into offices (id, nameOffice, created_at, updated_at)
values (0, 'Ciudad de México', now(), now()),
       (0, 'Guadalajara', now(), now()),
       (0, 'Querétaro', now(), now());

create table categories
(
    id           int NOT NULL AUTO_INCREMENT,
    nameCategory varchar(100),
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    constraint pk6 primary key (id)
);

create table providers
(
    id                  int NOT NULL AUTO_INCREMENT,
    phone               bigint,
    nameProvider        varchar(30) not null ,
    apProvider          varchar(50),
    amProvider          varchar(30),
    companyProvider     varchar(50),
    descriptionProvider varchar(30),
    emailProvider       varchar(70),
    rfcProvider         varchar(13),
    created_at          timestamp default now(),
    updated_at          timestamp default now(),
    constraint pk8 primary key (id)
);

ALTER TABLE addresses
    ADD CONSTRAINT FOREIGN KEY (provider_id)
        REFERENCES providers (id);

create table typeUsers
(
    id         int auto_increment primary key,
    role       varchar(50),
    created_at timestamp default now(),
    updated_at timestamp default now()
);

insert into typeUsers
values (0, 'Cliente', now(), now()),
       (0, 'Administrador', now(), now()),
       (0, 'SuperUsuario', now(), now()),
       (0, 'Eliminado', now(), now());

create table sexs
(
    id         int auto_increment,
    sex        varchar(20),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    constraint primary key (id)
);

insert into sexs
values (0, 'Masculino', now(), now()),
       (0, 'Femenino', now(), now()),
       (0, 'Otro', now(), now());

create table users
(
    id                bigint              NOT NULL auto_increment,
    typeUser_id       int,
    phone             bigint,
    name              varchar(255)        not null,
    ap                varchar(255),
    am                varchar(255),
    email             varchar(255) unique not null,
    email_verified_at timestamp    default now(),
    password          varchar(255)        not null,
    profilePicture    varchar(255) default 'https://api.adorable.io/avatars/285/abott@adorable.png',
    birthdate         date,
    rfc               varchar(17),
    created_at        timestamp    default now(),
    updated_at        timestamp    default now(),
    sex_id            int,
    remember_token    varchar(100),
#     provider             varchar(255),
#     provider_id          varchar(255),
#     nameNotAutentication varchar(255),
#     avatar               varchar(50) unique,
    constraint pk9 primary key (id),
    constraint foreign key (typeUser_id) references typeUsers (id) on update cascade,
    constraint foreign key (sex_id) references sexs (id)
);

ALTER TABLE users
    ADD UNIQUE INDEX USU (id);

ALTER TABLE addresses
    ADD CONSTRAINT FOREIGN KEY (user_id)
        REFERENCES users (id);

delimiter //
create trigger typeUsers
    before insert
    on users
    for each row
begin
    set new.typeUser_id = 1;
end;
delimiter ;

create table administrators
(
    id         bigint NOT NULL AUTO_INCREMENT,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    user_id    bigint,
    office_id  int,
    constraint pk10 primary key (id),
    constraint fk5 foreign key (user_id) references users (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    constraint fk6 foreign key (office_id) references offices (id) ON DELETE cascade ON UPDATE CASCADE
);

delimiter //
create trigger createAdmin
    after update
    on users
    for each row
begin
    if new.typeUser_id != 1 then
        begin
            insert into administrators (user_id) value (new.id);
        end;
    end if;
end //
delimiter ;

delimiter //
create trigger timestamps
    before insert
    on administrators
    for each row
begin
    set new.created_at = now();
    set new.updated_at = now();
end;
delimiter ;

create table sizes
(
    id         int not null auto_increment,
    nom_talla  varchar(30),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    PRIMARY KEY (id)
);

insert into sizes
values (0, 'Extra chica', now(), now()),
       (0, 'Chica', now(), now()),
       (0, 'Mediana', now(), now()),
       (0, 'Grande', now(), now()),
       (0, 'Extra grande', now(), now());

create table statusProducts
(
    id         int auto_increment not null,
    nameStatus varchar(50),
    constraint primary key (id)
);

insert into statusProducts
values (0, 'Nuevo'),
       (0, 'De temporada'),
       (0, 'Liquidación'),
       (0, 'Descontinuado');


create table products
(
    id               int          NOT NULL AUTO_INCREMENT,
    statusProduct_id int          not null default 2,
    nameProduct      varchar(100) not null,
    description_prod text,
    costo_prod       float        not null,
    precio_prod      float        not null,
    descuento        float,
    material_prod    varchar(50) default 'Algodón',
    created_at       timestamp             default now(),
    updated_at       timestamp             default now(),
    category_id      int,
    provider_id      int,
    size_id          int,
    CHECK (precio_prod > costo_prod),
    constraint pk13 primary key (id),
    constraint foreign key (size_id) references sizes (id),
    constraint foreign key (statusProduct_id) references statusProducts (id),
    constraint fk14 foreign key (category_id) references categories (id) ON DELETE cascade ON UPDATE CASCADE,
    constraint fk15 foreign key (provider_id) references providers (id) ON DELETE cascade ON UPDATE CASCADE
);

ALTER TABLE products
    ADD UNIQUE INDEX PROD (nameProduct);

delimiter //
create trigger descuento
    before insert
    on products
    for each row
begin
    case
        when new.statusProduct_id = '3' then
            set new.descuento = 0.10;
        when new.statusProduct_id = '1' then
            set new.descuento = 0;
        end case;
end //
delimiter ;

delimiter //
create trigger descuentoOnUpdate
    before update
    on products
    for each row
begin
    case
        when new.statusProduct_id = '3' then
            set new.descuento = 0.10;
        when new.statusProduct_id = '1' then
            set new.descuento = 0;
        end case;
end //
delimiter ;

create table imagesProducts
(
    id         int  auto_increment,
    url        text not null,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    product_id   int,
    constraint primary key (id),
    foreign key (product_id) references products (id)
);

create table inventories
(
    id         int NOT NULL AUTO_INCREMENT,
    exist_inv  int,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    product_id int,
    office_id  int,
    PRIMARY KEY (id),
    constraint fk16 foreign key (product_id) references products (id) ON DELETE cascade ON UPDATE CASCADE,
    constraint foreign key (office_id) references offices (id) ON DELETE cascade ON UPDATE CASCADE
);

create table buys
(
    id               int NOT NULL AUTO_INCREMENT,
    dateBuy          timestamp,
    cost_com         float,
    created_at       timestamp default now(),
    updated_at       timestamp default now(),
    administrator_id bigint,
    primary key (id),
    foreign key (administrator_id) references administrators (id)
);

create table buyDetails
(
    cantidad_com int,
    cost_com     float,
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    buy_id       int,
    product_id   int,
    inventory_id int,
    foreign key (buy_id) references buys (id),
    foreign key (product_id) references products (id),
    foreign key (inventory_id) references inventories (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DELIMITER //
CREATE PROCEDURE TOTAL_COMPRA(in buys int, out total float)
BEGIN
    SELECT SUM(cantidad_com * costo_prod)
    into total
    FROM products,
         buyDetails,
         buys,
         inventories
    WHERE products.id = inventories.product_id
      AND buyDetails.buy_id = buys.id
      AND buyDetails.inventory_id = inventories.id
      and buys.id = buys;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER total_com
    AFTER INSERT
    ON buyDetails
    FOR EACH ROW
BEGIN
    CALL total_compra(new.buy_id, @total);
    UPDATE buys
    SET cost_com = @total
    WHERE id = new.buy_id;
END //
DELIMITER ;

create table sells
(
    id         int NOT NULL AUTO_INCREMENT,
    fec_vta    timestamp,
    monto_pago float,
    status_vta varchar(50),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    user_id    bigint,
    constraint pk17 primary key (id),
    constraint fk17 foreign key (user_id) references users (id) ON DELETE set null ON UPDATE CASCADE
);

create table sellDetails
(
    cantidad     int,
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    sell_id      int,
    inventory_id int,
    product_id   int,
    constraint foreign key (product_id) references products (id),
    constraint fk20 foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    constraint fk21 foreign key (inventory_id) references inventories (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

create table pays
(
    id         int NOT NULL AUTO_INCREMENT,
    fec_pago   timestamp,
    tipo_pago  varchar(30),
    created_at timestamp default now(),
    updated_at timestamp default now(),
    sell_id    int,
    buy_id     int,
    constraint pk18 primary key (id),
    constraint foreign key (buy_id) references buys (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    constraint fk18 foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

create table tickets
(
    id           int NOT NULL AUTO_INCREMENT,
    fechaFactura timestamp,
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    sell_id      int,
    buy_id       int,
    constraint pk19 primary key (id),
    constraint foreign key (buy_id) references buys (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    constraint fk19 foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

delimiter //
create trigger existencia_menos
    after insert
    on sellDetails
    for each row
begin
    update inventories
    set inventories.exist_inv = inventories.exist_inv - new.cantidad
    where inventories.id = new.inventory_id;
end //
delimiter ;

delimiter //
create trigger existencia_mas
    after insert
    on buyDetails
    for each row
begin
    update inventories
    set inventories.exist_inv = inventories.exist_inv + new.cantidad_com
    where inventories.id = new.inventory_id;
end //

DELIMITER //
CREATE PROCEDURE TOT_VTA(in sells int, out total float)
BEGIN
    SELECT SUM(cantidad * precio_prod - (cantidad * precio_prod * descuento))
    into total
    FROM products,
         sellDetails,
         tienda.sells,
         inventories
    WHERE products.id = inventories.product_id
      AND sellDetails.sell_id = sells.id
      AND sellDetails.inventory_id = inventories.id
      and sells.id = sells;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER tot
    AFTER INSERT
    ON sellDetails
    FOR EACH ROW
BEGIN
    CALL tot_vta(new.sell_id, @total);
    UPDATE sells
    SET monto_pago = @total
    WHERE id = new.sell_id;
END //
DELIMITER ;

create table shipments
(
    id         int NOT NULL AUTO_INCREMENT,
    fec_env    date,
    fec_ent    date,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    sell_id    int,
    user_id    bigint,
    address_id int,
    check (fec_env < fec_ent),
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    foreign key (address_id) references addresses (id)
);

create table audits
(
    id         int auto_increment primary key,
    usuario    varchar(30),
    old_precio float,
    new_precio float,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    product_id int,
    constraint foreign key (product_id) references products (id)
);

delimiter //
create trigger Auditoria
    before update
    on products
    for each row
begin
    insert into audits
    values (0, current_user(), new.id, old.precio_prod,
            new.precio_prod, now(), now());
end //
delimiter ;

delimiter //
create trigger verifica
    before insert
    on sells
    for each row
begin
    if new.fec_vta < now()
    then
        set new.fec_vta = now();
    end if;
end //
delimiter ;

show tables;


# update users
# set typeUser_id=3
# where id = 51;
#
# update users
# set typeUser_id=2
# where id = 53;
#
# update users
# set typeUser_id=2
# where id = 54;
#
# update users
# set typeUser_id=4
# where id = 55;
