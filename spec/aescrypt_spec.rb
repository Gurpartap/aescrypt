require_relative '../lib/aescrypt'

describe AESCrypt do
  describe '.encrypt(message, password)' do
    it 'returns an encrypted string' do
      expect(described_class.encrypt('some secret', 'password')).to_not eq 'some secret'
    end
  end

  describe '.decrypt(message, password)' do
    it 'can decrypt strings encrypted with the same password' do
      encrypted_string = described_class.encrypt('some secret', 'password')
      expect(described_class.decrypt(encrypted_string, 'password')).to eq 'some secret'
    end

    it 'cannot decrypt strings encrypted with a different password' do
      encrypted_string = described_class.encrypt('some secret', 'password')
      expect {
        described_class.decrypt(encrypted_string, 'bad password')
      }.to raise_error OpenSSL::Cipher::CipherError
    end
  end
end
