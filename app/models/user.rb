class User < ApplicationRecord
    has_secure_password

    #Relations
    has_many :user_service, dependent: :destroy
    has_many :service, through: :user_service

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
