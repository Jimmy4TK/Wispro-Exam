class IspsController < ApplicationController
    
    before_action :set_isp, except:[:index,:create,:login]
    before_action :check_token, except:[:index,:show,:create,:login]

    def index
        @isps=Isp.all.select("id,name,created_at,updated_at")
        render status:200, json:{isps: @isps}
    end

    def show
        render status:200, json:{isp: {id:@isp.id, name: @isp.name,created_at: @isp.created_at, updated_at: @isp.updated_at}}
    end

    def create
        if params[:isp][:password] == params[:isp][:confirm_password]
            @isp=Isp.new(params.require(:isp).permit(:name,:password))
            if @isp.save
                render status:200, json:{isp: {id:@isp.id, name: @isp.name,created_at: @isp.created_at, updated_at: @isp.updated_at}}
            else
                render status:500, json:{message: @isp.errors.full_messages}
            end
        else
            render status:400, json:{message:"Password and Confirm Password don't match"}
        end
    end

    def update
        @isp.assign_attributes(params.require(:isp).permit(:name))
        if @isp.save
            render status:200, json:{isp: {id:@isp.id, name: @isp.name,created_at: @isp.created_at, updated_at: @isp.updated_at}}
        else
            render status:500, json:{message: @isp.errors.full_messages}
        end
    end

    def destroy
        if @isp.destroy
            render status:200, json:{}
        else
            render status:500, json:{message: @isp.errors.full_messages}
        end
    end

    def login
        @isp=Isp.find_by(name: params[:isp][:name])
        if @isp.present?
            if @isp.authenticate(params[:isp][:password])
                render status:200, json:{isp: {id: @isp.id, name: @isp.name, token: @isp.token}}
            else
                render status:400, json:{message: "The Password is incorrect"}
            end
        else
            render status:400, json:{message: "The Isp #{params[:isp][:name]} doesn't exist"}
        end
    end

    def change_password
        if @isp.authenticate(params[:isp][:current_password])
            if params[:isp][:password]==params[:isp][:confirm_password]
                @isp.assign_attributes(params.require(:isp).permit(:password))
                if @isp.save
                    render status:200, json:{isp: {id:@isp.id, name: @isp.name}}
                else
                    render status:500, json:{message:@isp.errors.full_messages}
                end
            else
                render status:400, json:{message: "Password and Confirm Password don't match"}
            end
        else
            render status:400, json:{message: "Current Password is incorrect"}
        end
    end

    def list_request
        @user_services=@isp.services.map(&:pending_request).reject { |c| c.empty? }
        if @user_services.present?
            render status:200,json:{user_services: @user_services}
        else
            render status:200,json:{message: "You doesn't have pending request"}
        end
    end

    def list_rejected
        @user_services=@isp.services.map(&:reject_request).reject { |c| c.empty? }
        if @user_services.present?
            render status:200,json:{user_services: @user_services}
        else
            render status:200,json:{message: "You doesn't have reject request in the last month"}
        end
    end

    private

    def set_isp
        @isp=Isp.find_by(id: params[:id])
        if @isp.blank?
            render status:400, json:{message: "The Isp #{params[:id]} doesn't exist"}
            false
        end
    end

    def check_token
        if request.headers["Authorization"] != "Bearer #{@isp.token}"
            render status:400, json:{message: "The Token isn't valid"}
            false
        end
    end

end
