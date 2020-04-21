# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

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
        path: {{ resharper.pkg.archive.path }}/bin
        environ: {{ resharper.environ|json }}
    - require:
      - sls: .archive
