DROP SCHEMA IF EXISTS ${schema~} CASCADE;
COMMIT;

CREATE SCHEMA ${schema~};
COMMIT;

CREATE TABLE ${schema~}.boundaryline
(
  fid character varying NOT NULL,
  featurecode integer,
  geom geometry(MultiLineString,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.cartographicsymbol
(
  fid character varying NOT NULL,
  featurecode integer,
  orientation integer,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.cartographictext
(
  fid character varying NOT NULL,
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  anchorposition integer,
  font integer,
  height double precision,
  orientation integer,
  textstring character varying,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.topographicarea
(
  fid character varying NOT NULL,
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  geom geometry(Polygon,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.topographicline
(
  fid character varying NOT NULL,
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicalpresence character varying,
  geom geometry(LineString,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.topographicpoint
(
  fid character varying NOT NULL,
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;