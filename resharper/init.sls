{% from "resharper/map.jinja" import resharper with context %}

# Cleanup first
resharper-remove-prev-archive:
  file.absent:
    - name: '{{ resharper.tmpdir }}
    - require_in:
      - resharper-install-dir

resharper-install-dir:
  file.directory:
    - names:
      - '{{ resharper.jetbrains.realhome }}'
      - '{{ resharper.tmpdir }}'
    - makedirs: True
    - require_in:
      - resharper-download-archive

resharper-download-archive:
  cmd.run:
    - name: curl {{ resharper.dl.opts }} -o '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}' {{ resharper.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ resharper.dl.retries }}
        interval: {{ resharper.dl.interval }}
      {% endif %}

{%- if resharper.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / non-Unix
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('Windows') %}
resharper-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}'
     - file_hash: {{ resharper.dl.src_hashsum }}
     - onchanges:
       - cmd: resharper-download-archive
     - require_in:
       - archive: resharper-package-install
  {%- endif %}
{%- endif %}

resharper-package-install:
{% if grains.os == 'Windows' %}
  winpkg.installed:
    - installer: '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}'
    - onchanges:
      - cmd: resharper-download-archive
    - require_in:
      - resharper-remove-archive

resharper-remove-archive:
  file.absent:
    - name: '{{ resharper.tmpdir }}
    - onchanges:
      - winpkg: resharper-package-install

