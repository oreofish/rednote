# encoding: utf-8

class TasksController < ApplicationController
  before_filter :authorized_user, :only => :destroy
  respond_to :js, :html
  
  # GET /tasks
  # GET /tasks.json
  def index
    @current_project = Project.find(params[:project])
    @task = Task.new
    @tasks = @current_project.tasks.find_all_by_status(Task::TODO)

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @tasks }
    end
  end

  def history
    @current_project = Project.find(params[:project])
    @old_tasks = @current_project.tasks.find_all_by_status(Task::DONE)

    respond_to do |format|
      format.html # history.html.erb
      format.js # history.js.erb
      format.json { render json: @tasks }
    end
  end

  def discuss
    @current_project = Project.find(params[:project])
    @comments = Comment.find_by_sql("select distinct commentable_id from (select commentable_id from comments where commentable_type = 'Task' order by created_at DESC) as new where commentable_id in (select id from tasks where project_id = #{@current_project.id}) limit 6")
    @tasks = Array.new
    @comments.each do |comment|
      @task = Task.find(comment.commentable_id)
      @tasks << @task 
    end

    respond_to do |format|
      format.html 
      format.js 
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    @comment = Comment.new
    @comments = @task.comments
    @project = @task.project

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @task }
    end
  end

  def show_partial
    @task = Task.find(params[:id])

    respond_to do |format|
      format.json { render json: @task }
    end
  end

  def set_status
    @task = Task.find(params[:id])
    
    #update status of task
    @oldstatus = @task.status
    @task.status += 2
    @task.status = Task::TODO if @oldstatus == Task::DONE
    
    # set start_at and finish_at
    case @task.status
    when Task::DOING # set start_at
      last_done_task = Task.find(:first, :order => "finish_at DESC")
      if last_done_task
        if last_done_task.finish_at.nil? or last_done_task.finish_at.to_datetime.cweek != Date.today.cweek
          @task.start_at = Date.today.beginning_of_week
        else
          @task.start_at = last_done_task.finish_at
        end
      else
        @task.start_at = Date.today.beginning_of_week
      end
    when Task::DONE #set finish_at
      @task.touch(:finish_at)
    end
    
    respond_to do |format|
      if @task.save
        #format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.js
      else
        #format.html { redirect_to tasks_path, notice: 'Task was failed to updated.' }
        format.js
      end
    end
  end

  def set_tag
    @task = Task.find(params[:task][:id])
    @task.project_list = params[:project][:name]
    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Project was successfully update.' }
        format.js
      else
        format.html { redirect_to @task, notice: 'Project was failed to update.' }
        format.js
      end
    end
  end

  def assign
    @task = Task.find(params[:taskid].sub('task', ''))
    userid = params[:userid].sub('user', '').to_i
    @user = User.find(userid) if @task.estimate.to_f > 0 and @task.assigned_to.nil?
    respond_to do |format|
      if @user and @task.update_attributes(:assigned_to => userid)
        format.js
      else
        format.js
      end
    end
  end
  
  def mytasks
    @user = User.find(params[:id])
    @avatar = @user.avatar
    @nickname = @user.nickname
    
    @mytasks = @user.tasks
    @assigned_to_me_tasks = Task.find_all_by_assigned_to(@user.id)
    @projects = Task.top_projects

    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /tasks/1/edit
  def edit
#    @task = Task.find(params[:id])
#    respond_to do |format|
#      format.js # edit.js.erb
#    end
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])
    respond_with @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @tasks = current_user.tasks
    @task = current_user.tasks.new(:project_id => params[:task][:project_id],
                                   :content => params[:task][:content]
                                   )
    @task.status = Task::TODO
    @task.assigned_to = @current_user.id
    @task.estimate = 0.0

    respond_to do |format|
      if @task.save
        #current_user.send_message(@users, "#{current_user.nickname} 创建任务：#{@task.content}", "创建新任务")
        format.html { redirect_to project_path(params[:project][:name]) }
        format.js # create.js.erb
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "index" }
        format.js # create.js.erb
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.json
  def update
    @task = Task.find(params[:id])
    @project = @task.project

    respond_to do |format|
      if @task.update_attributes(params[:task])
        if not params[:task][:assigned_to].nil? and params[:task][:assigned_to].to_i > 0
          @receiver = User.find(params[:task][:assigned_to])
          subject = "[#{@project.name}]收到任务：#{@task.content}"
          UserMailer.task_assign_notify(@receiver.email, subject, @task, current_user).deliver
          # current_user.send_message(@receive_user, "<b>#{current_user.nickname} 将任务：#{@task.content}指派给你</b>", "收到新任务")
        end
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { respond_with_bip(@task) }
      else
        format.html { render action: "edit", notice: 'Assigned task was not allowed to update, Please add comment.' }
        format.json { respond_with_bip(@task) }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    if @task.assigned_to.nil?
      @task.destroy
    end

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Assigned task was not allowed to destroy.' }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end

  private
  def authorized_user
    task = current_user.tasks.find_by_id(params[:id])
    redirect_to root_path if task.nil?
  end
  
end
