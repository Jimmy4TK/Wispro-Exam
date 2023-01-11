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
    def pending_request
        self.user_service.pendiente.order(:created_at)
    end

    def reject_request
        rejects=self.user_service.rechazado.where('created_at > ?', Time.now - 1.month)
    end
    
end
