# encoding: utf-8

class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @all_projects = Task.project_counts.collect{ |it| it.name }.join(',')
    @current_project = params[:project] || @all_projects

    @task = Task.new
    @projects = Task.project_counts
    
    @project_class = Array.new
    @projects.each { |project| @project_class << ( project.name == @current_project ? 'btn active' : 'btn') }

    @tasks = Task.tagged_with(@current_project.split(','), :on => :projects, :any => true)
    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
    @task = Task.find(params[:id])
    @projects = Task.top_projects

    respond_to do |format|
      format.html { render 'index' }
      format.js # show.js.erb
      format.json { render json: @task }
    end
  end

  def set_status
    @task = Task.find(params[:id])
    status = @task.status + 1
    if @task.status == Task::DONE
      status = Task::DOING
    end

    @task.status = status
    
    # set start_at and finish_at
    case status
    when Task::DOING
      @task.finish_at = nil # reset finish_at
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
    when Task::DONE
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

  def new_project
    @new_task = current_user.tasks.new(:content => "新项目建立")
    @new_task.project_list = params[:project][:name]
    respond_to do |format|
      if @new_task.save
        format.html { redirect_to tasks_path, notice: 'Project was successfully created.' }
        format.js # new_project.js.erb
        format.json { head :no_content }
      else
        format.html { redirect_to tasks_path, notice: 'Project was failed to create.' }
        format.js # new_project.js.erb
        format.json { render json: @task.errors, status: :unprocessable_entity }
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
  
  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])
    respond_with @task
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @tasks = current_user.tasks
    @task = Task.new(:content => params[:task][:content])
    @task.project_list = params[:project][:name]
    @task.user = current_user
    @task.status = Task::TODO

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path }
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
        format.js # update.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # update.js.erb
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to tasks_url }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end
end
