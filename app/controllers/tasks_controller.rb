class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
    @task = Task.new
    @projects = Task.project_counts
    @milestones = Task.milestone_counts

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
