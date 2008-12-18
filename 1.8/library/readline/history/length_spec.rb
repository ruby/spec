require File.dirname(__FILE__) + '/../../../spec_helper'

not_supported_on :ironruby do
  has_tty? do # needed for CI until we figure out a better way
  require 'readline'
  require File.dirname(__FILE__) + '/shared/size'

  describe "Readline::HISTORY.length" do
    it_behaves_like :readline_history_size, :length
  end
  end
end
