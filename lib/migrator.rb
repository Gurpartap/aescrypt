require 'openssl'

module AESCrypt
  class Migrator
    def self.decrypt_from_v1(data, password)
      warn("AESCrypt WARNING: You have called the AESCrypt version migrator decryption method. You should only use " +
           "this method as part of a migration from version 1.x to version 2.x of AESCrypt, NOT as a permanent part " +
           "of any production system.")
      key = OpenSSL::Digest::SHA256.new(password).digest
      AESCrypt.decrypt_data(data, key, nil, 'AES-256-CBC')
    end
  end
end
