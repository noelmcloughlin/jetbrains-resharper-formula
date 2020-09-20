# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_clean = tplroot ~ '.archive.clean' %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}

include:
  - {{ sls_package_clean }}

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
               {%- if grains.kernel|lower == 'linux' %}
      - {{ resharper.shortcut.file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ resharper.dir.homes }}/{{ resharper.identity.user }}/Desktop/{{ resharper.pkg.name }}*{{ resharper.edition }}*
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
