--dropping table if exists

DROP TABLE IF EXISTS online_retail;
DROP TABLE IF EXISTS retail_clean;

--CREARTING NEW TABLE

CREATE TABLE online_retail(
	invoiceno TEXT,
	stockcode TEXT,
	description TEXT,
	quantity INT,
	invoicedate TEXT,
	unitprice NUMERIC,
	customerid NUMERIC,
	country TEXT
);
select count(*) from online_retail

--cleaned analytical table

CREATE TABLE clean_retail as
	SELECT
		invoiceno,
		stockcode,
		description,
		quantity,
		TO_TIMESTAMP(invoicedate, 'DD-MM-YY HH24:MI') AS invoicedate,
		unitprice,
		customerid,
		quantity*unitprice as revenue
	FROM online_retail
	WHERE invoiceno NOT LIKE 'C%'  --excluding cancelled invoice
	AND quantity >0                --removing returns/invalid
	AND customerid IS NOT NULL;    --unidentified customers
SELECT COUNT(*) FROM clean_retail  --checking if data is cleaned or not(validation check)

--validation check
SELECT MIN(invoicedate), MAX(invoicedate)
FROM clean_retail;

