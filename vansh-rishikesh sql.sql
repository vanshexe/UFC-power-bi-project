CREATE DATABASE ufc;
USE ufc;
SELECT * FROM ufc_event_data;
SELECT * FROM ufc_fight_stat_data;
SELECT * FROM ufc_fighter_data;


Create Table ufc_fight_data(
fight_id text,
event_id text,
referee text,
f_1 text,	f_2 text,
winner text,	num_rounds text,
title_fight text,
weight_class TEXT,
gender text,
result text,
result_details text,
finish_round text,
finish_time text,
fight_url text);

SELECT @@secure_file_priv;


LOAD DATA INFILE 'C:/Users/kumar/Downloads/ufc_fight_data.csv'
INTO TABLE ufc_fight_data
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

# DROP TABLE ufc_fight_data
SELECT * FROM ufc_fight_data;


-- ----------------------------------------------------------------------------------------------------
## CLEAN TABLE ufc_fight_data
describe ufc_fight_data;
select distinct gender from ufc_fight_data group by gender;

SELECT DISTINCT fight_id, COUNT(*) FROM UFC_FIGHT_DATA GROUP BY FIGHT_ID HAVING COUNT(*)>1; # CHECK DUPLICATES

ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN FIGHT_ID INT;

ALTER TABLE UFC_FIGHT_DATA ADD PRIMARY KEY (FIGHT_ID);

ALTER TABLE UFC_FIGHT_DATA ADD FOREIGN KEY (EVENT_ID) REFERENCES UFC_EVENT_DATA(EVENT_ID);

ALTER TABLE UFC_FIGHT_DATA DROP COLUMN referee;

ALTER TABLE UFC_FIGHT_DATA DROP COLUMN FIGHT_URL; # DROP COLUMN event_url

select distinct f_1, count(f_1) from UFC_FIGHT_DATA group by f_1;

UPDATE UFC_FIGHT_DATA
SET F_1=0
WHERE F_1='';
ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN F_1 INT;


UPDATE UFC_FIGHT_DATA
SET F_2=0
WHERE F_2='';
ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN F_2 INT;

UPDATE UFC_FIGHT_DATA
SET WINNER=0
WHERE WINNER='';
ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN WINNER INT;

select distinct NUM_ROUNDS, count(NUM_ROUNDS) from UFC_FIGHT_DATA group by NUM_ROUNDS;

UPDATE UFC_FIGHT_DATA
SET NUM_ROUNDS=0
WHERE NUM_ROUNDS='N';
ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN NUM_ROUNDS INT;

select distinct TITLE_FIGHT from UFC_FIGHT_DATA group by TITLE_FIGHT;
select distinct WEIGHT_CLASS from UFC_FIGHT_DATA group by WEIGHT_CLASS;

DELETE FROM UFC_FIGHT_DATA WHERE WEIGHT_CLASS=''; # DELETE NULL VALUES
select distinct RESULT from UFC_FIGHT_DATA group by RESULT;
select distinct RESULT_DETAILS from UFC_FIGHT_DATA group by RESULT_DETAILS;


ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN finish_round INT;

ALTER TABLE UFC_FIGHT_DATA DROP COLUMN result_details;

ALTER TABLE UFC_FIGHT_DATA MODIFY COLUMN finish_time TIME;


select* from UFC_FIGHT_DATA;
describe UFC_FIGHT_DATA;

-- --------------------------------------------------------------------------------------------------------------

## CLEAN TABLE ufc_event_data
describe ufc_event_data;
SELECT COUNT(event_id),COUNT(event_name),COUNT(event_name),COUNT(event_city),COUNT(event_date)
FROM ufc_event_data
WHERE event_id="" or event_name=""  or event_name="" or event_city="" or event_date=""; # COUNTING NULLS

select * from ufc_event_data;

SELECT DISTINCT COUNT(EVENT_ID), COUNT(EVENT_ID) from ufc_event_data; #CHECK DUPLICATES (PRIMARY KEY)
describe ufc_event_data;
ALTER TABLE ufc_event_data DROP COLUMN EVENT_URL;

UPDATE ufc_event_data
SET event_name="Unknown"
WHERE event_name='';

UPDATE ufc_event_data
SET event_city="Unknown"
WHERE event_city='';

UPDATE ufc_event_data
SET event_state="Unknown"
WHERE event_state='';

UPDATE ufc_event_data
SET event_country="Unknown"
WHERE event_country='';

ALTER TABLE ufc_event_data MODIFY COLUMN event_date DATE;
-- --------------------------------------------------------------------------------------------------------------

## CLEAN TABLE ufc_fight_stat_data
SELECT * FROM ufc_fight_stat_data;
describe ufc_fight_data;
ALTER TABLE ufc_fight_stat_data DROP COLUMN FIGHT_URL;
ALTER TABLE ufc_fight_stat_data ADD PRIMARY KEY (FIGHT_STAT_ID);
ALTER TABLE ufc_fighter_data ADD PRIMARY KEY (FIGHTER_ID);
ALTER TABLE ufc_fight_stat_data MODIFY COLUMN FIGHTER_ID INT;
ALTER TABLE ufc_fight_stat_data
ADD CONSTRAINT FK_FIGHTER_ID
FOREIGN KEY (FIGHTER_ID)
REFERENCES ufc_fighter_data(FIGHTER_ID)
ON DELETE CASCADE;
SHOW CREATE TABLE ufc_fight_stat_data
ALTER TABLE ufc_fight_stat_data ADD FOREIGN KEY (FIGHTER_ID) REFERENCES ufc_fighter_data(FIGHTER_ID);
ALTER TABLE ufc_fight_stat_data ADD FOREIGN KEY (FIGHT_ID) REFERENCES ufc_fight_data(FIGHT_ID);


-- --------------------------------------------------------------------------------------------------------------------------
## CLEAN TABLE ufc_fighter_data

SELECT * FROM ufc_fighter_data;
describe ufc_fighter_data;

SELECT fighter_id, count(*) FROM ufc_fighter_data group by fighter_id having count(fighter_id)>1; # Check duplicates

ALTER TABLE ufc_fighter_data ADD PRIMARY KEY(FIGHTER_ID);
ALTER TABLE ufc_fighter_data DROP COLUMN FIGHTER_URL;
ALTER TABLE ufc_fighter_data DROP COLUMN fighter_nickname;

UPDATE ufc_fighter_data SET FIGHTER_HEIGHT_CM=0 where FIGHTER_HEIGHT_CM=""; # REPLACE NULL VALUES with zero
ALTER TABLE ufc_fighter_data MODIFY COLUMN FIGHTER_HEIGHT_CM INT;
SELECT AVG(fighter_height_cm) FROM ufc_fighter_data;
UPDATE ufc_fighter_data SET fighter_height_cm=168.1095 where fighter_height_cm=0; # IMPUTE heght WITH AVG


SELECT count(fighter_weight_lbs) FROM ufc_fighter_data where fighter_weight_lbs=""; #CHECK NULL
ALTER TABLE ufc_fighter_data MODIFY COLUMN fighter_weight_lbs INT;
SELECT AVG(fighter_weight_lbs) FROM ufc_fighter_data;
UPDATE ufc_fighter_data SET fighter_weight_lbs=170.6455 where fighter_weight_lbs=0; # IMPUTE weight WITH AVG


SELECT count(fighter_reach_cm) FROM ufc_fighter_data where fighter_reach_cm=""; #CHECK NULL
UPDATE ufc_fighter_data SET fighter_reach_cm=0 where fighter_reach_cm=""; # REPLACE NULL WITH ZERO
ALTER TABLE ufc_fighter_data MODIFY COLUMN fighter_reach_cm INT;
SELECT AVG(fighter_reach_cm) FROM ufc_fighter_data;
UPDATE ufc_fighter_data SET fighter_reach_cm=97.9920 where fighter_reach_cm=0; # IMPUTE reach WITH AVG


SELECT count(fighter_stance) FROM ufc_fighter_data where fighter_stance=""; #CHECK NULL
SELECT DISTINCT fighter_stance, COUNT(fighter_stance) FROM ufc_fighter_data GROUP BY fighter_stance ORDER BY COUNT(fighter_stance) DESC;#mode
UPDATE ufc_fighter_data SET fighter_stance="Orthodox" where fighter_stance=""; # IMPUTE stance WITH mode


SELECT fighter_dob FROM ufc_fighter_data;
SELECT count(fighter_dob) FROM ufc_fighter_data where fighter_dob=""; #CHECK NULL
UPDATE ufc_fighter_data SET fighter_dob="1900-01-01" where fighter_dob="";# Replace null with default dob;
ALTER TABLE ufc_fighter_data MODIFY COLUMN fighter_dob DATE;


ALTER TABLE ufc_fighter_data RENAME COLUMN fighter_w TO matches_won;
SELECT count(matches_won) FROM ufc_fighter_data where matches_won="";
ALTER TABLE ufc_fighter_data MODIFY matches_won int;
SELECT ROUND(AVG(matches_won)) FROM ufc_fighter_data;
UPDATE ufc_fighter_data SET matches_won=13 WHERE matches_won="";



ALTER TABLE ufc_fighter_data RENAME COLUMN fighter_l TO matches_lost;
SELECT count(matches_lost) FROM ufc_fighter_data where matches_lost="";
ALTER TABLE ufc_fighter_data MODIFY matches_lost int;
SELECT ROUND(AVG(matches_lost)) FROM ufc_fighter_data;
UPDATE ufc_fighter_data SET matches_lost=6 WHERE matches_lost="";


ALTER TABLE ufc_fighter_data RENAME COLUMN fighter_d TO draws;
SELECT count(draws) FROM ufc_fighter_data where draws="";
ALTER TABLE ufc_fighter_data MODIFY draws int;
SELECT ROUND(AVG(draws)) FROM ufc_fighter_data;
UPDATE ufc_fighter_data SET draws=0 WHERE draws="";  #IMPUTE with avg 0

ALTER TABLE ufc_fighter_data DROP COLUMN fighter_nc_dq;




-- ------------------------------------------------------------------------------------------------------

# KPI'S

SELECT DISTINCT COUNT(event_id) AS "TOTAL NUMBER OF EVENTS" FROM ufc_event_data; #1-EVENT COUNTS

SELECT COUNT(fight_id) AS "TOTAL NUMBER OF FIGHTS" FROM ufc_fight_data; #2- TOTAL NUMBER OF FIGHTS

SELECT ROUND(AVG(num_rounds)) AS "AVERAGE NUMBER OF ROUNDS" FROM ufc_fight_data; #3- AVERAGE NUMBER OF ROUNDS

WITH CTE AS (SELECT COUNT(DISTINCT(fight_id)) as f,COUNT(DISTINCT(event_id)) as e FROM ufc_fight_data) SELECT f/e 
AS "Avg no of Fights per Event" FROM CTE;  #4- Avg no of Fights per Event

SELECT DISTINCT(result),COUNT(fight_id) FROM ufc_fight_data GROUP BY RESULT;#5- Result vs count result 

SELECT DISTINCT(event_country),COUNT(DISTINCT(event_id)) AS Event_Count FROM ufc_event_data GROUP BY event_country 
ORDER BY Event_Count DESC
LIMIT 10; #6-  TOP 10 Countires by event count

SELECT DISTINCT(weight_class),COUNT(fight_id) AS fight_Count FROM ufc_fight_data GROUP BY weight_class 
ORDER BY fight_Count DESC; #7- Fight Count Weight class 


SELECT AVG(fighter_weight_lbs) AS "AVG FIGHTER WEIGHT(lbs)", 
AVG(fighter_height_cm) AS "AVG FIGHTER HEIGHT(cm)"
from ufc_fighter_data; #--------------->>>> ADD AGE TOO



describe ufc_fight_data;
describe ufc_event_data;

SELECT DISTINCT(event_name), COUNT(fight_id) FROM ufc_event_data
JOIN ufc_fight_data on ufc_event_data.event_id=ufc_fight_data.event_id group by event_name order by count(fight_id) DESC LIMIT 10 ;


SELECT
    finish_round,
    COUNT(CASE WHEN result = 'Decision' THEN 1 END) AS decision_count,
    COUNT(CASE WHEN result = 'DQ' THEN 1 END) AS DQ_count,
    COUNT(CASE WHEN result = 'KO/TKO' THEN 1 END) AS KO_TKO_Count,
    COUNT(CASE WHEN result = 'Submission' THEN 1 END) AS Submission_Count,
    COUNT(CASE WHEN result = 'TKO - Doctor\'s Stoppage' THEN 1 END) AS Doctors_Count
FROM ufc_fight_data
GROUP BY finish_round;


SELECT DISTINCT(COUNT(RESULT)) ,RESULT From ufc_fight_data GROUP BY RESULT ORDER BY COUNT(RESULT);