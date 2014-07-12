name 'kibana'
description 'The role for kibana'

run_list(
  'recipe[kibana::default]'
)

default_attributes(
  'kibana' => {
    'webserver_listen' => '0.0.0.0',
    'webserver' => 'nginx',
    'install_type' => 'file',
    'file' => {
      'type' => 'zip',
      'url' => 'https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.zip',
      'checksum' => '12fd7ed0b1b7857dc0777946daf6858c99099713493f184aeabc6704e23f2916'
    },
    'config' => {
      'panel_names' => [
        'histogram', 'map', 'pie', 'table', 'filtering', 'timepicker', 'text', 'fields',
        'hits', 'dashcontrol','column', 'derivequeries', 'trends', 'bettermap', 'query', 'terms',
        'stats', 'goal', 'sparklines'
      ]
    }
  }
)
