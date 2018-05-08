DROP SCHEMA IF EXISTS ${schema~} CASCADE;
COMMIT;

CREATE SCHEMA ${schema~};
COMMIT;

CREATE TABLE ${schema~}.boundaryline
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  accuracyofposition character varying,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
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
  version integer,
  versiondate character varying,
  theme character varying[],
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  orientation integer,
  physicallevel integer,
  physicalpresence character varying,
  referencetofeature character varying,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.cartographictext
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
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
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  calculatedareavalue double precision,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  geom geometry(Polygon,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.topographicline
(
  fid character varying NOT NULL,
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  accuracyofposition character varying,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  nonboundingline character varying,
  heightabovedatum double precision,
  accuracyofheightabove character varying,
  heightabovegroundlevel double precision,
  accuracyofheightaboveground character varying,
  make character varying,
  physicallevel integer,
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
  featurecode integer,
  version integer,
  versiondate character varying,
  theme character varying[],
  accuracyofposition character varying,
  changedate character varying[],
  reasonforchange character varying[],
  descriptivegroup character varying[],
  descriptiveterm character varying[],
  heightabovedatum double precision,
  accuracyofheightabovedatum character varying,
  make character varying,
  physicallevel integer,
  physicalpresence character varying,
  referencetofeature character varying,
  geom geometry(Point,27700)
)
WITH (
  OIDS=FALSE
);
COMMIT;

CREATE TABLE ${schema~}.departedfeature
(
  fid character varying NOT NULL,
  theme character varying[],
  reasonForDeparture character varying,
  deletionDate character varying
)
WITH (
  OIDS=FALSE
);
COMMIT;