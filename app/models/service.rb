class Service < ApplicationRecord
    #Relations
    belongs_to :isp
    has_many :user_service, dependent: :destroy
    has_many :user, through: :user_service

    #Validates
    validates :name, presence: true
    validates :price, presence: true
    validates :description, presence: true

    #CallBacks

    #Methods
    
end
