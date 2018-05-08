const child_process = require('child_process');
const appRoot = require('app-root-path');

//Import third part modules
const async = require("async");
const ProgressBar = require('progress');
const logger = require('../logger'); //Winston logger for logging message to console

const loader = module.exports = {};
const green = '\u001b[42m \u001b[0m';
const red = '\u001b[41m \u001b[0m';

loader.loadPostGIS = function(database_connection, update_product, file_list, schema_name, ogr_format, callback) {
    logger.log('info', 'Loading files to PostGIS');
    var bar = new ProgressBar('Progress  [:bar] :percent', {
        complete: green,
        incomplete: red,
        width: 40,
        total: file_list.length
    });
    var pg_connection = `PG:"dbname=${database_connection.database} user=${database_connection.user} password=${database_connection.password} active_schema=${schema_name} host=${database_connection.host} port=${database_connection.port}"`;
    var gfs_path = appRoot +  '/loader/gfs/' + `${update_product}.gfs`;
    async.mapLimit(file_list, 4, function (file, callback) {
        var ogr_cmd = `ogr2ogr -append --config GML_GFS_TEMPLATE ${gfs_path} --config PG_USE_COPY YES -lco GEOMETRY_NAME=geom -lco create_schema=off -lco create_table=off -lco spatial_index=off -f PostgreSQL ${pg_connection} ${ogr_format}${file} -a_srs EPSG:27700`;
        child_process.exec(ogr_cmd, function (error, stdout, stderr){
            if(error) {
                logger.log('error', error);
                callback(error);
            }
            bar.tick();
            callback();
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
