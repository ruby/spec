require_relative '../../spec_helper'
require_relative 'shared/now'
require_relative 'shared/tz'

describe "Time.now" do
  it_behaves_like :time_now, :now
  it_behaves_like :time_tz, :now, -> { Time.now }
end
