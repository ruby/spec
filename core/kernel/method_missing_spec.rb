require File.dirname(__FILE__) + '/../../shared/kernel/method_missing'

describe "Kernel#method_missing" do
  it_behaves_like(:method_missing, :method_missing, Kernel)
end  

describe "Kernel#method_missing is undefined" do
  it_behaves_like(:method_missing_undef, :method_missing, Kernel)
end  

describe "Kernel.method_missing" do
  it_behaves_like(:method_missing_class_method, :method_missing, Kernel)
end  
