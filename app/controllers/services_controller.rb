class ServicesController < ApplicationController
    before_action :set_isp, except:[:index]
    before_action :set_service, only:[:show,:update,:destroy]
    before_action :check_token, only:[:create,:update,:destroy]

    def index
        @services=Service.all
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

    private

    def set_isp
        @isp=Isp.find_by(id: params[:isp_id].to_i)
        if @isp.blank?
            render status:404, json:{message: "The Isp #{params[:isp_id]} doesn't exist"}
            false
        end
    end

    def set_service
        @service=Service.find_by(id: params[:id])
        if @service.blank?
            render status:404, json:{message: "The Service #{params[:id]} doesn't exist"}
            false
        end
        if @service.isp_id != @isp.id
            render status:404, json:{message: "The Service doesn't correspond to Isp #{params[:isp_id]}"}
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
