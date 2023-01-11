class User < ApplicationRecord
    has_secure_password

    #Relations
    has_one :user_service, dependent: :destroy
    has_one :service, through: :user_service

    #Validates
    validates :name, presence: true
    validates :mail, presence: true
    validates :password_digest, presence: true
    validates :token, uniqueness: true

    #CallBacks
    before_create :set_token

    #Methods
    def set_token
        self.token = SecureRandom.uuid
    end

end
