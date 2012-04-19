class UserMailer < ActionMailer::Base
  default from: "sycao@redflag-linux.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.notify.subject
  #
  def notify(email, subject, body)
    mail( to: email, subject: subject ) do |format|
      format.text { render :text => body }
    end
  end

  def task_assign_notify(email, subject, task, sender)
    @task = task
    @sender = sender

    mail( to: email, subject: subject ) do |format|
      format.html 
    end
  end

  def daily_notify( update_task, update_user)
    subject = "daily recap"
    @emails = ""
    User.all.each do |user|
      @emails += user.email + ","
    end
    @project_users = update_user
    @project_tasks = update_task
    @projects = Project.all
    tag = 0

    @project_tasks.each do |project_task|
      if project_task == [] and tag > 0
        @projects -= Project.find(tag)
      end
      tag += 1
    end

    mail( to: @emails, subject: subject ) do |format|
      format.html 
    end
  end
end
