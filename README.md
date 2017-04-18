# AESCrypt
> Simple AES encryption/decryption for Ruby

AESCrypt is a simple to use, opinionated AES encryption / decryption Ruby gem that just works.

AESCrypt uses the AES-256-CBC cipher and encodes the encrypted data with Base64.

A corresponding gem to easily handle AES encryption / decryption in Objective-C is available at http://github.com/Gurpartap/AESCrypt-ObjC.

This version of AESCrypt is a fork of the original, and is maintained by Charcoal. The original has not been updated
since 2013, and was suffering from a few deprecations and lack of security best practice, which this version fixes.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'aescrypt', github: 'Charcoal-SE/aescrypt'
```

And then execute:

    $ bundle install

## Usage
**Encrypting:**
```ruby
message = 'my secret message'
password = 'h4xx0r3d'
salt, iv, encrypted = AESCrypt.encrypt(message, password)
```

Store `salt` and `iv` safely - you'll need them again to decrypt the encrypted text.

**Decrypting:**
```ruby
decrypted = AESCrypt.decrypt(encrypted, password, salt, iv)
```

## Advanced usage
**Note:** If you want to use SHA1 as your key derivation function, you will need to go down the 
advanced usage route. AESCrypt uses SHA256 by default for better security.

**Encrypting:**
```ruby
message = 'my other secret'
password = 'h4xx0r3d'

# I recommend AES-256-CBC, but you can pick another cipher type/mode like this.
# This can be anything that OpenSSL::Cipher.new will accept. You'll be warned if you
# pick ECB mode.
cipher_mode = 'AES-256-CBC'
iv = OpenSSL::Random.random_bytes(16)

# Not all implementations support PBKDF2-HMAC with SHA256. For maximum compatibility,
# use SHA1 as your key digest. Bear in mind that SHA1 has been broken; for maximum
# security, use a stronger algorithm like SHA256.
key_digest = OpenSSL::Digest::SHA256.new
salt = OpenSSL::Random.random_bytes(32)
key = OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 10000, key_digest.digest_length, key_digest)

# Don't use the password directly as the encryption key. Generate a key as shown above.
encrypted = AESCrypt.encrypt_data(message, key, iv, cipher_mode)
```

**Decrypting:**
```ruby
decrypted = AESCrypt.decrypt_data(encrypted, key, iv, cipher_mode)
```

## Migrating from 1.x
AESCrypt 1.x is obsolete; it hasn't been updated in a while and uses outdated security practices.
AESCrypt 2.x fixes these issues, but is not backwards-compatible with v1.x because of that.

To migrate encrypted data from 1.x to using 2.x, you can use the `AESCrypt::Migrator` class:

```ruby
decrypted = AESCrypt::Migrator.decrypt_from_v1(v1_encrypted_data, v1_encryption_password)
```

Once you've got the cleartext back using the above snippet, you can re-encrypt it using v2.x and
save it again.

## License
Copyright (c) 2012-17 Gurpartap Singh and Charcoal.

AESCrypt is available under the terms of the MIT license; see LICENSE for full license terms.

## Contributing
If you'd like to contribute code, go ahead and fork this repo, add your changes, and send us a 
pull request. We'll review it and keep you updated.

If you've got questions or feedback, please open a new issue on this repository.
