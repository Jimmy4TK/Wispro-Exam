class UserService < ApplicationRecord
    enum status: {aprobado: 1, rechazado: 2, pendiente:0}

    #Relations
    belongs_to :user
    belongs_to :service

    #Validates

    #CallBacks

    #Methods        
    
    #Scope
    scope :last_month, -> { where('updated_at > ?', Time.now - 1.month) }
end
