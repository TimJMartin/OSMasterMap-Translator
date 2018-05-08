DROP SCHEMA IF EXISTS ${schema~} CASCADE;
COMMIT;

CREATE SCHEMA ${schema~};
COMMIT;

CREATE TABLE ${schema~}.boundaryline
(
  featurecode integer,
  geom geometry(MultiLineString,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.cartographicsymbol
(
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
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;