# Avoids warnings on Ruby 3.3
module ProcSpecs
  module SyntaxTree
    def self.lambda_it
      -> { it }
    end
    LAMBDA_IT_LINE = __LINE__ - 2

    def self.proc_it
      proc { it }
    end
    PROC_IT_LINE = __LINE__ - 2
  end
end
