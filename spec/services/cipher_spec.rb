RSpec.describe Cipher do
  ALPHANUMERIC_CHARS = %w(0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z)
  NON_ALPHANUMERIC_CHARS = %w(! @ # $ % ^ & * \( \) _ + - = [ ] ; ' \\ , . / : " | < > ?)
  CHARS = ALPHANUMERIC_CHARS + NON_ALPHANUMERIC_CHARS + (0..255).map {|n| "" <<n }

  describe '#decrypt' do
    let(:contents) do
      contents = []
      contents += [
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
    end

    let(:contents_and_passwords) do
      contents_and_passwords = []

      passwords.each do |password|
        contents.each do |content|
          contents_and_passwords << [content, password]
        end
      end

      contents_and_passwords
    end

    let(:passwords) do
      passwords = []
      # random_passwords = [3, 5, 10, 50, 200].map { |n| Base64.encode64((0...n).map { (rand(255)).chr }.join) }
      random_passwords = [3, 5, 10, 15, 50, 200].map { |n| ((0...n).map { (65+rand(26)).chr }.join) }
      passwords += random_passwords
      passwords += [
        'password',
        ' ',
        '     ',
        '(*&^@#$)',
        '111',
        'Sentences makes great passwords'
      ]
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
        context 'with password with less than 15 chars' do
          it 'fails to decrypt' do
            contents_and_passwords.each do |content, password|
              next if password.length > 14
              CHARS.each do |char|
                invalid_password = password + char
                expect_decryption_failure(content, password, invalid_password)
              end
            end
          end
        end

        context 'with password with at least 15 chars' do
          xit 'fails to decrypt' do
            contents_and_passwords.each do |content, password|
              next if password.length < 15
              CHARS.each do |char|
                invalid_password = password + char
                expect_decryption_failure(content, password, invalid_password)
              end
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
    ).to_not eql(decrypted_content), "valid password: [#{valid_password}](length=#{valid_password.length}), used password: [#{invalid_password}](length=#{invalid_password.length}), content: [#{decrypted_content}]"
  end
end
