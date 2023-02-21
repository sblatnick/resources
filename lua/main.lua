#!/usr/bin/lua

-- Source: https://www.lua.org/pil/contents.html

-- Arg capture: `lua -e "sin=math.sin" script a b`
  arg[-3] = "lua"
  arg[-2] = "-e"
  arg[-1] = "sin=math.sin"
  arg[0] = "script"
  arg[1] = "a"
  arg[2] = "b"

--Types
  type("example") --> string (always immutable)
  type(print)     --> function
  type(nil)       --> nil

  type(true)      --> boolean
  type(false)     --> boolean

  type(0)         --> number
  type(0.1)       --> number
  type(0.1e10)    --> number

  --Other types:
    --userdata = store arbitrary C data
    --threads = coroutines

  --Type Conversion
    --Automatic
      print("10" + 1)           --> 11
      print("10 + 1")           --> 10 + 1
      print("-5.3e-10"*"2")     --> -1.06e-09
      print("hello" + 1)        -- ERROR (cannot convert "hello")
      print(10 .. 20)           --> 1020
      print(10 .. "")           --> "10"
    --Explicit
      tostring(10)              --> "10"
      tonumber("10")            --> 10

      n = tonumber("bad")       --> nil
      if n == nil then
        error("invalid number")
      end

  --Boolean
    false --> false
    nil   --> false
    0     --> true
    ""    --> true

  --Strings
    a = "double quoted"
    b = 'double quoted'
    c = [[
      multi-line
      no templating built in, so variable interpolation can't be used
    ]]

    --[[
      Escaping
        \a  bell
        \b  back space
        \f  form feed
        \n  newline
        \r  carriage return
        \t  horizontal tab
        \v  vertical tab
        \\  backslash
        \"  double quote
        \'  single quote
        \[  left square bracket
        \]  right square bracket
    --]]

  --Comments
    --Comment
    --[[
      Comment block
    --]]

    ---[[ Comment with code toggled on
      print(0)
    --]]

--Tables (Objects/Associative Array/Map)
  --String keys:
    a = {}
    a["key"] = "value"
    a["key"] = nil     --> delete
    a.key = "value"    --shorthand for a["key"]
    a[key] = "value"   --uses key variable
  --Type matters:
    a[10] = "set"
    print(a["10"])     --> nil
  --First index is 1, not 0:
    days = {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
    days[1] --> Sunday
    --force 0 index:
    days = {[0]="Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
  --Initialize:
    a = {x=0, y=0,}                     --trailing comma optional
    {x=10, y=45; "one", "two", "three"} --semicolon for visibility of parts
    --same as:
    a = {["x"] = 0, ["y"] = 0}

  --Linked list (backwards):
    list = nil
    for line in io.lines() do
      list = {next=list, value=line}
    end
    l = list
    while l do
      print(l.value)
      l = l.next
    end
  --Nested:
    polyline = {
      color="blue", thickness=2, npoints=2,
      {x=0, y=0},
      {x=0, y=1}
    }

--Expressions
  --Arithmetic Operators
    + --> addition
    - --> subtraction/negation
    * --> multiply
    / --> division
    ^ --> binary operator for exponents
  --Concatenation
    ..
  --Relational Operators
    <
    >
    <=
    >=
    ==
    ~= --> not equal
    --Type matters:
      "10" ~= 10
      "12" < "2" --> true, because alphabetical
  --Logical Operators
    and
    or
    not
    --Default:
      x = x or v --> set to v when x is false/nil
      --same as:
      if not x then x = v end
    --Ternary:
      (a and b) or c --> same as C `a ? b : c` when b is not false
      max = (x > y) and x or y
  --Precedence
    ^
    not  - (unary)
    *   /
    +   -
    ..
    <   >   <=  >=  ~=  ==
    and
    or

--Variable scope:
  example1 = 10       --global
  local example2 = 10 --local, doesn't work in interactive shell unless within a block ("chunk")
  local x = x         --local fast access that isn't modifying the global variable
  local x             --> nil implicit
--Assignment:
  a = "example"
  --Multiple:
    a, b = 10, "b"
  --Swap:
    x, y = y, x
  --Surplus are nil:
    a, b, c = 0, 1
    a, b, c = 0 --> a = 0;b = nil;c = nil
  --Silent discard:
    a, b = 0, 1, 2
--Control Structure Blocks:
  --Scope block:
    do
      local x = x
      x = x + 1
      print(x)
    end

  --Conditional:
    if a<0 then
      a=-1
    elseif a>0 then
      a=1
    else
      a=0
    end

  --Goto
    goto label
    ::label::

  --Loops:
    --While:
      while true do
        return        --> syntax error, unreachable statements
        do return end --> works, good for temp debugging
        print("running")
        --no such thing as next/continue in lua
        break
      end

    --Repeat (do while, condition tested after first run)
      repeat
        print("here I am!")
      until false

    --For loops
      --Numeric for - expr evaluated before the loop starts
        for i=start,finish,step do --commas, step optional
          i = 10 --NEVER DO THIS, unpredictable
          j = i
          break
        end
        print(i) --> nil, as i was implicitly local
        print(j)

        for i=10,1,-1 do print(i) end
      --Generic for or Iterator - expr evaluated each time using iterator function
        for index,value in ipairs(table) do --for in do
          print(index .. ": " .. value)
        end

        for key,value in pairs(table) do
          print(key .. " = " .. value)
        end

        --reverse lookup table:
          revDays = {}
          for i,v in ipairs(days) do
            revDays[v] = i
          end
  --Functions
    --Subroutine
      function fun()
      end
    --Return
      function do_something(param1, param2)
        return param1 + param2
      end
    --Multiple Return:
      function fun()
        return 1,2
      end
      x,y = fun()
      --constructor:
        table = {fun()} --> {1,2}
        function do_nothing() end
        table = {do_nothing()} --> {}
      --Only last can return multiples:
        a,b,c,d,e,f = 0,fun(),"first",fun() --> a=0;b=1;c="first";d=1;e=2;f=nil
    --Call
      do_something(one, two, three)
      print "parenthesis optional when only one string/table-constructor arg"
      fun{x=10,y=20} --> fun({x=10,y=20})
    --Default param:
      function fun(n)
        n = n or 1
        print n
      end
      --no errors for wrong number of args:
      fun      --> pointer/reference to function
      fun()    --> 1
      fun(2)   --> 2
      fun(3,4) --> 2

  --Objects
    --Passing self to object function:
      object:fun(param) --> object.fun(object, param)

--Misc:
  --load contents of file, useful for interactive mode
    dofile("lib1.lua")
  --delete global variable
    x = nil

