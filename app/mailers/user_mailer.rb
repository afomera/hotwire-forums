class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_post_notification.subject
  #
  def new_post_notification
    @user = params[:recipient]
    @post = params[:post]

    mail(to: @user.email, subject: "There's been a new reply in #{@post.discussion.name}.")
  end
end
