class MSpecScript
  # An ordered list of the directories containing specs to run
  set :files, [
    '1.8/language',
    '1.8/core',
    '1.8/library',
    '1.9'
  ]

  # The default implementation to run the specs.
  # TODO: this needs to be more sophisticated since the
  # executable is not consistently named.
  set :target, 'ruby19'
end
