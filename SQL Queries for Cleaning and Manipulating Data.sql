/*

Cleaning Data in SQL Queries

*/

Select *
From [Portfolio Project]..[Nashville Housing Exercise]

-------------------------------------------
-- Standardize Date Format
Select SaleDate, CONVERT(date,SaleDate)
From [Portfolio Project]..[Nashville Housing Exercise]

Update [Nashville Housing Exercise]
SET SaleDate = CONVERT(date,SaleDate)

ALTER TABLE Nashville Housing Exercise
Add SaleDateConverted Date;

Update [Nashville Housing Exercise]
SET SaleDateConverted = CONVERT(date,SaleDate)

-------------------------------------------
-- Populate Property Address Data

Select *
From [Portfolio Project]..[Nashville Housing Exercise]
--Where PropertyAddress is null	
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..[Nashville Housing Exercise] a 
JOIN [Portfolio Project]..[Nashville Housing Exercise] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
--Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Portfolio Project]..[Nashville Housing Exercise] a 
JOIN [Portfolio Project]..[Nashville Housing Exercise] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



-------------------------------------------
-- Breaking out address into individuals columns (Address, City, State)

Select PropertyAddress
From [Portfolio Project]..[Nashville Housing Exercise]

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From [Portfolio Project]..[Nashville Housing Exercise]

ALTER TABLE [Nashville Housing Exercise]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing Exercise]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [Nashville Housing Exercise]
Add PropertySplitCity NvarChar(255);

Update [Nashville Housing Exercise]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From [Portfolio Project]..[Nashville Housing Exercise]


Select OwnerAddress
From [Portfolio Project]..[Nashville Housing Exercise]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio Project]..[Nashville Housing Exercise]

ALTER TABLE [Nashville Housing Exercise]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing Exercise]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE [Nashville Housing Exercise]
Add OwnerSplitCity NvarChar(255);

Update [Nashville Housing Exercise]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [Nashville Housing Exercise]
Add OwnerSplitState NvarChar(255);

Update [Nashville Housing Exercise]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

Select *
From [Portfolio Project]..[Nashville Housing Exercise]


-------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio Project]..[Nashville Housing Exercise]
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio Project]..[Nashville Housing Exercise]


Update [Nashville Housing Exercise]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END



-------------------------------------------
-- Remove duplicates

WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
					UniqueID
					) row_num

From [Portfolio Project]..[Nashville Housing Exercise]
--Order by ParcelID
)
--DELETE
Select *
From RoWNumCTE
Where row_num > 1
Order by PropertyAddress





-------------------------------------------
-- Delete Unused Columns

Select *
From [Portfolio Project]..[Nashville Housing Exercise]

ALTER TABLE [Portfolio Project]..[Nashville Housing Exercise]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Portfolio Project]..[Nashville Housing Exercise]
DROP COLUMN SaleDate