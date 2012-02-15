class MailsController < ApplicationController
  before_filter :authenticate_user!
	
  def index
    #  if can? :rank, Idea
    respond_to do |format|
      format.html
      format.js
    end
  end

  def interview
    subject = params[:subject]
    body = params[:body]
    interviews = params[:interview].split("\n")
    
    interviews.each do |it|
      email, user, time = it.split(",")
      current_body = body.sub("__TIME__", time.strip).sub("__NAME__", user.strip)
      UserMailer.notify(email.strip, subject, current_body).deliver
    end
    
    render :text => interviews
  end
  
  def invite
    emails = params[:invite].split("\n")
    if emails.count == 1 and emails[0] == 'all'
      users = User.find(:all)
      users.each do |user|
        UserMailer.notify(user).deliver
      end
      render :text => users.count
      return
    end
    
    emails.each do |email|
      email.strip!
      user = User.find_by_email(email)
      if user
        # registered user
        UserMailer.notify(user).deliver
      else
        # non registered user
        password = "abc123"
        User.create!(:email => email, :password => password,
                     :password_confirmation => password)
      end
    end
    render :text => emails
  end
end
