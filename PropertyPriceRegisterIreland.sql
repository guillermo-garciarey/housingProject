-- First Table Check
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select * 
from PropertyRegisterIreland


-- Standard Date Format
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select SALE_DATE, CONVERT(date, SALE_DATE)
from PropertyRegisterIreland

Update PropertyRegisterIreland
Set SALE_DATE = CONVERT(date, SALE_DATE) 

ALTER TABLE PropertyRegisterIreland
Add SaleDate Date;

Update PropertyRegisterIreland
Set SaleDate = CONVERT(date, SALE_DATE)


--Cleaning property description
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

select Property_Desc, COUNT(Property_desc)
from PropertyRegisterIreland
Group by PROPERTY_DESC 

ALTER TABLE PropertyRegisterIreland
Add PropertyType VarChar(255)

Update PropertyRegisterIreland
Set PropertyType = 

CASE 
        WHEN Property_Desc LIKE '%New%' THEN 'New build'
        WHEN Property_Desc LIKE '%Second%' THEN 'Second hand'
        ELSE 'Other'
END

Select PropertyType, COUNT(PropertyType)
From PropertyRegisterIreland
Group by PropertyType
Order by 2 Desc


-- Cleaning property size 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select PROPERTY_SIZE_DESC, COUNT(property_size_desc)
From PropertyRegisterIreland
Group by PROPERTY_SIZE_DESC


ALTER TABLE PropertyRegisterIreland
Add Size VarChar(255)

Select PROPERTY_SIZE_DESC, COUNT(

CASE 
        WHEN Property_Size_Desc LIKE '%less than 38%' THEN 'Small'
        WHEN Property_Size_Desc LIKE '%less than 125%' THEN 'Medium'
		WHEN Property_Size_Desc LIKE '%greater than%' THEN 'Large'
        ELSE 'Other'
END AS Size)
From PropertyRegisterIreland
Group by property_size_desc

Update PropertyRegisterIreland
Set Size = 

CASE 
        WHEN Property_Size_Desc LIKE '%less than 38%' THEN 'Small'
        WHEN Property_Size_Desc LIKE '%less than 125%' THEN 'Medium'
		WHEN Property_Size_Desc LIKE '%greater than%' THEN 'Large'
        ELSE 'Other'
END

Select Size, COUNT(size)
From PropertyRegisterIreland
Group by Size


-- Cleaning Sale_Price
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE PropertyRegisterIreland SET Sale_Price = ROUND(Sale_Price, 0)


-- Deleting unused columns
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Select *
From PropertyRegisterIreland

Alter table propertyRegisterIreland
Drop column Property_Desc, Postal_Code, Size, Property_Size_Desc, Sale_Date, IF_Market_Price, IF_vat_exlcluded


