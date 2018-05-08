DROP TABLE IF EXISTS ${schema~}.boundaryline_style;
COMMIT;

CREATE INDEX fid_${schema^}_boundaryline_idx ON ${schema~}.boundaryline(fid);
COMMIT;

DELETE FROM ${schema~}.boundaryline a WHERE a.ctid <> (SELECT min(b.ctid) FROM ${schema~}.boundaryline b WHERE  a.fid = b.fid);
COMMIT;

CREATE TABLE ${schema~}.boundaryline_style AS SELECT
b.*,
CASE	
	WHEN featurecode = 10136 THEN 'Parish Boundary'
	WHEN featurecode = 10131 THEN 'District Boundary'
	WHEN featurecode = 10128 THEN 'Electoral Boundary'
	WHEN featurecode = 10127 THEN 'County Boundary'
	WHEN featurecode = 10135 THEN 'Parliamentary Boundary'
	ELSE 'Unclassified' 
END AS style_description,
CASE
	WHEN featurecode = 10136 THEN 1
	WHEN featurecode = 10131 THEN 2
	WHEN featurecode = 10128 THEN 3
	WHEN featurecode = 10127 THEN 4
	WHEN featurecode = 10135 THEN 5
	ELSE 99 
	END AS style_code
FROM ${schema~}.boundaryline as b;

DROP TABLE IF EXISTS ${schema~}.boundaryline;
COMMIT;

ALTER TABLE ${schema~}.boundaryline_style RENAME TO boundaryline;
COMMIT;

ALTER TABLE ${schema~}.boundaryline RENAME COLUMN fid TO toid;
COMMIT;

ALTER TABLE ${schema~}.boundaryline ADD PRIMARY KEY (toid);
COMMIT;

CREATE INDEX geom_${schema^}_boundaryline_idx ON ${schema~}.boundaryline USING GIST (geom);
COMMIT;

CREATE INDEX stylecode_${schema^}_boundaryline_idx ON ${schema~}.boundaryline(style_code);
COMMIT;

COMMENT ON TABLE ${schema~}.boundaryline IS ${release};
COMMIT;