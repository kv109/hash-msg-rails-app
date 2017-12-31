class EncryptedMessage::CreateWithTokenForm
  include ActiveModel::Model

  attr_accessor :decrypted_content
  validates :decrypted_content, presence: { message: "can't be blank" }, length: { minimum: 6 }
end
