# frozen_string_literal: true

objs = Array.new(2) { "abc" }
p objs.first.object_id == objs.last.object_id
