--Create a database and I call it "VhclAcc".

CREATE TABLE dbo.vehicle (
VehicleID VARCHAR(50) PRIMARY KEY,
AccidentIndex VARCHAR(50),
VehicleType VARCHAR(100),
PointImpact VARCHAR(50),
LeftHand VARCHAR(50),
JourneyPurpose VARCHAR(100),
Propulsion VARCHAR(100),
AgeVehicle INT NULL
)

SELECT * FROM vehicle

BULK INSERT vehicle
FROM 'C:\Users\Roshan Jha\Downloads\vehicle.csv'
	WITH (
		FIRSTROW=2,
		FIELDTERMINATOR=',',
		ROWTERMINATOR='\n'
		);

--Question 1: How many accidents have occurred in urban areas versus rural areas?
SELECT
	Area,
	COUNT(*) AS Total_Accident
FROM 
	dbo.accident
GROUP BY
	Area

--Question 2: Which day of the week has the highest number of accidents?
SELECT 
    Day,
    Count(*) Total_Accidents
FROM
    dbo.accident
GROUP BY 
	Day
ORDER BY 
    Total_Accidents DESC

--Question 3: What is the average age of vehicles involved in accidents based on their type?
SELECT 
	VehicleType,
	Count(AccidentIndex) Total_Accident,
	AVG(AgeVehicle) Avg_Age
FROM 
	vehicle
WHERE 
	AgeVehicle IS NOT NULL
GROUP BY 
	VehicleType
Order By
    Total_Accident DESC

--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
SELECT 
	AgeGroup,
	COUNT(AccidentIndex) Total_Accident,
	AVG(AgeVehicle) Average_Year
FROM (
		SELECT
		    AccidentIndex,
			AgeVehicle,
			CASE
				WHEN AgeVehicle BETWEEN 0 AND 5 THEN 'New'
				WHEN AgeVehicle BETWEEN 6 AND 10 THEN 'Regular'
				ELSE 'Old'
			END AS 'AgeGroup'
		FROM vehicle
) AS Subquery
GROUP BY 
     AgeGroup


--Question 5: Are there any specific weather conditions that contribute to severe 'Fatal' accidents?
SELECT 
	WeatherConditions,
	COUNT(Severity) AS Total_Accident
FROM
	accident
WHERE
	Severity = 'Fatal'
GROUP BY 
	WeatherConditions
ORDER BY
	Total_Accident DESC


--Question 6: Do accidents often involve impacts on the left-hand side of vehicle?
SELECT 
	LeftHand,
	COUNT(AccidentIndex) AS Total_Accident
FROM 
	vehicle
GROUP BY
	LeftHand
HAVING 
	LeftHand IS NOT NULL


--Question 7: Are there any realtionships between journey purposes and the severity of accidents?
SELECT 
	v.JourneyPurpose,
	COUNT(a.Severity) AS Total_Accident,
	CASE 
		WHEN COUNT(a.Severity) BETWEEN 0 AND 1000 THEN 'LOW'
		WHEN COUNT(a.Severity) BETWEEN 1001 AND 3000 THEN 'MODERATE'
		ELSE 'HIGH'
    END AS 'Level'
FROM
	accident AS a
INNER JOIN
	vehicle AS v
ON
	a.AccidentIndex = v.AccidentIndex
GROUP BY
	v.JourneyPurpose
ORDER BY
	Total_Accident DESC


--Question 8: Calculate the Average age of vehicles involved in accidents, considering Day light and point of impact.
SELECT
    a.LightConditions,
	v.PointImpact,
	AVG(v.AgeVehicle) AS Average_age
	
FROM
	accident AS a
INNER JOIN
	vehicle AS v
ON 
	a.AccidentIndex = v.AccidentIndex
GROUP BY
	a.LightConditions, v.PointImpact
HAVING 
	a.LightConditions = 'Daylight'













