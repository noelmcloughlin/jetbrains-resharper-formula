# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import resharper with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

resharper-package-archive-install:
              {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
              {%- else %}
  pkg.installed:
              {%- endif %}
    - names: {{ resharper.pkg.deps|json }}
    - require_in:
      - file: resharper-package-archive-install

              {%- if resharper.flavour|lower == 'windowsweb' %}

  file.managed:
    - name: {{ resharper.dir.tmp }}/resharper.exe
    - source: {{ resharper.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ resharper.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ resharper.dir.tmp }}/resharper.exe
    - require:
      - file: resharper-package-archive-install

              {%- else %}

  file.directory:
    - name: {{ resharper.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: resharper-package-archive-install
                 {%- if grains.os != 'Windows' %}
    - user: {{ resharper.identity.rootuser }}
    - group: {{ resharper.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
                 {%- endif %}
  archive.extracted:
    {{- format_kwargs(resharper.pkg.archive) }}
    - retry: {{ resharper.retry_option|json }}
                 {%- if grains.os != 'Windows' %}
    - user: {{ resharper.identity.rootuser }}
    - group: {{ resharper.identity.rootgroup }}
    - recurse:
        - user
        - group
                 {%- endif %}
    - require:
      - file: resharper-package-archive-install

              {%- endif %}
              {%- if grains.kernel|lower == 'linux' and resharper.linux.altpriority|int == 0 %}

resharper-archive-install-file-symlink-resharper:
  file.symlink:
    - name: /usr/local/bin/{{ resharper.command }}
    - target: {{ resharper.dir.path }}/{{ resharper.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windowsWeb' }}
    - require:
      - archive: resharper-package-archive-install

              {%- elif resharper.flavour|lower == 'windowszip' %}

resharper-archive-install-file-shortcut-resharper:
  file.shortcut:
    - name: C:\Users\{{ resharper.identity.rootuser }}\Desktop\{{ resharper.dirname }}.lnk
    - target: {{ resharper.dir.archive }}\{{ resharper.dirname }}\{{ resharper.command }}
    - working_dir: {{ resharper.dir.archive }}\{{ resharper.dirname }}\bin
    - icon_location: {{ resharper.dir.archive }}\{{ resharper.dirname }}\bin\resharper.ico
    - makedirs: True
    - force: True
    - user: {{ resharper.identity.rootuser }}
    - require:
      - archive: resharper-package-archive-install

              {%- endif %}
