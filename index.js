'use strict'
//NPM Modules
import async from 'async';
import appRoot from 'app-root-path';
import dayjs from 'dayjs';
import jsonfile from 'jsonfile';
import prettyMS from 'pretty-ms';
import fs from 'fs-extra';
import os from 'os';
import path from 'path';
import klaw from 'klaw'

//Custom Modules
import logger from "./logger/index.js";
import configFile from "./config/index.js";
import database from "./database/index.js";
import loader from "./loader/index.js";

//Globals
const todaysDate = dayjs().format('YYYY-MM-DD');
const startTime = dayjs();
const logFileFolder = `${appRoot}/logs`;
let logFile = {};

const run = () => {
    let files = [];
    async.series([
            /*
            Setup working folder stuff and copy from sourcePath
            */
           function (callback) {
                try {
                    fs.emptyDirSync(logFileFolder)
                    logger.log('info', `Processing ${configFile.update_product}`);
                    console.log(`Starting to process data on ${todaysDate} at ${startTime}`);
                    logger.log('info', `Starting to process data on ${todaysDate} at ${startTime}`);
                    //Add logfile metadata
                    logFile.startTime = startTime;
                    logFile.date = todaysDate;
                    logFile.arch = os.arch();
                    logFile.hostname = os.hostname();
                    logFile.platform = os.platform();
                    logFile.release = os.release();
                    logFile.username = os.userInfo().username;
                    logger.log('info', `Successful Setup for Product: ${configFile.update_product}`);
                    callback()
                } catch (error) {
                    logger.log('error', `Error during setup for product: ${configFile.update_product}`);
                    callback(error)
                }
            },
            /*
            Create database tables to load data into
            */
            function (callback) {
                logger.log('info', `Creating database tables for ${configFile.update_product}`);                            
                database.createTable(configFile.update_product, function (response) {
                    if (response === 'created') {
                        logger.log('info', `Created database tables for ${configFile.update_product}`);
                        callback()
                    } else {
                        logger.log('error', `Error creating database tables for ${configFile.update_product}`);
                        callback(`Error creating database tables for ${configFile.update_product}`)
                    }
                })
            },
            function(callback) {
                logger.log('info', 'Listing files in source directory');
                const sourceDir = configFile[configFile.update_product].source_path
                klaw(sourceDir)
                    .on('data', function (item) {
                        if(path.extname(item.path) === '.gz') {
                            files.push(item.path)
                        }
                    })
                    .on('error', (err, item) => {
                        console.log('klaw error: ', item);
                        throw new Error(`klawError: ${err}`);
                      })
                    .on('end', function () {
                        logger.log('info', `Found ${files.length} files`);
                        callback();
                    })
            },
            function(callback) {
                loader.loadPostGIS(files, function(response) {
                    if (response === 'loaded') {
                        logger.log('info', `Successfully loaded ${configFile.update_product} data`);
                        callback();
                    } else {
                        logger.log('error', `Error loading ${configFile.update_product} data`);
                        callback(`Error loading ${configFile.update_product} data`)
                    }
                });
            }, 
            function(callback) {
                logger.log('info', 'Post processing database tables');
                async.each(configFile[configFile.update_product].post_processes, function(file, callback) {
                    console.log(file)
                    database.postProcess(file, function(response) {
                        if (response === 'processed') {
                            logger.log('info', `Successfully post processed ${configFile.update_product} data`);
                            callback();
                        } else {
                            logger.log('error', `Error post processing ${configFile.update_product} data`);
                            callback(`Error post processing ${configFile.update_product} data`)
                        }
                    });
                }, function(err) {
                    if( err ) {
                        logger.log('error', err);
                    } else {
                        logger.log('info', 'Finished post processing database tables');
                        callback();
                    }
                });
            }
    ], // Series finish
        function (error, results) {
            if (error) {
                console.error(error)
                logger.log('error', error);
                const endTime = dayjs();
                const timeTaken = endTime - startTime;
                console.log(`Finished processing  data on ${todaysDate} at ${endTime} in ${prettyMS(timeTaken, {verbose: true})}`);
            } else {
                const endTime = dayjs();
                logFile.endTime = endTime
                const timeTaken = endTime - startTime;
                logFile.timeTaken = prettyMS(timeTaken, {
                    verbose: true
                })
                const logFilePath = `${logFileFolder}/OSDT_${todaysDate}.json`
                jsonfile.writeFile(logFilePath, logFile, {
                    spaces: 2
                }, function (error) {
                    if (error) {
                        console.error(error)
                    }
                    console.log(`Finished processing data on ${todaysDate} at ${endTime} in ${prettyMS(timeTaken, {verbose: true})}`);
                    logger.log('info', `Finished processing data on ${todaysDate} at ${endTime} in ${prettyMS(timeTaken, {verbose: true})}`);
                })
            }
        });
}
run();