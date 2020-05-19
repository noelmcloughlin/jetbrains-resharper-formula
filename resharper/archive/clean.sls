# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}

resharper-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ resharper.pkg.archive.path }}
      - /usr/local/jetbrains/resharper-{{ resharper.edition }}-*
