# `aes.sh`

Encrypts or decrypts a given data file with the provided passphrase. Specifically, performs AES-256 in CBC mode, using PBKDF2 for key derivation with a random salt and SHA-1 message digest. Produces Base64-encoded output.

Prerequisites:

* [OpenSSL](https://www.openssl.org/) 1.1 or newer

Usage:
```
aes.sh [-d] -p <file> -i <file> -o <file> 
```

Options:

* `-d`

    Decryption mode. If omitted, encryption mode is implied.

* `-p <file>`

    Passphrase file.

* `-i <file>`

    Input data file.

* `-o <file>`

    Output data file.

Example:

```
aes.sh -p ./pass.txt -i ./data.txt -o ./data.txt.enc
```