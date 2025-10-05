{{/*
Expand the name of the chart.
*/}}
{{- define "healthcare-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "healthcare-app.fullname" -}}
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
{{- define "healthcare-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "healthcare-app.labels" -}}
helm.sh/chart: {{ include "healthcare-app.chart" . }}
{{ include "healthcare-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "healthcare-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "healthcare-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Patient Service labels
*/}}
{{- define "patient-service.labels" -}}
{{ include "healthcare-app.labels" . }}
app.kubernetes.io/component: patient-service
{{- end }}

{{/*
Appointment Service labels
*/}}
{{- define "appointment-service.labels" -}}
{{ include "healthcare-app.labels" . }}
app.kubernetes.io/component: appointment-service
{{- end }}

{{/*
Patient Service selector labels
*/}}
{{- define "patient-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "healthcare-app.name" . }}-patient
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Appointment Service selector labels
*/}}
{{- define "appointment-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "healthcare-app.name" . }}-appointment
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Get patient service image
*/}}
{{- define "patient-service.image" -}}
{{- if .Values.global.imageRegistry }}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .Values.patientService.image.repository (default .Values.global.tag .Values.patientService.image.tag) }}
{{- else }}
{{- printf "%s:%s" .Values.patientService.image.repository (default .Values.global.tag .Values.patientService.image.tag) }}
{{- end }}
{{- end }}

{{/*
Get appointment service image
*/}}
{{- define "appointment-service.image" -}}
{{- if .Values.global.imageRegistry }}
{{- printf "%s/%s:%s" .Values.global.imageRegistry .Values.appointmentService.image.repository (default .Values.global.tag .Values.appointmentService.image.tag) }}
{{- else }}
{{- printf "%s:%s" .Values.appointmentService.image.repository (default .Values.global.tag .Values.appointmentService.image.tag) }}
{{- end }}
{{- end }}