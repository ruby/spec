require_relative '../../spec_helper'
require_relative 'shared/local'
require_relative 'shared/time_params'
require_relative 'shared/tz'

describe "Time.mktime" do
  it_behaves_like :time_local, :mktime
  it_behaves_like :time_local_10_arg, :mktime
  it_behaves_like :time_params, :mktime
  it_behaves_like :time_params_10_arg, :mktime
  it_behaves_like :time_params_microseconds, :mktime
  it_behaves_like :time_tz, :mktime, -> { Time.mktime(2000, "jan", 1, 20, 15, 1) }
end
