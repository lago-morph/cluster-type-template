apache2:
  pkg.installed: []
  service.running:
    - require:
      - pkg: apache2
      - webpage

webpage:
  file.managed:
    - name: /var/www/html/index.html
    - template: jinja
    - source: salt://webserver/index.html.jinja
    - require:
      - pkg: apache2
