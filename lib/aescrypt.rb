# -*- encoding: utf-8 -*-

# The encrypt_data and decrypt_data methods are Copyright (c) 2007 Brent Sowers
# and have been included with prior permission.
#
# Copyright (c) 2012 Gurpartap Singh
# 
# MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'openssl'
require 'base64'
require 'securerandom'

require_relative 'migrator'

module AESCrypt
  def self.encrypt(message, password, salt = nil, iv = nil)
    iv ||= SecureRandom.bytes 16
    salt, key = self.key_digest(password, salt)
    return salt, iv, Base64.encode64(self.encrypt_data(message.to_s.strip, key, iv, 'AES-256-CBC'))
  end

  def self.decrypt(message, password, salt, iv)
    base64_decoded = Base64.decode64(message.to_s.strip)
    slt, key = self.key_digest(password, salt)
    self.decrypt_data(base64_decoded, key, iv, 'AES-256-CBC')
  end

  def self.key_digest(password, salt = nil)
    salt ||= SecureRandom.bytes 32
    digest = OpenSSL::Digest::SHA256.new
    return salt, OpenSSL::PKCS5.pbkdf2_hmac(password, salt, 10000, digest.digest_length, digest)
  end

  # Decrypts a block of data (encrypted_data) given an encryption key
  # and an initialization vector (iv).  Keys, iv's, and the data 
  # returned are all binary strings.  Cipher_type should be
  # "AES-256-CBC", "AES-256-ECB", or any of the cipher types
  # supported by OpenSSL.  Pass nil for the iv if the encryption type
  # doesn't use iv's (like ECB).
  #:return: => String
  #:arg: encrypted_data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String
  def self.decrypt_data(encrypted_data, key, iv, cipher_type)
    self.warn_if_ecb cipher_type

    aes = OpenSSL::Cipher.new(cipher_type)
    aes.decrypt
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(encrypted_data) + aes.final  
  end

  # Encrypts a block of data given an encryption key and an 
  # initialization vector (iv).  Keys, iv's, and the data returned 
  # are all binary strings.  Cipher_type should be "AES-256-CBC",
  # "AES-256-ECB", or any of the cipher types supported by OpenSSL.  
  # Pass nil for the iv if the encryption type doesn't use iv's (like
  # ECB).
  #:return: => String
  #:arg: data => String 
  #:arg: key => String
  #:arg: iv => String
  #:arg: cipher_type => String  
  def self.encrypt_data(data, key, iv, cipher_type)
    self.warn_if_ecb cipher_type

    aes = OpenSSL::Cipher.new(cipher_type)
    aes.encrypt
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(data) + aes.final      
  end

  private
  def self.warn_if_ecb(cipher_type)
    if cipher_type.downcase.include? 'ecb'
      warn("AESCrypt WARNING: You are using AES in ECB mode. This mode does not effectively hide patterns in " +
           "plaintext. Unless you know what you're doing and are absolutely sure you need ECB mode, you should use " +
           "another mode, such as CBC. See " +
           "http://ruby-doc.org/stdlib-2.0.0/libdoc/openssl/rdoc/OpenSSL/Cipher.html#class-OpenSSL::Cipher-label-Choosing+an+IV " +
           "for further information.")
    end
  end
end
