# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "etcd/map.jinja" import etcd with context %}

   {%- if etcd.docker.stop_local_etcd_service_first %}
include:
  - etcd.service.stopped
   {% endif %}

{%- if etcd.docker.packages %}
  {%- for pkg in etcd.docker.packages %}

etcd-docker-{{ pkg }}-package:
  pkg.installed:
    - name:  {{ pkg }}
    - require_in:
      - docker_container: run-etcd-dockerized-service
    - onfail_in:
      - pip: etcd-docker-python-modules-install

  {% endfor %}
{% endif %}

etcd-docker-python-modules-install:
  pip.installed:
    - names:
      - docker
    {%- if grains.os_family == 'RedHat' %}
       {# https://github.com/saltstack-formulas/etcd-formula/issues/19  #}
      - requests {{ etcd.docker.pip_requests_version_wanted }}
    {%- endif %}
    - reload_modules: True
    - exists_action: i
    - force_reinstall: False
    - require_in:
      - docker_container: run-etcd-dockerized-service

etcd-ensure-docker-service:
  service.running:
    - name: docker
    - require_in:
      - docker_container: run-etcd-dockerized-service

run-etcd-dockerized-service:
  docker_container.running:
    - name: {{ etcd.docker.container_name }}
    - skip_translate: {{ etcd.docker.skip_translate }}
    - image: {{ etcd.docker.image }}:{{ etcd.docker.version }}
    - restart_policy: always
    - network_mode: host
    - command: {{ etcd.docker.cmd }}
        {%- if "environment" in etcd.docker %}
    - environment:
          {%- for k,v in etcd.docker.environment %}
      - {{ k|upper }}: {{ v }}
          {% endfor %}
        {%- endif %}
        {%- if "volumes" in etcd.docker %}
    - binds:
          {% for volume in etcd.docker.volumes %}
      - {{ volume }}
          {% endfor %}
        {%- endif %}
    - ports:
        {% for port in etcd.docker.ports %}
      - {{ port }}
        {% endfor %}
    - port_bindings:
        {% for porty in etcd.docker.port_bindings %}
      - {{ porty }}
        {% endfor %}
