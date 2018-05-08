DROP TABLE IF EXISTS ${schema~}.topographicpoint_style;
COMMIT;

CREATE TABLE ${schema~}.topographicpoint_style AS SELECT
CASE
	WHEN descriptiveterm = '{"Spot Height"}' THEN 1
	WHEN descriptiveterm = '{"Emergency Telephone"}' THEN 2
	WHEN descriptiveterm @> '{"Site Of Heritage"}' THEN 3
	WHEN descriptiveterm @> '{Culvert}' THEN 4
	WHEN descriptiveterm = '{"Positioned Nonconiferous Tree"}' THEN 5
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 6
	WHEN descriptivegroup @> '{Roadside}' THEN 7
	WHEN descriptiveterm @> '{"Overhead Construction"}' THEN 8
	WHEN descriptivegroup @> '{"Rail"}' THEN 9
	WHEN descriptiveterm = '{"Positioned Coniferous Tree"}' THEN 10
	WHEN descriptiveterm = '{"Boundary Post Or Stone"}' THEN 11
	WHEN descriptiveterm = '{"Triangulation Point Or Pillar"}' THEN 12
	WHEN descriptivegroup = '{"Historic Interest"}' THEN 13
	WHEN (descriptivegroup = '{Landform}' OR descriptiveterm = '{"Positioned Boulder"}') THEN 14
	WHEN descriptivegroup @> '{"Tidal Water"}' THEN 15
	WHEN descriptivegroup @> '{Structure}' THEN 16
ELSE 99
END AS style_code,
geom
FROM ${schema~}.topographicpoint as p;
COMMIT;

DROP TABLE IF EXISTS ${schema~}.topographicpoint;
COMMIT;

ALTER TABLE ${schema~}.topographicpoint_style RENAME TO topographicpoint;
COMMIT;

ALTER TABLE ${schema~}.topographicpoint ADD COLUMN id SERIAL PRIMARY KEY;
COMMIT;

CREATE INDEX geom_${schema^}_topographicpoint_idx ON ${schema~}.topographicpoint USING GIST (geom);
COMMIT;

CREATE INDEX stylecode_${schema^}_topographicpoint_idx ON ${schema~}.topographicpoint(style_code);
COMMIT;

COMMENT ON TABLE ${schema~}.topographicpoint IS ${release};
COMMIT;

