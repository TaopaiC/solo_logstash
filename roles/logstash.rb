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
      'default' => {
        'version' => '1.4.2',
        'source_url' => 'https://download.elasticsearch.org/logstash/logstash/logstash-1.4.2.tar.gz',
        'checksum' => 'd5be171af8d4ca966a0c731fc34f5deeee9d7631319e3660d1df99e43c5f8069',
        'install_type' => 'tarball',
        'plugins_version' => '1.4.2',
        'plugins_source_url' => 'https://download.elasticsearch.org/logstash/logstash/logstash-contrib-1.4.2.tar.gz',
        'plugins_checksum' => '7497ca3614ba9122159692cc6e60ffc968219047e88de97ecc47c2bf117ba4e5',
        'plugins_install_type' => 'tarball'
      },
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
