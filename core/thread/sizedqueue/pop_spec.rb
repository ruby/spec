require_relative '../../../spec_helper'
require_relative '../../../shared/queue/deque'

describe "SizedQueue#pop" do
  it_behaves_like :queue_deq, :pop, -> { Thread::SizedQueue.new(10) }
end
