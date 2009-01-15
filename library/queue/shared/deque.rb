describe :queue_deq, :shared => true do
  it "removes an item from the Queue" do
    q = Queue.new
    q << Object.new
    q.size.should == 1
    q.send(@method)
    q.size.should == 0
  end

  it "should return items in the order they were added" do
    q = Queue.new
    q << 1
    q << 2
    q.send(@method).should == 1
    q.send(@method).should == 2
  end

  it "should block the thread until there are items in the queue" do
    q = Queue.new
    v = 0

    th = Thread.new do
      q.send(@method)
      v = 1
    end

    v.should == 0
    q << Object.new
    th.join
    v.should == 1
  end

  it "non-blocking wait should raise a ThreadError if Queue is empty" do
    q = Queue.new
    lambda { q.send(@method,true) }.should raise_error(ThreadError)
  end
end
