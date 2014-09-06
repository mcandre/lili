# Configuration

LiLi offers multiple ways to resolve preferences:

1. Command-line flags (`lili -i`)
2. Dotfiles (`.lili-ignore`, `.lili-rc.yml`)
3. Built-in defaults (`DEFAULT_IGNORES`, `DEFAULT_RULES`)

Any command-line flags that are present override the same settings in dotfiles and built-in defaults.

# Command-line flags

Run `lili -h` or `lili --help` for a full list, or refer to the source code for `bin/lili`.

```
$ lili -h
Usage: lili [options] [<files>]
    -i, --ignore pattern             Ignore file names matching Ruby regex pattern
    -h, --help                       Print usage info
    -v, --version                    Print version info
```

# Dotfiles

LiLi automatically applies any `.lili-ignore` and/or `.lili-rc.yml` configuration files in the same directory as a file being scanned, or a parent directory (`../.lili-ignore`, `../.lili-rc.yml`), up to `$HOME/.lili-ignore`, `$HOME/.lili-rc.yml`, if any such files exist.

## `.lili-ignore`

Samples:

* [examples/python/.lili-ignore](https://github.com/mcandre/lili/blob/master/examples/python/.lili-ignore)

A `.lili-ignore` may contain Ruby regex patterns of files and/or folders to exclude from scanning, one pattern per line.

## `.lili-rc.yml`

Samples:

* [examples/macweb/.lili-rc.yml](https://github.com/mcandre/lili/blob/master/examples/macweb/.lili-rc.yml)

`.lili-rc.yml` may contain a number of keys:

* `rules` may be a list of rules.

A rule is a two element list, of a filename pattern and a format preference.

A format preference is a two element list of a line ending pattern and a final end of line pattern.

Filename patterns, line ending patterns, and final end of line patterns, are each Ruby regexps.

# Built-in defaults

`rules` defaults to:

```
[
  [/[\.-]min\./, [/^none$/, /^false$/]],
  [/\.reg$/, [/^crlf|none$/, /^false$/]],
  [/\.bat$/, [/^crlf|none$/, /^false$/]],
  [/\.ps1$/, [/^crlf|none$/, /^false$/]],
  [/.*/, [/^lf|none$/, /^true$/]]
]
```
