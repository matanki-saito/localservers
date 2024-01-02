local env = {
    grafana:{
        admin: {
            name: 'gnagaoka',
            pass: 'abc',
        },
        alert: {
            discordwebhook: 'xxxxxxxx'
        }
    },
    alertmanager: {
        webhook: 'xxxx'
    }
};

local printer = (import 'printer.libsonnet');

printer(env) {}
