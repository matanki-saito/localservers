local kp = 
  (import 'kube-prometheus/main.libsonnet') + {
  values+:: {
    common+: {
      namespace: 'monitoring',
    },
    grafana+:: {
      rawDashboards+:: {
        'node-exporter.json': (importstr 'grafana-dashboard/node-exporter_1860_rev33.json'),
        'process-exporter.json': (importstr 'grafana-dashboard/process-exporter-13882_rev9.json'),
      },
      plugins:: ['marcusolsson-treemap-panel'],
      env: [
        {
          name: "GF_SECURITY_ADMIN_USER",
          valueFrom: {
            secretKeyRef: {
              name: "grafana-env-secret",
              key: "GF_SECURITY_ADMIN_USER",
            },
          },
        },
        {
          name: "GF_SECURITY_ADMIN_PASSWORD",
          valueFrom: {
            secretKeyRef: {
              name: "grafana-env-secret",
              key: "GF_SECURITY_ADMIN_PASSWORD",
            },
          },
        },
      ],
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

{ 'setup/0namespace-namespace': kp.kubePrometheus.namespace } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor' && name != 'prometheusRule'), std.objectFields(kp.prometheusOperator))
} +
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ 'prometheus-operator-prometheusRule': kp.prometheusOperator.prometheusRule } +
{ 'kube-prometheus-prometheusRule': kp.kubePrometheus.prometheusRule } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['blackbox-exporter-' + name]: kp.blackboxExporter[name] for name in std.objectFields(kp.blackboxExporter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['kubernetes-' + name]: kp.kubernetesControlPlane[name] for name in std.objectFields(kp.kubernetesControlPlane) }
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['micrometer-application-' + name]: kp.micrometerApplication[name] for name in std.objectFields(kp.micrometerApplication) } +
{ ['process-exporter-' + name]: kp.processExporter[name] for name in std.objectFields(kp.processExporter) } +
{ ['apache-exporter-' + name]: kp.apacheExporter[name] for name in std.objectFields(kp.apacheExporter) }
