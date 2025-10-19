{{/*
Expand the name of the chart.
*/}}
{{- define "kafka-sandy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kafka-sandy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kafka-sandy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kafka-sandy.labels" -}}
helm.sh/chart: {{ include "kafka-sandy.chart" . }}
{{ include "kafka-sandy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kafka-sandy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kafka-sandy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kafka-sandy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "kafka-sandy.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "kafka.controllerQuorumVoters" -}}
{{- $voters := list }}
{{- range $i, $e := until (.Values.replicaCount | int) }}
  {{- $voters = append $voters (printf "%d@kafka-%d.kafka-svc.%s.svc.cluster.local:%d" $i $i $.Values.namespace (int $.Values.controllerPort)) }}
{{- end }}
{{- join "," $voters }}
{{- end }}

{{- define "kafka.bootstrapServers" -}}
{{- $servers := list }}
{{- range $i, $e := until (.Values.replicaCount | int) }}
  {{- $servers = append $servers (printf "kafka-%d.kafka-svc.%s.svc.cluster.local:%d" $i $.Values.namespace (int $.Values.kafkaPort)) }}
{{- end }}
{{- join "," $servers }}
{{- end }}

