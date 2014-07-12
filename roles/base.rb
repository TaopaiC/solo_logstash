name 'base'
description 'The role for base'

run_list(
  'recipe[apt::default]'
)

default_attributes(
)
