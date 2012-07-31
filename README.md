# AESCrypt - Simple AES encryption / decryption for Ruby

AESCrypt is a simple to use, opinionated AES encryption / decryption Ruby gem that just works.

AESCrypt uses the AES-256-CBC cipher and encodes the encrypted data with Base64.

A corresponding gem to easily handle AES encryption / decryption in Objective-C is available at http://github.com/Gurpartap/AESCrypt-ObjC.

## Installation

Add this line to your application's Gemfile:

    gem 'aescrypt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aescrypt

## Usage

    message = "top secret message"
    password = "p4ssw0rd"

Encrypting

    encrypted_data = AESCrypt.encrypt(message, password)

Decrypting

    message = AESCrypt.decrypt(encrypted_data, password)

## Advanced usage

Encrypting

    encrypted_data = encrypt_data(data, key, iv, cipher_type)

Decrypting

    decrypted_data = decrypt_data(encrypted_data, key, iv, cipher_type)

## Corresponding usage in Objective-C

The AESCrypt Objective-C class, available at https://github.com/Gurpartap/AESCrypt-ObjC, understands what you're talking about in your Ruby code. The purpose of the Ruby gem and Objective-C class is to have something that works out of the box across the server (Ruby) and client (Objective-C). However, a standard encryption technique is implemented, which ensures that you can handle the data with any AES compatible library available across the web. So, you're not locked-in.

Here's how you would use the AESCrypt Objective-C class:

    NSString *message = @"top secret message";
    NSString *password = @"p4ssw0rd";

Encrypting

    NSString *encryptedData = [AESCrypt encrypt:message password:password];

Decrypting

    NSString *message = [AESCrypt decrypt:encryptedData password:password];

See the Objective-C class README at http://github.com/Gurpartap/AESCrypt-ObjC for more details.

## License

Copyright (c) 2012 Gurpartap Singh

The encrypt_data and decrypt_data methods are Copyright (c) 2007 Brent Sowers and have been included in the gem with prior permission. Thanks Brent! :)

See LICENSE for license terms.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
