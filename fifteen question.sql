

CREATE TABLE Worker (
    WORKER_ID SERIAL PRIMARY KEY,
    FIRST_NAME CHAR(25),
    LAST_NAME CHAR(25),
    SALARY INT,
    JOINING_DATE TIMESTAMP,
    DEPARTMENT CHAR(25)
);


INSERT INTO Worker 
    (WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
        (101, 'John', 'Doe', 80000, '2022-01-15 09:00:00', 'IT'),
        (102, 'Jane', 'Smith', 70000, '2022-02-20 10:30:00', 'Finance'),
        (103, 'Michael', 'Johnson', 90000, '2022-03-10 08:45:00', 'HR'),
        (104, 'Emily', 'Williams', 75000, '2022-04-05 11:15:00', 'Marketing'),
        (105, 'William', 'Brown', 85000, '2022-05-12 09:30:00', 'IT'),
        (106, 'Olivia', 'Jones', 72000, '2022-06-18 10:00:00', 'Finance'),
        (107, 'Daniel', 'Clark', 95000, '2022-07-22 08:15:00', 'HR'),
        (108, 'Sophia', 'Taylor', 78000, '2022-08-28 11:45:00', 'Marketing');

CREATE TABLE Bonus (
    WORKER_REF_ID INT,
    BONUS_AMOUNT INT,
    BONUS_DATE TIMESTAMP,
    FOREIGN KEY (WORKER_REF_ID)
        REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);

INSERT INTO Bonus 
    (WORKER_REF_ID, BONUS_AMOUNT, BONUS_DATE) VALUES
        (101, 5000, '2022-02-16 14:00:00'),
        (102, 3000, '2022-03-20 13:30:00'),
        (103, 4000, '2022-04-25 16:45:00'),
        (101, 4500, '2022-05-30 12:15:00'),
        (102, 3500, '2022-06-28 15:00:00');

CREATE TABLE Title (
    WORKER_REF_ID INT,
    WORKER_TITLE CHAR(25),
    AFFECTED_FROM TIMESTAMP,
    FOREIGN KEY (WORKER_REF_ID)
        REFERENCES Worker(WORKER_ID)
        ON DELETE CASCADE
);


INSERT INTO Title 
    (WORKER_REF_ID, WORKER_TITLE, AFFECTED_FROM) VALUES
    (101, 'Manager', '2022-01-20 00:00:00'),
    (102, 'Executive', '2022-02-15 00:00:00'),
    (108, 'Executive', '2022-02-15 00:00:00'),
    (105, 'Manager', '2022-02-15 00:00:00'),
    (104, 'Asst. Manager', '2022-02-15 00:00:00'),
    (107, 'Executive', '2022-02-15 00:00:00'),
    (106, 'Lead', '2022-02-15 00:00:00'),
    (103, 'Lead', '2022-02-15 00:00:00');

-- Q.1 
SELECT FIRST_NAME AS WORKER_NAME
FROM Worker;

-- Q.2

SELECT UPPER(FIRST_NAME) AS WORRKER_NAME
FROM Worker;


-- Q.3

SELECT DISTINCT DEPARTMENT
FROM Worker;

-- Q.4
SELECT SUBSTRING(FIRST_NAME,1,3) AS First_Three_letters 
FROM Worker;
-- Q.5
SELECT POSITION('a'IN FIRST_NAME) AS Position_a
FROM Worker
WHERE FIRST_NAME='Amitabh';
-- Q.6
SELECT RTRIM(FIRST_NAME) AS  First_Name_RTrimed
FROM Worker;

-- Q.7
SELECT LTRIM(DEPARTMENT) AS Department_Trim
FROM Worker;
-- Q.8
SELECT DISTINCT DEPARTMENT, LENGTH(DEPARTMENT) AS count
FROM Worker;

-- Q.9
SELECT REPLACE (FIRST_NAME, 'a' ,'A') AS first_name_A 
FROM Worker;

-- Q.10
SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS COMPLETE_NAME
FROM Worker;

-- Q.11
SELECT * 
FROM Worker
ORDER BY FIRST_NAME ;

-- Q.12

SELECT *
FROM Worker
ORDER BY FIRST_NAME , DEPARTMENT DESC;

-- Q.13
SELECT * 
FROM Worker
WHERE FIRST_NAME IN ('Vipul','Satish');

-- Q.15
SELECT *
FROM Worker
WHERE DEPARTMENT = 'Admin';

-- Q.16
SELECT *
FROM Worker
WHERE FIRST_NAME LIKE'%a%';

-- Q.17
SELECT *
FROM Worker
WHERE RTRIM(FIRST_NAME) LIKE '%a';

-- Q.18
SELECT *
FROM Worker
WHERE RTRIM(FIRST_NAME) LIKE '_____h';

-- Q.19
SELECT *
FROM Worker
WHERE SALARY BETWEEN 100000 AND 500000;

-- Q.20
SELECT *
FROM Worker
WHERE EXTRACT(YEAR FROM JOINING_DATE) =2014 AND EXTRACT(MONTH FROM JOINING_DATE) =2;

-- Q.21
SELECT COUNT(*) AS Number_OF_Admins
FROM Worker
WHERE    DEPARTMENT ='Admin';

-- Q.22
SELECT FIRST_NAME , LAST_NAME
FROM Worker
WHERE SALARY BETWEEN 50000 AND 100000;


-- Q.23
SELECT DEPARTMENT,COUNT(*) AS NUMBER_OF_WORKERS
FROM WORKER 
GROUP BY DEPARTMENT
ORDER BY NUMBER_OF_WORKERS DESC;

-- Q.24
SELECT w.*
FROM Worker w
JOIN Title t ON w.WORKER_ID = t.WORKER_REF_ID
WHERE t.WORKER_TITLE LIKE '%Manager%' OR t.WORKER_TITLE LIKE '%Lead%' OR t.WORKER_TITLE LIKE '%Director%';

-- Q.25
SELECT TRIM(BOTH ' ' FROM UPPER(FIRST_NAME)) AS FIRST_NAME, 
       TRIM(BOTH ' ' FROM UPPER(LAST_NAME)) AS LAST_NAME, 
       TRIM(BOTH ' ' FROM UPPER(DEPARTMENT)) AS DEPARTMENT, 
       COUNT(*)
FROM Worker
GROUP BY TRIM(BOTH ' ' FROM UPPER(FIRST_NAME)), 
         TRIM(BOTH ' ' FROM UPPER(LAST_NAME)), 
         TRIM(BOTH ' ' FROM UPPER(DEPARTMENT))
HAVING COUNT(*) > 1;

-- Q.26
SELECT * 
FROM Worker
WHERE WORKER_ID % 2 <> 0;

-- Q.27
SELECT * 
FROM Worker
WHERE WORKER_ID % 2 = 0;

-- Q.28
CREATE TABLE COPIEDWORKER AS
SELECT *
FROM Worker;

-- Q.29
SELECT w.*
FROM Worker w
INNER JOIN COPIEDWORKER cw ON w.WORKER_ID = cw.WORKER_ID;
-- Q.30
SELECT w.*
FROM Worker w
LEFT JOIN COPIEDWORKER cw ON w.WORKER_ID = cw.WORKER_ID
WHERE cw.WORKER_ID IS NULL;

-- Q.31
SELECT NOW() AS current_date_time;

-- Q.32

SELECT *
FROM Worker
LIMIT 10;

-- Q.33
SELECT  Salary
FROM (
	SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary  DESC) AS rank
	FROM Worker
	) AS ranked_salary
	WHERE rank=5;

-- Q.34
SELECT Salary
FROM (
	SELECT Salary, ROW_NUMBER() OVER (ORDER BY Salary DESC) AS rank
	FROM Worker
) AS ranked_salary
WHERE rank=5;

-- Q.35

SELECT w1.FIRST_NAME AS First_Name1, w1.LAST_NAME AS Last_Name1, w1.Salary, 
       w2.FIRST_NAME AS First_Name2, w2.LAST_NAME AS Last_Name2
FROM Worker w1
JOIN Worker w2 ON w1.Salary = w2.Salary AND w1.WORKER_ID <> w2.WORKER_ID
ORDER BY w1.Salary, w1.FIRST_NAME, w1.LAST_NAME;


-- Q.36

SELECT Salary
FROM (
    SELECT Salary, DENSE_RANK() OVER (ORDER BY Salary DESC) as rank
    FROM Worker
) as ranked_salaries
WHERE rank = 2;


-- Q.37

SELECT WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT
FROM Worker
WHERE WORKER_ID = 101

UNION ALL

SELECT WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT
FROM Worker
WHERE WORKER_ID = 101;

-- Q.39

WITH TotalCount AS (
    SELECT COUNT(*) as total
    FROM Worker
),
NumberedRows AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY WORKER_ID) as row_num
    FROM Worker
)
SELECT *
FROM NumberedRows
WHERE row_num <= (SELECT CEIL(total / 2.0) FROM TotalCount);

-- Q.40

SELECT DEPARTMENT, COUNT(*) AS numberofmembers
FROM Worker
GROUP BY DEPARTMENT
HAVING COUNT(*) < 5;


-- Q.41


SELECT DEPARTMENT, COUNT(*) AS EmployeeCount
FROM Worker
GROUP BY DEPARTMENT;
-- Q.42
SELECT *
FROM Worker
ORDER BY JOINING_DATE DESC
LIMIT 1;


-- Q.43

WITH RankedRecords AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY WORKER_ID) as rn
    FROM Worker
)
SELECT *
FROM RankedRecords
WHERE rn = 1;

-- Q.44
WITH rankrecored AS (
	SELECT *,
	DENSE_RANK( ) OVER (ORDER BY JOINING_DATE DESC) as rnk
	FROM Worker
)
SELECT *
FROM rankrecored 
WHERE rnk <= 5;

-- Q.45
WITH maxsalary AS (
	SELECT *,
	MAX(SALARY) OVER (PARTITION BY DEPARTMENT) AS Mxsalary
	FROM Worker
)

SELECT FIRST_NAME, LAST_NAME, DEPARTMENT, SALARY
FROM maxsalary
WHERE SALARY=Mxsalary;

-- Q.46
WITH RankedSalaries AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) as dr
    FROM Worker
)
SELECT Salary
FROM RankedSalaries
WHERE dr <= 3;

-- Q.47
WITH RankedSalaries AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary ASC) as dr
    FROM Worker
)
SELECT Salary
FROM RankedSalaries
WHERE dr <= 3;

-- Q.48

WITH RankedSalaries AS (
    SELECT Salary,
           DENSE_RANK() OVER (ORDER BY Salary DESC) as dr
    FROM Worker
)
SELECT Salary
FROM RankedSalaries
WHERE dr = 4;   -- Assumed nth =4

-- Q.49
SELECT DEPARTMENT, SUM(SALARY) AS TotalSalaries
FROM Worker
GROUP BY DEPARTMENT;

-- Q.50

SELECT FIRST_NAME, LAST_NAME, SALARY
FROM Worker
WHERE SALARY = (SELECT MAX(SALARY) FROM Worker);






















