# vim-go-test [![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

Test runner and helper for golang.

## Usage

```vim
" run: go test <current-package>
: RunTest 

" run: go test <current-package> -run=<current-func>
: RunTestFunc 

" echo current package name
: EchoPackage

" echo current test func name
: EchoTestFunc
```

## Options

TBD

## Requirements

- Vim 8.2+
- Go 1.12+

## Installation

```vim
Plug 'micheam/vim-go-test'
```

## License
MIT

## Author
Michito Maeda 
