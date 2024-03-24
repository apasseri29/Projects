/*

Cleaning Data in SQL Queries

*/

Select *
From PortfolioProject2.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT (Date, SaleDate)
From PortfolioProject2.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)

--Populate Property Address data

Select *
From PortfolioProject2.dbo.NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID 

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject2.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

Select
Substring(PropertyAddress, 1,CHARINDEX(',' , PropertyAddress) -1) as Address
, Substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) as Address

FROM PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar (255);

Update NashvilleHousing
SET PropertySplitAddress = Substring(PropertyAddress, 1,CHARINDEX(',' , PropertyAddress) -1)



ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

Select *
From PortfolioProject2.dbo.NashvilleHousing

Select OwnerAddress
From PortfolioProject2.dbo.NashvilleHousing


Select
ParseName(Replace(OwnerAddress,',', '.'), 3)
,ParseName(Replace(OwnerAddress,',', '.'), 2)
,ParseName(Replace(OwnerAddress,',', '.'), 1)
From PortfolioProject2.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar (255);

Update NashvilleHousing
SET OwnerSplitAddress = ParseName(Replace(OwnerAddress,',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = ParseName(Replace(OwnerAddress,',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar (255);

Update NashvilleHousing
SET OwnerSplitState = ParseName(Replace(OwnerAddress,',', '.'), 1)

Select *
From PortfolioProject2.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject2.dbo.NashvilleHousing
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END
From PortfolioProject2.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   Else SoldAsVacant
	   END

--Remove Duplicates

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
From PortfolioProject2.dbo.NashvilleHousing
--Order By ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
--Order By PropertyAddress

Select *
From PortfolioProject2.dbo.NashvilleHousing


--Delete Unused Columns

Select *
From PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN SaleDate