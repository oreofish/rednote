# encoding: utf-8

class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  def index
    @projects = Task.project_counts

    @month = (params[:month] || Time.zone.now.month).to_i
    @year = (params[:year] || Time.zone.now.year).to_i
    @shown_month = Date.civil(@year, @month)

    # filter out tasks that act as projects
    start_d, end_d = Task.get_start_and_end_dates(@shown_month) 

    #tasks = Task.events_for_date_range(start_d, end_d).sort do |x, y|
      #x.project_counts[0].name <=> y.project_counts[0].name
    #end

    #i = 0
    #project_like_tasks = tasks.select do |x|
      #j = i
      #i += 1
      #j == 0 or (j > 0 and (x.project_list[0] != tasks[j-1].project_list[0]))
    #end

    project_like_tasks = Task.events_for_date_range(start_d, end_d).select do |task|
       task.content == '新项目建立' and task.project_list.size > 0
    end
    @project_strips = Task.create_event_strips(start_d, end_d, project_like_tasks)

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

  # GET /projects/1/edit
  #def edit
  #end

  # POST /projects
  # POST /projects.json
  def create
    @new_task = current_user.tasks.new(:content => "新项目建立",
                                       :status => Task::DONE,
                                       :start_at => Date.today,
                                       :finish_at => Date.today.to_datetime + 7
                                       )
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
  #def update
  #end

  # DELETE /projects/1
  # DELETE /projects/1.json
  #def destroy
  #end
end
