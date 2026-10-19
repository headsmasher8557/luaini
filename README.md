# luaini
Simple ini file parser written in Lua, should work with version 5.1 and later.

## Usage

Require the `ini.lua` file as you would with any other library and you're done.

```lua
ini = require"ini"
```

`ini.read` reads from a string containing the data and `ini.readfile` is the same, except you pass in a filename.

```lua
ini.read("foo=bar")
ini.readfile("config.ini")
```

## Example

Suppose you have the following ini file:

```
note0=keys show up on _nsec if they were defined with no section, like this one
note1="see example.ini if you're confused"

[info]
name=John Doe
age=20
country=USA
note="Hello world!" ;quotes are optional for definining strings

[moreinfo]
foo=bar
6=9
```
Running it through luaini would give you something like the following:

```
$ lua examples/example.lua
moreinfo: {
  6=9
  foo="bar"
}
info: {
  name="John Doe"
  note="I don't know what I'm doing anymore"
  age=20
  country="USA"
}
_nsec: {
  note0="keys show up on _nsec if they were defined with no section, like this one"
  note1="see example.ini if you're confused"
}
```

See the examples folder.

## Contributing

*TODO: add CONTRIBUTING.md*
