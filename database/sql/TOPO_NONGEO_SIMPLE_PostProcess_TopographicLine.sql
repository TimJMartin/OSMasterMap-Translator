DROP TABLE IF EXISTS ${schema~}.topographicline_style;
COMMIT;

CREATE TABLE ${schema~}.topographicline_style AS SELECT
CASE
	--Descriptive Term Rules
	WHEN descriptiveterm = '{"Polygon Closing Link"}' THEN 1
	WHEN descriptiveterm = '{"Inferred Property Closing Link"}' THEN 2
	WHEN descriptiveterm = '{"Bottom Of Slope"}' THEN 3
	WHEN descriptiveterm = '{"Top Of Slope"}' THEN 4
	WHEN descriptiveterm = '{Step}' THEN 5
	WHEN descriptiveterm @> '{"Mean High Water (Springs)"}' THEN 6
	WHEN descriptiveterm = '{"Traffic Calming"}' THEN 7
	WHEN descriptiveterm = '{"Standard Gauge Track"}' THEN 8
	WHEN descriptiveterm = '{"Bottom Of Cliff"}' THEN 9
	WHEN descriptiveterm = '{"Top Of Cliff"}' THEN 10
	WHEN descriptiveterm = '{"Mean Low Water (Springs)"}' THEN 11
	WHEN descriptiveterm = '{"Unmade Path Alignment"}' THEN 12
	WHEN descriptiveterm @> '{"Overhead Construction"}' THEN 13
	WHEN descriptiveterm = '{Culvert}' THEN 14
	WHEN descriptiveterm = '{Pylon}' THEN 15
	WHEN descriptiveterm = '{Ridge Or Rock Line}' THEN 16	
	WHEN descriptiveterm = '{"Narrow Gauge"}' THEN 17
	WHEN descriptiveterm = '{Buffer}' THEN 18
	WHEN descriptiveterm = '{"Tunnel Edge"}' THEN 19
	WHEN descriptiveterm @> '{"Line Of Posts"}' THEN 20 --NEW
	WHEN descriptiveterm = '{Drain}' THEN 21 --NEW
	WHEN descriptiveterm @> '{"Normal Tidal Limit"}' THEN 22 --NEW
	--Descriptive Group Rules
	WHEN descriptivegroup @> '{"General Feature"}' AND physicalpresence <> 'Edge / Limit' THEN 23
	WHEN descriptivegroup @> '{Building}' AND descriptiveterm = '{Outline}' AND physicalpresence = 'Obstructing' THEN 24
	WHEN descriptivegroup @> '{"General Feature"}' AND physicalpresence = 'Edge / Limit' THEN 25
	WHEN descriptivegroup @> '{"Road Or Track"}' THEN 26
	WHEN descriptivegroup @> '{Building}' AND descriptiveterm = '{Division}' AND physicalpresence = 'Obstructing' THEN 27
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 28
	WHEN descriptivegroup @> '{"General Surface"}' AND make = 'Natural' THEN 29
	WHEN descriptivegroup @> '{Building}' AND descriptiveterm = '{Outline}' AND physicalpresence = 'Overhead' THEN 30
	WHEN descriptivegroup = '{Landform}' AND make = 'Natural' THEN 31
	WHEN descriptivegroup = '{"Historic Interest"}' THEN 32
	WHEN descriptivegroup = '{Landform}' AND make = 'Manmade' THEN 33	
	ELSE 99 
END AS style_code,
geom
FROM ${schema~}.topographicline as l;
COMMIT;

DROP TABLE IF EXISTS ${schema~}.topographicline;
COMMIT;

ALTER TABLE ${schema~}.topographicline_style RENAME TO topographicline;
COMMIT;

ALTER TABLE ${schema~}.topographicline ADD COLUMN id SERIAL PRIMARY KEY;
COMMIT;

CREATE INDEX geom_${schema^}_topographicline_idx ON ${schema~}.topographicline USING GIST (geom);
COMMIT;

CREATE INDEX stylecode_${schema^}_topographicline_idx ON ${schema~}.topographicline(style_code);
COMMIT;

COMMENT ON TABLE ${schema~}.topographicline IS ${release};
COMMIT;