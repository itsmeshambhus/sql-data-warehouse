/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL bronze.load_bronze();
===============================================================================
*/

CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE
	start_time TIMESTAMP;
	end_time TIMESTAMP;
BEGIN
		RAISE NOTICE '==================================';
		RAISE NOTICE 'LOADING CRM AND ERP TABLES';
		RAISE NOTICE '==================================';
		start_time := CURRENT_TIMESTAMP;
		TRUNCATE TABLE bronze.crm_cust_info;
		COPY bronze.crm_cust_info
		FROM '/tmp/cust_info.csv'
		DELIMITER ','
		CSV HEADER;
		
		TRUNCATE TABLE bronze.crm_prd_info;
		COPY bronze.crm_prd_info
		FROM '/tmp/prd_info.csv'
		DELIMITER ','
		CSV HEADER;
		
		TRUNCATE TABLE bronze.crm_sales_details;
		COPY bronze.crm_sales_details
		FROM '/tmp/sales_details.csv'
		DELIMITER ','
		CSV HEADER;

		end_time := CURRENT_TIMESTAMP;
		RAISE NOTICE '>> CRM LOAD DURATION: % seconds', EXTRACT(EPOCH FROM end_time - start_time);

		start_time := CURRENT_TIMESTAMP;
		TRUNCATE TABLE bronze.erp_cust_az12;
		COPY bronze.erp_cust_az12
		FROM '/tmp/cust_az12.csv'
		DELIMITER ','
		CSV HEADER;
		
		TRUNCATE TABLE bronze.erp_loc_a101;
		COPY bronze.erp_loc_a101
		FROM '/tmp/loc_a101.csv'
		DELIMITER ','
		CSV HEADER;
		
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		COPY bronze.erp_px_cat_g1v2
		FROM '/tmp/px_cat_g1v2.csv'
		DELIMITER ','
		CSV HEADER;

		end_time := CURRENT_TIMESTAMP;
		RAISE NOTICE '>> CRM LOAD DURATION: % seconds', EXTRACT(EPOCH FROM end_time - start_time);
		
		RAISE NOTICE '==================================';
		RAISE NOTICE 'All data loaded successfully!';
		RAISE NOTICE '==================================';

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE '==================================';
		RAISE NOTICE 'Error loading data: %', SQLERRM;
		RAISE NOTICE '==================================';
END;
$$;

