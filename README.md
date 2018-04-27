# pass file
`pass file` is a extension for adding arbitary files to the [pass](https://www.passwordstore.org/) password store. Files will be encoded using `base64` before encryption.

## Usage
```
Usage: pass file attach|retrieve pass-name [path]
  attach|add: add new file to password store
  retrieve|show|cat: retrieve file from password store and print it to stdout
```

## Examples
Storing a PNG picture and retrieving it.
```
pass file attach pics/secretpic mypicture.png
pass file retrieve pics/secretpic > retrieved-picture.png
```
Alternativley you can also use shortcuts for `attach` and `retrieve`:
```
pass file add article my_super_secret_revelations.txt
pass file cat article
```
## Installation
See [here](https://www.passwordstore.org/#extensions) for details. There is also information on how to install extensions in the `pass` man page.
