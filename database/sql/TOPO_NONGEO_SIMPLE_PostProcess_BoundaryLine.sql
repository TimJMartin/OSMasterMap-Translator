DROP TABLE IF EXISTS ${schema~}.boundaryline_style;
COMMIT;

CREATE TABLE ${schema~}.boundaryline_style AS SELECT
CASE
	WHEN featurecode = 10136 THEN 1
	WHEN featurecode = 10131 THEN 2
	WHEN featurecode = 10128 THEN 3
	WHEN featurecode = 10127 THEN 4
	WHEN featurecode = 10135 THEN 5
	ELSE 99 
END AS style_code,
geom
FROM ${schema~}.boundaryline as b;

DROP TABLE IF EXISTS ${schema~}.boundaryline;
COMMIT;

ALTER TABLE ${schema~}.boundaryline_style RENAME TO boundaryline;
COMMIT;

ALTER TABLE ${schema~}.boundaryline ADD COLUMN id SERIAL PRIMARY KEY;
COMMIT;

CREATE INDEX geom_${schema^}_boundaryline_idx ON ${schema~}.boundaryline USING GIST (geom);
COMMIT;

CREATE INDEX stylecode_${schema^}_boundaryline_idx ON ${schema~}.boundaryline(style_code);
COMMIT;

COMMENT ON TABLE ${schema~}.boundaryline IS ${release};
COMMIT;