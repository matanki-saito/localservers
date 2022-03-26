local kp = (import 'kube-prometheus/main.libsonnet') + {
  values+:: {
    common+: {
      namespace: 'monitoring',
    },
    prometheus+:: {
      namespaces+: ['ente-pubblico-per-il-benessere-sociale'],
    },
  },
  processExporter: {
    myhome: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'process-exporter-servicemonitor',
        namespace: 'monitoring',
      },
      spec: {
        jobLabel: 'app',
        endpoints: [
          {
            targetPort: 9256,
            path: '/metrics',
          },
        ],
        selector: {
          matchLabels: {
            'app': 'process-exporter-app',
          },
        },
      },
    },
  },
  apacheExporter: {
    ck2wiki: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'ck2-wiki-apache-exporter-servicemonitor',
        namespace: 'monitoring',
      },
      spec: {
        jobLabel: 'app',
        endpoints: [
          {
            targetPort: 9117,
            path: '/metrics',
          },
        ],
        selector: {
          matchLabels: {
            'app': 'ck2-wiki-apache-exporter-app',
          },
        },
      },
    },
    eu4wiki: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'eu4-wiki-apache-exporter-servicemonitor',
        namespace: 'monitoring',
      },
      spec: {
        jobLabel: 'app',
        endpoints: [
          {
            targetPort: 9117,
            path: '/metrics',
          },
        ],
        selector: {
          matchLabels: {
            'app': 'eu4-wiki-apache-exporter-app',
          },
        },
      },
    },
  },
  micrometerApplication: {
    serviceMonitorHenrietta: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'henrietta-servicemonitor',
        namespace: 'ente-pubblico-per-il-benessere-sociale',
      },
      spec: {
        jobLabel: 'app',
        endpoints: [
          {
            targetPort: 80,
            path: '/actuator/prometheus',
          },
        ],
        selector: {
          matchLabels: {
            'app': 'henrietta-app',
          },
        },
      },
    },
    serviceMonitorTriela: {
      apiVersion: 'monitoring.coreos.com/v1',
      kind: 'ServiceMonitor',
      metadata: {
        name: 'triela-servicemonitor',
        namespace: 'ente-pubblico-per-il-benessere-sociale',
      },
      spec: {
        jobLabel: 'app',
        endpoints: [
          {
            targetPort: 80,
            path: '/actuator/prometheus',
          },
        ],
        selector: {
          matchLabels: {
            'app': 'triela-app',
          },
        },
      },
    },
  },

};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['micrometer-application-' + name]: kp.micrometerApplication[name] for name in std.objectFields(kp.micrometerApplication) } +
{ ['process-exporter-' + name]: kp.processExporter[name] for name in std.objectFields(kp.processExporter) } +
{ ['apache-exporter-' + name]: kp.apacheExporter[name] for name in std.objectFields(kp.apacheExporter) }
