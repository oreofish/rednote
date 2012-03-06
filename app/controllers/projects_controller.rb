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

  def baseinfo
    #mock
    respond_to do |format|
      format.html # baseinfo.html.erb
      format.js # baseinfo.js.erb
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
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @new_task = current_user.tasks.new(:content => "新项目建立")
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
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.js # update.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # update.js.erb
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end
end
