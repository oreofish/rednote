# encoding: utf-8

class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
    @project = Project.new

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])

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

  # GET /projects/1/edit
  #def edit
  #end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(params[:project])

    respond_to do |format|
      if @project.save
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
  #def update
  #end

  # DELETE /projects/1
  # DELETE /projects/1.json
  #def destroy
  #end
end
