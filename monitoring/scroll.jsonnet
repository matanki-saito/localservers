local kp = (import 'kube-prometheus/main.libsonnet') + {
  values+:: {
    common+: {
      namespace: 'monitoring',
    },
    prometheus+:: {
      namespaces+: ['ente-pubblico-per-il-benessere-sociale'],
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
  },

};

{ ['00namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{ ['0prometheus-operator-' + name]: kp.prometheusOperator[name] for name in std.objectFields(kp.prometheusOperator) } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) } +
{ ['micrometer-application-' + name]: kp.micrometerApplication[name] for name in std.objectFields(kp.micrometerApplication) }
