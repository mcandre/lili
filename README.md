# lili - line ending linter

`lili` searches your source code files for strange line endings that may cause issues with software interoperability.

# EXAMPLES

```
$ lili examples/
examples/hello-wrong.bat: observed lf preferred: /^crlf$/
examples/index-acorn.html: observed lfcr preferred: /^lf$/
examples/index-form-feed.html: observed ff preferred: /^lf$/
examples/index-ie.html: observed crlf preferred: /^lf$/
examples/index-line-separator.html: observed ls preferred: /^lf$/
examples/index-monstrosity.html: observed mix preferred: /^lf$/
examples/index-next-line.html: observed nel preferred: /^lf$/
examples/index-paragraph-separator.html: observed ps preferred: /^lf$/
examples/index-vertical.html: observed vt preferred: /^lf$/

$ lili -i '*.html' examples/
examples/hello-wrong.bat: observed lf preferred: /^crlf$/

$ lili -i '*.html' -i '*.bat' examples/
$

$ lili examples/empty.txt
$

$ lili -h
Usage: lili [options] [<files>]
    -i, --ignore pattern             Ignore file pattern (fnmatch)
    -h, --help                       Print usage info
    -v, --version                    Print version info
```

# HOMEPAGE

https://github.com/mcandre/lili

# RUBYGEMS

https://rubygems.org/gems/lili

# ABOUT

lili scans large projects for strange line endings, which may cause issues with some software.

* Most software prefers LF.
* Some Windows-centric software prefers CRLF.
* Some old Mac OS 9 software prefers CR.

Either way, lili can help identify which files in your projects may be in the "wrong" format, helping resolve line ending-related errors across different computer systems.

lili is a wrapper around [line-detector](https://github.com/mcandre/line-detector), presenting a frontend similar to modern linters like [Reek](https://github.com/troessner/reek/wiki) and [JSHint](http://jshint.com/).

* Recursive file scanning, like `jshint .`
* Optional ignore patterns, like `.gitignore`
* Configuration via per-project and per-user [dotfiles](https://github.com/mcandre/lili/blob/master/CONFIGURE.md#dotfiles)
* Install via a standard programming language package manager

# REQUIREMENTS

* [Ruby](https://www.ruby-lang.org/) 2.3+

## Optional

There are a handful of programs for identifying line ending formats:

* [line-detector](https://github.com/mcandre/line-detector), used by lili for format detection.
* [od](http://man.cx/od) can elucidate file contents by printing the raw byte values.
* The Unix [file](http://man.cx/file) command can report CRLF files, but fails to report CRLFs in `.html` files.

There are numerous programs that can help convert files to different line ending formats:

* [dos2unix](http://waterlan.home.xs4all.nl/dos2unix.html)
* [tofrodos](http://tofrodos.sourceforge.net/)
* [tr](http://man.cx/tr)
* [sed](https://www.gnu.org/software/sed/)
* [awk](http://cm.bell-labs.com/cm/cs/awkbook/index.html)
* [perl](http://www.perl.org/)
* [emacs](http://www.gnu.org/software/emacs/)
* [vim](http://www.vim.org/)

# INSTALL

Install via [RubyGems](http://rubygems.org/):

```
$ gem install lili
```

# CONFIGURE

See [CONFIGURE.md](https://github.com/mcandre/lili/blob/master/CONFIGURE.md) for details.

# LICENSE

FreeBSD

# DEVELOPMENT

## Testing

Keep the interface working:

```
$ cucumber
```

## Linting

Keep the code tidy:

```
$ rake lint
```

## Git Hooks

See `hooks/`.
