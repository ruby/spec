class MSpecScript
  # An ordered list of the directories containing specs to run
  set :files, [
    'language',
    'core',
    'library',
    '^library/prime'
  ]

  # The default implementation to run the specs.
  set :target, 'ruby'
end
