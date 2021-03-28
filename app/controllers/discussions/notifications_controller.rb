module Discussions
  class NotificationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_discussion

    def create
      @discussion.toggle_subscription(Current.user)
      redirect_to @discussion
    end

    private

    def set_discussion
      @discussion = Discussion.find(params[:discussion_id])
    end
  end
end
