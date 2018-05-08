OSMasterMap Translator
--------------------
--------------------

OSMasterMap Translator uses OGR2OGR to load OS MasterMap Topography Layer (.gz) files into PostGIS.


Folder Structure
----------------

* config - contains the configuration file that needs to be edited prior to running the loader.
    * update_product - this refers to the different types of OS MasterMap Topograghy Layer that the loader supports
    * release - this is the release data, this is added to the PostGIS database tables as a comment
    * database_connection - contains the PostGIS connection details. This is used for setting up the database tables, loading the data using OGR2OGR and finally post processing the tables
    * TOPO_NONGEO - this is the Non Geographic chunked version of OS MasterMap Topography Layer.
        * source_path - full path to the directory containing the data
        * file_extension - used to correctly find the right file types in the source_path directory
        * ogr_format - for .gz files we use /vsigzip/ so that the data can be read directly without uncompressing the files
        * schema_name - this is the database schema you want the data to be loaded into
        * update_schema - this is the database schema you want the change-only data to impact. This attribute should be let blank for all apart from TOPO_GEO_COU.
        * post_processes - contains an array of SQL file names in the database/sql folder that will be used to post process the data. 
    * TOPO_GEO - this is the Geographic chunked version of OS MasterMap Topography Layer.
        * uses the same options as above 
    * TOPO_GEO_COU - this is the Change-Only Geographic chunked version of OS MasterMap Topography Layer.
        * uses the same options as above 
    * TOPO_GEO_SIMPLE - this is a stripped down version the Geographic chunked version of OS MasterMap Topography Layer that is created by limiting the data loaded in the GFS file and post processing.
        * uses the same options as above 
* database - this uses pg-promise to create the database tables and post process them
    * sql - contains all the required SQL files to create the tables and post processing
* loader - uses child_process to run the correct OGR2OGR command using the config variables. Uses Progress to show user the loading progress
* logger - Winston is used to log to the console and the logs/app.log file. 
* logs - contains the app.log file containing all log messages
* index.js - main loader script

Software Requirements
----------------------

OSMasterMap Translator requires the following

* OGR2OGR - this needs to be installed and be made avaliable in the PATH environment variable or in your bash_profile. You can download windows binaries from [here](https://www.gisinternals.com/) or for OSX you can get it from [kyngchaos](http://www.kyngchaos.com/software/frameworks)

* PostgreSQL/PostGIS - a PostGIS database setup and credentials to access it

* NodeJS - use latest Stable Release 

How to use OSMasterMap Translator
-----------------------------------

1. Download the source files from GitHub
2. Run ```npm install``` to install all the required node_modules
3. Update the config/index.js file to match your configuration. Likely changes would be to the update_product, release, database_connection and then change the source_path
4. Save the config.index.js file
5. Open a terminal or command prompt window in the folder containing the index.js file and run ```node index.js```
6. The logs will show you the progress or report any errors.

Post Processing
----------------

To get the most out of OS MasterMap Topography Layer it can sometimes be important to post process the data. The OSMasterMap Translator (depending on the update_product) does a mixture of post processing tasks.

1. Creates the style_description and style_code columsn which can then be used to style from
2. Cartographic Text has extra specific changes to make styling the text as easy as possibly depdning on end software.
    * Font Code
    * Colour Code
    * Rotation - this is orientation/10
    * Anchor
    * Geo_X
    * Geo_Y
    * Horizontal
    * Vertical
3. Renames FID to TOID
4. Adds Primary Key using TOID
5. Adds a spatial index to the geom columns
6. Adds a comment to the table of the release from the config/idnex.js file

For the Geochunked data there is an extra step to deduplicate the features that cross tile boundaries. This required an index to be added to the fid attribute then the duplicates are removed using 

```
DELETE FROM ${schema~}.boundaryline a WHERE a.ctid <> (SELECT min(b.ctid) FROM ${schema~}.boundaryline b WHERE  a.fid = b.fid);
COMMIT;
```

Performance
-----------

Performance tests have been run against TOPO_GEO and TOPO_GEO_COU for the 100km grid square SU which contains 400 gzip files and is 2.86Gb in size.

* TOPO_GEO intial load in 37 minutes 
* TOPO_GEO post processing (removing duplicates and adding styling columns and indexing) taking an extra 1 hour 5 minutes. 

**Total Time: 1hr42minutes**

* TOPO_GEO_COU applied to the above schema takes 5 minutes 48 seconds

Tests run on a MacBook Pro 2.9GHz Intel Core i5 with 16Gb of RAM with PostGIS optimised.

Applying COU
-------------

Applying COU to your original data holding can be done in several ways and depends on your requirements. Within OSMasterMap Translator the change-only data is applied using the following process:

1. Load TOPO_GEO_COU into its own schema defined in the configuration file
2. Data is then deduplicated
3. Styling columns are added so that the fields match the data in the original schema
4. Adds an index on the toid attribute is added to make the searching from the COU schema and the original schema as quick as possible.
5. Data is then deleted from the original table where the toid exists in the matching COU table
6. Data is then deleted from the original table where the toid exists in the departedfeatures table
7. Data is then inserted from the COU table into the original table

**Due to the way the PostgreSQL deals with deletes you will need to run VACUUM FULL on the database to remove the rows that have been flagged for delete. If you do not do this then the database size will get bigger and bigger with each COU you apply**







