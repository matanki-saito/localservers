local env = {
    grafana:{
        admin: {
            name: 'gnagaoka',
            pass: 'abc',
        },
    },
};

local printer = (import 'printer.libsonnet');

printer(env) {}
