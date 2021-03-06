class RoomChannel < ApplicationCable::Channel
  def subscribed
    @room = params[:room]
    @user = self.current_user.id.to_s + @room
    stream_for @room
    stream_for @user

    room_in(key: @room, account: self.current_user.account)
  end

  def unsubscribed
    room_out(key: @room, account: self.current_user.account)

    # 全員に送ります。
    RoomChannel.broadcast_to(@room, account: self.current_user.account, type: :out)
  end

  def greeting
    # 全員に送ります。
    RoomChannel.broadcast_to(@room, roommate: roommate(key: @room), account: self.current_user.account, type: :in)
  end

  def mumbling
    # 独り言です。
    RoomChannel.broadcast_to(@user, content: '(ﾟДﾟ;)', account: self.current_user.account, type: :mumbling)
  end

  def bark(data)
    # 全員に送ります。
    RoomChannel.broadcast_to( \
      @room, content: data["content"], account: self.current_user.account, type: :bark)
  end

  class << self
    private def roommate(key:)
      REDIS.smembers(key) || []
    end

    private def room_in(key:, account:)
      ROOMMATE_COUNTER_MUTEX.synchronize do
        REDIS.sadd(key, account)
        REDIS.smembers(key) || []
        end
    end

    private def room_out(key:, account:)
      ROOMMATE_COUNTER_MUTEX.synchronize do
        REDIS.srem(key, account)
        REDIS.smembers(key) || []
        end
    end
  end

  private define_method :roommate, &method(:roommate)
  private define_method :room_in, &method(:room_in)
  private define_method :room_out, &method(:room_out)
end
