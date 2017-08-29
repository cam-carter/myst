# Arguments in function calls are pattern matched to the parameters of each
# clause defined for a given functor. This implicitly means that functions
# support multiple definitions with the same name. Each definition gets added
# as a `clause` for the _functor_ (the object representing a function and it's
# definitions).
#
# A clause consists of a set of parameters used for matching and a definition
# body that is executed if the parameters are all matched. For each function
# call, all of the clauses in the corresponding functor will be attempted
# following the order in which they were defined. Once a match is found,
# searching stops and the matched clause is executed.
#
# With that, parameters are able to take any of 3 forms:
#   - just a name, exactly like parameters in Ruby.
#   - just a pattern, as shown in the `pattern_matching.mt` example.
#   - a pattern-matching assignment expression in the form `pattern =: name`.
#
# In the first form, any value given will be assigned to a variable with the
# given name.
#
# In the second form, the argument must match the given pattern, and any
# bindings within the pattern will be applied to the function scope. However,
# the full value of the argument will not be available.
#
# In the third form, the matching of the second form must pass, but the full
# value is also made available under the given name.

# Here, `fib` is defined three times. The first two definitions are base cases
# for the function with the patterns `0` and `1`, respectively, for the first
# argument. The third definition is the default case, accepting any argument
# under the name `n`.
def fib(0)  1 end
def fib(1)  1 end
def fib(n)
  # Nested calls to the same function are processed just the same as top-level
  # calls. They will attempt to match each clause in order, so this recursion
  # implicitly is able to handle the base cases of 0 and 1 with no explicit
  # conditional logic.
  fib(n-1) + fib(n-2)
end

# Definitions can also have different arities. In this case, passing no
# argument will simply return 0.
def fib
  0
end

# The first call here matches the first definition and immediately returns 1.
# The second follows suit with the second definition. The remaining calls all
# fallback to the third definition to calculate their result.
IO.puts(fib(0)) #=> 1
IO.puts(fib(1)) #=> 1
IO.puts(fib(2)) #=> 2
IO.puts(fib(5)) #=> 8
IO.puts(fib())  #=> 0


# Pattern matching in functions is exactly the same as pattern-matching
# assignment. That means all of the pattern matching assignment syntax
# will work as expected, even value interpolation!
value = 10
def match(<(value*2)> =: val)
  IO.puts("matched " + val.to_s())
end
def match(failed_match)
  IO.puts("failed to match " + failed_match.to_s())
end

match(20)   #=> matched 20
match(4)    #=> failed to match 4
value = 2
match(20)   #=> failed to match 20
match(4)    #=> matched 4
