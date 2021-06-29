require_relative '../../../spec_helper'
require_relative '../../../shared/queue/enque'
require_relative '../../../shared/sizedqueue/enque'

describe "SizedQueue#push" do
  it_behaves_like :queue_enq, :push, -> { Thread::SizedQueue.new(10) }
end

describe "SizedQueue#push" do
  it_behaves_like :sizedqueue_enq, :push, -> n { Thread::SizedQueue.new(n) }
end
