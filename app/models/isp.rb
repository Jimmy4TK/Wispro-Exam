class Isp < ApplicationRecord
    has_secure_password

    #Relations
    has_many :services, dependent: :destroy

    #Validates
    validates :name, presence: true, uniqueness:true
    validates :password_digest, presence: true
    validates :token, uniqueness: true

    #Callbacks
    before_create :set_token


    def set_token
        self.token = SecureRandom.uuid
    end

end
