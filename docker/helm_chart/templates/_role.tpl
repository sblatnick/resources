{{/*
Common Functionality Template
*/}}

{{ define "my.pod" }}
{{- $role := (index .Values.roles .role) }}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .role }}
  namespace: {{ .Release.Namespace }}
  labels:
    app.kubernetes.io/name: {{ .role }}
    helm.sh/chart: {{ replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
spec:
  serviceName: "{{ $.role }}"
  replicas: {{ $role.replicas }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ .role }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ .role }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      hostAliases:
      - ip: "127.0.0.1"
        hostnames:
        - "{{ .role }}.{{ .Release.Namespace }}.{{ .Values.my.domain }}"
      initContainers:
        - name: init
          image: "{{ .Values.my.image }}:{{ .Release.Namespace }}-{{ .Values.my.version.current }}"
  {{- if hasKey .Values "containers" }}
    {{- toYaml .Values.containers | nindent 10 }}
  {{- end }}
          imagePullPolicy: Always
          command: ["bash", "-c", {{ $role.init | quote }}]
  {{- if hasKey .Values.persistence "volumes" }}
          volumeMounts:
    {{- range $name, $volume := .Values.persistence.volumes }}
            - name: {{ $name }}
              mountPath: {{ $volume.path }}-volume
    {{- end }}
  {{- end }}
          securityContext:
            runAsUser: 0 #root
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.my.image }}:{{ .Release.Namespace }}-{{ .Values.my.version.current }}"
  {{- if hasKey .Values "containers" }}
    {{- toYaml .Values.containers | nindent 10 }}
  {{- end }}
          imagePullPolicy: Always
          command: ["bash", "-c", {{ $role.startup | quote }}]
          ports:
  {{- range $name, $port := $role.ports }}
            - name: {{ $name }}
              containerPort: {{ $port.port }}
              protocol: TCP
  {{- end }}
  {{- if hasKey $role "probes" }}
    {{- toYaml $role.probes | nindent 10 }}
  {{- end }}
  {{- if hasKey .Values.persistence "volumes" }}
          volumeMounts:
    {{- range $name, $volume := .Values.persistence.volumes }}
            - name: {{ $name }}
              mountPath: {{ $volume.path }}
    {{- end }}
  {{- end }}
          securityContext:
            runAsUser: 0 #root
      securityContext:
        runAsUser: {{ .Values.my.uid }}
        fsGroup: {{ .Values.my.gid }}
  {{- if hasKey .Values.persistence "volumes" }}
    {{- if not .Values.persistence.enabled }}
      volumes:
      {{- range $name, $volume := .Values.persistence.volumes }}
        - name: {{ $name }}
          emptyDir: {}
      {{- end }}
    {{- else }}
  volumeClaimTemplates:
      {{- range $name, $volume := .Values.persistence.volumes }}
    - metadata:
        name: {{ $name }}
        namespace: {{ $.Release.Namespace }}
      spec:
        accessModes: [ "ReadWriteOnce" ]
        storageClassName: {{ $.Values.persistence.storageClass }}
        resources:
          requests:
            storage: {{ $volume.size }}
      {{- end }}
    {{- end }}
  {{- end }}
{{ end }}