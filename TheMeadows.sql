-- The Meadows Database
-- Marcus Zimmermann
-- Marist '19




-- drop in case they exist
DROP TYPE  IF EXISTS dayText	    CASCADE;
DROP TYPE  IF EXISTS TTText	    CASCADE;
DROP TYPE  IF EXISTS HCText	    CASCADE;
DROP TABLE IF EXISTS People	    CASCADE;
DROP TABLE IF EXISTS Concertgoers   CASCADE;
DROP TABLE IF EXISTS Performers     CASCADE;
DROP TABLE IF EXISTS Staff 	    CASCADE;
DROP TABLE IF EXISTS Volunteers     CASCADE;
DROP TABLE IF EXISTS MemberOf 	    CASCADE;
DROP TABLE IF EXISTS Bands 	    CASCADE;
DROP TABLE IF EXISTS AppearsIn 	    CASCADE;
DROP TABLE IF EXISTS Sets	    CASCADE;
DROP TABLE IF EXISTS Venues	    CASCADE;
DROP TABLE IF EXISTS KnowsHowToPlay CASCADE;
DROP TABLE IF EXISTS Instruments    CASCADE;
DROP TABLE IF EXISTS UsedIn	    CASCADE;
DROP TABLE IF EXISTS Songs	    CASCADE;
DROP TABLE IF EXISTS SongsInSet     CASCADE;
DROP TABLE IF EXISTS WorksDuring    CASCADE;
DROP TABLE IF EXISTS Shifts	    CASCADE;
DROP TABLE IF EXISTS AssignedTo	    CASCADE;
DROP TABLE IF EXISTS Jobs	    CASCADE;
DROP TABLE IF EXISTS JobLocations   CASCADE;
DROP ROLE IF EXISTS Admin;
DROP ROLE IF EXISTS Staff;
DROP ROLE IF EXISTS Volunteers;




-- CREATE TYPES -- -- CREATE TYPES -- -- CREATE TYPES --
-- only Saturday or Sunday can be entered for Day
CREATE TYPE dayText AS ENUM ('Saturday', 'Sunday') ;
--

-- only certain ticket types can be entered
CREATE TYPE TTText AS ENUM ('Saturday GA', 'Sunday GA', '2-Day GA', 
'Saturday VIP', 'Sunday VIP', '2-Day VIP', '2-Day Super VIP') ;
--

-- only yes or no can be entered for HoursCompleted
CREATE TYPE HCText AS ENUM ('yes', 'no') ;
--




-- PEOPLE -- -- PEOPLE -- -- PEOPLE -- AND SUBTYPES -- -- AND SUBTYPES -- -- AND SUBTYPES --
CREATE TABLE People (
	PID	  SERIAL NOT NULL PRIMARY KEY ,
	FirstName TEXT   NOT NULL,
	LastName  TEXT   NOT NULL,
	DOB 	  DATE   NOT NULL
);
--

-- CONCERTGOERS -- -- CONCERTGOERS -- -- CONCERTGOERS --
CREATE TABLE Concertgoers (
	PID 	   SERIAL NOT NULL REFERENCES People(PID),
	TicketType TTText NOT NULL
);
--

-- PERFORMERS -- -- PERFORMERS -- -- PERFORMERS --
CREATE TABLE Performers (
	PID 	      SERIAL NOT NULL REFERENCES People(PID),
	StageName     TEXT,
	PreShowRitual TEXT
);
--

-- STAFF -- -- STAFF -- -- STAFF --
CREATE TABLE Staff (
	PID 	      SERIAL NOT NULL REFERENCES People(PID),
	HourlyWageUSD INT    NOT NULL
);
--

-- VOLUNTEERS -- -- VOLUNTEERS -- -- VOLUNTEERS --
CREATE TABLE Volunteers (
	PID 	       SERIAL NOT NULL REFERENCES People(PID),
	HoursCompleted HCText NOT NULL
);
--




-- VENUES -- -- VENUES -- -- VENUES --
CREATE TABLE Venues (
	VenueID Serial PRIMARY KEY NOT NULL,
	Name    TEXT   NOT NULL
);
--

-- SETS -- -- SETS -- -- SETS --
CREATE TABLE Sets (
	SetID 	  SERIAL  NOT NULL PRIMARY KEY ,
	VenueID   Serial  NOT NULL REFERENCES Venues(VenueID),
	Day       dayText NOT NULL,
	StartTime TIME    NOT NULL,
	EndTime   TIME    NOT NULL
);
--

-- APPEARS IN -- -- APPEARS IN -- -- APPEARS IN --
CREATE TABLE AppearsIn (
	PID   Serial NOT NULL REFERENCES People(PID),
	SetID Serial NOT NULL REFERENCES Sets(SetID),
	PRIMARY KEY (PID, SetId)
);
--




-- BANDS -- -- BANDS -- -- BANDS --
CREATE TABLE Bands (
	BID 	      SERIAL NOT NULL PRIMARY KEY ,
	Name 	      TEXT   NOT NULL,
	YearsTogether INT
);
--

-- MEMBER OF -- -- MEMBER OF -- -- MEMBER OF --
CREATE TABLE MemberOf (
	PID Serial NOT NULL REFERENCES People(PID),
	BID Serial NOT NULL REFERENCES Bands(BID),
	PRIMARY KEY (PID, BID)
);
--




-- INSTRUMENTS -- -- INSTRUMENTS -- -- INSTRUMENTS --
CREATE TABLE Instruments (
	InstrumentId Serial NOT NULL PRIMARY KEY,
	Name 	     TEXT   NOT NULL
);
--

-- KNOWS HOW TO PLAY -- -- KNOWS HOW TO PLAY -- -- KNOWS HOW TO PLAY --
CREATE TABLE KnowsHowToPlay (
	PID 	     Serial NOT NULL REFERENCES People(PID),
	InstrumentID Serial NOT NULL REFERENCES Instruments(InstrumentID),
	PRIMARY KEY (PID, InstrumentID)
);
--




-- SONGS -- -- SONGS -- -- SONGS --
CREATE TABLE Songs (
	SongID   Serial NOT NULL PRIMARY KEY,
	SongName TEXT   NOT NULL
);
--

-- USED IN -- -- USED IN -- -- USED IN --
CREATE TABLE UsedIn (
	InstrumentID Serial NOT NULL REFERENCES Instruments(InstrumentID),
	SongID 	     Serial NOT NULL REFERENCES Songs(SongID),
	PRIMARY KEY (InstrumentID, SongID)
);
--

-- SONGS IN SET -- -- SONGS IN SET -- -- SONGS IN SET --
CREATE TABLE SongsInSet (
	SongID Serial NOT NULL REFERENCES Songs(SongID),
	SetID  Serial NOT NULL REFERENCES Sets(SetID),
	PRIMARY KEY (SongID, SetID)
);
--




-- SHIFTS -- -- SHIFTS -- -- SHIFTS --
CREATE TABLE Shifts (
	SID 	  Serial  NOT NULL PRIMARY KEY,
	Day 	  DayText NOT NULL,
	StartTime TIME    NOT NULL,
	EndTime   TIME    NOT NULL
);
--

-- WORKS DURING -- -- WORKS DURING -- -- WORKS DURING --
CREATE TABLE WorksDuring (
	PID Serial NOT NULL REFERENCES People(PID),
	SID Serial NOT NULL REFERENCES Shifts(SID),
	PRIMARY KEY (PID, SID)
);
--




-- JOBS -- -- JOBS -- -- JOBS --
CREATE TABLE Jobs (
	JID 	    Serial NOT NULL PRIMARY KEY,
	Name 	    TEXT   NOT NULL,
	Description TEXT   NOT NULL
);
--

-- ASSIGNED TO -- -- ASSIGNED TO -- -- ASSIGNED TO --
CREATE TABLE AssignedTo (
	PID Serial NOT NULL REFERENCES People(PID),
	JID Serial NOT NULL REFERENCES Jobs(JID),
	PRIMARY KEY (PID, JID)
);
--

-- JOB LOCATIONS -- -- JOB LOCATIONS -- -- JOB LOCATIONS --
CREATE TABLE JobLocations (
	JID 	Serial NOT NULL REFERENCES Jobs(JID),
	VenueID Serial NOT NULL REFERENCES Venues(VenueID),
	PRIMARY KEY (JID, VenueID)
);
--




-- SAMPLE DATA -- -- SAMPLE DATA -- -- SAMPLE DATA -- -- SAMPLE DATA -- -- SAMPLE DATA --

-- sample data, concertgoers
INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Marcus', 'Zimmermann', '01-26-1997') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('G', 'Leaden', '02-24-1997') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Marcella', 'Rose', '05-29-1996') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Janine', 'Lim', '09-11-1997') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Lauren', 'Vecchio', '01-02-1997') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Katie', 'Kilkullen', '09-03-1997') ;

-- sample data, performers
INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Chancellor', 'Bennett', '04-16-1993') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Nico', 'Segal', '06-25-1993') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Bryson', 'Tiller', '01-02-1993') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Austin', 'Post', '07-04-1995') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Kanye', 'West', '06-08-1977') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Matthew', 'Healy', '04-08-1989') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Adam', 'Hann', '06-20-1989') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Ross', 'Macdonald', '06-06-1990') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('George', 'Daniel', '03-26-1990') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Caroline', 'Polacheck', '06-20-1985') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Patrick', 'Wimberly', '05-29-1983') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Jermaine', 'Cole', '01-28-1985') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Kyrre', 'Gørvell-Dahll', '09-11-1991') ;

-- sample data staff/volunteers (Members of Founder's Entertainment)
INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Tom', 'Russel', '01-01-1985') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Jordan', 'Wolowitz', '01-02-1985') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Jennifer', 'Styles', '01-03-1985') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Alex', 'Joffe', '01-04-1985') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Jack', 'Black', '08-28-1969') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Kyle', 'Gass', '07-14-1960') ;

INSERT INTO People (FirstName, LastName, DOB)
VALUES ('Dave', 'Grohl', '01-14-1969') ;

-- Select * from people
SELECT * FROM People ;
--

-- CONCERTGOERS -- -- CONCERTGOERS -- -- CONCERTGOERS --
INSERT INTO Concertgoers (PID, TicketType)
VALUES (1, 'Sunday GA') ;

INSERT INTO Concertgoers (PID, TicketType)
VALUES (2, 'Sunday GA') ;

INSERT INTO Concertgoers (PID, TicketType)
VALUES (3, 'Sunday GA') ;

INSERT INTO Concertgoers (PID, TicketType)
VALUES (4, 'Sunday GA') ;

INSERT INTO Concertgoers (PID, TicketType)
VALUES (5, 'Sunday GA') ;

INSERT INTO Concertgoers (PID, TicketType)
VALUES (6, '2-Day Super VIP') ;

-- Select * from concertgoers
SELECT * FROM Concertgoers;
--

-- PERFORMERS -- -- PERFORMERS -- -- PERFORMERS --
INSERT INTO Performers (PID, Stagename, PreShowRitual)
VALUES (7, 'Chance The Rapper', 'Eats some Sunday candy') ;

INSERT INTO Performers (PID, Stagename, PreShowRitual)
VALUES (8, 'Donnie Trumpet', 'Talks to his trumpet') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (9, 'Looks for Waldo amongst all the concertgoers') ;

INSERT INTO Performers (PID, Stagename, PreShowRitual)
VALUES (10, 'Post Malone', 'Balls like Iverson') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (11, 'Admires himself in the mirror for ten minutes') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (12, 'Puts on an entirely plaid outfit') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (13, 'Tunes his guitar more times than necessary') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (14, 'Smokes two packs of cigarette') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (15, 'Walks around aimlessly') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (16, 'Prays to Codd') ;

INSERT INTO Performers (PID, PreShowRitual)
VALUES (17, 'Prays to Codd') ;

INSERT INTO Performers (PID, Stagename, PreShowRitual)
VALUES (18, 'J. Cole', 'Calls out false prophets... @codd') ;

INSERT INTO Performers (PID, Stagename, PreShowRitual)
VALUES (19, 'Kygo', 'Contemplates the inevitable heat death of the universe') ;

-- Select * from performers
SELECT * FROM Performers;
--

-- STAFF -- -- STAFF -- -- STAFF --
INSERT INTO Staff (PID, HourlyWageUSD)
VALUES (20, '10') ;

INSERT INTO Staff (PID, HourlyWageUSD)
VALUES (21, '11') ;

INSERT INTO Staff (PID, HourlyWageUSD)
VALUES (22, '11') ;

INSERT INTO Staff (PID, HourlyWageUSD)
VALUES (23, '11') ;

-- Select * from staff
SELECT * FROM Staff ;
--

-- VOLUNTEERS -- -- VOLUNTEERS -- -- VOLUNTEERS --
INSERT INTO Volunteers (PID, HoursCompleted)
VALUES (24, 'no') ;

INSERT INTO Volunteers (PID, HoursCompleted)
VALUES (25, 'no') ;

INSERT INTO Volunteers (PID, HoursCompleted)
VALUES (26, 'no') ;

-- Select * from volunteers
SELECT * FROM Volunteers;
--




-- VENUES -- -- VENUES -- -- VENUES --
INSERT INTO Venues (Name)
VALUES ('The Meadows') ;

INSERT INTO Venues (Name)
VALUES ('Linden Blvd') ;

INSERT INTO Venues (Name)
VALUES ('Queens Blvd') ;

INSERT INTO Venues (Name)
VALUES ('Shea') ;

-- Select * from venues
SELECT * FROM Venues;
--

-- SETS -- -- SETS -- -- SETS --
INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (1, 'Saturday', '3:00:PM', '3:45:PM') ; -- post malone

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (1, 'Saturday', '8:45:PM', '10:00:PM') ; -- j. cole

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (2, 'Sunday', '1:15:PM', '2:00:PM') ; -- chairlift

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (1, 'Sunday', '3:45:PM', '4:45:PM') ; -- bryson tiller

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (1, 'Sunday', '5:45:PM', '7:00:PM') ; -- chance (chancellor) and donnie (nico)

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (4, 'Sunday', '7:00:PM', '8:00:PM') ; -- the 1975

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (3, 'Sunday', '8:00:PM', '9:30:PM') ; -- kygo

INSERT INTO Sets (VenueID, Day, StartTime, EndTime)
VALUES (1, 'Sunday', '8:15:PM', '10:00:PM') ; -- kanye

-- Select * from sets
SELECT * FROM Sets;
--

-- APPEARS IN -- -- APPEARS IN -- -- APPEARS IN --
INSERT INTO AppearsIn (PID, SetID)
VALUES (10, 1) ; -- post malone

INSERT INTO AppearsIn (PID, SetID)
VALUES (18, 2) ; -- j. cole

INSERT INTO AppearsIn (PID, SetID)
VALUES (16, 3) ; -- chairlift (Caroline)
INSERT INTO AppearsIn (PID, SetID)
VALUES (17, 3) ; -- chairlift (Patrick)

INSERT INTO AppearsIn (PID, SetID)
VALUES (9, 4) ; -- bryson tiller

INSERT INTO AppearsIn (PID, SetID)
VALUES (7, 5) ; -- Chancellor
INSERT INTO AppearsIn (PID, SetID)
VALUES (8, 5) ; -- Nico

INSERT INTO AppearsIn (PID, SetID)
VALUES (12, 6) ; -- the 1975 (Matthew)
INSERT INTO AppearsIn (PID, SetID)
VALUES (13, 6) ; -- the 1975 (Adam)
INSERT INTO AppearsIn (PID, SetID)
VALUES (14, 6) ; -- the 1975 (Ross)
INSERT INTO AppearsIn (PID, SetID)
VALUES (15, 6) ; -- the 1975 (George)

INSERT INTO AppearsIn (PID, SetID)
VALUES (19, 7) ; -- kygo

INSERT INTO AppearsIn (PID, SetID)
VALUES (11, 8) ; -- kanye

-- Select * form AppearsIn
SELECT * FROM AppearsIn;
--




-- BANDS -- -- BANDS -- -- BANDS --
INSERT INTO Bands (Name, YearsTogether)
VALUES ('The 1975', 14) ;

INSERT INTO Bands (Name, YearsTogether)
VALUES ('Chairlift', 11) ;

-- Select * from Bands
SELECT * FROM Bands;
--

-- MEMBEROF -- -- MEMBEROF -- -- MEMBEROF --
INSERT INTO MemberOf (PID, BID)
VALUES (12, 1); -- the 1975 (Matthew)
INSERT INTO MemberOf (PID, BID)
VALUES (13, 1); -- the 1975 (Adam)
INSERT INTO MemberOf (PID, BID)
VALUES (14, 1); -- the 1975 (Ross)
INSERT INTO MemberOf (PID, BID)
VALUES (15, 1); -- the 1975 (George)

INSERT INTO MemberOf (PID, BID)
VALUES (16, 2); -- Chairlift (Caroline)
INSERT INTO MemberOf (PID, BID)
VALUES (17, 2); -- Chairlift (Patrick)

-- Select * from MemberOf
SELECT * FROM MemberOf;
--




-- Instruments -- -- Instruments -- -- Instruments --
INSERT INTO Instruments (Name)
VALUES ('Trumpet') ;

INSERT INTO Instruments (Name)
VALUES ('Guitar') ;

INSERT INTO Instruments (Name)
VALUES ('Bass Guitar') ;

INSERT INTO Instruments (Name)
VALUES ('Drums') ;

INSERT INTO Instruments (Name)
VALUES ('Piano') ;

-- Select * from Instruments
SELECT * FROM Instruments;
--

-- KnowsHowToPlay -- -- KnowsHowToPlay -- -- KnowsHowToPlay --
INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (8, 1) ; -- trumpet

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (12, 2) ; -- guitar

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (13, 2) ; -- guitar

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (17, 2) ; -- guitar

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (17, 4) ; -- drums

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (14, 3) ; -- base guitar

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (15, 4) ; -- drums

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (7, 5) ; -- piano

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (16, 5) ; -- piano

INSERT INTO KnowsHowToPlay (PID, InstrumentID)
VALUES (19, 5) ; -- piano

-- Select * from KnowsHowToPlay
SELECT * FROM KnowsHowToPlay;
--




-- SONGS -- -- SONGS -- -- SONGS --
-- Post Malone --
INSERT INTO Songs (SongName)
VALUES ('White Iverson Intro');
INSERT INTO Songs (SongName)
VALUES ('Too Young');
INSERT INTO Songs (SongName)
VALUES ('Go Flex');
INSERT INTO Songs (SongName)
VALUES ('Hollywood Dreams Come Down');
INSERT INTO Songs (SongName)
VALUES ('Tear$');
INSERT INTO Songs (SongName)
VALUES ('Window Shopper');
INSERT INTO Songs (SongName)
VALUES ('Money Made Me Do It');
INSERT INTO Songs (SongName)
VALUES ('White Iverson');

-- J. Cole --
INSERT INTO Songs (SongName)
VALUES ('A Tale of 2 Citiez');
INSERT INTO Songs (SongName)
VALUES ('Fire Squad');
INSERT INTO Songs (SongName)
VALUES ('Wet Dreamz');
INSERT INTO Songs (SongName)
VALUES ('Nobody''s Perfect');
INSERT INTO Songs (SongName)
VALUES ('St. Tropez');
INSERT INTO Songs (SongName)
VALUES ('No Role Modelz');
INSERT INTO Songs (SongName)
VALUES ('Lights Please');
INSERT INTO Songs (SongName)
VALUES ('In The Morning');
INSERT INTO Songs (SongName)
VALUES ('Lit');
INSERT INTO Songs (SongName)
VALUES ('Housewives');
INSERT INTO Songs (SongName)
VALUES ('G.O.M.D.');
INSERT INTO Songs (SongName)
VALUES ('Apparently');
INSERT INTO Songs (SongName)
VALUES ('Love Yourz');
INSERT INTO Songs (SongName)
VALUES ('Can''t Get Enough');
INSERT INTO Songs (SongName)
VALUES ('Work Out');
INSERT INTO Songs (SongName)
VALUES ('Planez');
INSERT INTO Songs (SongName)
VALUES ('Crooked Smile');
INSERT INTO Songs (SongName)
VALUES ('Power Trip');
INSERT INTO Songs (SongName)
VALUES ('Note to Self');

-- Chairlift --
INSERT INTO Songs (SongName)
VALUES ('Look Up');
INSERT INTO Songs (SongName)
VALUES ('Polymorphing');
INSERT INTO Songs (SongName)
VALUES ('Amanaemonesia');
INSERT INTO Songs (SongName)
VALUES ('I Belong in Your Arms');
INSERT INTO Songs (SongName)
VALUES ('Show U Off');
INSERT INTO Songs (SongName)
VALUES ('Romeo');
INSERT INTO Songs (SongName)
VALUES ('Bruises');
INSERT INTO Songs (SongName)
VALUES ('Crying In Public');
INSERT INTO Songs (SongName)
VALUES ('Moth to the Flame');
INSERT INTO Songs (SongName)
VALUES ('Ch-Ching');

-- Bryson Tiller --
INSERT INTO Songs (SongName)
VALUES ('Intro (Difference)');
INSERT INTO Songs (SongName)
VALUES ('Let Em'' Know');
INSERT INTO Songs (SongName)
VALUES ('Set You Free');
INSERT INTO Songs (SongName)
VALUES ('Open Interlude');
INSERT INTO Songs (SongName)
VALUES ('Exchange');
INSERT INTO Songs (SongName)
VALUES ('Sorry Not Sorry');
INSERT INTO Songs (SongName)
VALUES ('Rambo');
INSERT INTO Songs (SongName)
VALUES ('502 Come Up');
INSERT INTO Songs (SongName)
VALUES ('For However Long');
INSERT INTO Songs (SongName)
VALUES ('The Sequence');
INSERT INTO Songs (SongName)
VALUES ('Been That Way');
INSERT INTO Songs (SongName)
VALUES ('Don''t');

-- Chance and Donnie --
INSERT INTO Songs (SongName)
VALUES ('Angels');
INSERT INTO Songs (SongName)
VALUES ('Blessings');
INSERT INTO Songs (SongName)
VALUES ('Pusha Man');
INSERT INTO Songs (SongName)
VALUES ('Smoke Again');
INSERT INTO Songs (SongName)
VALUES ('Cocoa Butter Kisses');
INSERT INTO Songs (SongName)
VALUES ('Favorite Song');
INSERT INTO Songs (SongName)
VALUES ('Brain Cells');
INSERT INTO Songs (SongName)
VALUES ('Smoke Break');
INSERT INTO Songs (SongName)
VALUES ('Juke Jam');
INSERT INTO Songs (SongName)
VALUES ('Same Drugs');
INSERT INTO Songs (SongName)
VALUES ('Baby Blue');
INSERT INTO Songs (SongName)
VALUES ('The Way');
INSERT INTO Songs (SongName)
VALUES ('Ultralight Beam');
INSERT INTO Songs (SongName)
VALUES ('No Problem');
INSERT INTO Songs (SongName)
VALUES ('Mixtape');
INSERT INTO Songs (SongName)
VALUES ('All Night');
INSERT INTO Songs (SongName)
VALUES ('D.R.A.M. Sings Special');
INSERT INTO Songs (SongName)
VALUES ('Grown Ass Kid');
INSERT INTO Songs (SongName)
VALUES ('Sunday Candy');
INSERT INTO Songs (SongName)
VALUES ('All We Got');
INSERT INTO Songs (SongName)
VALUES ('How Great');
INSERT INTO Songs (SongName)
VALUES ('Blessings (Reprise)');
INSERT INTO Songs (SongName)
VALUES ('Summer Friends');
INSERT INTO Songs (SongName)
VALUES ('Friends');

-- The 1975 --
INSERT INTO Songs (SongName)
VALUES ('Love Me');
INSERT INTO Songs (SongName)
VALUES ('UGH!');
INSERT INTO Songs (SongName)
VALUES ('Heart Out');
INSERT INTO Songs (SongName)
VALUES ('A Change of Heart');
INSERT INTO Songs (SongName)
VALUES ('She''s American');
INSERT INTO Songs (SongName)
VALUES ('Loving Someone');
INSERT INTO Songs (SongName)
VALUES ('Somebody Else');
INSERT INTO Songs (SongName)
VALUES ('Paris');
INSERT INTO Songs (SongName)
VALUES ('Girls');
INSERT INTO Songs (SongName)
VALUES ('If I Believe You');
INSERT INTO Songs (SongName)
VALUES ('Chocolate');
INSERT INTO Songs (SongName)
VALUES ('The Sound');
INSERT INTO Songs (SongName)
VALUES ('12');
INSERT INTO Songs (SongName)
VALUES ('Sex');

-- Kygo --
INSERT INTO Songs (SongName)
VALUES ('Stole Your Show');
INSERT INTO Songs (SongName)
VALUES ('Younger');
INSERT INTO Songs (SongName)
VALUES ('Fiction');
INSERT INTO Songs (SongName)
VALUES ('Feels Like Home');
INSERT INTO Songs (SongName)
VALUES ('No Money');
INSERT INTO Songs (SongName)
VALUES ('OOkay');
INSERT INTO Songs (SongName)
VALUES ('Here Comes The Night');
INSERT INTO Songs (SongName)
VALUES ('Sexual Healing');
INSERT INTO Songs (SongName)
VALUES ('Carry Me');
INSERT INTO Songs (SongName)
VALUES ('Carry On For Me');
INSERT INTO Songs (SongName)
VALUES ('Give Me Your Love');
INSERT INTO Songs (SongName)
VALUES ('I''m In Love');
INSERT INTO Songs (SongName)
VALUES ('Stay');
INSERT INTO Songs (SongName)
VALUES ('Firestone');

-- Kanye --
INSERT INTO Songs (SongName)
VALUES ('Father Stretch My Hands Pt. 1');
INSERT INTO Songs (SongName)
VALUES ('Pt. 2');
INSERT INTO Songs (SongName)
VALUES ('Famous');
INSERT INTO Songs (SongName)
VALUES ('Pop Style');
INSERT INTO Songs (SongName)
VALUES ('THat Part');
INSERT INTO Songs (SongName)
VALUES ('Facts');
INSERT INTO Songs (SongName)
VALUES ('Mercy');
INSERT INTO Songs (SongName)
VALUES ('Don''t Like');
INSERT INTO Songs (SongName)
VALUES ('All Day');
INSERT INTO Songs (SongName)
VALUES ('Black Skinhead');
INSERT INTO Songs (SongName)
VALUES ('Niggas in Paris');
INSERT INTO Songs (SongName)
VALUES ('Can''t Tell Me Nothing');
INSERT INTO Songs (SongName)
VALUES ('Power');
INSERT INTO Songs (SongName)
VALUES ('Blood on the Leaves');
INSERT INTO Songs (SongName)
VALUES ('Freestyle 4');
INSERT INTO Songs (SongName)
VALUES ('New Slaves');
INSERT INTO Songs (SongName)
VALUES ('Jesus Walks');
INSERT INTO Songs (SongName)
VALUES ('Flashing Lights');
INSERT INTO Songs (SongName)
VALUES ('Highlights');
INSERT INTO Songs (SongName)
VALUES ('Feedback');
INSERT INTO Songs (SongName)
VALUES ('Wolves');
INSERT INTO Songs (SongName)
VALUES ('Heartless');

-- USED IN -- -- USED IN -- -- USED IN --
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES ( 1, 50); -- trumpet --
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES ( 1, 51);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES ( 1, 68);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES ( 1, 69);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES ( 1, 70);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES ( 1, 71);

INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (2, 74); -- guitar --
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (2, 75);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (2, 76);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (2, 78);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (2, 82);

INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (3, 74); -- bass guitar --
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (3, 75);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (3, 76);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (3, 78);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (3, 82);

INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (4, 74); -- drums --
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (4, 75);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (4, 76);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (4, 78);
INSERT INTO UsedIn (InstrumentID, SongID)
VALUES (4, 82);

--
SELECT * FROM Songs;
--

-- SONGS IN SET -- -- SONGS IN SET -- -- SONGS IN SET --
-- songs in post malone's set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 1, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 2, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 3, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 4, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 5, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 6, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 7, 1);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 8, 1);

-- j. cole's set
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 9, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 10, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 11, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 12, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 13, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 14, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 15, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 16, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 17, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 18, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 19, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 20, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 21, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 22, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 23, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 24, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 25, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 26, 2);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 27, 2);

-- chairlifts set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 28, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 29, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 30, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 31, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 32, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 33, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 34, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 35, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 36, 3);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 37, 3);

-- bryson's set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 38, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 39, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 40, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 41, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 42, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 43, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 44, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 45, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 46, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 47, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 48, 4);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 49, 4);

-- chance's set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 50, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 51, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 52, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 53, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 54, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 55, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 56, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 57, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 58, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 59, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 60, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 61, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 62, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 63, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 64, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 65, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 66, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 67, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 68, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 69, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 70, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 71, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 72, 5);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 73, 5);

-- The 1975's set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 74, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 75, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 76, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 77, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 78, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 79, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 80, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 81, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 82, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 83, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 84, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 85, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 86, 6);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 87, 6);

-- Kygo's set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 88, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 89, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 90, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 91, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 92, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 93, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 94, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 95, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 96, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 97, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 98, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 99, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 100, 7);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 101, 7);

-- Kanye's Set --
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 102, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 103, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 104, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 105, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 106, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 107, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 108, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 109, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 110, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 111, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 112, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 113, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 114, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 115, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 116, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 117, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 118, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 119, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 120, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 121, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 122, 8);
INSERT INTO SongsInSet (SongID, SetID)
VALUES ( 123, 8);




-- SHIFTS -- -- SHIFTS -- -- SHIFTS --
-- early shift, saturday --
INSERT INTO Shifts (Day, StartTime, Endtime)
VALUES ('Saturday', '06:00:am', '03:00:pm');
-- late shift, saturday --
INSERT INTO Shifts (Day, StartTime, Endtime)
VALUES ('Saturday', '03:00:pm', '12:00:am');
-- early shift, sunday --
INSERT INTO Shifts (Day, StartTime, Endtime)
VALUES ('Sunday', '06:00:am', '03:00:pm');
-- late shift, sunday --
INSERT INTO Shifts (Day, StartTime, Endtime)
VALUES ('Sunday', '03:00:pm', '12:00:am');

-- WORKS DURING -- -- WORKS DURING -- -- WORKS DURING --
-- Staff --
INSERT INTO WorksDuring (PID, SID)
VALUES ( 20, 1);	-- Tom Russel
INSERT INTO WorksDuring (PID, SID)
VALUES ( 21, 2);	-- Jordan Wolowitz
INSERT INTO WorksDuring (PID, SID)
VALUES ( 22, 3);	-- Jennifer Styles
INSERT INTO WorksDuring (PID, SID)
VALUES ( 23, 4);	-- Alex Joffe
-- volunteers --
INSERT INTO WorksDuring (PID, SID)
VALUES ( 24, 1);	-- Jack Black
INSERT INTO WorksDuring (PID, SID)
VALUES ( 25, 1);	-- Kyle Gass
INSERT INTO WorksDuring (PID, SID)
VALUES ( 26, 3);	-- Dave Grohl
SELECT * FROM WorksDuring;
--




-- JOBS -- -- JOBS -- -- JOBS --
INSERT INTO Jobs (Name, Description) -- 1
VALUES ('Water Filling Station', 'Refill water bottles for thirsty concertgoers');
INSERT INTO Jobs (Name, Description) -- 2
VALUES ('Catering', 'Serve food to hungry concertgoers');
INSERT INTO Jobs (Name, Description) -- 3
VALUES ('Trash', 'Keep our venues clean by picking up unwanted litter');
INSERT INTO Jobs (Name, Description) -- 4
VALUES ('VIP Set-Up and Maintenance', 'Set-up VIP lounges and keep them clean');
INSERT INTO Jobs (Name, Description) -- 5
VALUES ('Decorations', 'Set up galleries for our sponsored artists and decorate the venues');

-- ASSIGNED TO -- -- ASSIGNED TO -- -- ASSIGNED TO --
-- staff --
INSERT INTO AssignedTo (PID, JID)
VALUES ( 20, 4);	-- Tom Russel
INSERT INTO AssignedTo (PID, JID)
VALUES ( 21, 5);	-- Jordan Wolowitz
INSERT INTO AssignedTo (PID, JID)
VALUES ( 22, 4);	-- Jennifer Styles
INSERT INTO AssignedTo (PID, JID)
VALUES ( 23, 1);	-- Alex Joffe
-- volunteers --
INSERT INTO AssignedTo (PID, JID)
VALUES ( 24, 3);	-- Jack Black
INSERT INTO AssignedTo (PID, JID)
VALUES ( 25, 2);	-- Kyle Gass
INSERT INTO AssignedTo (PID, JID)
VALUES ( 26, 2);	-- Dave Grohl
SELECT * FROM AssignedTo;

-- JOB LOCATIONS -- -- JOB LOCATIONS -- -- JOB LOCATIONS --
INSERT INTO JobLocations (JID, VenueID)
VALUES (1, 1) ; -- job 1
INSERT INTO JobLocations (JID, VenueID)
VALUES (1, 2) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (1, 3) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (1, 4) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (2, 1) ; -- job 2
INSERT INTO JobLocations (JID, VenueID)
VALUES (2, 2) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (2, 3) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (2, 4) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (3, 1) ; -- job 3
INSERT INTO JobLocations (JID, VenueID)
VALUES (3, 2) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (3, 3) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (3, 4) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (4, 1) ; -- job 4
INSERT INTO JobLocations (JID, VenueID)
VALUES (4, 2) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (4, 3) ;
INSERT INTO JobLocations (JID, VenueID)
VALUES (4, 4) ;




-- VIEWS -- GET COMPLETE LIST OF SOMETHING --

-- GET ALL CONCERTGOER INFO AND THEIR TICKET TYPES --
CREATE OR REPLACE VIEW ConcertgoerInfo AS
SELECT p.PID, FirstName, LastName, DOB, TicketType
FROM People p INNER JOIN Concertgoers c ON p.PID = c.PID;
--
SELECT * FROM ConcertgoerInfo;
--

-- GET ALL PERFORMERS, THEIR DAY ASSIGNMENTS, VENUE ASSIGNMENTS, AND SET TIMES --
CREATE OR REPLACE VIEW PerformerShowtimes AS
SELECT p.PID, FirstName, LastName, Day, Name AS Venue, StartTime, EndTime
FROM People p INNER JOIN Performers pe ON p.PID =     pe.PID
	      INNER JOIN AppearsIn a   ON p.PID =     a.PID
	      INNER JOIN Sets s        ON a.SetID =   s.SetID
	      INNER JOIN Venues v      ON s.VenueID = v.VenueID;
--
SELECT * FROM PerformerShowtimes;
--

-- GET ALL STAFF MEMBERS, THE SHIFTS THEY WORK DURING, AND THE JOBS THEY ARE ASSIGNED TO --
CREATE OR REPLACE VIEW StaffSchedule AS
SELECT p.PID, FirstName, LastName, Day, StartTime, EndTime, Name
FROM People p INNER JOIN Staff s       ON p.PID = s.PID
	      INNER JOIN WorksDuring w ON p.PID = w.PID
	      INNER JOIN Shifts sh     ON w.SID = sh.SID
	      INNER JOIN AssignedTo a  ON p.PID = a.PID
	      INNER JOIN Jobs j        ON a.JID = j.JID;
--
SELECT * FROM StaffSchedule;
--
	
-- GET ALL VOLUNTEERS, THE SHIFTS THEY ARE ASSIGNED TO, AND THE JOBS THEY ARE ASSIGNED TO --
CREATE OR REPLACE VIEW VolunteerSchedule AS
SELECT p.PID, FirstName, LastName, Day, StartTime, EndTime, Name
FROM People p INNER JOIN Volunteers v  ON p.PID = v.PID
	      INNER JOIN WorksDuring w ON p.PID = w.PID
	      INNER JOIN Shifts sh     ON w.SID = sh.SID
	      INNER JOIN AssignedTo a  ON p.PID = a.PID
	      INNER JOIN Jobs j        ON a.JID = j.JID;
--
SELECT * FROM VolunteerSchedule;
--




-- REPORTS AND THEIR QUERIES -- -- REPORTS AND THEIR QUERIES --

-- PRESHOW RITUALS OF ALL PERFORMERS IN A BAND -- -- PRESHOW RITUALS OF ALL PERFORMERS IN A BAND --
SELECT p.PID, FirstName, LastName, b.BID, Name, PreShowRitual
FROM People p INNER JOIN Performers pe ON p.PID =  pe.PID
	      INNER JOIN MemberOF m    ON pe.PID = m.PID
	      INNER JOIN Bands b       ON m.BID =  b.BID;

-- INSTRUMENTS THAT PERFORMERS IN A BAND KNOW HOW TO PLAY -- -- INSTRUMENTS THAT PERFORMERS IN A BAND KNOW HOW TO PLAY --
SELECT p.PID, FirstName, LastName, b.BID, b.Name, i.Name
FROM People p INNER JOIN Performers pe       ON p.PID    = pe.PID
	      INNER JOIN MemberOf m          ON pe.PID   = m.PID
	      INNER JOIN Bands b             ON m.BID    = b.BID
	      INNER JOIN KnowsHowToPlay khtp ON pe.PID = khtp.PID
	      INNER JOIN Instruments i	     ON khtp.InstrumentID = i.InstrumentID;




-- STORED PROCEDURES -- -- STORED PROCEDURES -- -- STORED PROCEDURES --

-- GET SONGS AFTER -- -- GET SONGS AFTER -- -- GET SONGS AFTER --
CREATE OR REPLACE FUNCTION GetSongsAfter(INT, INT, REFCURSOR) RETURNS refcursor AS
$body$ DECLARE
	iSongID INT := $1;
	iSetID INT := $2;
	result REFCURSOR := $3;
BEGIN
  OPEN result FOR
	WITH RECURSIVE SongsAfter(SongID, SongName) AS (
		SELECT s.SongID, s.SongName
		FROM Songs s

			INNER JOIN SongsInSet sis ON s.SongID = sis.SongID
		
		WHERE s.SongID=iSongID AND sis.SetID = iSetID

			UNION

		SELECT sa.SongID+1, s.SongName
		FROM SongsAfter sa, Songs s

			INNER JOIN SongsInSet sis ON s.SongID = sis.SongID
		
		WHERE s.songID=sa.SongID+1 AND sis.SetID = iSetID
		
	) SELECT * FROM SongsAfter;
  RETURN result;
END; $body$ LANGUAGE plpgsql;
SELECT GetSongsAfter(43, 4, 'ref');
FETCH ALL FROM ref;
CLOSE ref;
--

			SELECT s.SongID, s.SongName -- test by comparing recursive output with entire post malone set
			FROM Songs s INNER JOIN SongsInSet sis ON s.SongID = sis.SongID
				INNER JOIN Sets se ON sis.SetID = se.SetID
			WHERE se.SetID = 1;

			SELECT s.SongID, s.SongName -- test by comparing recursive output with entire kanye set
			FROM Songs s INNER JOIN SongsInSet sis ON s.SongID = sis.SongID
				INNER JOIN Sets se ON sis.SetID = se.SetID
			WHERE se.SetID = 8;


-- GET SONGS BEFORE -- -- GET SONGS BEFORE -- -- GET SONGS BEFORE --
CREATE OR REPLACE FUNCTION GetSongsBefore(INT, INT, REFCURSOR) RETURNS refcursor AS
$body$ DECLARE
	iSongID INT := $1;
	iSetID INT := $2;
	result REFCURSOR := $3;
BEGIN
  OPEN result FOR
	WITH RECURSIVE SongsAfter(SongID, SongName) AS (
		SELECT s.SongID, s.SongName
		FROM Songs s

			INNER JOIN SongsInSet sis ON s.SongID = sis.SongID
		
		WHERE s.SongID=iSongID AND sis.SetID = iSetID

			UNION

		SELECT sa.SongID-1, s.SongName
		FROM SongsAfter sa, Songs s

			INNER JOIN SongsInSet sis ON s.SongID = sis.SongID
		
		WHERE s.songID=sa.SongID-1 AND sis.SetID = iSetID
		
	) SELECT * FROM SongsAfter;
  RETURN result;
END; $body$ LANGUAGE plpgsql;
--
SELECT GetSongsBefore(106, 8, 'ref');
FETCH ALL FROM ref;
CLOSE ref;
--

-- SET WITH THE LONGEST RUNTIME -- -- SET WITH THE LONGEST RUNTIME -- -- SET WITH THE LONGEST RUNTIME --
CREATE OR REPLACE FUNCTION LongestSet(REFCURSOR) RETURNS refcursor AS
$body$ DECLARE

	duration TIME := ( SELECT MAX(y.SetDuration)
	  FROM (SELECT SetID, (EndTime - StartTime)AS SetDuration
		  FROM Sets
		  GROUP BY SetID
		  ORDER BY SetDuration DESC LIMIT 1) y);
--
	result REFCURSOR := $1;

BEGIN

OPEN result FOR
	
	SELECT SetID, StartTime, EndTime, (EndTime - StartTime)AS SetDuration
	FROM Sets
	WHERE (EndTime - StartTime) = duration;

  RETURN result;

END; $body$ LANGUAGE plpgsql;
SELECT LongestSet('ref');
FETCH ALL FROM ref;
CLOSE ref;
--

-- SET WITH THE MOST SONGS -- -- SET WITH THE MOST SONGS -- -- SET WITH THE MOST SONGS --
CREATE OR REPLACE FUNCTION MostSongs(REFCURSOR) RETURNS refcursor AS
$body$ DECLARE

	num INT := ( SELECT MAX(y.SongTotal)
	  FROM (SELECT s.SetID, COUNT(SongID)AS SongTotal
		  FROM Sets s INNER JOIN SongsInSet sis ON s.SetID = sis.SetID
		  GROUP BY s.SetID) y);--
--
	result REFCURSOR := $1;
BEGIN

OPEN result FOR
	
	SELECT s.SetID, s.StartTime, s.EndTime, COUNT(SongID)AS SongTotal
	FROM Sets s INNER JOIN SongsInSet sis ON s.SetID = sis.SetID
	GROUP BY s.SetID
	HAVING COUNT(s.SetID) = num;

  RETURN result;

END; $body$ LANGUAGE plpgsql;
SELECT MostSongs('ref');
FETCH ALL FROM ref;
CLOSE ref;
--

-- MOST PLAYED INSTRUMENT -- -- MOST PLAYED INSTRUMENT -- -- MOST PLAYED INSTRUMENT --
CREATE OR REPLACE FUNCTION MostPlayedInstrument(REFCURSOR) RETURNS refcursor AS
$body$ DECLARE

	num INT := ( SELECT MAX(y.HowManyCanPlay)
	  FROM (SELECT i.InstrumentID, COUNT(p.PID)AS HowManyCanPlay
		  FROM Instruments i INNER JOIN KnowsHowToPlay khtp ON i.InstrumentID = khtp.InstrumentID
				     INNER JOIN Performers p 	    ON khtp.PID =       p.PID
		  GROUP BY i.InstrumentID) y);--
--
	result REFCURSOR := $1;		  
	
BEGIN

OPEN result FOR
	
	SELECT i.InstrumentID, i.Name, COUNT(p.PID)AS HowManyCanPlay
	FROM Instruments i INNER JOIN KnowsHowToPlay khtp ON i.InstrumentID = khtp.InstrumentID
			   INNER JOIN Performers p 	  ON khtp.PID =       p.PID
	GROUP BY i.InstrumentID
	HAVING COUNT(p.PID) = num;

  RETURN result;

END; $body$ LANGUAGE plpgsql;
SELECT MostPlayedInstrument('ref');
FETCH ALL FROM ref;
CLOSE ref;
--

-- UPDATE HOURS COMPLETED -- -- UPDATE HOURS COMPLETED -- -- UPDATE HOURS COMPLETED --
CREATE OR REPLACE FUNCTION UpdateHoursCompleted() RETURNS TRIGGER AS
$body$
BEGIN
	IF new.PID IS NOT NULL
	AND (SELECT HoursCompleted
		FROM Volunteers
		WHERE PID = new.PID) = 'no'
	THEN
		UPDATE Volunteers
		SET HoursCompleted = 'yes'
		WHERE PID = new.PID;
	END IF;
	RETURN new;
END; $body$ LANGUAGE plpgsql;
--




-- TRIGGERS -- -- TRIGGERS --

-- UPDATE HOURS -- -- UPDATE HOURS -- -- UPDATE HOURS --
CREATE TRIGGER updateHoursCompleted
AFTER INSERT ON WorksDuring
FOR EACH ROW
EXECUTE PROCEDURE updateHoursCompleted();




-- SECURITY -- -- SECURITY -- -- SECURITY --
CREATE ROLE Admin;
GRANT ALL ON ALL TABLES
IN SCHEMA PUBLIC
TO Admin;

CREATE ROLE Staff;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES
IN SCHEMA PUBLIC
TO Staff;

CREATE ROLE Volunteers;
GRANT SELECT ON ALL TABLES
IN SCHEMA PUBLIC
TO Volunteers;




--
SELECT StageName, PreshowRitual
FROM Performers
WHERE StageName = 'Kygo';
--





