# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}

include:
  - .archive.clean

resharper-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if resharper.config_file and resharper.config %}
      - {{ resharper.config_file }}
               {%- endif %}
               {%- if resharper.environ_file %}
      - {{ resharper.environ_file }}
               {%- endif %}
    - require:
      - sls: .archive.clean
