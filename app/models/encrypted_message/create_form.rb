class EncryptedMessage::CreateForm
  include ActiveModel::Model

  attr_accessor :decrypted_content, :password, :question
  validates :decrypted_content, :password, presence: true
end
