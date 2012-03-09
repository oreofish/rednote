# encoding: utf-8

class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Task.project_counts

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project_name = params[:id]
    @projects = Task.project_counts

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @project }
    end
  end

  def history
    #mock
    respond_to do |format|
      format.html # history.html.erb
      format.js # history.js.erb
      format.json { render json: @project }
    end
  end

  def knowledgebase
    #mock
    respond_to do |format|
      format.html # knowledgebase.html.erb
      format.js # knowledgebase.js.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @new_task = current_user.tasks.new(:content => "新项目建立", :status => Task::DONE)
    @new_task.project_list = params[:project][:name]

    respond_to do |format|
      if @new_task.save
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.js # create.js.erb
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { redirect_to projects_path, notice: 'Project was successfully created.' }
        format.js # create.js.erb
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
  end
end
