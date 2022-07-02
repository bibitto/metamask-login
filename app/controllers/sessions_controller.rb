require "time"
require "eth"

class SessionsController < ApplicationController

    def new
    end

    def create
        # アドレスをもとにユーザーを見つける
        user = User.find_by(eth_address: params[:eth_address])
        if user.present?
            # 署名を確認
            if params[:eth_signature]
                message = params[:eth_message]
                signature = params[:eth_signature]
                user_address = user.eth_address
                user_nonce = user.eth_nonce
                # 署名（eth_signatureの生成）から300秒を過ぎた場合はexpireとする
                custom_title, request_time, signed_nonce = message.split(",")
                request_time = Time.at(request_time.to_f / 1000.0)
                expiry_time = request_time + 300
                sane_checkpoint = Time.parse "2022-01-01 00:00:00 UTC"
                if request_time and request_time > sane_checkpoint and Time.now < expiry_time
                    # 署名のnonce（uuid）がdbのnonceと一致するかの確認
                    if signed_nonce.eql? user_nonce
                        # 署名をもとにアドレスを復元
                        signature_pubkey = Eth::Key.personal_recover message, signature
                        signature_address = Eth::Utils.public_key_to_address signature_pubkey
                        # 復元されたアドレスがdbのアドレスと一致するかの確認(downcaseケースで堅牢にする)
                        if user_address.downcase.eql? signature_address.to_s.downcase
                            # ログイン完了
                            session[:user_id] = user.id
                            # 次回ログインのためにnonce(uuid)を変える
                            user.eth_nonce = SecureRandom.uuid
                            user.save
                            redirect_to root_path, notice: "ログインに成功しました。"
                        else
                            flash.now[:alert] = "サインの検証に失敗しました。"
                            render :new
                        end
                    else
                        flash.now[:alert] = "nonce（uuid）が一致しません。"
                        render :new
                    end
                else
                    flash.now[:alert] = "サインの期限が切れました。もう一度認証してください。"
                    render :new
                end
            else
                flash.now[:alert] = "メタマスクのメッセージを承認してください。"
                render :new
            end
        else

            # user not found in database
            redirect_to signup_path, alert: "そのようなユーザーは存在しません。もう一度挑戦してください。"
        end
    end

    def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "ログアウトしました。"
    end
end