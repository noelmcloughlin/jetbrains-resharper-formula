# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.kernel|lower in ('windows',) %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}

include:
  - .archive.clean
  - .config.clean

    {%- else %}

resharper-not-available-to-install:
  test.show_notification:
    - text: |
        The resharper package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
