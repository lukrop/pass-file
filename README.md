# pass file
`pass file` is a extension for adding arbitary files to the [pass](https://www.passwordstore.org/) password store. Files will be encoded using `base64` before encryption. This extension is inspired by [gopass](https://github.com/justwatchcom/gopass)' `binary` function to which it is also compatible. Files stored with `gopass binary` can be retrieved with `pass file` and vice versa.

## Usage
```
Usage: pass file action pass-name [path]
Actions:
  store|add|attach: add new file to password store
  retrieve|show|cat: retrieve file from password store and print it to stdout
  edit|vi: edit a file (warning: unencrypted file will be opened with $EDITOR)
```

## Examples
Storing a PNG picture and retrieving it.
```
pass file store pics/secretpic mypicture.png
pass file retrieve pics/secretpic > retrieved-picture.png
```
Alternativley you can also use shortcuts for `attach` and `retrieve`:
```
pass file add article my_super_secret_revelations.txt
pass file cat article
```
Use `edit` to edit a file:
```
pass file edit article
```
## Installation
See [here](https://www.passwordstore.org/#extensions) for details. There is also information on how to install extensions in the `pass` man page.
