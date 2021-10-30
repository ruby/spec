# shareable_constant_value: literal

A = [1, 2]
H = {a: "a"}

Ractor.new do
  A
  H
end.take
