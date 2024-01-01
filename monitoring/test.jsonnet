local env = {
    grafana:{
        admin: {
            name: 'gnagaoka',
            pass: 'abc',
        },
        alert: {
            discordwebhook: 'xxxxxxxx'
        },
        database: {
            host: 'mysql',
            db: 'dbname',
            user: 'name',
            password: 'pass',
        }
    },
};

local printer = (import 'printer.libsonnet');

printer(env) {}
