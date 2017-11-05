{% from "resharper/map.jinja" jar resharper with context %}

{% if resharper.prefs.user not in (None, 'undefined_user', 'undefined', '',) %}

    ## todo: Check desktop shortcut exists

  {% if resharper.prefs.jarurl or resharper.prefs.jardir %}

resharper-prefs-jarfile:
   {% if resharper.prefs.jardir %}
  file.managed:
    - onlyif: test -f {{ resharper.prefs.jardir }}\\{{ resharper.prefs.jarfile }}
    - name: {{ resharper.homes }}{{ resharper.prefs.user }}\\{{ resharper.prefs.jarfile }}
    - source: {{ resharper.prefs.jardir }}\\{{ resharper.prefs.jarfile }}
    - user: {{ resharper.prefs.user }}
    - makedirs: True
    - if_missing: {{ resharper.homes }}\\{{ resharper.prefs.user }}\\{{ resharper.prefs.jarfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{resharper.homes}}\\{{resharper.prefs.user}}\\{{resharper.prefs.jarfile}} {{resharper.prefs.jarurl}}
    - runas: {{ resharper.prefs.user }}
    - if_missing: {{ resharper.homes }}\\{{ resharper.prefs.user }}\\{{ resharper.prefs.jarfile }}
   {% endif %}

  {% endif %}

{% endif %}

