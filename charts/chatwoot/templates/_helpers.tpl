{{/*
Expand the name of the chart.
*/}}
{{- define "chatwoot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "chatwoot.fullname" -}}
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
{{- define "chatwoot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "chatwoot.labels" -}}
helm.sh/chart: {{ include "chatwoot.chart" . }}
{{ include "chatwoot.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "chatwoot.selectorLabels" -}}
app.kubernetes.io/name: {{ include "chatwoot.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "chatwoot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "chatwoot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "rails.labels" }}
{{- include "chatwoot.labels" . }}
component: rails
name: {{ .Values.services.name}}
version: {{ .Values.image.tag }}
{{- end }}

{{- define "sidekiq.labels" }}
{{- include "chatwoot.labels" . }}
component: rails
name: sidekiq
{{- end }}

{{- define "migration-job.labels" }}
{{- include "chatwoot.labels" . }}
component: db-migration
name: db-migration
version: {{ .Values.image.tag}}
chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
release: "{{ .Release.Name }}"
{{- end }}
