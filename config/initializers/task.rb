require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 17 * * 2' do
  Book.all.each {|p| p.status = "keep"; p.save!}
  Debit.all.first
end

scheduler.cron '50 23 * * *' do
  @tasks = Task.find_by_sql("select * from tasks where status=#{Task::DONE} and finish_at > '#{Date.today.to_datetime.to_formatted_s(:db)}'")
  if @tasks.nil?
    return
  end
  
  @project_tasks = Array.new(Project.all.length+1)
  @project_users = Array.new(Project.all.length+1)

  @tasks.each do |task|
    @project_tasks[task.project_id] = [] if @project_tasks[task.project_id].nil?
    @project_users[task.project_id] = [] if @project_users[task.project_id].nil?
    @project_tasks[task.project_id] << task
    @project_users[task.project_id] << task.user
  end

  UserMailer.daily_notify(@project_tasks,@project_users).deliver

end
#scheduler.cron '31 17 * * 1' do
#  books = Book.find_by_sql("SELECT books.* FROM books WHERE status='keep' ")
#  books.each do |book|
#    debits = Debit.find_by_sql("SELECT debits.* FROM debits WHERE book_id=#{book.id}")
#    if debits.first != nil
#      debits.first.destroy
#    end
#  end
#end
