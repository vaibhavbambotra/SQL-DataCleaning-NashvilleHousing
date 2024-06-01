select *

from Project1..NashvilleHousing
order by 2

-- Standardize Date Format

Update NashvilleHousing
Set SaleDate = Convert(date, saledate)

Alter table NashvilleHousing
Add ConvertedSaleDate Date;

Update NashvilleHousing
Set ConvertedSaleDate = Convert(Date, SaleDate)


-- Corrected Property Address

Select a.ParcelID , a.PropertyAddress, b.ParcelID , b.PropertyAddress, isnull (a.PropertyAddress, b.PropertyAddress) as CorrectedPropertyAddress
from Project1..NashvilleHousing as A
Join Project1..NashvilleHousing as B
	On a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

	order by 1

Update a
Set propertyaddress =  isnull (a.PropertyAddress, b.PropertyAddress)
from Project1..NashvilleHousing as A
Join Project1..NashvilleHousing as B
	On a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID


-- Seprating Address and City names

Select 
Substring(PropertyAddress, 1, CharIndex(',' , PropertyAddress) -1) as UpdatedAddress,
Substring(PropertyAddress, CharIndex(',', PropertyAddress) +1 ,Len(PropertyAddress))
from Project1..NashvilleHousing

--Adding Address Column
Alter table NashvilleHousing
Add UpdatedAddress Nvarchar(255);

Update NashvilleHousing
Set UpdatedAddress = Substring(PropertyAddress, 1, CharIndex(',' , PropertyAddress) -1)

-- Adding City Column
Alter table NashvilleHousing
Add UpdatedCity Nvarchar(255);

Update NashvilleHousing
Set UpdatedCity = Substring(PropertyAddress, CharIndex(',', PropertyAddress) +1 ,Len(PropertyAddress))


-- Seperating Addresses, City and State from Owner's Address

Select 
Parsename(Replace(OwnerAddress, ',' , '.'), 3),
Parsename(Replace(OwnerAddress, ',' , '.'), 2),
Parsename(Replace(OwnerAddress, ',' , '.'), 1)
From Project1..NashvilleHousing

--Adding Address Column
Alter table NashvilleHousing
Add UpdatedOwnerAddress Nvarchar(255);

Update NashvilleHousing
Set UpdatedOwnerAddress = Parsename(Replace(OwnerAddress, ',' , '.'), 3)

--Adding City Column
Alter table NashvilleHousing
Add UpdatedOwnerCity Nvarchar(255);

Update NashvilleHousing
Set UpdatedOwnerCity = Parsename(Replace(OwnerAddress, ',' , '.'), 2)

--Adding Address Column
Alter table NashvilleHousing
Add OwnerState Nvarchar(255);

Update NashvilleHousing
Set OwnerState = Parsename(Replace(OwnerAddress, ',' , '.'), 1)


-- Changing Y and N to Yes and No 

Select Distinct Soldasvacant , Count(Soldasvacant)
From Project1..Nashvillehousing
Group by Soldasvacant

Select Soldasvacant,
Case when Soldasvacant = 'N' then 'No'
	when Soldasvacant = 'Y' then 'Yes'
	else Soldasvacant
	End
From Project1..NashvilleHousing

Update NashvilleHousing
Set Soldasvacant = Case when Soldasvacant = 'N' then 'No'
	when Soldasvacant = 'Y' then 'Yes'
	else Soldasvacant
	End


-- Deleting Duplicate Rows

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

From project1.dbo.NashvilleHousing
--order by ParcelID
)
Delete
From RowNumCTE
Where row_num > 1


-- Deleting Duplicate Columns

Select *
From Project1.dbo.NashvilleHousing

ALTER TABLE Project1.dbo.NashvilleHousing
DROP COLUMN TaxDistrict, PropertyAddress, SaleDate