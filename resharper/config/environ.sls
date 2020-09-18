# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if grains.os != 'Windows' %}

include:
  - .archive

resharper-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ resharper.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='resharper-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ resharper.identity.rootuser }}
    - group: {{ resharper.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      environ: {{ resharper.environ|json }}
                      {%- if resharper.pkg.use_upstream_macapp %}
      edition:  {{ '' if not resharper.edition else ' %sE'|format(resharper.edition) }}.app/Contents/MacOS
      appname: {{ resharper.dir.path }}/{{ resharper.pkg.name }}
                      {%- else %}
      edition: ''
      appname: {{ resharper.dir.path }}/bin
                      {%- endif %}
    - require:
      - sls: .archive

    {%- endif %}
