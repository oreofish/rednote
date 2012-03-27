class QuestionsController < ApplicationController
  # GET /questions
  # GET /questions.json
  def index
    @current_project = params[:project]
    @question = Question.new

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @questions }
    end
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id].sub('question', ''))
    @answers = @question.answers
    @new_answer = Answer.new

    respond_to do |format|
      format.js # show.js.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/new
  # GET /questions/new.json
  def new
    @question = Question.new

    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
      format.json { render json: @question }
    end
  end

  # GET /questions/1/edit
  def edit
    @question = Question.find(params[:id])
  end

  # POST /questions
  # POST /questions.json
  def create
    @questions = Question.all
    @question = current_user.questions.new(params[:question])

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.js # create.js.erb
        format.json { render json: @question, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.js # create.js.erb
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /questions/1
  # PUT /questions/1.json
  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.js # update.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # update.js.erb
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_url }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end
end
