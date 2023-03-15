# EDA using SQL of the Irish Property Register


---

</br>

  - **[1. Tools](#1-tools)**
  - **[2. Project Scope](#2-project-scope)**
  - **[3. Importing and describing the dataset](#3-importing-and-describing-the-dataset)**
  - **[4. Data cleaning](#4-data-cleaning)**
  - **[5. Tableau](#5-tableau)**

</br>

---

## 1. Tools

</br>



**SQL | Tableau**




</br>

---

## 2. Project Scope

</br>

This is a brief exploratory data analysis using SQL for a public dataset found through [Kaggle](https://www.kaggle.com/datasets/erinkhoo/property-price-register-ireland). 

The dataset contained information about the Ireland property register prices from 2010 to 2021 and throughout this project we applied some transformation steps using SQL queries, which included text formatting, date and currency standardization, grouping of results using case statements, and removal of unused columns.

After this, the data was visualized in [Tableau](https://public.tableau.com/app/profile/guillermo.garcia6900/viz/IrelandPropertyPriceRegister/Dashboard1) where the resulting information was analyzed and future predictions were made.

The aim of this was to provide insights into the property market trends in Ireland and inform future investment decisions.

Without further ado, first we will get a feel of a dataset and try to answer the following questions:

</br>


-   What has been the price trend for the past 10 years?
-   How does price vary between counties?
-   What is the most common budget when purchasing?
-   Is there enough offer to keep up with demand?



</br>
</br>

---
      
## 3. Importing and describing the dataset

</br>



Initially we want to have a general overview of the dataset, in particular the column type in search for errors (for example: string instead of date, string or float for True / False type columns) and overall size of the dataset.

</br>
      

```
SELECT column_name, data_type

FROM information_schema.columns

WHERE table_name =  'RawPropertyRegisterIreland';
```

</br>

| Column        | Data Type |
|---------------|-----------|
| SaleDate      | datetime  |
| Address       | nvarchar  |
| PostalCode    | nvarchar  |
| County        | nvarchar  |
| SalePrice     | float     |
| IfMarketPrice | float     |
| IfVATExcluded | float     |
| PropertyDesc  | nvarchar  |
| PropertySize  | nvarchar  |


</br>


In this case the data type looks to be correct except for SaleDate where we have "datetime" instead of "date".

Wherever possible it is a good idea to simplify as much as possible provided you do not need certain level of granularity.

</br>
</br>

---

## 4. Data cleaning

</br>

When cleaning a dataset in SQL, the following are some initial considerations that need to be taken into account.

</br>


>### Identifying missing values:

</br>

Since the dataset is fairly straightforward, we will delete any rows that have missing values in the fields of SaleDate, County, SalePrice.

```
DELETE FROM RawPropertyRegisterIreland
WHERE SalePrice IS NULL OR County IS NULL OR SaleDate IS NULL
```

</br>

>### Checking for duplicates:

</br>


```
SELECT Address, PostalCode, County, SalePrice, SaleDate, COUNT(*) as Duplicate
FROM RawPropertyRegisterIreland
GROUP BY Address, PostalCode, County, SalePrice, SaleDate
HAVING COUNT(*) > 1
```

</br>

No duplicates were found in this step but had there been, we would remove them with a `Delete` query and a condition plus `Rank` clause.

</br>

>### Addressing inconsistencies:

</br>

To standardize columns we used the following queries:

</br>


```
Update RawPropertyRegisterIreland
Set SaleDate = CONVERT(date, SaleDate) 
```

Converting the SaleDate to `date` instead of `datetime` removed the time and prevented any possible errors when visualizing the data.

</br>



```
UPDATE RawPropertyRegisterIreland 
SET County = REPLACE(REPLACE(REPLACE(County, ' ', ''), '.', ''), ',', '');
```

</br>


```
UPDATE RawPropertyRegisterIreland
SET County = INITCAP(County)
```

</br>

Since we intend to use a map feature in Tableau when viewing our data, we want to make sure the information is accurate by removing any spaces and capitalizing the first letter of each County.

</br>



```
Update RawPropertyRegisterIreland
Set Size = 

CASE 
WHEN PropertySize LIKE '%less than 38%' THEN 'Small'
WHEN PropertySize LIKE '%less than 125%' THEN 'Medium'
WHEN PropertySize LIKE '%greater than%' THEN 'Large'
ELSE 'Other'
END
```

</br>

We separate PropertySize column into 4 categories based on the footprint.

</br>

```
Update RawPropertyRegisterIreland
Set PropertyDesc = 

CASE 
WHEN PropertyDesc LIKE '%New%' THEN 'New build'
WHEN PropertyDesc LIKE '%Second%' THEN 'Second hand'
ELSE 'Other'
END
```

</br>

We separate PropertyDesc column into 3 categories based on the type of build.


</br>

```
UPDATE RawPropertyRegisterIreland 
SET SalePrice = ROUND(SalePrice, 0)
```
</br>

In order to simplify things, we round the SalePrice value to have no decimal points. The same thing can be accomplished in Tableau when creating the visualization.

</br>


>### Removing irrelevant data:

</br>

After exploring the dataset I found that in order to answer the original questions I had there was no need for the following columns.

</br>



>PostalCode was redundant with County.

>Address contained too many inconsistencies to be of use.

>PropertySize was not necessary and wasn't sufficiently detailed to be of use.

>IfVATExcluded and IfMarketPrice were not necessary.

</br>

In order to remove the columns from the dataset we used the following query:

</br>

```
ALTER TABLE RawPropertyRegisterIreland
DROP COLUMN PropertySize, IfVATExcluded, IfMarketPrice, PostalCode, Address
```

</br>
</br>


---

## 5. Tableau

</br>



