require "eth"

# アドレスをもとにnonce（uuid）をfetchするAPI
class Api::V1::UsersController < ApiController
    def index
        render json: nil
    end

    def show
        user = nil
        response = nil
        params_address = Eth::Address.new params[:id]
        if params_address.valid?
            user = User.find_by(eth_address: params[:id].downcase)
        end
        if user and user.id > 0
            response = [eth_nonce: user.eth_nonce]
        end
        render json: response
    end
end