const config = require('./config')
const logger = require('./logger')
const async = require('async')
const database = require('./database')
const klaw = require('klaw')
const prettyMs = require('pretty-ms')
const path = require('path')
const loader = require('./loader')


const translateData = () => {
    //Top Level Variables
    const start = new Date();
    const update_product = config.update_product;
    const database_connection = config.database_connection;
    const working_directory = config.working_directory;
    const release = config.release;
    let db;//Empty database object that is reused for creating database tables and then post processing

    //Update Product Variables
    const source_directory = config[update_product].source_path;
    const file_extension = config[update_product].file_extension;
    const schema_name = config[update_product].schema_name;
    const ogr_format = config[update_product].ogr_format;
    const postProcesses = config[update_product].post_processes;

    
    async.waterfall([
        function(callback) {
            logger.log('info', `Starting to translate ${update_product}`);
            database.createTable(database_connection, update_product, schema_name, function(response) {
                db = response[1];
                if (response[0] === 'created') {
                    callback(null, response);
                }
            }); 
        },
        function(response, callback) {
            logger.log('info', 'Listing files in source directory');
            var files = [];
            klaw(source_directory)
                .on('data', function (item) {
                    if(path.extname(item.path) === file_extension) {
                        files.push(item.path)
                    }
                })
                .on('end', function () {
                    logger.log('info', `Found ${files.length} files`);
                    callback(null, files);
                })
        },
        function(files, callback) {
            loader.loadPostGIS(database_connection, update_product, files, schema_name, ogr_format, function(response) {
                if (response === 'loaded') {
                    callback(null, response);
                }
            });
        },
        function(response, callback) {
            logger.log('info', 'Post processing database tables');
            async.each(postProcesses, function(file, callback) {
                database.postProcess(db, file, schema_name, release, function(response) {
                    if (response === 'processed') {
                    callback();
                    }
                });
            }, function(err) {
                if( err ) {
                    logger.log('error', err);
                } else {
                    logger.log('info', 'Finished post processing database tables');
                    callback(null, response);
                }
            });
        },  

    ], function(err, result) {
        var end = new Date() - start;
        logger.log('info', 'Finished processing in ', prettyMs(end));
    });
}

translateData();


