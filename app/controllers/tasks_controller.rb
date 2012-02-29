# encoding: utf-8

class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @all_projects = Task.project_counts.collect{ |it| it.name }.join(',')
    @all_milestones = Task.milestone_counts.collect{ |it| it.name }.join(',')
    @current_project = params[:project] || @all_projects
    @current_milestone = params[:milestone] || @all_milestones

    @task = Task.new
    @projects = Task.project_counts
    @milestones = Task.milestone_counts
    
    @tasks = Task.tagged_with(@current_project.split(','), :on => :projects, :any => true)
                 .tagged_with(@current_milestone.split(','), :on => :milestones, :any => true)
    
    @project_class = Array.new
    @projects.each { |project| @project_class << ( project.name == @current_project ? 'btn active' : 'btn') }
    @milestone_class = Array.new
    @milestones.each { |milestone| @milestone_class << ( milestone.name == @current_milestone ? 'btn active' : 'btn') }

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
    @milestones = Task.top_milestones

    respond_to do |format|
      format.html { render 'index' }
      format.js # show.js.erb
      format.json { render json: @task }
    end
  end

  def done
    @task = Task.find(params[:id])
    respond_to do |format|
      if @task.update_attributes(:status => 1)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.js # done.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # done.js.erb
        format.json { render json: @task.errors, status: :unprocessable_entity }
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
  
  def new_milestone
    @new_task = current_user.tasks.new(:content => "新里程碑建立")
    @new_task.milestone_list = params[:milestone][:name]
    respond_to do |format|
      if @new_task.save
        format.html { redirect_to tasks_path, notice: 'Milestone was successfully created.' }
        format.js # new_milestone.js.erb
        format.json { head :no_content }
      else
        format.html { redirect_to tasks_path, notice: 'Milestone was failed to create.' }
        format.js # new_milestone.js.erb
        format.json { render json: @task.errors, status: :unprocessable_entity }
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
    @task = Task.new(params[:id])
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task.parent }
        format.js # create.js.erb
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new" }
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
