class UsersController < ApplicationController
    before_action :set_user, only:[:show,:update]
    before_action :check_token, only:[:show,:update]

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

    private

    def set_user
        @user=User.find_by(id: params[:id])
        if @user.blank?
            render status:404, json:{message: "User #{params[:id]} doesn't exist"}
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
