require "../../ast"

module Myst
  class TFunctor < Value
    struct ParameterSet
      alias ParamT = AST::FunctionParameter
      property  left  : Array(ParamT)
      property  splat : ParamT?
      property  right : Array(ParamT)

      def initialize(@left = [] of ParamT, @splat = nil, @right = [] of ParamT); end
    end

    struct Clause
      property  parameters  : ParameterSet
      property  arity       : Int32
      property  body        : AST::Block
      property  parent      : Scope

      def initialize(params, @body, @parent)
        @parameters = chunk_parameters(params)
        @arity = params.size
      end

      # Return a 3-tuple representing the positional parameters for this
      # clause, split by the splat parameter. If there is no splat, all
      # parameters will end up in `left`.
      private def chunk_parameters(params)
        left  = [] of AST::FunctionParameter
        splat = nil
        right = [] of AST::FunctionParameter

        past_splat = false
        params.each do |param|
          if param.splat?
            if past_splat
              raise "Multiple splat collectors in function definition"
            else
              splat = param
              past_splat = true
            end
          elsif past_splat
            right.unshift(param)
          else
            left.push(param)
          end
        end

        return ParameterSet.new(left: left, splat: splat, right: right)
      end

      # This method allows functors to act as if they are `AST::Node`s.
      def accept(visitor)
        @body.accept(visitor)
      end

    end


    property name       : String
    property clauses    : Array(Clause)
    property parent     : Scope

    def self.type_name; "Functor"; end
    def type_name; self.class.type_name; end

    def initialize(definition : AST::FunctionDefinition, @parent : Scope)
      @name       = definition.name
      @clauses    = [] of Clause
      add_clause(definition)
    end

    def add_clause(definition : AST::FunctionDefinition)
      clauses << Clause.new(definition.parameters, definition.body, @parent)
    end


    def ==(other : TFunctor)
      false
    end

    def !=(other : TFunctor)
      true
    end

    def hash
      name.hash + clauses.hash
    end
  end
end
