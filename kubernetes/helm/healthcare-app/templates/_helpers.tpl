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