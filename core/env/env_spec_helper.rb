# Reserve variables.
def reserve_variables(hash)
  hash.each_pair  do |name, value|
    fail "Environment variable name #{name} is already in use" if ENV.include?(name)
  end
  @reserved_names = hash.keys
  ENV.update(hash)
end

# Release reserved variables.
def release_variables
  @reserved_names.each do |name|
    ENV.delete(name)
  end
end

# Return mock object for calling #to_str.
def mock_to_str(s)
  mock_object = mock('name')
  mock_object.should_receive(:to_str).and_return(s.to_s)
  mock_object
end

require_relative '../../spec_helper'
