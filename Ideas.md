
# Idea: The '(' ')' escape mechanism

Use parenthesis to escape the normal program invocation mode access the internal script data.

```
(foo)     : access the variable `foo` (does not include environment variables)
(env.foo) : access the environment variable `foo`
```

Build Example:
```
(repo_dir = script.dir)
dmd -of=(repo_dir) (path(repo_dir "minscript.d"))
```

# Idea: Function Calls

If the parser sees this pattern `<identifier> '(' ... ')'` then it interprets it as a function call.
```
set(message hello)
set(mystuff.foo something)
set(mystuff.bar "another thing")
echo path($script.dir)
```

This disadvantage is that if a program invocation contains parens, then they will need to be escaped or quoted, but BASH also has this disadvantage.  We could prevent function expansion inside quoted strings.  BASH does this, but does not prevent '$' expansion in this case.

# Idea: The `$` operator.

The `$` operator temporarily escapes the normal program invocation mode to access the internal script data.

Grammar 1:
```
DollarExpression ::= '$' ( Expression | '(' Expression ')' )
Expression ::= Node ( '.' Node )*
Node ::= Identifier | QuotedString | '(' Expression* ')'
```
Grammar 2:
```
DollarExpression ::= '$' Expression ';'?
Expression ::= Node ( '.' Node )*
Node ::= Identifier | QuotedString | '(' Expression* ')'
```

```
$<varname>   : access the variable `<varname>`
             : i.e. $a (access the variable 'a')

$(<expression>) : evaluate the given `<expression>`

```

Examples:
```
$foo
$foo.bar
$"hello"
$(foo)
$(foo).bar
$(foo.bar baz.bin).path
```
```
foo=what
$foo;.txt (creates 'what.txt')
```


```
$env : env contains members for each variable in the environment
       i.e. $env.a

UFCS properties:

.path  : convert arguments to path
       : i.e. $a.path
       :      $"foo/bar".path
       :      $(a "foo").path

```

Build Example:
```
repo_dir=$script.dir
dmd -of=$script.dir $(script.dir "minscript.d").path
```

# Idea: use arrays and allow whitespace in unescaped arguments

Consider:
```
a="my file.txt"
cat $a
```

In bash you would get this:
```
cat: my: No such file or directory
cat: file.txt: No such file or directory
```

However, in this shell, we could make this work by separating arguments before performing variable substitution.  This solves the problem but creates another.  Let's say you want to have multiple arguments in a single variable:

```
cc="cc -Wall -O2"
...
cc="$cc --anotherOption"
...
$cc hello.c
```
This is where arrays come in (note: not sure about array syntax yet):
```
cc=[cc -Wall -O2]
...
cc+=--anotherOption
...
$cc hello.c
```

When the new shell sees `$cc`, since it is an array, it will interpret each entry as a separate argument.
