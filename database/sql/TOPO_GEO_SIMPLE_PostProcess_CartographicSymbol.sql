DROP TABLE IF EXISTS ${schema~}.cartographicsymbol_style;
COMMIT;

CREATE INDEX fid_${schema^}_cartographicsymbol_idx ON ${schema~}.cartographicsymbol(fid);
COMMIT;

DELETE FROM ${schema~}.cartographicsymbol a WHERE a.ctid <> (SELECT min(b.ctid) FROM ${schema~}.cartographicsymbol b WHERE  a.fid = b.fid);
COMMIT;

CREATE TABLE ${schema~}.cartographicsymbol_style AS SELECT
CASE
	WHEN featurecode = 10091 THEN 1
	WHEN featurecode = 10082 THEN 2
	WHEN featurecode = 10130 THEN 3
	WHEN featurecode = 10066 OR featurecode = '10170' THEN 4
	WHEN featurecode = 10165 THEN 5
	WHEN featurecode = 10177 THEN 6
    ELSE 99
END AS style_code,
geom
FROM ${schema~}.cartographicsymbol as s;

DROP TABLE IF EXISTS ${schema~}.cartographicsymbol;
COMMIT;

ALTER TABLE ${schema~}.cartographicsymbol_style RENAME TO cartographicsymbol;
COMMIT;

ALTER TABLE ${schema~}.cartographicsymbol ADD COLUMN id SERIAL PRIMARY KEY;
COMMIT;

CREATE INDEX geom_${schema^}_cartographicsymbol_idx ON ${schema~}.cartographicsymbol USING GIST (geom);
COMMIT;

CREATE INDEX stylecode_${schema^}_cartographicsymbol_idx ON ${schema~}.cartographicsymbol(style_code);
COMMIT;

COMMENT ON TABLE ${schema~}.cartographicsymbol IS ${release};
COMMIT;