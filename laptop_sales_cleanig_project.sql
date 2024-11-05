SELECT *
FROM [Practice].[dbo].[laptopData]

--Changing column name
EXEC sp_rename 'dbo.laptopData.Unnamed_0', 'Index', 'COLUMN';



--Apply rownumbers to a column

WITH numbered_rows AS ( -- WITH numbered_rows AS: This is a Common Table Expression (CTE) that allows you to create a temporary result set that can be referenced within the UPDATE statement.

    SELECT row_number() OVER (ORDER BY (SELECT NULL)) AS row_num, --This line generates a sequential integer starting from 1 for each row in the laptopData table. The ORDER BY (SELECT NULL) clause ensures that the order is arbitrary. This means that the rows will be assigned row numbers based on the internal order in which they are processed, which might not be stable or predictable.

	[Index] AS original_index --  This line selects the current values of the Index column and gives it an alias original_index.

	FROM laptopData -- This line sets the value of the Index column in the laptopData table to the row_num value from the numbered_rows CTE.
)
UPDATE laptopData 
set [Index] = numbered_rows.row_num
from laptopData
join numbered_rows -- This joins the laptopData table with the numbered_rows CTE on the following condition.

on laptopData.[Index] = numbered_rows.original_index; --  This specifies the condition for the join. It matches rows in the laptopData table with rows in the numbered_rows CTE based on the original Index value.



--delete rows

DELETE FROM [Practice].[dbo].[laptopData] WHERE [Index] IS NULL -- we have to put sensitive names in brackets in SQL. Because Index is probably some function in SQL.


--changing values from inches to centimeter
exec sp_rename 'dbo.laptopData.Inches', 'Centimeter', 'Column';
UPDATE [Practice].[dbo].[laptopData]
set Centimeter = Centimeter * 2.54

-- changing the company name

SELECT * FROM laptopData
WHERE Company = 'chuwi'

UPDATE laptopData
SET Company = 'Acer'
WHERE Company = 'Vero'

-- Finding all the laptops whose operating system is not mentioned

SELECT * FROM laptopData
WHERE OpSys = 'No OS'

--CHECKING OUT THE COMPANY NAME AND TYPE NAME SO THAT WE CAN FILL PUT THE VALUES IN 'OpSys' column that says No OS

SELECT * FROM laptopData 
WHERE Company = 'HP' AND OpSys = 'No OS'

SELECT * FROM laptopData 
WHERE Company = 'Lenovo' AND OpSys = 'No OS'

SELECT * FROM laptopData 
WHERE Company = 'Asus' AND OpSys = 'No OS'

SELECT * FROM laptopData
WHERE Company = 'Asus' and Gpu = 'Nvidia GeForce GTX 950M'

SELECT * FROM laptopData 
WHERE Company = 'Xiaomi' 

-- Updating the operating system column for HP notebooks where it says 'No OS'

UPDATE laptopData
SET OpSys = 'Windows 10'
WHERE Company  = 'HP' AND TypeName = 'Notebook' AND OpSys = 'No OS'

UPDATE laptopData
SET OpSys = 'Windows 10'
WHERE Company  = 'Lenovo' AND OpSys = 'No OS'

UPDATE laptopData  -- Had to compare these values with others to come up with the right result
SET OpSys = 'Windows 10'
WHERE Company  = 'Asus' AND OpSys = 'No OS' AND ScreenResolution = 'IPS Panel Full HD 1920x1080'

UPDATE laptopData
SET OpSys = 'Windows 10'
WHERE Company  = 'Asus' AND OpSys = 'No OS'

UPDATE laptopData
SET OpSys = 'Windows 10'
WHERE Company  = 'Xiaomi' AND OpSys = 'No OS'

-- Discrepencies in weight

UPDATE laptopData
SET Weight = '1 kg' 
WHERE Weight < '1 kg'

select * from laptopData
where weight = '?'

-- Split the Screen resolution column into display and Resolution

ALTER TABLE laptopData
ADD Resolution VARCHAR(50),
Display VARCHAR(100)


UPDATE [Practice].[dbo].[laptopData]
SET resolution = SUBSTRING(ScreenResolution,
                           PATINDEX('%[0-9][0-9][0-9][0-9]x[0-9][0-9][0-9][0-9]%', ScreenResolution), -- PATINDEX('%[0-9][0-9][0-9][0-9]x[0-9][0-9][0-9][0-9]%', screen_info): This pattern matches exactly 4 digits followed by 'x' followed by 4 digits, ensuring correct extraction of resolution.
                           9),                                                                       --SUBSTRING(..., 9): Extracts exactly 9 characters matching the resolution pattern like 3840x2160.
    display = TRIM(REPLACE(ScreenResolution, --REPLACE(..., 9): Removes the extracted resolution from the original string to get the display information.
                           SUBSTRING(ScreenResolution,
                                     PATINDEX('%[0-9][0-9][0-9][0-9]x[0-9][0-9][0-9][0-9]%', ScreenResolution),
                                     9), 
                           ''));



-- Spliting the memory column into SSD & HDD

ALTER TABLE laptopData
ADD SSD_Memory VARCHAR(50),
HDD_Memory VARCHAR(100)

ALTER TABLE laptopData
ADD Flash_storage varchar(50)


UPDATE laptopData
set SSD_Memory = CASE 
                 WHEN memory LIKE '%SSD%' THEN
				 TRIM(SUBSTRING(memory, 1, CHARINDEX('SSD', memory) + LEN('SSD')-1))
				 ELSE NULL
			END,
	HDD_memory = CASE
				 WHEN memory LIKE '%HDD%' THEN
				 TRIM(SUBSTRING(memory, CHARINDEX('HDD', memory) -5, 10))
				 ELSE NULL
			END,
	Flash_storage = CASE
					When memory LIKE '%Flash%' THEN
					     TRIM(SUBSTRING(memory, 1, CHARINDEX('Flash', memory) + LEN('Flash Storage')-1))
						 ELSE NULL
						 END;

-- Fixing some of the data that didnt get properly seperated in the screen resolution category

select * 
from laptopData
where Display = 'Touchscreen'

With Touch AS (
select * 
from laptopData
where Resolution = 'Touchscr'
)
Update Touch
Set Resolution = '1366x768',
Display = 'Touchscreen'


select * from laptopData
where Resolution = 'IPS Pane'

With IPS AS (
select * from laptopData
where Resolution = 'IPS Pane'
)
Update IPS
Set Resolution = SUBSTRING(ScreenResolution, LEN(ScreenResolution) - CHARINDEX(' ', REVERSE(ScreenResolution))+2, LEN(ScreenResolution)),
Display = Trim(SUBSTRING(ScreenResolution, 1, LEN(ScreenResolution)-CHARINDEX(' ', REVERSE(ScreenResolution))))

-- cleaning up the memory details properly

select Memory, SSD_Memory, HDD_Memory, Flash_storage, Memory_GB from laptopData

select * from laptopData
where HDD_Memory = '00GB HDD'

update laptopData
SET HDD_Memory = '500GB HDD' 
WHERE HDD_Memory = '00GB HDD'

SELECT * FROM laptopData
WHERE Cpu = 'Intel Core i7 7500U 2.7GHz' and
Ram = '16GB' and
Company ='Dell' and
TypeName = 'Notebook'

Update laptopData
SET Memory = '2TB HDD',
HDD_Memory = '2TB HDD'
WHERE Memory = '?'

Update laptopData
set HDD_Memory = '2TB HDD'
Where HDD_Memory = '1TB HDD +'

select * from laptopData
where Memory_GB is not null

-- CONVERT THE BIG DECIMAL PLACES TO SMALL DECIMAL PLACE

UPDATE laptopData
SET Centimeter = ROUND(Centimeter, 2) 

UPDATE laptopData
SET Price = ROUND(Price, 2)

ALTER TABLE laptopdata
DROP COLUMN Memory_GB

-- filling up the null values

update laptopData
set Display = 'Unknown'
where Display = ' ' or Display is null

Update laptopData
set SSD_Memory = 'No'
where SSD_Memory is null

Update laptopData
set HDD_Memory = 'No'
where HDD_Memory IS NULL

Update laptopData
set Flash_storage = 'No'
where Flash_storage is null



-------
SELECT *
FROM [Practice].[dbo].[laptopData]
