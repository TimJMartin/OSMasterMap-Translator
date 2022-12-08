'use strict'
import appRoot from 'app-root-path';
import {transports, createLogger, format} from 'winston';

// define the custom settings for each transport (file, console)
const options = {
    file: {
        level: 'info',
        filename: `${appRoot}/logs/app.log`,
        handleExceptions: true,
        json: true,
        maxsize: 52428800, // 50MB
        maxFiles: 5,
        colorize: false
    }
};

// instantiate a new Winston Logger with the settings defined above
const logger = createLogger({
    format: format.combine(
        format.timestamp({format:'DD-MM-YYYY HH:mm:ss'}),
        format.json()
    ),
    transports: [
        new transports.File(options.file),
        // new transports.Console(options.console)
    ],
    exitOnError: false,
});

logger.stream = {
    write: function(message, encoding) {
        logger.info(message);
    },
};
export default logger