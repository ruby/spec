require_relative '../../shared/rational/minus'
require_relative '../../shared/rational/arithmetic_exception_in_coerce'

describe "Rational#-" do
  it_behaves_like :rational_minus, :-
  it_behaves_like :rational_arithmetic_exception_in_coerce, :-
end

describe "Rational#- passed a Rational" do
  it_behaves_like :rational_minus_rat, :-
end

describe "Rational#- passed a Float" do
  it_behaves_like :rational_minus_float, :-
end

describe "Rational#- passed an Integer" do
  it_behaves_like :rational_minus_int, :-
end
