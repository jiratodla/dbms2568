create table place(
    place_id int primary key ,
    name varchar(50),
    phone varchar(10)
);

create table musician(
    musician_id int primary key,
    ssn varchar(13),
    Name varchar(50)
):

create table live(
    place_id int,
    musician_id int,
    since date,
    primary key(place_id,musician_id),
    foreign key(place_id) references place(place_id),
    foreign key(musician_id) references musician(musician_id)

);

create table instrument(
    instrument_id int primary key,
    name varchar(50),
    key varchar(20)
);

create table play(
    play_id int primary key,
    musician_id int,
    instrument_id int,
    foreign key(musician_id) references musician(musician_id),
    foreign key(instrument_id) references instrument(instrument_id)
);


create table album(
    album_id int primary key,
    title varchar(50),
    copyright_date date,
    format varchar(50),
    album_identifier varchar(50)
);

create table song(
    song_id int primary key,
    title varchar(100),
    author varchar(50),
    album_id int not null,
    foreign key(album_id) references album(album_id
));

create table perform(
    perform_id int primary key,
    musician_id int,
    song_id int,
    perform_date date,
    perform_place varchar(100),
    foreign key (musician_id) references musician(musician_id),
    foreign key (song_id) references song(song_id)
);

alter table album add column producer_id int;
alter table album add constraint fk_producer_id foreign key(producer_id) references musician(musician_id);

insert into 