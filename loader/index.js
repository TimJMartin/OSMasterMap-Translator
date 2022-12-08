'use strict';
import child_process from 'child_process'
import appRoot from 'app-root-path';
import async from 'async';
import logger from "./../logger/index.js";
import configFile from "./../config/index.js";
import os from 'os';
const cpus = os.cpus();
const cpuCount = cpus.length;

let loader = {}

loader.loadPostGIS = function(file_list, callback) {
    logger.log('info', 'Loading files to PostGIS');
    const gfsPath = `${appRoot}/loader/gfs/${configFile.update_product}_CreateTables.sql`
    const pg_connection = `PG:"dbname=${configFile.database_connection.database} user=${configFile.database_connection.user} password=${configFile.database_connection.password} active_schema=${configFile[configFile.update_product].schema_name} host=${configFile.database_connection.host} port=${configFile.database_connection.port}"`;
    async.mapLimit(file_list, cpuCount, function (file, callback) {
        let ogr_cmd = `ogr2ogr -append --config GML_GFS_TEMPLATE ${gfsPath} --config PG_USE_COPY YES -lco GEOMETRY_NAME=geom -lco create_schema=off -lco create_table=off -lco spatial_index=off -f PostgreSQL ${pg_connection} ${configFile.ogr_format}${file} -a_srs EPSG:27700`;
        child_process.exec(ogr_cmd, function (error, stdout, stderr) {
            if (error) {
                console.log(error)
                console.log(stderr)
                console.log(stdout)
                logger.log('error', error);
                callback(error);
            }
        }).on('exit', function (code, signal) {
            if (code === 0) {
                logger.log('info', `${ogr_cmd} was successful`);
                callback()
            } else {
                logger.log('error', `${ogr_cmd} failed`);
                logger.log('error', signal)
                callback(`${ogr_cmd} failed`);
            }
        });
    }, function(error, results) {
        if (error) {
            logger.log('error', error);
            callback(error);
        } else {
            logger.log('info', 'Finished loading files to PostGIS');
            callback('loaded');
        }
    });
};
export default loader