CREATE TABLE place (
    place_id INT PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(10)
); 
CREATE TABLE musician (
    musician_id INT PRIMARY KEY,
    ssn VARCHAR(13),
    Name VARCHAR(50)
); 
CREATE TABLE live (
    place_id INT,
    musician_id INT,
    since DATE,
    PRIMARY KEY (place_id, musician_id),
    FOREIGN KEY (place_id) REFERENCES place(place_id),
    FOREIGN KEY (musician_id) REFERENCES musician(musician_id)
); 
CREATE TABLE instrument (
    instrument_id INT PRIMARY KEY,
    name VARCHAR(50),
    key VARCHAR(20)
);
CREATE TABLE play (
    play_id INT PRIMARY KEY,
    musician_id INT,
    instrument_id INT,
    FOREIGN KEY (musician_id) REFERENCES musician (musician_id),
    FOREIGN KEY (instrument_id) REFERENCES instrument (instrument_id)
);
CREATE TABLE album (
    album_id INT PRIMARY KEY,
    title VARCHAR(50),
    copyright_date DATE,
    format VARCHAR(50),
    album_identifier VARCHAR(50)
);
CREATE TABLE song(
    song_id INT PRIMARY KEY,
    title VARCHAR(100),
    author VARCHAR(50),
    album_id INT NOT NULL,
    FOREIGN KEY (album_id) REFERENCES album(album_id)
);
CREATE TABLE perform(
    perform_id INT PRIMARY KEY,
    musician_id INT,
    perform_date DATE,
    perform_place VARCHAR (100),
    song_id INT,
   FOREIGN KEY (musician_id) REFERENCES musician (musician_id),
   FOREIGN KEY (song_id) REFERENCES song (song_id)
);

-- place
INSERT INTO place (place_id, name, phone) VALUES (1, 'Bangkok Jazz Bar', '021234567');
INSERT INTO place (place_id, name, phone) VALUES (2, 'Chiangmai Music Hall', '053765432');
INSERT INTO place (place_id, name, phone) VALUES (3, 'Phuket Live House', '076998877');

-- musician
INSERT INTO musician (musician_id, ssn, Name) VALUES(1, '1101700000011', 'Anan');
INSERT INTO musician (musician_id, ssn, Name) VALUES(2, '1101700000022', 'Boon');
INSERT INTO musician (musician_id, ssn, Name) VALUES(3, '1101700000033', 'Chai');

-- live
INSERT INTO live (place_id, musician_id, since) VALUES(1, 1, '2023-01-10');
INSERT INTO live (place_id, musician_id, since) VALUES(2, 2, '2023-02-15');
INSERT INTO live (place_id, musician_id, since) VALUES(3, 3, '2023-03-20');

-- instrument
INSERT INTO instrument (instrument_id, name, key) VALUES(1, 'Piano', 'C');
INSERT INTO instrument (instrument_id, name, key) VALUES(2, 'Guitar', 'E');
INSERT INTO instrument (instrument_id, name, key) VALUES(3, 'Violin', 'G');

-- play
INSERT INTO play (play_id, musician_id, instrument_id) VALUES(1, 1, 1);
INSERT INTO play (play_id, musician_id, instrument_id) VALUES(2, 2, 2);
INSERT INTO play (play_id, musician_id, instrument_id) VALUES(3, 3, 3);

-- album
INSERT INTO album (album_id, title, copyright_date, format, album_identifier) VALUES (1, 'First Sound', '2023-01-01', 'Digital', 'ALB001');
INSERT INTO album (album_id, title, copyright_date, format, album_identifier) VALUES (2, 'Second Wave', '2023-02-01', 'CD', 'ALB002');
INSERT INTO album (album_id, title, copyright_date, format, album_identifier) VALUES (3, 'Final Note', '2023-03-01', 'Vinyl', 'ALB003');

-- song

INSERT INTO song (song_id, title, author, album_id) VALUES (1, 'Dream Melody', 'Anan', 1);
INSERT INTO song (song_id, title, author, album_id) VALUES (2, 'Blue Sky', 'Boon', 2);
INSERT INTO song (song_id, title, author, album_id) VALUES (3, 'Last Light', 'Chai', 3);

-- perform
INSERT INTO perform (perform_id, musician_id, song_id, perform_date, perform_place) VALUES (1, 1, 1, '2024-01-10', 'Central World Stage');
INSERT INTO perform (perform_id, musician_id, song_id, perform_date, perform_place) VALUES (2, 2, 2, '2024-02-15', 'Nimman Open Arena');
INSERT INTO perform (perform_id, musician_id, song_id, perform_date, perform_place) VALUES (3, 3, 3, '2024-03-20', 'Patong Beach Stage');

create table patient(
    patient_id int primary key,
    ssn varchar(13),
    name varchar(50),
    address varchar(100),
    age int ,
    doctor_id int,
    foreign key(doctor_id) references doctor(doctor_id)
);

create table doctor(
    doctor_id int primary key,
    ssn varchar(13),
    name varchar(50),
    specialty varchar(50),
    experience_years int
);

create table drug(
    drug_id int primary key,
    trade_name varchar(50),
    formula varchar(100)
);

create table prescription(
    prescription_id int primary key,
    patient_id int,
    doctor_id int,
    drug_id int,
    prescription_date date,
    quantity int,
    foreign key(patient_id) references patient(patient_id),
    foreign key(doctor_id) references doctor(doctor_id),
    foreign key(drug_id) references drug(drug_id)
);

create table pharmacy(
    pharmacy_id int primary key,
    name varchar(50),
    address varchar(100),
    phone varchar(12)
);

create table pharm_co(
    pharm_co_id int primary key,
    name varchar(50),
    phone varchar(12)
);

create table sell(
    sell_id int primary key,
    pharmacy_id int,
    drug_id int,
    price float,
    foreign key(pharmacy_id) references pharmacy(pharmacy_id),
    foreign key(drug_id) references drug(drug_id)
);

create table contract(
    contract_id int primary key,
    pharmacy_id int,
    pharm_co_id int,
    drug_id int,
    start_date date,
    end_date date,
    contract_note varchar(200),
    supervisor varchar(50),
    foreign key(pharmacy_id) references pharmacy(pharmacy_id),
    foreign key(pharm_co_id) references pharm_co(pharm_co_id),
    foreign key(drug_id) references drug(drug_id)
);



INSERT INTO doctor (doctor_id, ssn, name, specialty, experience_years) VALUES
(1, '1101701234567', 'Dr. Somchai', 'Cardiology', 15),
(2, '1201702345678', 'Dr. Supaporn', 'Pediatrics', 10),
(3, '1301703456789', 'Dr. Anan', 'Neurology', 8);

-- 2. ตาราง patient
INSERT INTO patient (patient_id, ssn, name, address, age, doctor_id) VALUES
(1, '3101704567890', 'Mr. Adisak', '123 Sukhumvit Rd, Bangkok', 45, 1),
(2, '3201705678901', 'Mrs. Kamonwan', '456 Rama IV Rd, Bangkok', 30, 2),
(3, '3301706789012', 'Ms. Nattaya', '789 Silom Rd, Bangkok', 28, 3);

-- 3. ตาราง drug
INSERT INTO drug (drug_id, trade_name, formula) VALUES
(1, 'Paracetamol', 'C8H9NO2'),
(2, 'Amoxicillin', 'C16H19N3O5S'),
(3, 'Aspirin', 'C9H8O4');

-- 4. ตาราง prescription
INSERT INTO prescription (prescription_id, patient_id, doctor_id, drug_id, prescription_date, quantity) VALUES
(1, 1, 1, 1, '2025-12-01', 10),
(2, 2, 2, 2, '2025-12-02', 20),
(3, 3, 3, 3, '2025-12-03', 15);

-- 5. ตาราง pharmacy
INSERT INTO pharmacy (pharmacy_id, name, address, phone) VALUES
(1, 'Bangkok Pharmacy', '101 Sukhumvit Rd, Bangkok', '0812345678'),
(2, 'Central Pharmacy', '202 Silom Rd, Bangkok', '0898765432');

-- 6. ตาราง pharm_co
INSERT INTO pharm_co (pharm_co_id, name, phone) VALUES
(1, 'Thai Pharma Co., Ltd.', '021234567'),
(2, 'Global Pharma Inc.', '022345678');

-- 7. ตาราง sell
INSERT INTO sell (sell_id, pharmacy_id, drug_id, price) VALUES
(1, 1, 1, 5.50),
(2, 1, 2, 12.75),
(3, 2, 1, 5.75),
(4, 2, 3, 8.20);

-- 8. ตาราง contract
INSERT INTO contract (contract_id, pharmacy_id, pharm_co_id, drug_id, start_date, end_date, contract_note, supervisor) VALUES
(1, 1, 1, 1, '2025-01-01', '2025-12-31', 'Annual supply of Paracetamol', 'Mr. Chai'),
(2, 1, 2, 2, '2025-06-01', '2025-12-31', 'Supply of Amoxicillin', 'Ms. Pim'),
(3, 2, 1, 1, '2025-03-01', '2025-12-31', 'Paracetamol supply', 'Mr. Somchai'),
(4, 2, 2, 3, '2025-07-01', '2025-12-31', 'Supply of Aspirin', 'Ms. Supaporn');

SELECT 
    p.name AS pharmacy,
    pc.name AS pharm_copany,
    d.trade_name AS drug,
    c.start_date,
    c.end_date
FROM contract c
join pharm_co pc on c.pharm_co_id = pc.pharm_co_id
join pharmacy p on c.pharmacy_id = p.pharmacy_id
join drug d on c.drug_id = d.drug_id;

SELECT
    p.name as pharmacy




SELECT pharmacy.name AS pharmacy, drug.trade_name AS drug, sell.price
FROM sell
join pharmacy ON sell.pharmacy_id = pharmacy.pharmacy_id
join drug ON sell.drug_id = drug.drug_id;

SELECT 
    p.name as patient,
    d.name as doctor
    dr.trade_name as drug,
    qr
    from patient p
    join doctor d on p.doctor_id = d.doctor_id;