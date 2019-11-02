class ClassChecker
  def self.check_classes(this_class, super_class)
    this_class.should be_kind_of(Class)
    this_class.superclass.should == super_class
  end
end