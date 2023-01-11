class ServicesController < ApplicationController
    
    before_action :set_isp, except:[:index]
    before_action :set_service, except:[:index,:create]
    before_action :check_token, except:[:index,:show,:request_service]
    before_action :set_user_service, only:[:check_request,:change_service]

    def index
        @services=Service.all.order("isp_id")
        render status:200, json:{services: @services}
    end

    def show
        render status:200, json:{service: @service}
    end

    def create
        @service=@isp.services.new(params.require(:service).permit(:name,:price,:description))
        if @service.save
            render status:200, json:{service: @service}
        else
            render status:500, json:{message: @service.errors.full_messages}
        end
    end

    def update
        @service.assign_attributes(params.require(:service).permit(:name,:price,:description))
        if @service.save
            render status:200, json:{service: @service}
        else
            render status:500, json:{message: @service.errors.full_messages}
        end
    end

    def destroy
        if @service.destroy
            render status:200, json:{}
        else
            render status:500, json:{message: @service.errors.full_messages}
        end
    end

    def request_service
        @user=User.find_by(id: params[:user][:id])
        if @user.present?
            if request.headers["Authorization"] == "Bearer #{@user.token}"
                if change_service?
                    render status:200, json:{userservice: @userservice}
                else
                    @userservice=@service.user_service.new(user_id: @user.id)
                    if @userservice.save
                        render status:200, json:{userservice: @userservice}
                    else
                        render status:400, json:{message: @userservice.errors.full_messages}
                    end
                end
            else
                render status:400, json:{message: "The The Token isn't valid"}
            end
        else
            render status:400, json:{message: "The User doesn't exist"}
        end
    end

    def check_request
        @userservice.assign_attributes(params.require(:userservice).permit(:status))
        if @userservice.save
            render status:200, json:{userservice: @userservice}
        else
            render status:500, json:{message: @userservice.errors.full_messages}
        end
    end

    private

    def set_isp
        @isp=Isp.find_by(id: params[:isp_id].to_i)
        if @isp.blank?
            render status:400, json:{message: "The Isp #{params[:isp_id]} doesn't exist"}
            false
        end
    end

    def set_service
        @service=Service.find_by(id: params[:id])
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
        @userservice=UserService.find_by(id: params[:user_service_id])
        if @userservice.blank?
            render status:400, json:{message: "The User Service #{params[:user_service_id]} doesn't exist"}
            false
        else
            if @userservice.service_id != @service.id
                render status:400, json:{message: "The User Service doesn't correspond to Service #{@service.id}"}
                false
            end
        end
    end


    def check_token
        if request.headers["Authorization"] != "Bearer #{@isp.token}"
            render status:400, json:{message: "The Token isn't valid"}
            false
        end
    end

    def change_service?
        if @user.user_service.present?
            @userservice=@user.user_service
            @userservice.service_id=params[:id]
            @userservice.status=0
            if !@userservice.save
                render status:400, json:{message: @userservice.errors.full_messages}
            else
                true
            end
        else
            false
        end
    end

end
