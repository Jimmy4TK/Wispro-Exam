class UsersController < ApplicationController
    before_action :set_user, only:[:show,:update,:change_password]
    before_action :check_token, only:[:show,:update,:change_password]

    def show
        render status:200, json:{user: {id:@user.id, name: @user.name,last_name: @user.last_name, mail: @user.mail}}
    end

    def create
        if params[:user][:password] == params[:user][:confirm_password]
            @user=User.new(params.require(:user).permit(:name,:last_name,:mail,:password))
            if @user.save
                render status:200, json:{user: {id:@user.id, name: @user.name,last_name: @user.last_name, mail: @user.mail}}
            else
                render status:500, json:{message: @user.errors.full_messages}
            end            
        else
            render status:400, json:{message:"Password and Confirm Password don't match"}
        end
    end

    def update
        @user.assign_attributes(params.require(:user).permit(:name,:last_name,:mail))
        if @user.save
            render status:200, json:{user: {id:@user.id, name: @user.name,last_name: @user.last_name, mail: @user.mail}}
        else
            render status:500, json:{message: @user.errors.full_messages}
        end
    end

    def login
        @user=User.find_by(mail: params[:user][:mail])
        if @user.present?
            if @user.authenticate(params[:user][:password])
                render status:200, json:{user: {id: @user.id, name: @user.name, last_name: @user.last_name, mail: @user.mail, token: @user.token}}
            else
                render status:404, json:{message: "The Password is incorrect"}
            end
        else
            render status:400, json:{message: "The Mail #{params[:user][:mail]} doesn't correspond to any User"}
        end
    end

    def change_password
        if @user.authenticate(params[:user][:current_password])
            if params[:user][:password]==params[:user][:confirm_password]
                @user.assign_attributes(params.require(:user).permit(:password))
                if @user.save
                    render status:200, json:{user: {id:@user.id, name: @user.name,last_name: @user.last_name, mail: @user.mail}}
                else
                    render status:500, json:{message:@user.errors.full_messages}
                end
            else
                render status:400, json:{message: "Password and Confirm Password don't match"}
            end
        else
            render status:400, json:{message: "Current Password is incorrect"}
        end
    end


    private

    def set_user
        @user=User.find_by(id: params[:id])
        if @user.blank?
            render status:400, json:{message: "The User doesn't exist"}
            false
        end
    end

    def check_token
        if request.headers["Authorization"] != "Bearer #{@user.token}"
            render status:400, json:{message: "Token isn't valid"}
            false
        end
    end
    
end
