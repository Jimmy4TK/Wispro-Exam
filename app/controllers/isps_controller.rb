class IspsController < ApplicationController
    before_action :set_isp, only:[:show,:update,:destroy]
    before_action :check_token, except:[:index,:show,:create]

    def index
        @isps=Isp.all.select("id,name,created_at,updated_at")
        render status:200, json:{isps: @isps}
    end

    def show
        @isp
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

    private

    def set_isp
        @isp=Isp.find_by(id: params[:id])
        if @isp.blank?
            render status:404, json:{message: "Isp #{params[:id]} doesn't exist"}
            false
        end
    end

    def check_token
        if request.headers["Authorization"] != "Bearer #{@isp.token}"
            render status:400, json:{message: "Token isn't valid"}
            false
        end
    end

end
