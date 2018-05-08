'use strict';
const async = require('async');
const promise = require('bluebird');
const options = {
    promiseLib: promise,
    error: function (error, e) {
    },
    noWarnings: true
};
const QueryFile = require('pg-promise').QueryFile;
const pgp = require('pg-promise')(options);
const path = require('path');
const logger = require('./../logger'); 

const database = module.exports = {};

function createSQL(file, schema_name) {
    const fullPath = path.join(__dirname, file); // generating full path;
    const options = {
        minify: true,
        params: {
            schema: schema_name
        }
    };
    const qf = new QueryFile(fullPath, options);
    if (qf.error) {
        console.error(qf.error);
    }
    return qf;
}


let post_process;

function postSQL(file, schema_name, release) {
    const fullPath = path.join(__dirname, file); // generating full path;
    const options = {
        minify: true,
        params: {
            schema: schema_name,
            release, release
        }
    };
    const qf = new QueryFile(fullPath, options);
    if (qf.error) {
        console.error(qf.error);
    }
    return qf;
}

function postSQL(file, schema_name, release, update_schema) {
    const fullPath = path.join(__dirname, file); // generating full path;
    const options = {
        minify: true,
        params: {
            schema: schema_name,
            release, release,
            update_schema: update_schema
        }
    };
    const qf = new QueryFile(fullPath, options);
    if (qf.error) {
        console.error(qf.error);
    }
    return qf;
}

database.createTable = function (database_connection, update_product, schema_name, callback) {
  var create_table = createSQL('sql/' + update_product + '_CreateTables.sql', schema_name);
  logger.log('info', 'Starting to create database tables');
  var db = pgp(database_connection);
  db.any(create_table)
    .then(result=> {
        logger.log('info', 'Finished creating database tables');
        callback(["created", db]);
    })
    .catch(error=> {
        logger.log('error', 'Error when creating database tables', error.message);
        callback(error.message);
    })
};

database.postProcess = function (db, file, schema_name, release, update_schema, callback) {
  var post_process = postSQL('sql/' + file, schema_name, release, update_schema);
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