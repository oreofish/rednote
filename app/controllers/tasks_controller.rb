class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.json
  def index
    all_tasks = current_user.tasks
    @manage_tasks = Array.new
    @real_tasks = Array.new
    all_tasks.each do |task|
      if task.parent_id == 0
        @manage_tasks << task
      else
        @real_tasks << task
      end
    end

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
    @subtasks = @task.tasks
    @new_task = Task.new

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
  
  # GET /tasks/new_root
  # GET /tasks/new_root.json
  def new_root
    @task = Task.new

    respond_to do |format|
      format.html # new_root.html.erb
      format.js # new_root.js.erb
      format.json { render json: @task }
    end
  end
  
  # POST /tasks/create_root
  # POST /tasks/create_root.json
  def create_root
    @task = Task.new(params[:task])
    @task.parent_id = 0
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to tasks_path }
        format.json { render json: @task, status: :created, location: @task }
      else
        format.html { render action: "new_root" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @tasks = current_user.tasks
    @task = Task.new(params[:task])
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
