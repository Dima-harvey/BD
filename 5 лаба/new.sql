CREATE TABLE book_2020_11 (like book including all) INHERITS (book);
ALTER TABLE book_2020_11 add check ( publicationdate between date'2020-11-01' and date'2020-12-01'-1);

CREATE OR REPLACE FUNCTION book_select_part()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.publicationdate between date'2020-11-01' and date'2020-12-01'-1 THEN
      INSERT INTO book_2020_11 VALUES (NEW.*);
	else
      RAISE EXCEPTION 'this date not in you partitions %',NEW.id;
    END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
SELECT * from book_2020_11;
CREATE TRIGGER check_date_book
  BEFORE INSERT ON book
  FOR EACH ROW EXECUTE PROCEDURE book_select_part();
    INSERT INTO book(id,author,name,publicationdate)values(1001,'d','d','2020-11-04');
  INSERT INTO book(id,author,name,publicationdate)
SELECT
  gen AS id,
  (
    CASE (RANDOM() * 5)::INT
      WHEN 0 THEN 'Pushkin'
      WHEN 1 THEN 'Geoffrey'
      WHEN 2 THEN 'William'
      WHEN 3 THEN 'Robert'
      WHEN 4 THEN 'Charles'
	  WHEN 5 THEN 'Jack'
    END
  ) AS author,
  (
    CASE (RANDOM() * 5)::INT
      WHEN 0 THEN 'Sparrow'
      WHEN 1 THEN 'Petr'
      WHEN 2 THEN 'Dickens'
      WHEN 3 THEN 'bad'
      WHEN 4 THEN 'good day'
	  WHEN 5 THEN 'Jhoni day'
    END
  ) AS name,
  (now() - interval '20 day' * random())::date as publicationdate
FROM GENERATE_SERIES (100001,1000000) gen;