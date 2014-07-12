name 'logstash'
description 'The role for logstash'

run_list(
  'recipe[java::default]',
  'recipe[my_logstash::server]'
)

default_attributes(
  'java' => {
    'install_flavor' => 'oracle',
    'jdk_version' => '7',
    'oracle' => {
      'accept_oracle_download_terms' => true
    }
  },
  'logstash' => {
    'instance' => {
      'server' => {
        'config_templates_cookbook' => 'my_logstash',
        'config_templates' => {
          'input_syslog' => 'config/input_syslog.conf.erb',
          'output_stdout' => 'config/output_stdout.conf.erb',
          'output_elasticsearch' => 'config/output_elasticsearch.conf.erb'
        },
        'config_templates_variables' => {
          'elasticsearch_embedded' => true
        },
        'pattern_templates' => {
          'default' => 'patterns/custom_patterns.erb'
        },
        'elasticsearch_ip' => '127.0.0.1',
        'enable_embedded_es' => true
      }
    }
  }
)
