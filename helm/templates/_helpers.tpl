{{- define "ui.labels" -}}
app: hello-world
env: {{ .Values.app.env  }}
{{- end -}}