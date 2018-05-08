DROP TABLE IF EXISTS ${schema~}.cartographictext_style;
COMMIT;

CREATE INDEX fid_${schema^}_cartographictext_idx ON ${schema~}.cartographictext(fid);
COMMIT;

DELETE FROM ${schema~}.cartographictext a WHERE a.ctid <> (SELECT min(b.ctid) FROM ${schema~}.cartographictext b WHERE  a.fid = b.fid);
COMMIT;

CREATE TABLE ${schema~}.cartographictext_style AS SELECT
t.*,
CASE
	WHEN descriptivegroup @> '{"Buildings Or Structure"}' THEN 'Building Text'
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 'Water Text'
	WHEN descriptivegroup @> '{"Road Or Track"}' THEN 'Road Text'
	WHEN descriptivegroup = '{Terrain And Height}' THEN 'Height Text'
	WHEN descriptivegroup @> '{Roadside}' THEN 'Roadside Text'
	WHEN descriptivegroup @> '{Structure}' THEN 'Structure Text'
	WHEN descriptivegroup = '{"Political Or Administrative"}' THEN 'Administrative Text'
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Natural' THEN 'General Surface Natural Text'
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Manmade' OR descriptivegroup = '{"General Surface"}' AND make IS NULL THEN 'General Surface Manmade Text'
	WHEN descriptivegroup = '{Landform}' and make = 'Natural' THEN 'Landform Natural Text'
	WHEN descriptiveterm = '{Foreshore}' THEN 'Foreshore Text'
	WHEN descriptivegroup @> '{"Tidal Water"}' THEN 'Tidal Water Text'
	WHEN descriptivegroup = '{"Built Environment"}' THEN 'Built Environment Text'
	WHEN descriptivegroup @> '{"Historic Interest"}' THEN 'Historic Text'
	WHEN descriptivegroup = '{Rail}' THEN 'Rail Text'
	WHEN descriptivegroup @> '{"General Feature"}' THEN 'General Feature Text'
	WHEN descriptivegroup = '{Landform}' and make = 'Manmade' THEN 'Landform Manmade Text'
	ELSE 'Unclassified' 
END AS style_description,
CASE
	WHEN descriptivegroup @> '{"Buildings Or Structure"}' THEN 1
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 2
	WHEN descriptivegroup @> '{"Road Or Track"}' THEN 3
	WHEN descriptivegroup = '{Terrain And Height}' THEN 4
	WHEN descriptivegroup @> '{Roadside}' THEN 5
	WHEN descriptivegroup @> '{Structure}' THEN 6
	WHEN descriptivegroup = '{"Political Or Administrative"}' THEN 7
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Natural' THEN 8
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Manmade' OR descriptivegroup = '{"General Surface"}' AND make IS NULL THEN 9
	WHEN descriptivegroup = '{Landform}' and make = 'Natural' THEN 10
	WHEN descriptiveterm = '{Foreshore}' THEN 11
	WHEN descriptivegroup @> '{"Tidal Water"}' THEN 12
	WHEN descriptivegroup = '{"Built Environment"}' THEN 13
	WHEN descriptivegroup @> '{"Historic Interest"}' THEN 14
	WHEN descriptivegroup = '{Rail}' THEN 15
	WHEN descriptivegroup @> '{"General Feature"}' THEN 16
	WHEN descriptivegroup = '{Landform}' and make = 'Manmade' THEN 17
	ELSE '99' 
END AS style_code,
CASE
	WHEN descriptivegroup @> '{"Buildings Or Structure"}' THEN 1
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 2
	WHEN descriptivegroup @> '{"Road Or Track"}' THEN 1
	WHEN descriptivegroup = '{Terrain And Height}' THEN 3
	WHEN descriptivegroup @> '{Roadside}' THEN 1
	WHEN descriptivegroup @> '{Structure}' THEN 1
	WHEN descriptivegroup = '{"Political Or Administrative"}' THEN 5
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Natural' THEN 1
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Manmade' OR descriptivegroup = '{"General Surface"}' AND make IS NULL THEN 1
	WHEN descriptivegroup = '{Landform}' and make = 'Natural' THEN 4
	WHEN descriptiveterm = '{Foreshore}' THEN 4
	WHEN descriptivegroup @> '{"Tidal Water"}' THEN 2
	WHEN descriptivegroup = '{"Built Environment"}' THEN 1
	WHEN descriptivegroup @> '{"Historic Interest"}' THEN 1
	WHEN descriptivegroup = '{Rail}' THEN 1
	WHEN descriptivegroup @> '{"General Feature"}' THEN 1
	WHEN descriptivegroup = '{Landform}' and make = 'Manmade' THEN 4
	ELSE '1' 
END AS colour_code,
CASE
	WHEN descriptivegroup @> '{"Buildings Or Structure"}' THEN 1
	WHEN descriptivegroup @> '{"Inland Water"}' THEN 2
	WHEN descriptivegroup @> '{"Road Or Track"}' THEN 1
	WHEN descriptivegroup = '{Terrain And Height}' THEN 1
	WHEN descriptivegroup @> '{Roadside}' THEN 1
	WHEN descriptivegroup @> '{Structure}' THEN 1
	WHEN descriptivegroup = '{"Political Or Administrative"}' THEN 1
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Natural' THEN 1
	WHEN descriptivegroup = '{"General Surface"}' AND make = 'Manmade' OR descriptivegroup = '{"General Surface"}' AND make IS NULL THEN 1
	WHEN descriptivegroup = '{Landform}' and make = 'Natural' THEN 1
	WHEN descriptiveterm = '{Foreshore}' THEN 1
	WHEN descriptivegroup @> '{"Tidal Water"}' THEN 2
	WHEN descriptivegroup = '{"Built Environment"}' THEN 1
	WHEN descriptivegroup @> '{"Historic Interest"}' THEN 3
	WHEN descriptivegroup = '{Rail}' THEN 1
	WHEN descriptivegroup @> '{"General Feature"}' THEN 1
	WHEN descriptivegroup = '{Landform}' and make = 'Manmade' THEN 1
	ELSE '1' 
END AS font_code,
(orientation/10) as rotation,
CASE
	WHEN anchorposition = 0 THEN 0
	WHEN anchorposition = 1 THEN 0
	WHEN anchorposition = 2 THEN 0
	WHEN anchorposition = 3 THEN 0.5
	WHEN anchorposition = 4 THEN 0.5
	WHEN anchorposition = 5 THEN 0.5
	WHEN anchorposition = 6 THEN 1
	WHEN anchorposition = 7 THEN 1
	WHEN anchorposition = 8 THEN 1
END AS geo_x,
CASE
	WHEN anchorposition = 0 THEN 0
	WHEN anchorposition = 1 THEN 0.5
	WHEN anchorposition = 2 THEN 1
	WHEN anchorposition = 3 THEN 0
	WHEN anchorposition = 4 THEN 0.5
	WHEN anchorposition = 5 THEN 1
	WHEN anchorposition = 6 THEN 0
	WHEN anchorposition = 7 THEN 0.5
	WHEN anchorposition = 8 THEN 1
END AS geo_y,
CASE
	WHEN anchorposition = 0 THEN 'SW'
	WHEN anchorposition = 1 THEN 'W'
	WHEN anchorposition = 2 THEN 'NW'
	WHEN anchorposition = 3 THEN 'S'
	WHEN anchorposition = 4 THEN ''
	WHEN anchorposition = 5 THEN 'N'
	WHEN anchorposition = 6 THEN 'SE'
	WHEN anchorposition = 7 THEN 'E'
	WHEN anchorposition = 8 THEN 'NE'
END as anchor,
CASE
	WHEN anchorposition = 0 THEN 'left'
	WHEN anchorposition = 1 THEN 'left'
	WHEN anchorposition = 2 THEN 'left'
	WHEN anchorposition = 3 THEN 'middle'
	WHEN anchorposition = 4 THEN 'middle'
	WHEN anchorposition = 5 THEN 'middle'
	WHEN anchorposition = 6 THEN 'right'
	WHEN anchorposition = 7 THEN 'right'
	WHEN anchorposition = 8 THEN 'right'
END as horizontal,
CASE
	WHEN anchorposition = 0 THEN 'bottom'
	WHEN anchorposition = 1 THEN 'middle'
	WHEN anchorposition = 2 THEN 'top'
	WHEN anchorposition = 3 THEN 'bottom'
	WHEN anchorposition = 4 THEN 'middle'
	WHEN anchorposition = 5 THEN 'top'
	WHEN anchorposition = 6 THEN 'bottom'
	WHEN anchorposition = 7 THEN 'middle'
	WHEN anchorposition = 8 THEN 'top'
END as vertical		
FROM ${schema~}.cartographictext as t;

DROP TABLE IF EXISTS ${schema~}.cartographictext;
COMMIT;

ALTER TABLE ${schema~}.cartographictext_style RENAME TO cartographictext;
COMMIT;

ALTER TABLE ${schema~}.cartographictext RENAME COLUMN fid TO toid;
COMMIT;

ALTER TABLE ${schema~}.cartographictext ADD PRIMARY KEY (toid);
COMMIT;

DELETE FROM ${update_schema~}.cartographictext WHERE toid IN (SELECT toid FROM ${schema~}.cartographictext);
COMMIT;

DELETE FROM ${update_schema~}.cartographictext WHERE toid IN (SELECT toid FROM ${schema~}.departedfeature);
COMMIT;

INSERT INTO ${update_schema~}.cartographictext SELECT * FROM ${schema~}.cartographictext;
COMMIT;

COMMENT ON TABLE ${update_schema~}.cartographictext IS ${release};
COMMIT;