class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        # 全てのログイン情報が正しく記入されていることを確認
        if @user and @user.username and @user.username.size > 0
            # nonce(uuid)を生成
            @user.eth_nonce = SecureRandom.uuid
            # アドレスが入力されていることを確認
            if @user.eth_address
                # 登録されたアドレスが妥当性を判定
                address = Eth::Address.new @user.eth_address
                if address.valid?
                    # 新規ユーザーを検証＆dbに保存
                    if @user.save
                        #ログイン画面に遷移して通知
                        redirect_to login_path, notice: "アカウントの作成に成功しました。"
                    else
                        redirect_to login_path, alert: "既にアカウントが存在します。"
                    end
                else
                    flash.now[:alert] = "間違ったウォレットアドレスです。"
                    render :new
                end
            else
                flash.now[:alert] = "ウォレットアドレスの取得に失敗しました。"
                render :new
            end
        else
            flash.now[:alert] = "名前を入力してください。"
            render :new
        end
    end

    private
    def user_params
        params.require(:user).permit(:username, :eth_address)
    end
end