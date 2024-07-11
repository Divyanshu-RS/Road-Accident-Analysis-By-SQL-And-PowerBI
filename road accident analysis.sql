use accident_summary;

select distinct(light_conditions) from road_accident;

select count(*) from road_accident;

describe road_accident;

set sql_safe_updates=0;

UPDATE road_accident
SET accident_date = DATE_FORMAT(STR_TO_DATE(accident_date, '%d-%m-%Y'), '%y-%m-%d')
WHERE accident_date LIKE '%-%';

alter table road_accident
modify accident_date date;

select accident_date from road_accident;

-- 1. Total Number Of casualties of this year
select sum(number_of_casualties) as Current_Year_casualties from road_accident
where Year(accident_date)='2022';

-- 2. Total Number of accident of this year
select count(distinct(accident_index)) as Current_year_accident from road_accident
where year(accident_date)='2022';

-- 3. Current Year fatal Casualtes
select sum(number_of_casualties) as Current_year_Fatal from road_accident
where year(accident_date)='2022' and accident_severity='fatal';

-- 4. Current Year serious Casualtes
select sum(number_of_casualties) as Current_year_Serious from road_accident
where year(accident_date)='2022' and accident_severity='Serious';

-- 5. Current Year Slight Casualtes
select sum(number_of_casualties) as Current_year_Slight from road_accident
where year(accident_date)='2022' and accident_severity='Slight';

-- 6.Group the Vehicle type with their number of accident by them
SELECT
    CASE
        WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'cars'
        WHEN vehicle_type = 'Agricultural Vehicle' THEN 'Agricultural'
        WHEN vehicle_type IN ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc') THEN 'bikes'
        WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'buses'
        WHEN vehicle_type IN ('Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under', 'Goods 7.5 tonnes mgw and over') THEN 'Vans'
        ELSE 'Others'
    END AS vehicle_category,
    SUM(Number_of_casualties) AS Current_year_casualties
FROM
    road_accident
WHERE
    YEAR(accident_date) = 2022
GROUP BY
    vehicle_category;

-- 7. Current Year casualties month trend
select Monthname(accident_date) as Month_name, sum(Number_of_casualties) as CY_casualties
from road_accident
where year(accident_date)='2022'
Group by Month_name;

-- 8. Previous Year casualties month trend
select Monthname(accident_date) as Month_name, sum(Number_of_casualties) as Previous_casualties
from road_accident
where year(accident_date)='2021'
Group by Month_name;

-- 9. Casualties in different Different Type Road Types
select road_type, sum(number_of_casualties) from road_accident
where year(accident_date)='2022'
Group by road_type;

-- 10. Casualties in Rural and Urban Areas
select urban_or_rural_area ,sum(number_of_casualties) 
from road_accident
where year(accident_date)='2022'
group by urban_or_rural_area;

-- 11. Casualties by lightening Condition
select case 
when light_conditions in ('Daylight') then 'Day'
when light_conditions in ('Darkness - lights lit','Darkness - lighting unknown','Darkness - lights unlit','Darkness - no lighting') then 'Night'
end as Light_condition,
sum(number_of_casualties) from road_accident
where year(accident_date)='2022'
group by light_condition;

-- 12. Top 10 location where the highest number of casualties occured

select local_authority, sum(number_of_casualties) as total_casualties 
from road_accident
where Year(accident_date)='2022'
group by local_authority
order by total_casualties desc limit 10

