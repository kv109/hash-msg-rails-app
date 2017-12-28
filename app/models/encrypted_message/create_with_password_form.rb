class EncryptedMessage::CreateWithPasswordForm
  include ActiveModel::Model

  attr_accessor :decrypted_content, :password, :question
  validates :decrypted_content, presence: { message: "can't be blank" }, length: { minimum: 6 }
  validates :password, presence: true, length: { minimum: 6 }
end
