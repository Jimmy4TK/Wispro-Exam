class UserServicesController < ApplicationController
    before_action :set_isp
    before_action :set_service, except:[:list_rejected,:list_request]
    before_action :set_user_service, only:[:check_request]

    def create
        @user=User.find_by(id: params[:user][:id])
        if @user.present?
            if request.headers["Authorization"] == "Bearer #{@user.token}"
                @user_service=@service.user_service.new(user_id: @user.id)
                if @user_service.save
                    render status:200, json:{user_service: @user_service}
                else
                    render status:400, json:{message: @user_service.errors.full_messages}
                end
            else
                render status:400, json:{message: "The Token isn't valid"}
            end
        else
            render status:400, json:{message: "The User doesn't exist"}
        end
    end

    def check_request
        @user_service.assign_attributes(params.require(:user_service).permit(:status))
        if @user_service.save
            render status:200, json:{user_service: @user_service}
        else
            render status:500, json:{message: @user_service.errors.full_messages}
        end
    end

    def list_request
        @user_services=UserService.where(Service.where('id = user_services.service_id AND isp_id= ?',@isp.id).arel.exists).pendiente
        if @user_services.present?
            render status:200, json:{user_services: @user_services}
        else
            render status:200, json:{message: "Isp #{@isp.id} doesn't have pending requests"}
        end
    end

    def list_rejected
        @user_services=UserService.where(Service.where('id = user_services.service_id AND isp_id= ?',@isp.id).arel.exists).rechazado.last_month
        if @user_services.present?
            render status:200, json:{user_services: @user_services}
        else
            render status:200, json:{message: "Isp #{@isp.id} doesn't have reject requests in last month"}
        end
    end

    private

    def set_isp
        @isp=Isp.find_by(id: params[:isp_id])
        if @isp.blank?
            render status:400, json:{message: "The Isp #{params[:isp_id]} doesn't exist"}
            false
        end
    end

    def set_service
        @service=Service.find_by(id: params[:service_id])
        if @service.blank?
            render status:400, json:{message: "The Service #{params[:id]} doesn't exist"}
            false
        else
            if @service.isp_id != @isp.id
                render status:400, json:{message: "The Service doesn't correspond to Isp #{@isp.id}"}
                false
            end
        end
    end

    def set_user_service
        @user_service=UserService.find_by(id: params[:id])
        if @user_service.blank?
            render status:400, json:{message: "The User Service #{params[:user_service_id]} doesn't exist"}
            false
        else
            if @user_service.service_id != @service.id
                render status:400, json:{message: "The User Service doesn't correspond to Service #{@service.id}"}
                false
            end
        end
    end
end
