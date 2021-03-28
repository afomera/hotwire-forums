class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = Current.user.notifications.newest_first.unread
    @previous_notifications = Current.user.notifications.newest_first.read
  end

  def read_all
    Current.user.notifications.mark_as_read!
    redirect_to notifications_path, notice: "Marked all as read"
  end
end
