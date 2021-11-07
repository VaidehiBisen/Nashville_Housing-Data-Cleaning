select * from project_1.dbo.NashvilleHousing
select saledate from project_1.dbo.NashvilleHousing;

-- CORRECTING DATE DATA FROMATE

select saledate, convert(date,saledate)  from project_1.dbo.NashvilleHousing
alter table project_1.dbo.NashvilleHousing add saledateconverted date
update project_1.dbo.NashvilleHousing set saledateconverted = convert(date,saledate)
 
--POPULATE PROPERTY ADDRESS DATA

select * from project_1.dbo.nashvillehousing order by parcelid
select a.propertyaddress,a.parcelid,b.propertyaddress,b.parcelid,isnull(a.propertyaddress,b.PropertyAddress) from project_1.dbo.NashvilleHousing a join Project_1.dbo.NashvilleHousing b 
on a.parcelid=b.parcelid and a.uniqueid<>b.uniqueid and a.PropertyAddress is null

update a set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from project_1.dbo.NashvilleHousing a join Project_1.dbo.NashvilleHousing b 
on a.parcelid=b.parcelid and a.uniqueid<>b.uniqueid and a.PropertyAddress is null

-- BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS,CITY,STATE)

select substring(propertyaddress,1,charindex(',',propertyaddress)-1) as Address, 
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as City
from project_1.dbo.nashvillehousing;

Alter table project_1.dbo.nashvillehousing add PropertysplitAddress Varchar(200);
Update project_1.dbo.nashvillehousing set PropertysplitAddress = substring(propertyaddress,1,charindex(',',propertyaddress)-1);

Alter table project_1.dbo.nashvillehousing add PropertysplitCity varchar(200);
Update project_1.dbo.nashvillehousing set PropertysplitCity = substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress));

select * from project_1.dbo.NashvilleHousing;

select PARSENAME(Replace(owneraddress,',','.') , 3),
PARSENAME(Replace(owneraddress,',','.') , 2),
PARSENAME(Replace(owneraddress,',','.') , 1)
from project_1.dbo.nashvillehousing;

Alter table project_1.dbo.nashvillehousing add OwmersplitAddress Varchar(200);
Update project_1.dbo.nashvillehousing set OwmersplitAddress = PARSENAME(Replace(owneraddress,',','.') , 3) ;

Alter table project_1.dbo.nashvillehousing add OwnersplitCity varchar(200);
Update project_1.dbo.nashvillehousing set OwnersplitCity = PARSENAME(Replace(owneraddress,',','.') , 2);

Alter table project_1.dbo.nashvillehousing add OwnersplitState varchar(200);
Update project_1.dbo.nashvillehousing set OwnersplitState = PARSENAME(Replace(owneraddress,',','.') , 1);

select * from project_1.dbo.nashvillehousing;

select * from project_1.dbo.nashvillehousing;

-- CHANGE Y ANS N TO YES AND NO RESPECTIVELY IN SOLD AS VACANT

select soldasvacant , count(soldasvacant) from project_1.dbo.nashvillehousing group by soldasvacant order by 2

select soldasvacant, CASE when soldasvacant='Y' then 'Yes'
	 when soldasvacant='N' then 'No'
	 else soldasvacant
end
from project_1.dbo.nashvillehousing

update project_1.dbo.nashvillehousing set soldasvacant =  CASE when soldasvacant='Y' then 'Yes'
	 when soldasvacant='N' then 'No'
	 else soldasvacant
end

-- REMOVE DUPLICATES

with ROWNUMCTE AS(
select *, ROW_NUMBER() over (partition by ParcelID
                                          ,LandUse
                                          ,PropertyAddress
                                          ,SaleDate
                                          ,SalePrice
                                          ,LegalReference order by uniqueid) as row_num from project_1.dbo.nashvillehousing)
Delete from ROWNUMCTE where row_num > 1

--DELETE UNUSED COLUMN

select * from project_1.dbo.nashvillehousing

Alter Table project_1.dbo.nashvillehousing drop column propertyaddress,saledate,owneraddress,taxdistrict;




