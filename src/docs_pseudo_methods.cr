{% skip_file unless flag?(:docs) %}

# This file documents pseudo-methods that are implemented by the compiler
# and can't be redefined.
# For documentation purposes, they are declared as regular methods with
# their names prefixed by `__crystal_pseudo`. This prefix is removed by
# the docs generator making it appear as the pseudo-method.

# Returns the type of an expression.
#
# ```
# typeof(1) # => Int32
# ```
#
# It accepts multiple arguments, and the result is the union of the expression types:
#
# ```
# typeof(1, "a", 'a') # => (Int32 | String | Char)
# ```
#
# The expressions passed as arguments to `typeof` do not evaluate. The compiler
# only analyzes their return type.
#
# * See [`typeof`](https://crystal-lang.org/reference/syntax_and_semantics/typeof.html) in the language specification.
def __crystal_pseudo_typeof(*expression) : Class
end

# Returns the size of the given type as number of bytes.
#
# *type* must be a constant or `typeof()` expression. It cannot be evaluated
# at runtime.
#
# ```
# sizeof(Int32)        # => 4
# sizeof(Int64)        # => 8
# sizeof(typeof(true)) # => 1
# ```
#
# For `Reference` types, the size is the same as the size of a pointer:
#
# ```
# # On a 64 bits machine
# sizeof(Pointer(Int32)) # => 8
# sizeof(String)         # => 8
# ```
#
# This is because a `Reference`'s memory is allocated on the heap and a pointer
# to it is passed around. The size of a class on the heap can be determined
# using `#instance_sizeof`.
#
# * See [`sizeof`](https://crystal-lang.org/reference/syntax_and_semantics/sizeof.html) in the language specification.
def __crystal_pseudo_sizeof(type : Class) : Int32
end

# Returns the instance size of the given class as number of bytes.
#
# *type* must be a constant or `typeof()` expression. It cannot be evaluated at runtime.
#
# ```
# instance_sizeof(String)    # => 16
# instance_sizeof(Exception) # => 48
# ```
#
# See `sizeof` for determining the size of value types.
#
# * See [`instance_sizeof`](https://crystal-lang.org/reference/syntax_and_semantics/instance_sizeof.html) in the language specification.
def __crystal_pseudo_instance_sizeof(type : Class) : Int32
end

# Returns the alignment of the given type as number of bytes.
#
# *type* must be a constant or `typeof()` expression. It cannot be evaluated
# at runtime.
#
# ```
# alignof(Int32)        # => 4
# alignof(Float64)      # usually 4 or 8
# alignof(typeof(true)) # => 1
# ```
#
# For `Reference` types, the alignment is the same as the alignment of a pointer:
#
# ```
# # On a 64 bits machine
# alignof(Pointer(Int32)) # => 8
# alignof(String)         # => 8
# ```
#
# This is because a `Reference`'s memory is allocated on the heap and a pointer
# to it is passed around. The alignment of a class on the heap can be determined
# using `#instance_alignof`.
#
# * See [`alignof`](https://crystal-lang.org/reference/syntax_and_semantics/alignof.html) in the language specification.
def __crystal_pseudo_alignof(type : Class) : Int32
end

# Returns the instance alignment of the given class as number of bytes.
#
# *type* must be a constant or `typeof()` expression. It cannot be evaluated at runtime.
#
# ```
# instance_alignof(String)    # => 4
# instance_alignof(Exception) # => 8
# ```
#
# See `alignof` for determining the size of value types.
#
# * See [`instance_alignof`](https://crystal-lang.org/reference/syntax_and_semantics/instance_alignof.html) in the language specification.
def __crystal_pseudo_instance_alignof(type : Class) : Int32
end

# Returns a `Pointer` to the contents of a variable.
#
# *variable* must be a variable (local, instance, class or library).
#
# ```
# a = 1
# ptr = pointerof(a)
# ptr.value = 2
#
# a # => 2
# ```
#
# * See [`pointerof`](https://crystal-lang.org/reference/syntax_and_semantics/pointerof.html) in the language specification.
def __crystal_pseudo_pointerof(variable : T) : Pointer(T) forall T
end

# Returns the byte offset of an instance variable in a struct or class type.
#
# *type* must be a constant or `typeof()` expression. It cannot be evaluated at runtime.
# *offset*  must be the name of an instance variable of *type*, prefixed by `@`,
# or the index of an element in a Tuple, starting from 0, if *type* is a `Tuple`.
# ```
# offsetof(String, @bytesize)       # => 4
# offsetof(Exception, @message)     # => 8
# offsetof(Time, @location)         # => 16
# offsetof({Int32, Int8, Int32}, 0) # => 0
# offsetof({Int32, Int8, Int32}, 1) # => 4
# offsetof({Int32, Int8, Int32}, 2) # => 8
# ```
#
# * See [`offsetof`](https://crystal-lang.org/reference/syntax_and_semantics/offsetof.html) in the language specification.
def __crystal_pseudo_offsetof(type : Class, offset) : Int32
end

class Object
  # Returns the boolean negation of `self`.
  #
  # ```
  # !true  # => false
  # !false # => true
  # !nil   # => true
  # !1     # => false
  # !"foo" # => false
  # ```
  #
  # This method is a unary operator and usually written in prefix notation
  # (`!foo`) but it can also be written as a regular method call (`foo.!`).
  def __crystal_pseudo_! : Bool
  end

  # Returns `true` if `self` inherits or includes *type*.
  # *type* must be a constant or `typeof()`expression. It cannot be evaluated at runtime.
  #
  # ```
  # a = 1
  # a.class                 # => Int32
  # a.is_a?(Int32)          # => true
  # a.is_a?(String)         # => false
  # a.is_a?(Number)         # => true
  # a.is_a?(Int32 | String) # => true
  # ```
  #
  # * See [`is_a?`](https://crystal-lang.org/reference/syntax_and_semantics/is_a.html) in the language specification.
  def __crystal_pseudo_is_a?(type : Class) : Bool
  end

  # Returns `true` if `self` is `Nil`.
  #
  # ```
  # 1.nil?   # => false
  # nil.nil? # => true
  # ```
  #
  # This method is equivalent to `is_a?(Nil)`.
  #
  # * See [`nil?`](https://crystal-lang.org/reference/syntax_and_semantics/nil_question.html) in the language specification.
  def __crystal_pseudo_nil? : Bool
  end

  # Returns `self`.
  #
  # The type of this expression is restricted to *type* by the compiler.
  # *type* must be a constant or `typeof()` expression. It cannot be evaluated at runtime.
  #
  # If *type* is not a valid restriction for the expression type, it
  # is a compile-time error.
  # If *type*  is a valid restriction for the expression, but `self` can't
  # be restricted to *type*, it raises at runtime.
  # *type* may be a wider restriction than the expression type, the resulting
  # type is narrowed to the minimal restriction.
  #
  # ```
  # a = [1, "foo"][0]
  # typeof(a) # => Int32 | String
  #
  # typeof(a.as(Int32)) # => Int32
  # a.as(Int32)         # => 1
  #
  # typeof(a.as(Bool)) # Compile Error: can't cast (Int32 | String) to Bool
  #
  # typeof(a.as(String)) # => String
  # a.as(String)         # Runtime Error: Cast from Int32 to String failed
  #
  # typeof(a.as(Int32 | Bool)) # => Int32
  # a.as(Int32 | Bool)         # => 1
  # ```
  #
  # * See [`as`](https://crystal-lang.org/reference/syntax_and_semantics/as.html) in the language specification.
  def __crystal_pseudo_as(type : Class)
  end

  # Returns `self` or `nil` if can't be restricted to *type*.
  #
  # The type of this expression is restricted to *type* by the compiler.
  # If *type* is not a valid type restriction for the expression type, then
  # it is restricted to `Nil`.
  # *type* must be a constant or `typeof()` expression. It cannot be evaluated at runtime.
  #
  # ```
  # a = [1, "foo"][0]
  # typeof(a) # => Int32 | String
  #
  # typeof(a.as?(Int32)) # => Int32 | Nil
  # a.as?(Int32)         # => 1
  #
  # typeof(a.as?(Bool)) # => Bool | Nil
  # a.as?(Bool)         # => nil
  #
  # typeof(a.as?(String)) # => String | Nil
  # a.as?(String)         # nil
  #
  # typeof(a.as?(Int32 | Bool)) # => Int32 | Nil
  # a.as?(Int32 | Bool)         # => 1
  # ```
  #
  # * See [`#as?`](https://crystal-lang.org/reference/syntax_and_semantics/as_question.html) in the language specification.
  def __crystal_pseudo_as?(type : Class)
  end

  # Returns `true` if method *name* can be called on `self`.
  #
  # *name* must be a symbol literal, it cannot be evaluated at runtime.
  #
  # ```
  # a = 1
  # a.responds_to?(:abs)  # => true
  # a.responds_to?(:size) # => false
  # ```
  #
  # * See [`#responds_to?`](https://crystal-lang.org/reference/syntax_and_semantics/responds_to.html) in the language specification.
  def __crystal_pseudo_responds_to?(name : Symbol) : Bool
  end
end

# Some expressions won't return to the current scope and therefore have no return type.
# This is expressed as the special return type `NoReturn`.
#
# Typical examples for non-returning methods and keywords are `return`, `exit`, `raise`, `next`, and `break`.
#
# This is for example useful for deconstructing union types:
#
# ```
# string = STDIN.gets
# typeof(string)                        # => String?
# typeof(raise "Empty input")           # => NoReturn
# typeof(string || raise "Empty input") # => String
# ```
#
# The compiler recognizes that in case string is Nil, the right hand side of the expression `string || raise` will be evaluated.
# Since `typeof(raise "Empty input")` is `NoReturn` the execution would not return to the current scope in that case.
# That leaves only `String` as resulting type of the expression.
#
# Every expression whose code paths all result in `NoReturn` will be `NoReturn` as well.
# `NoReturn` does not show up in a union type because it would essentially be included in every expression's type.
# It is only used when an expression will never return to the current scope.
#
# `NoReturn` can be explicitly set as return type of a method or function definition but will usually be inferred by the compiler.
struct CRYSTAL_PSEUDO__NoReturn
end

# Similar in usage to `Nil`. `Void` is preferred for C lib bindings.
struct CRYSTAL_PSEUDO__Void
end
