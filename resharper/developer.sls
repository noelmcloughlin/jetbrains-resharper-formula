{% from "resharper/map.jinja" import resharper with context %}

{% if resharper.prefs.user not in (None, 'undefined_user') %}

  {% if grains.os == 'MacOS' %}
resharper-desktop-shortcut-clean:
  file.absent:
    - name: '{{ resharper.homes }}/{{ resharper.prefs.user }}/Desktop/ReSharper'
    - require_in:
      - file: resharper-desktop-shortcut-add
  {% endif %}

resharper-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://resharper/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ resharper.prefs.user }}
      homes: {{ resharper.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ resharper.jetbrains.edition }}
    - runas: {{ resharper.prefs.user }}
    - require:
      - file: resharper-desktop-shortcut-add
   {% else %}
  file.managed:
    - source: salt://resharper/files/resharper.desktop
    - name: {{ resharper.homes }}/{{ resharper.prefs.user }}/Desktop/resharper.desktop
    - user: {{ resharper.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ resharper.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ resharper.symhome }}/{{ resharper.command }}
    - context:
      home: {{ resharper.symhome }}
      command: {{ resharper.command }}
   {% endif %}


  {% if resharper.prefs.importurl or resharper.prefs.importdir %}

resharper-prefs-importfile:
   {% if resharper.prefs.importdir %}
  file.managed:
    - onlyif: test -f {{ resharper.prefs.importdir }}/{{ resharper.prefs.myfile }}
    - name: {{ resharper.homes }}/{{ resharper.prefs.user }}/{{ resharper.prefs.myfile }}
    - source: {{ resharper.prefs.importdir }}/{{ resharper.prefs.myfile }}
    - user: {{ resharper.prefs.user }}
    - makedirs: True
        {% if salt['grains.get']('os_family') in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ resharper.prefs.user }}
        {% endif %}
    - if_missing: {{ resharper.homes }}/{{ resharper.prefs.user }}/{{ resharper.prefs.myfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{resharper.homes}}/{{resharper.prefs.user}}/{{resharper.prefs.myfile}} {{resharper.prefs.importurl}}
    - runas: {{ resharper.prefs.user }}
    - if_missing: {{ resharper.homes }}/{{ resharper.prefs.user }}/{{ resharper.prefs.myfile }}
   {% endif %}

  {% endif %}

{% endif %}

