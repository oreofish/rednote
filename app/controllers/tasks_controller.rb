# encoding: utf-8

class TasksController < ApplicationController
  before_filter :authorized_user, :only => :destroy
  respond_to :js, :html
  
  # GET /tasks
  # GET /tasks.json
  def index
    @current_project = params[:project]
    @task = Task.new
    all_tasks = Task.tagged_with(@current_project.split(','), :on => :projects, :any => true)
    @tasks = Array.new
    all_tasks.each do |task|
      @tasks << task if task.assigned_to == nil and task.status == Task::TODO
    end

    @questions = Question.tagged_with(@current_project.split(','), :on => :projects, :any => true)
    @question = Question.new

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @tasks }
    end
  end

  def history
    @current_project = params[:project]
    all_tasks = Task.tagged_with(@current_project.split(','), :on => :projects, :any => true)
    @old_tasks = Array.new
    all_tasks.each do |task|
      @old_tasks << task if task.status == Task::DONE and task.finish_at.to_datetime.cweek != Date.today.cweek
    end

    respond_to do |format|
      format.html # history.html.erb
      format.js # history.js.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    @projects = Task.top_projects

    respond_to do |format|
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
    @task.status += 1
    @task.status = Task::DOING if @oldstatus == Task::DONE
    
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
        format.html { redirect_to tasks_path, notice: 'Task was successfully updated.' }
        format.js
      else
        format.html { redirect_to tasks_path, notice: 'Task was failed to updated.' }
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
    @user = User.find(userid) if @task.estimate.to_f > 0
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
    @task = current_user.tasks.new(:content => params[:task][:content])
    @task.project_list = params[:project][:name]
    @task.status = Task::TODO

    respond_to do |format|
      if @task.save
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

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { respond_with_bip(@task) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@task) }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to :back }
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
