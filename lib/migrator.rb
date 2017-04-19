require 'openssl'

module AESCrypt
  class Migrator
    @@legacy = Class.new do
      def self.encrypt(message, password)
        warn("AESCrypt WARNING: The AESCrypt internal legacy class is not secure, and encryptions performed using " +
             "this class are vulnerable to attack. You should only be using this class as part of a migration between " +
             "AESCrypt versions, NOT as a permanent part of a production system.")
        Base64.encode64(self.encrypt_data(message.to_s.strip, self.key_digest(password), nil, "AES-256-CBC"))
      end

      def self.decrypt(message, password)
        warn("AESCrypt WARNING: The AESCrypt internal legacy class is not secure, and encryptions performed using " +
             "this class are vulnerable to attack. You should only be using this class as part of a migration between " +
             "AESCrypt versions, NOT as a permanent part of a production system.")
        base64_decoded = Base64.decode64(message.to_s.strip)
        self.decrypt_data(base64_decoded, self.key_digest(password), nil, "AES-256-CBC")
      end

      private
      def self.key_digest(password)
        OpenSSL::Digest::SHA256.new(password).digest
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
        aes = OpenSSL::Cipher::Cipher.new(cipher_type)
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
        aes = OpenSSL::Cipher::Cipher.new(cipher_type)
        aes.encrypt
        aes.key = key
        aes.iv = iv if iv != nil
        aes.update(data) + aes.final
      end
    end

    def self.decrypt_from_v1(data, password)
      @@legacy.decrypt(data, password)
    end
  end
end
