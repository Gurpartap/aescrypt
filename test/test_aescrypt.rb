require 'minitest/autorun'
require 'aescrypt'

class AESCryptTest < Minitest::Test
    def test_decrypted_encryption
        message = 'message'
        password = 'password'

        enc = AESCrypt.encrypt(message, password)
        dec = AESCrypt.decrypt(enc, password)

        assert_equal message, dec
    end
end