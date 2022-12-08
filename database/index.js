'use strict';
import async from 'async';
import promise from 'bluebird';
import path from 'path';
import appRoot from 'app-root-path';
const options = {
    promiseLib: promise,
    error: function (error, e) {
    },
    noWarnings: true
};
import pgPromise from 'pg-promise';
const QueryFile = pgPromise.QueryFile;
const pgp = pgPromise(options);
import logger from "./../logger/index.js" 
import configFile from "./../config/index.js";

let database = {}

function createSQL(sqlPath, schema_name) {
    // const fullPath = path.join(__dirname, file); // generating full path;
    const options = {
        minify: true,
        params: {
            schema: schema_name
        }
    };
    const qf = new QueryFile(sqlPath, options);
    if (qf.error) {
        console.error(qf.error);
    }
    return qf;
}

function postSQL(file, schema_name, release) {
    const options = {
        minify: true,
        params: {
            schema: schema_name,
            release, release
        }
    };
    const qf = new QueryFile(file, options);
    if (qf.error) {
        console.error(qf.error);
    }
    return qf;
}

database.createTable = function (update_product, callback) {
    const schema_name = configFile[update_product].schema_name
    let sqlPath = `${appRoot}/database/sql/${update_product}_CreateTables.sql`
  const create_table = createSQL(sqlPath, schema_name);
  logger.log('info', 'Starting to create database tables');
  const db = pgp(configFile.database_connection);
  db.any(create_table)
    .then(result=> {
        logger.log('info', 'Finished creating database tables');
        callback('created')
    })
    .catch(error=> {
        logger.log('error', 'Error when creating database tables', error.message);
        callback(error.message);
    })
    .finally(function () {
        pgp.end();
      });
};

database.postProcess = function (file, callback) {
    const schema_name = configFile[configFile.update_product].schema_name
    let sqlPath = `${appRoot}/database/sql/${file}`
    const post_process = postSQL(sqlPath, schema_name, configFile.release);
    const db = pgp(configFile.database_connection);
  db.any(post_process)
    .then(result=> {
      callback("processed");
    })
    .catch(error=> {
      logger.log('error', 'Error during post processing', error.message);
      callback(error.message);
    })
    .finally(function () {
      pgp.end();
    });
};
export default database