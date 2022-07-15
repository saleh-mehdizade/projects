

-- Standardize the date format

SELECT SaleDate, CONVERT(date, SaleDate) 
FROM nashville_housing

UPDATE nashville_housing
SET SaleDate = CONVERT(date, SaleDate) -- for some unknown reason this query does not affect the data
-- therefore, I used alternative below

ALTER TABLE nashville_housing
ADD saledate1 DATE
UPDATE nashville_housing
SET saledate1 = CONVERT(date, SaleDate)

ALTER TABLE nashville_housing
DROP COLUMN saledate

-- Populate the propertyaddress column
-- when parcel id of the property is the same with other property two properties have the same address. Using this knowledge I will populate the collumn

SELECT  a.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress) 
FROM nashville_housing as a
JOIN nashville_housing as b
ON a.[UniqueID ] != b.[UniqueID ]
AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress is null

UPDATE a
SET a.PropertyAddress = ISNULL(a.propertyaddress, b.PropertyAddress) 
FROM nashville_housing as a
JOIN nashville_housing as b
ON a.[UniqueID ] != b.[UniqueID ]
AND a.ParcelID = b.ParcelID
WHERE a.PropertyAddress is null

-- Separating data in the address column into different columns (address, city, state)

SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX (',', PropertyAddress)-1) AS address_,
SUBSTRING (propertyaddress, CHARINDEX (',', PropertyAddress)+1, LEN(propertyaddress)) AS address_1
FROM nashville_housing

ALTER TABLE nashville_housing
ADD propertyaddress1 VARCHAR(250)

UPDATE nashville_housing
SET propertyaddress1 = SUBSTRING(propertyaddress, 1, CHARINDEX (',', PropertyAddress)-1)

ALTER TABLE nashville_housing
ADD propertycity VARCHAR(250)

UPDATE nashville_housing
SET propertycity = SUBSTRING (propertyaddress, CHARINDEX (',', PropertyAddress)+1, LEN(propertyaddress))


ALTER TABLE nashville_housing
DROP COLUMN PropertyAddress

-- Doing the similar operation on the owneraddress collumn - splitting the column into three columns (address, city and state) 

SELECT 
PARSENAME(REPLACE(owneraddress, ',','.'), 3),
PARSENAME(REPLACE(owneraddress, ',','.'), 2),
PARSENAME(REPLACE(owneraddress, ',','.'), 1)
FROM nashville_housing

ALTER TABLE nashville_housing
ADD owneraddress1 VARCHAR(250)
 
UPDATE nashville_housing
SET owneraddress1 = PARSENAME(REPLACE(owneraddress, ',','.'), 3)

ALTER TABLE nashville_housing
ADD ownercity VARCHAR(250)

UPDATE nashville_housing
SET ownercity = PARSENAME(REPLACE(owneraddress, ',','.'), 2)


ALTER TABLE nashville_housing
ADD ownerstate VARCHAR(250)

UPDATE nashville_housing
SET ownerstate = PARSENAME(REPLACE(owneraddress, ',','.'), 1)

ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress

-- Changing the values in the soldasvacant column, altering all N and Y to NO and YES

SELECT soldasvacant,
	CASE
		WHEN soldasvacant = 'N' then 'No'
		WHEN soldasvacant = 'Y' then 'Yes'
		ELSE soldasvacant
	End 
FROM nashville_housing

UPDATE nashville_housing
SET SoldAsVacant = 
	CASE
		WHEN soldasvacant = 'N' then 'No'
		WHEN soldasvacant = 'Y' then 'Yes'
		ELSE soldasvacant
	End 

-- Finally removing duplicates
-- Partitioning the data by the important columns which might indicate potential duplicate
-- as a result when the number of rows is more than one then they are duplicates and we can delete them
WITH rownum AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 propertyaddress1,
				 propertycity,
				 SalePrice,
				 saledate1,
				 legalReference
				 ORDER BY UniqueId
				 ) as rows_
FROM nashville_housing
)
DELETE FROM rownum
WHERE rows_ > 1
