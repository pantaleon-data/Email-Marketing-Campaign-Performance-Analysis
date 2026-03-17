CREATE DATABASE marketing_db;
GO

USE marketing_db;
GO


-- EDA --

SELECT TOP 10*
FROM marketing_campaigns;

SELECT COUNT(*) AS total_rows
FROM marketing_campaigns
GROUP BY opened;

SELECT DISTINCT campaign_name
FROM marketing_campaigns;

-- dataset restructuring --

ALTER TABLE marketing_campaigns
ADD state_ VARCHAR(50);

UPDATE marketing_campaigns
SET state_ = 
CASE ABS(CHECKSUM(NEWID())) % 10
	WHEN 0 THEN 'California'
	WHEN 1 THEN 'Texas'
	WHEN 2 THEN 'Florida'
	WHEN 3 THEN 'New York'
	WHEN 4 THEN 'Illinois'
	WHEN 5 THEN 'Georgia'
	WHEN 6 THEN 'North Carolina'
	WHEN 7 THEN 'Michigan'
	WHEN 8 THEN 'Arizona'
ELSE 'Washington'
END;

ALTER TABLE marketing_campaigns
ADD country_fixed VARCHAR(20);

UPDATE marketing_campaigns
SET country_fixed = 'United States';

ALTER TABLE marketing_campaigns
DROP COLUMN country;

-- campaign_performance --

CREATE VIEW campaign_performance AS
SELECT 
	campaign_name,
	COUNT(*) AS emails_sent,
	SUM(
		CASE
			WHEN opened = '1' THEN 1
			ELSE 0
		END) AS opens,
	SUM(
		CASE
			WHEN clicked = '1' THEN 1
			ELSE 0
		END) AS clicks,
	SUM(
		CASE
			WHEN converted = '1' THEN 1
			ELSE 0
		END) AS conversions,
	SUM(revenue) AS total_revenue,

	SUM(
		CASE
			WHEN opened = '1' THEN 1
			ELSE 0
		END) * 1.0 / COUNT(*) AS open_rate,
	SUM(
		CASE
			WHEN clicked = '1' THEN 1
			ELSE 0
		END) * 1.0 / COUNT(*) AS click_through_rate,
	SUM(
		CASE
			WHEN converted = '1' THEN 1
			ELSE 0
		END) * 1.0 / COUNT(*) AS conversion_rate

FROM marketing_campaigns
GROUP BY campaign_name;

-- device_type_performance --

CREATE VIEW device_performance AS
SELECT
	device_type,
	COUNT(*) AS emails_sent,
	SUM(
		CASE
			WHEN opened = '1' THEN 1
			ELSE 0
		END) AS opens,
		SUM(
			CASE
				WHEN clicked = '1' THEN 1
				ELSE 0
			END) AS clicks,
	SUM(
		CASE	
			WHEN converted = '1' THEN 1
			ELSE 0
		END) AS conversions,
	SUM(revenue) AS total_revenue
FROM marketing_campaigns
GROUP BY device_type;

-- country_performance

ALTER VIEW country_performance AS
SELECT
	state_,
	COUNT(*) AS emails_sents,
	SUM(
		CASE
			WHEN converted = '1' THEN 1
			ELSE 0
		END) AS conversions,
	SUM(revenue) AS total_revenue
FROM marketing_campaigns
GROUP BY state_;
