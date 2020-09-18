# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if 'config' in resharper and resharper.config and resharper.config_file %}
        {%- if grains.os != 'Windows' %}

include:
  - .archive

resharper-config-file-managed-config_file:
  file.managed:
    - name: {{ resharper.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='resharper-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ resharper.identity.rootuser }}
    - group: {{ resharper.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ resharper.config|json }}
    - require:
      - sls: .archive

        {%- endif %}
    {%- endif %}
