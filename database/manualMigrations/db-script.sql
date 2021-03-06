# drop database if exists babel;
drop database if exists tienda;
# create database if not exists babel;
create database if not exists tienda;
# create database if not exists trys;
# use babel;
use tienda;
# use trys;

# CREATE USER 'jamahcs' IDENTIFIED BY 'Acceso.117';
# GRANT ALL PRIVILEGES ON babel.* TO 'jamahcs';
# GRANT ALL PRIVILEGES ON tienda.* TO 'jamahcs';

# CREATE USER 'verohcs' IDENTIFIED BY 'Acceso.117';
# GRANT ALL PRIVILEGES ON tienda.* TO 'verohcs';
# GRANT ALL PRIVILEGES ON babel.* TO 'verohcs';

# CREATE USER 'laravelsystem' IDENTIFIED BY 'Acceso.117';
# GRANT ALL PRIVILEGES ON tienda.* TO 'laravelsystem';
# GRANT ALL PRIVILEGES ON babel.* TO 'laravelsystem';

# SET GLOBAL log_bin_trust_function_creators = 1;
# EST zona horaria east usa
# cambio en la 384
# php artisan make:model users -cfsr

drop table if exists addresses;
create table addresses
(
    id                    int NOT NULL AUTO_INCREMENT,
    street                varchar(100),
    exteriorNumberAddress int,
    interiorNumberAddress int,
    suburb                varchar(50),
    city                  varchar(50),
    estate                varchar(50),
    cp                    varchar(10),
    created_at            timestamp default now(),
    updated_at            timestamp default now(),
    user_id               bigint    default null,
    provider_id           int       default null,
    constraint pk4 primary key (id)
);

drop table if exists offices;
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

drop table if exists categories;
create table categories
(
    id           int NOT NULL AUTO_INCREMENT,
    nameCategory varchar(100),
    status       int       default 1,
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    constraint pk6 primary key (id)
);

drop table if exists providers;
create table providers
(
    id                  int         NOT NULL AUTO_INCREMENT,
    phone               bigint,
    nameProvider        varchar(30) not null,
    apProvider          varchar(50),
    amProvider          varchar(30),
    companyProvider     varchar(50),
    descriptionProvider varchar(30),
    emailProvider       varchar(70) not null,
    rfcProvider         varchar(13),
    status              int default 1,
    created_at          timestamp,
    updated_at          timestamp,
    constraint pk8 primary key (id)
);

ALTER TABLE addresses
    ADD CONSTRAINT FOREIGN KEY (provider_id)
        REFERENCES providers (id);

drop table if exists typeUsers;
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
       (0, 'Eliminado', now(), now()),
       (0, 'Diseñador', now(), now());

drop table if exists sexs;
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

drop table if exists users;
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
    profilePicture    varchar(500) default 'https://api.adorable.io/avatars/285/abott@adorable.png',
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

drop trigger if exists typeUsers;
delimiter //
create trigger typeUsers
    before insert
    on users
    for each row
begin
    set new.typeUser_id = 1;
end;
delimiter ;

drop table if exists administrators;
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

drop trigger if exists createAdmin;
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

drop trigger if exists timestamps;
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

drop table if exists statusProducts;
create table statusProducts
(
    id         int auto_increment not null,
    nameStatus varchar(50),
    constraint primary key (id)
);

insert into statusProducts(id, nameStatus)
values (0, 'Nuevo'),
       (0, 'Disponible'),
       (0, 'Liquidación'),
       (0, 'Sin existencia'),
       (0, 'Eliminado');

drop table if exists products;
create table products
(
    id               int          NOT NULL AUTO_INCREMENT,
    statusProduct_id int         default 2,
    nameProduct      varchar(100) not null,
    description_prod text,
    costo_prod       float        not null,
    precio_prod      float        not null,
    descuento        float,
    material_prod    varchar(50) default 'Algodón',
    category_id      int         default 1,
    provider_id      int         default 1,
    sex_id           int         default 1,
    created_at       timestamp   default now(),
    updated_at       timestamp   default now(),
    CHECK (precio_prod > costo_prod),
    constraint pk13 primary key (id),
    constraint foreign key (statusProduct_id) references statusProducts (id) on delete restrict on update cascade,
    constraint fk14 foreign key (category_id) references categories (id) ON DELETE restrict ON UPDATE CASCADE,
    constraint foreign key (sex_id) references sexs (id),
    constraint fk15 foreign key (provider_id) references providers (id) ON DELETE restrict ON UPDATE CASCADE
);

drop trigger if exists verificaPrecio;
delimiter //
create trigger verificaPrecio
    before insert
    on products
    for each row
begin
    if new.precio_prod <= new.costo_prod
    then
        set new.precio_prod = null;
    end if;
end //
delimiter  ;

drop table if exists imagesProducts;
create table imagesProducts
(
    id         int auto_increment,
    url        text not null,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    product_id int,
    constraint primary key (id),
    foreign key (product_id) references products (id)
);

drop table if exists inventories;
create table inventories
(
    id         int NOT NULL AUTO_INCREMENT,
    eq_s       int       default 0,
    eq_m       int       default 0,
    eq_g       int       default 0,
    ec_s       int       default 0,
    ec_m       int       default 0,
    ec_g       int       default 0,
    eg_s       int       default 0,
    eg_m       int       default 0,
    eg_g       int       default 0,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    product_id int,
    PRIMARY KEY (id),
    constraint fk16 foreign key (product_id) references products (id) ON DELETE cascade ON UPDATE CASCADE
);

drop trigger if exists prodXtrigger;
delimiter //
create trigger prodXtrigger
    after insert
    on products
    FOR EACH ROW
begin
    insert into inventories (product_id) value (new.id);
end//
delimiter ;

drop table if exists buyStatus;
create table buyStatus
(
    id         int auto_increment,
    nameStatus varchar(20),
    primary key (id)
);

insert into buyStatus
values (0, 'En proceso'),
       (0, 'Realizada'),
       (0, 'Cancelada'),
       (0, 'sin completar');

drop table if exists buys;
create table buys
(
    id               int NOT NULL AUTO_INCREMENT,
    concepto_compra  text,
    status_id        int       default 1,
    cost_com         float,
    created_at       timestamp default now(),
    updated_at       timestamp default now(),
    administrator_id bigint,
    provider_id      int,
    primary key (id),
    foreign key (provider_id) references providers (id),
    foreign key (administrator_id) references administrators (id),
    foreign key (status_id) references buyStatus (id)
);

drop table if exists buyDetails;
create table buyDetails
(
    id           int auto_increment,
    cantidad_com int,
    costoProduct float,
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    buy_id       int,
    product_id   int,
    eq_s         int       default 0,
    eq_m         int       default 0,
    eq_g         int       default 0,
    ec_s         int       default 0,
    ec_m         int       default 0,
    ec_g         int       default 0,
    eg_s         int       default 0,
    eg_m         int       default 0,
    eg_g         int       default 0,
    constraint primary key (id),
    foreign key (buy_id) references buys (id),
    foreign key (product_id) references products (id)
);

drop procedure if exists TOTAL_COMPRA;
DELIMITER $$
CREATE PROCEDURE TOTAL_COMPRA(in buys int, out total float)
BEGIN
    SELECT SUM(cantidad_com * costo_prod)
    into total
    FROM products,
         buyDetails,
         buys
    WHERE products.id = buydetails.product_id
      AND buyDetails.buy_id = buys.id
      and buys.id = buys;
END $$

drop trigger if exists total_com;
DELIMITER //
CREATE TRIGGER total_com
    AFTER INSERT
    ON buyDetails
    FOR EACH ROW
BEGIN
    CALL TOTAL_COMPRA(new.buy_id, @total);
    UPDATE buys
    SET cost_com = @total
    WHERE id = new.buy_id;
END //
DELIMITER ;

drop table if exists shipments;
create table shipments
(
    id         int NOT NULL AUTO_INCREMENT,
    paqueteria varchar(100),
    guia       varchar(100),
    fec_env    date,
    fec_ent    date,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    user_id    bigint,
    address_id int,
    primary key (id),
    foreign key (user_id) references users (id),
    foreign key (address_id) references addresses (id)
);

drop table if exists sells;
create table sells
(
    id          int          NOT NULL AUTO_INCREMENT,
    status_id   int       default 4,
    phone       bigint,
    name        varchar(200) not null,
    monto_pago  float,
    created_at  timestamp default now(),
    updated_at  timestamp default now(),
    user_id     bigint,
    address_id  int          not null,
    shipment_id int,
    constraint pk17 primary key (id),
    constraint foreign key (address_id) references addresses (id),
    constraint fk17 foreign key (user_id) references users (id) ON DELETE set null ON UPDATE CASCADE,
    foreign key (status_id) references buyStatus (id),
    foreign key (shipment_id) references shipments (id)
);

drop table if exists sellDetails;
create table sellDetails
(
    id           int auto_increment,
    costProduct  float,
    cantidad     int,
    created_at   timestamp default now(),
    updated_at   timestamp default now(),
    sell_id      int,
    inventory_id int,
    product_id   int,
    descuento    float     default 0,
    size         varchar(10),
    constraint primary key (id),
    constraint foreign key (product_id) references products (id),
    constraint fk20 foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    constraint fk21 foreign key (inventory_id) references inventories (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

delimiter //
drop procedure if exists pc_sell_s;
// delimiter ;

delimiter $$
create procedure pc_sell_s(in _product_id int, _cantidad int, out _disponibility boolean)
begin
    declare _existencia int;
    select ec_s + eg_s + eq_s into _existencia from inventories where product_id = _product_id;
    if _existencia > _cantidad then
        set _disponibility = true;
    else
        set _disponibility = false;
    end if;
end$$

drop procedure if exists pc_sell_m;
delimiter $$
create procedure pc_sell_m(in _product_id int, _cantidad int, out _disponibility boolean)
begin
    declare _existencia int;
    select ec_m + eg_m + eq_m into _existencia from inventories where product_id = _product_id;
    if _existencia > _cantidad then
        set _disponibility = true;
    else
        set _disponibility = false;
    end if;
end$$

drop procedure if exists pc_sell_g;
delimiter $$
create procedure pc_sell_g(in _product_id int, _cantidad int, out _disponibility boolean)
begin
    declare _existencia int;
    select ec_g + eg_g + eq_g into _existencia from inventories where product_id = _product_id;
    if _existencia > _cantidad then
        set _disponibility = true;
    else
        set _disponibility = false;
    end if;
end$$

drop procedure if exists pc_insert_detail;
delimiter $$
create procedure pc_insert_detail(in _product_id int, _cantidad int, _size_id int, _sell_id int)
begin
    declare _precio float;
    declare _inventory_id int;
    select id into _inventory_id from inventories where product_id = _product_id;
    select precio_prod into _precio from products where id = _product_id;
    if _size_id = 1 then
        call pc_sell_s(_product_id, _cantidad, @outbool);
        start transaction ;
        insert into selldetails (product_id, sell_id, cantidad, costProduct, size, inventory_id)
            value (_product_id, _sell_id, _cantidad, _precio, _size_id, _inventory_id);
        if @outbool = 1 then
            commit ;
        elseif @outbool = 0 then
            rollback ;
        end if;
    elseif _size_id = 2 then
        call pc_sell_m(_product_id, _cantidad, @outbool);
        start transaction ;
        insert into selldetails (product_id, sell_id, cantidad, costProduct, size, inventory_id)
            value (_product_id, _sell_id, _cantidad, _precio, _size_id, _inventory_id);
        if @outbool = 1 then
            commit ;
        elseif @outbool = 0 then
            rollback ;
        end if;
    elseif _size_id = 3 then
        call pc_sell_g(_product_id, _cantidad, @outbool);
        start transaction ;
        insert into selldetails (product_id, sell_id, cantidad, costProduct, size, inventory_id)
            value (_product_id, _sell_id, _cantidad, _precio, _size_id, _inventory_id);
        if @outbool = 1 then
            commit ;
        elseif @outbool = 0 then
            rollback ;
        end if;
    end if;
end$$

drop table if exists pays;
create table pays
(
    id            varchar(255) NOT NULL,
    tipo_pago     varchar(50),
    receipt_email varchar(255),
    status        varchar(120),
    amount        float,
    created_at    timestamp default now(),
    updated_at    timestamp default now(),
    sell_id       int,
    constraint pk18 primary key (id),
    constraint fk18 foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

drop table if exists tickets;
create table tickets
(
    id                 varchar(255),
    url                varchar(255),
    customer_stripe_id varchar(255),
    created_at         timestamp default now(),
    updated_at         timestamp default now(),
    sell_id            int,
    constraint pk19 primary key (id),
    constraint fk19 foreign key (sell_id) references sells (id) ON DELETE RESTRICT ON UPDATE RESTRICT
);

drop procedure if exists TOT_VTA;
DELIMITER $$
CREATE PROCEDURE TOT_VTA(in sells int, out total float)
BEGIN
    SELECT SUM(cantidad * precio_prod - (cantidad * precio_prod * sellDetails.descuento))
    into total
    FROM products,
         sellDetails,
         sells
    WHERE products.id = sellDetails.product_id
      AND sellDetails.sell_id = sells.id
      and sells.id = sells;
END $$

drop trigger if exists tot;
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

drop table if exists audits;
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

drop trigger if exists Auditoria;
delimiter //
create trigger Auditoria
    before update
    on products
    for each row
begin
    insert into audits
    values (0, current_user(), old.precio_prod,
            new.precio_prod, now(), now(), new.id);
end //
delimiter ;

drop table if exists wish_lists;
create table if not exists wish_lists
(
    id         bigint auto_increment primary key,
    user_id    bigint,
    product_id int,
    created_at timestamp default now(),
    updated_at timestamp default now(),
    constraint foreign key (user_id) references users (id),
    constraint foreign key (product_id) references products (id)
);

show tables;
