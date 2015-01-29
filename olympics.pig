-- For your first project we are going to do some basic data 
-- analysis on Olympic medal data. We are going to find the country 
-- that won the most individual medals at the 2010 Olympics. 
-- Follow the link to our step-by-step tutorial to get started!
-- https://help.mortardata.com/technologies/mortar/first_web_project

-- Loading data from a S3 input bucket
athletes  = LOAD 's3://mortar-example-data/olympics/OlympicAthletes.csv'
           USING org.apache.pig.piggybank.storage.CSVExcelStorage(',', 'YES_MULTILINE', 'NOCHANGE', 'SKIP_INPUT_HEADER') AS (
                 athlete:chararray, country:chararray, year:int, sport:chararray, gold:int, silver:int, bronze:int, total:int);
        
----Insert Code Below
----Hint: Go to the footer of this script and hover over "Pig Statements"

-- Storing data to a S3 output bucket
rmf s3://mortar-example-output-data/$MORTAR_EMAIL_S3_ESCAPED/olympics;
STORE athletes
  INTO 's3://mortar-example-output-data/$MORTAR_EMAIL_S3_ESCAPED/olympics'
  USING PigStorage('\t');

