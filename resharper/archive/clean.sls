# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}

resharper-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ resharper.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ resharper.dir.path }}/{{ resharper.pkg.name }}*{{ resharper.edition }}*.app
                  {%- else %}
      - {{ resharper.dir.path }}
                  {%- endif %}
