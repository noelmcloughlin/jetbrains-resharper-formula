{% from "resharper/map.jinja" import resharper with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add pyCharmhome to alternatives system
resharper-home-alt-install:
  alternatives.install:
    - name: resharperhome
    - link: {{ resharper.symhome }}
    - path: {{ resharper.alt.realhome }}
    - priority: {{ resharper.alt.priority }}

resharper-home-alt-set:
  alternatives.set:
    - name: resharperhome
    - path: {{ resharper.alt.realhome }}
    - onchanges:
      - alternatives: resharper-home-alt-install

# Add to alternatives system
resharper-alt-install:
  alternatives.install:
    - name: resharper
    - link: {{ resharper.symlink }}
    - path: {{ resharper.alt.realcmd }}
    - priority: {{ resharper.alt.priority }}
    - require:
      - alternatives: resharper-home-alt-install
      - alternatives: resharper-home-alt-set

resharper-alt-set:
  alternatives.set:
    - name: resharper
    - path: {{ resharper.alt.realcmd }}
    - onchanges:
      - alternatives: resharper-alt-install

  {% endif %}

{% endif %}
