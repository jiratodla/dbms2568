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

