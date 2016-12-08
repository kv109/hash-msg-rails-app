class EncryptedMessage::CreateForm
  include ActiveModel::Model

  attr_accessor :decrypted_content, :password, :question
  validates :decrypted_content, presence: { message: "Message can't be blank" }
  validates :password, presence: true, length: { minimum: 6 }
end
