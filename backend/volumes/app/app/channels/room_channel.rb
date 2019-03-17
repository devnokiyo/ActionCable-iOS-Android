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
      Rails.cache.read(key)
    end

    private def room_in(key:, account:)
      locker = Mutex::new
      locker.synchronize do
        list = Rails.cache.read(key) || []
        list << account
        list.uniq!
        Rails.cache.write(key, list)  
        list
      end
    end

    private def room_out(key:, account:)
      locker = Mutex::new
      locker.synchronize do
        list = Rails.cache.read(key) || []
        list.delete_if {|item| item == account }
        list.uniq!
        Rails.cache.write(key, list)
        list
      end
    end
  end

  private define_method :roommate, &method(:roommate)
  private define_method :room_in, &method(:room_in)
  private define_method :room_out, &method(:room_out)
end
