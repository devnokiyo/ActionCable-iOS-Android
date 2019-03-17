module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    def disconnect
    end

    private
      def find_verified_user
        # 本番サービスならOpenID ConnectのAccessTokenなどをパラメーターに渡して、
        # ユーザーIDなどを割出すと思います。
        if verified_user = User.find_by(account: request.params[:account])
          verified_user
        else
          reject_unauthorized_connection
        end
      end
  end
end
