{% from "resharper/map.jinja" import resharper with context %}

# Cleanup first
resharper-remove-prev-archive:
  file.absent:
    - name: '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}'
    - require_in:
      - resharper-install-dir

resharper-install-dir:
  file.directory:
    - names:
      - '{{ resharper.alt.realhome }}'
      - '{{ resharper.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows') %}
      - '{{ resharper.prefix }}'
      - '{{ resharper.symhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
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

{% if grains.os not in ('MacOS') %}
resharper-unpacked-dir:
  file.directory:
    - name: '{{ resharper.alt.realhome }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: resharper-download-archive
{% endif %}

{%- if resharper.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS') %}
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
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  archive.extracted:
    - source: 'file://{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}'
    - name: '{{ resharper.alt.realhome }}'
    - archive_format: {{ resharper.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ resharper.dl.unpack_opts }}
    - if_missing: '{{ resharper.alt.realcmd }}'
       {% else %}
    - options: {{ resharper.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if resharper.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ resharper.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: resharper-download-archive
    - require_in:
      - resharper-remove-archive

resharper-remove-archive:
  file.absent:
    - names:
      # todo: maybe just delete the tmpdir itself
      - '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}'
      - '{{ resharper.tmpdir }}/{{ resharper.dl.archive_name }}.sha256'
    - onchanges:
{%- if grains.os in ('Windows') %}
      - pkg: resharper-package-install
{%- elif grains.os in ('MacOS') %}
      - macpackage: resharper-package-install
{% else %}
      - archive: resharper-package-install

resharper-home-symlink:
  file.symlink:
    - name: '{{ resharper.symhome }}'
    - target: '{{ resharper.alt.realhome }}'
    - force: True
    - onchanges:
      - archive: resharper-package-install

# Update system profile with PATH
resharper-config:
  file.managed:
    - name: /etc/profile.d/resharper.sh
    - source: salt://resharper/files/resharper.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      resharper_home: '{{ resharper.symhome }}'

{% endif %}
