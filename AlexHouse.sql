/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [test].[dbo].[alexhouse]

  /*------------------CLEANING DATA------------------------------------*/

  SELECT *
  FROM [test].[dbo].[alexhouse]

  ---------------STANDARDIZE DATE FORMAT---------------------------------
  select SaleDate,convert(date,SaleDate)
  FROM [test].[dbo].[alexhouse]

update [test].[dbo].[alexhouse]
set SaleDate = convert(date,SaleDate)

alter table [test].[dbo].[alexhouse]
add Sale_Date date

update [test].[dbo].[alexhouse]
set Sale_Date = convert(date,SaleDate)

------------------Populate Property address-------------------------------------

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, COALESCE(a.PropertyAddress,b.PropertyAddress)
FROM [test].[dbo].[alexhouse] a
join [test].[dbo].[alexhouse] b
on a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = COALESCE(a.PropertyAddress,b.PropertyAddress)
FROM [test].[dbo].[alexhouse] a
join [test].[dbo].[alexhouse] b
on a.ParcelID=b.ParcelID and a.[UniqueID ]!=b.[UniqueID ]
where a.PropertyAddress is null

select *
FROM [test].[dbo].[alexhouse]
where PropertyAddress is null

------------------------------Property Address------------------------------------------
SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))
  FROM [test].[dbo].[alexhouse]

  alter table [test].[dbo].[alexhouse]
add Paddress1 nvarchar(255);

update [test].[dbo].[alexhouse]
set Paddress1 = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table [test].[dbo].[alexhouse]
add Paddress2 nvarchar(255);

update [test].[dbo].[alexhouse]
set Paddress2 = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



select PARSENAME(replace(OwnerAddress,',','.'),3),
PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
FROM [test].[dbo].[alexhouse]


--------------------------------Change y to yes---------------

select SoldAsVacant,
case when SoldAsVacant = 'N' then 'No'
     when SoldAsVacant= 'Y' then'Yes'
	 else SoldAsVacant end 

FROM [test].[dbo].[alexhouse];

select distinct(SoldAsVacant), count(SoldAsVacant)
FROM [test].[dbo].[alexhouse]
group by SoldAsVacant


-------------------remove duplicates-----------------------
select *,
ROW_NUMBER()over(partition by ParcelID,PropertyAddress,SaleDate
      ,SalePrice, LegalReference order by UniqueID) rnk
FROM [test].[dbo].[alexhouse]

