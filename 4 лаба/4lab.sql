\timing ON

1)Задание
 INSERT INTO read_card(id,user_profile_id,book_id)
SELECT
  gen AS id,
  gen AS user_profile,
  (gen-1) AS book_id 
FROM GENERATE_SERIES (100001,1000000) gen;

 INSERT INTO user_Profile(id,user_id,Firstname, Surname,photo,phone)
SELECT
  gen AS id,
  gen AS user_id,
  (
    CASE (RANDOM() * 5)::INT
      WHEN 0 THEN 'Pushkin'
      WHEN 1 THEN 'Geoffrey'
      WHEN 2 THEN 'William'
      WHEN 3 THEN 'Robert'
      WHEN 4 THEN 'Charles'
	  WHEN 5 THEN 'Jack'
    END
  ) AS Firstname,
  (
    CASE (RANDOM() * 5)::INT
      WHEN 0 THEN 'Sparrow'
      WHEN 1 THEN 'Petr'
      WHEN 2 THEN 'Dickens'
      WHEN 3 THEN 'bad'
      WHEN 4 THEN 'good day'
	  WHEN 5 THEN 'Jhoni day'
    END
  ) AS Surname,
   (
    CASE (RANDOM() * 1)::INT
      WHEN 0 THEN 'YES'
      WHEN 1 THEN 'NOW'
    END
  ) AS photo,
  gen AS phone
  
FROM GENERATE_SERIES(100001,1000000) gen;

INSERT INTO users(id,login,password, role_id)
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
  ) AS login,
  
  gen AS password,
    (
    CASE (1+RANDOM() * 2)::INT
      WHEN 0 THEN 1
      WHEN 1 THEN 2
      WHEN 2 THEN 3
    END
  ) AS role_id
  
FROM GENERATE_SERIES(100001,1000000) gen;

2)Задание
SELECT
   Firstname, Surname, phone,u.id
FROM
  user_Profile as ud
   JOIN read_card AS u ON u.user_profile_id = ud.id
   LEFT JOIN book AS t ON u.book_id = t.id
where t.name='Dickens'
GROUP BY Firstname, Surname, phone,u.id
HAVING COUNT(Firstname)>0 
ORDER BY u.id asc
limit 10
offset 10;

4)Задание
create INDEX idx_name on book (name);
drop index idx_name;


