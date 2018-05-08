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
        * post_processes - contains an array of SQL file names in the database/sql folder that will be used to post process the data. 
* database - this uses pg-promise to create the database tables and post process them
    * sql - contains all the required SQL files to create the tables and post processing
* loader - uses child_process to run the correct OGR2OGR command using the config variables. Uses Progress to show user the loading progress
* logger - Winston is used to log to the console and the logs/app.log file. 
* logs - contains the app.log file containing all log messages
* index.js - main loader script

Software Requirements
----------------------

OSMasterMap Translator requires the following

* OGR2OGR - this needs to be installed and be made avaliable in the PATH environment variable or in your bash_profile. You can download windows binaries from [here] (https://www.gisinternals.com/) or for OSX you can get it from [kyngchaos] (http://www.kyngchaos.com/software/frameworks)

* PostgreSQL/PostGIS - a PostGIS database setup and credentials to access it

* NodeJS - use latest Stable Release 

How to use OSMasterMap Translator
-----------------------------------

1. Download the source files from GtiHub
2. Run ```npm install``` to install all the required node_modules
3. Update the config/index.js file to match your configuration. Likely changes would be to the update_product, release, database_connection and then change the source_path
4. Save the config.index.js file
5. Open a terminal or command prompt window in the folder containing the index.js file and run ```node index.js```
6. The logs will show you the progress or report any errors.