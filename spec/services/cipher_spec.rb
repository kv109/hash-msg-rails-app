RSpec.describe Cipher do
  ALPHANUMERIC_CHARS = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z)
  NON_ALPHANUMERIC_CHARS = %w(! @ # $ % ^ & * \( \) _ + - = [ ] ; ' \\ , . / : " | < > ?)
  CHARS = ALPHANUMERIC_CHARS + NON_ALPHANUMERIC_CHARS + (0..255).map {|n| "" <<n }

  describe '#decrypt' do
    let(:contents_and_passwords) do
      contents_and_passwords = []
      passwords = [
        'password',
        '   ',
        '(*&^@#$)',
        '111',
      ]
      contents = [
        ' ',
        '   ',
        'a',
        'a ',
        'a         ',
        'aa',
        'aaa',
        'aaaa',
        'ab',
        'abc ',
        'abcd ',
        'Very important message.',
        'Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message. Very long message.',
      ]
      passwords.each do |password|
        contents.each do |content|
          contents_and_passwords << [content, password]
        end
      end

      contents_and_passwords
    end

    context 'with valid password' do
      it 'decrypts content' do
        contents_and_passwords.each do |content, password|
          encrypt_hash = { decrypted_content: content, password: password }
          encrypted_content = described_class.encrypt(encrypt_hash)

          decrypt_hash = { encrypted_content: encrypted_content, password: password }
          decrypted_content_2 = described_class.decrypt(decrypt_hash)
          expect(decrypted_content_2).to eql content
        end
      end
    end

    context 'with invalid password' do
      context 'with one char added at the beginning' do
        it 'fails to decrypt' do
          contents_and_passwords.each do |content, password|
            CHARS.each do |char|
              invalid_password = char + password
              expect_decryption_failure(content, password, invalid_password)
            end
          end
        end
      end

      context 'with one char added at the end' do
        it 'fails to decrypt' do
          contents_and_passwords.each do |content, password|
            CHARS.each do |char|
              invalid_password = password + char
              expect_decryption_failure(content, password, invalid_password)
            end
          end
        end
      end

      context 'with first char replaced' do
        it 'fails to decrypt' do
          contents_and_passwords.each do |content, password|
            CHARS.each do |char|
              invalid_password = password.dup
              first_char = invalid_password[0]
              if char != first_char
                invalid_password[0] = char
                expect_decryption_failure(content, password, invalid_password)
              end
            end
          end
        end
      end
    end
  end

  def expect_decryption_failure(decrypted_content, valid_password, invalid_password)
    encrypted_content = described_class.encrypt(decrypted_content: decrypted_content, password: valid_password)
    expect(
      begin
        described_class.decrypt(encrypted_content: encrypted_content, password: invalid_password)
      rescue OpenSSL::Cipher::CipherError
        nil
      end
    ).to_not eql decrypted_content
  end
end
