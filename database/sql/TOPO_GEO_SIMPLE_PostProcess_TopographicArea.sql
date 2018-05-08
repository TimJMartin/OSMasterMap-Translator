DROP TABLE IF EXISTS ${schema~}.topographicarea_style;
COMMIT;

CREATE INDEX fid_${schema^}_topographicarea_idx ON ${schema~}.topographicarea(fid);
COMMIT;

DELETE FROM ${schema~}.topographicarea a WHERE a.ctid <> (SELECT min(b.ctid) FROM ${schema~}.topographicarea b WHERE  a.fid = b.fid);
COMMIT;

CREATE TABLE ${schema~}.topographicarea_style AS SELECT
CASE
	WHEN descriptiveterm = '{"Multi Surface"}' THEN 1
	WHEN descriptiveterm = '{Archway}'THEN 2
	WHEN descriptiveterm @> '{Bridge}' AND (descriptivegroup @> '{"Road Or Track"}' OR descriptivegroup @> '{Roadside}') THEN 3 --NEW
	WHEN descriptiveterm @> '{Bridge}' AND descriptivegroup @> '{Rail}' THEN 4 --NEW
	WHEN descriptiveterm @> '{Bridge}' THEN 5 --NEW
	WHEN descriptiveterm @> '{"Level Crossing"}' THEN 6 --NEW
	WHEN descriptiveterm = '{"Traffic Calming"}' THEN 7
	WHEN descriptiveterm = '{Pylon}' THEN 8
	WHEN descriptiveterm = '{Track}' THEN 9
	WHEN descriptiveterm = '{Step}' THEN 10
	WHEN descriptiveterm @> '{Canal}' THEN 11 --NEW
	WHEN descriptiveterm @> '{Footbridge}' THEN 12 --NEW
	--Natural Environment Descriptive Term Rules
	WHEN (descriptiveterm @> '{"Nonconiferous Trees"}' OR descriptiveterm @> '{"Nonconiferous Trees (Scattered)"}') AND (descriptiveterm @> '{"Coniferous Trees"}' OR descriptiveterm @> '{"Coniferous Trees (Scattered)"}') THEN 13
	WHEN descriptiveterm @> '{"Nonconiferous Trees"}' OR descriptiveterm @> '{"Nonconiferous Trees (Scattered)"}' THEN 14
	WHEN descriptiveterm @> '{"Coniferous Trees"}' OR descriptiveterm @> '{"Coniferous Trees (Scattered)"}' THEN 15
	WHEN descriptiveterm @> '{"Agricultural Land"}' THEN 16 --NEW
	WHEN descriptiveterm @> '{Orchard}' THEN 17
	WHEN descriptiveterm @> '{"Coppice Or Osiers"}' THEN 18
	WHEN descriptiveterm @> '{Scrub}' THEN 19
	WHEN descriptiveterm @> '{Boulders}' OR descriptiveterm @> '{"Boulders (Scattered)"}' THEN 20
	WHEN descriptiveterm @> '{Rock}' OR descriptiveterm @> '{"Rock (Scattered)"}' THEN 21
	WHEN descriptiveterm @> '{Scree}' THEN 22
	WHEN descriptiveterm @> '{"Rough Grassland"}' THEN 23
	WHEN descriptiveterm @> '{Heath}' THEN 24
	WHEN descriptiveterm @> '{"Marsh Reeds Or Saltmarsh"}' OR descriptiveterm @> '{Saltmarsh}' THEN 25
	WHEN descriptiveterm @> '{Sand}' THEN 26 --NEW
	WHEN descriptiveterm @> '{Mud}' THEN 27 --NEW
	WHEN descriptiveterm @> '{Shingle}' THEN 28 --NEW
	WHEN descriptiveterm @> '{Marsh}' THEN 29 --NEW
	WHEN descriptiveterm @> '{Reeds}' THEN 30 --NEW
	WHEN descriptiveterm @> '{Foreshore}' THEN 31
	WHEN descriptiveterm = '{Slope}' THEN 32
	WHEN descriptiveterm = '{Cliff}' THEN 33
	--Descriptive Group Rules
	WHEN descriptivegroup @> '{Building}' THEN 34
	WHEN descriptivegroup @> '{"General Surface"}' AND make = 'Natural' THEN 35
	WHEN descriptivegroup @> '{"General Surface"}' AND (make = 'Manmade' OR make = 'Unknown') THEN 36
	WHEN descriptivegroup @> '{"Road Or Track"}' AND make = 'Manmade' THEN 37
	WHEN descriptivegroup @> '{Roadside}' AND make = 'Natural' THEN 38
	WHEN descriptivegroup @> '{Roadside}' AND (make = 'Manmade' OR make = 'Unknown') THEN 39
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 40
	WHEN descriptivegroup @> '{Path}' THEN 41
	WHEN descriptivegroup @> '{Rail}' AND (make = 'Manmade' OR make = 'Unknown') THEN 42
	WHEN descriptivegroup @> '{Rail}' AND make = 'Natural' THEN 43
	WHEN descriptivegroup @> '{Structure}' THEN 44
	WHEN descriptivegroup = '{Glasshouse}' THEN 45
	WHEN descriptivegroup @> '{Landform}' AND make = 'Natural' THEN 46
	WHEN descriptivegroup @> '{"Tidal Water"}' THEN 47
	WHEN descriptivegroup @> '{Landform}' AND make = 'Manmade' THEN 48
	ELSE 99
END AS style_code,
geom
FROM ${schema~}.topographicarea a;
COMMIT;

DROP TABLE IF EXISTS ${schema~}.topographicarea;
COMMIT;

ALTER TABLE ${schema~}.topographicarea_style RENAME TO topographicarea;
COMMIT;

ALTER TABLE ${schema~}.topographicarea ADD COLUMN id SERIAL PRIMARY KEY;
COMMIT;

CREATE INDEX geom_${schema^}_topographicarea_idx ON ${schema~}.topographicarea USING GIST (geom);
COMMIT;

CREATE INDEX stylecode_${schema^}_topographicarea_idx ON ${schema~}.topographicarea(style_code);
COMMIT;

COMMENT ON TABLE ${schema~}.topographicarea IS ${release};
COMMIT;
