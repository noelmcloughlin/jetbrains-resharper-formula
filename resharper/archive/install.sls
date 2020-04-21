# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

resharper-package-archive-install:
  pkg.installed:
    - names: {{ resharper.pkg.deps|json }}
    - require_in:
      - file: resharper-package-archive-install
  file.directory:
    - name: {{ resharper.pkg.archive.path }}
    - user: {{ resharper.identity.rootuser }}
    - group: {{ resharper.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: resharper-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(resharper.pkg.archive) }}
    - retry: {{ resharper.retry_option|json }}
    - user: {{ resharper.identity.rootuser }}
    - group: {{ resharper.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: resharper-package-archive-install
