=======================================================================================
  Stored Procedure: Load BRonze Layer (Source --> Bronze)
=======================================================================================
Script Purpose:
    This store procedure loads data into the 'bronze' schema from external CSV files.
    It performs the following actions:
    - Truncate the bronze table before loading data.
    - Uses the 'BULK INSERT' command to load data from csv files to bronze table.

Usage example:
  EXEC bronze.load_bronze

=======================================================================================
-- creating stored procedure to store the script and just put 'exec bronze.load_bronze' if want to load the script

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME , @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY -- SQL RUNS THE TRY BLOCK, AND IF IT FAILS, IT RUNS THE CATCH BLOCK TO HANDLE THE ERROR
	PRINT '===================================================';
	PRINT 'Loading Bronze Layer';
	PRINT '===================================================';

----------------------------------------------------------------------------------------------------------------------------------
	PRINT '---------------------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '---------------------------------------------------';

	SET @start_time = GETDATE();
	PRINT '>> Truncating Table: bronze.crm_cust_info';
	TRUNCATE TABLE bronze.crm_cust_info;  --MAKING THE TABLE EMPTY, THEN INSERT FROM SCRATCH

	PRINT '>> Inserting Data into: bronze.crm_cust_info';
	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\Admin\Desktop\personal\projects\sql data warehouse\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2, -- telling sql that the data starts at second row (looking into csv file)
		FIELDTERMINATOR = ',', --telling delimiter
		TABLOCK  --locking entire table
);
SET @start_time = GETDATE();
	SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


----------------------------------------------------------------------------------------------------------------------------------
	PRINT '>> Truncating Table: bronze.crm_prd_info';
	TRUNCATE TABLE bronze.crm_prd_info;  --MAKING THE TABLE EMPTY, THEN INSERT FROM SCRATCH

	SET @start_time = GETDATE();
	PRINT '>> Inserting Data into: bronze.crm_prd_info';
	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\Admin\Desktop\personal\projects\sql data warehouse\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2, -- telling sql that the data starts at second row (looking into csv file)
		FIELDTERMINATOR = ',', --telling delimiter
		TABLOCK  --locking entire table
);
SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

----------------------------------------------------------------------------------------------------------------------------------
PRINT '>> Truncating Table: bronze.crm_prd_info';
TRUNCATE TABLE bronze.crm_sales_details;  --MAKING THE TABLE EMPTY, THEN INSERT FROM SCRATCH

SET @start_time = GETDATE();
PRINT '>> Inserting Data into: bronze.crm_sales_details';
BULK INSERT bronze.crm_sales_details
FROM 'C:\Users\Admin\Desktop\personal\projects\sql data warehouse\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
	FIRSTROW = 2, -- telling sql that the data starts at second row (looking into csv file)
	FIELDTERMINATOR = ',', --telling delimiter
	TABLOCK  --locking entire table
);
SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

----------------------------------------------------------------------------------------------------------------------------------
PRINT '---------------------------------------------------';
PRINT 'Loading ERP Tables';
PRINT '---------------------------------------------------';

PRINT '>> Truncating Table: bronze.crm_prd_info';
TRUNCATE TABLE bronze.erp_cust_az12;  --MAKING THE TABLE EMPTY, THEN INSERT FROM SCRATCH

SET @start_time = GETDATE();
PRINT '>> Inserting Data into: bronze.erp_cust_az12';
BULK INSERT bronze.erp_cust_az12
FROM 'C:\Users\Admin\Desktop\personal\projects\sql data warehouse\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
	FIRSTROW = 2, -- telling sql that the data starts at second row (looking into csv file)
	FIELDTERMINATOR = ',', --telling delimiter
	TABLOCK  --locking entire table
);
SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
----------------------------------------------------------------------------------------------------------------------------------
PRINT '>> Truncating Table: bronze.erp_loc_a101';
TRUNCATE TABLE bronze.erp_loc_a101;  --MAKING THE TABLE EMPTY, THEN INSERT FROM SCRATCH

SET @start_time = GETDATE();
PRINT '>> Inserting Data into: bronze.erp_loc_a101';
BULK INSERT bronze.erp_loc_a101
FROM 'C:\Users\Admin\Desktop\personal\projects\sql data warehouse\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
	FIRSTROW = 2, -- telling sql that the data starts at second row (looking into csv file)
	FIELDTERMINATOR = ',', --telling delimiter
	TABLOCK  --locking entire table
);
SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
----------------------------------------------------------------------------------------------------------------------------------
PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
TRUNCATE TABLE bronze.erp_px_cat_g1v2;  --MAKING THE TABLE EMPTY, THEN INSERT FROM SCRATCH

SET @start_time = GETDATE();
PRINT '>> Inserting Data into: bronze.erp_px_cat_g1v2';
BULK INSERT bronze.erp_px_cat_g1v2
FROM 'C:\Users\Admin\Desktop\personal\projects\sql data warehouse\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
	FIRSTROW = 2, -- telling sql that the data starts at second row (looking into csv file)
	FIELDTERMINATOR = ',', --telling delimiter
	TABLOCK  --locking entire table
);
SET @end_time = GETDATE();
	PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
		PRINT '======================================================'
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '======================================================'
	END CATCH
END
