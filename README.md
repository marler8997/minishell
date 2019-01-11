# Goals

* A minimal implementation to write scripts to invoke external programs
* Multi-Platform

# Example

printmsg:
```
#!/usr/bin/env minscript
@require message
echo $message
```

Execute it:
```
./printmsg                       # error: required variable 'message' is not defined
./printmsg message=hello         # prints 'hello'
minscript printmsg message=hello # prints 'hello'
```

# Invoke a program
```bash
[VAR=VALUE] [VAR=VALUE]... program arg1 arg2 ...
```

Each VAR=VALUE sets an environment variable to pass to `program`, but do not remain afterwards.

# Variables

```bash
@set message hello
echo $message
# prints 'hello'

echo $other_message
# error: $other_message does not exist
```

```
$var     : reference a local variable named 'var' (does not pick up environment variables)
          $var does not pick up environment variables by default because they shouldn't be
          the default.  all variables should be passed into the script explicitly by default
$env.var : reference an environment variable named 'var'
$any.var : reference either a locatl variable named 'var', it it does not exist, falls back
           to the environment variable
```

### "Local Variables" vs "Environment Variables"

"Local Variables" are local to the shell process, they do not get included in the environment variables passed to child processes.  "Environment Variables" are propogated to child processes in their environment variables.

# Shell Directives
Shell directives start with an `@` symbol, i.e.
```
@set message "hello"         # set `message` local variable to "hello"

@set env.message "hello"     # set `message' environment variable to "hello"

@require message             # require that the `message` local variable be set
@require env.message         # require that the `message` environment variable be set

@default message "hello"     # set `message` local variable to "hello" only if it's not already set
@default env.message "hello" # set `message` environment variable to "hello" only if it's not already set
```

### Predefined Variables
```
$script.file    #  filename of the script
$script.absfile # absolute filename of the script
```

# Functions

### How to call a function
```
@<function>(arg1 arg2 ...)
```

Example
```
echo @path("a" "b")     # prints "a/b" on posix, "a\b" on windows
```

# TODO

* Need a way to get environment variables from sub processes/shells
  I don't think there's a way to execute a program and take environment variables from it?
  This is because when you start the program via fork/exec the kernel sets up the process
  with it's own copy of the environment and there's no general way to get it that I know of.


