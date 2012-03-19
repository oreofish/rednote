class AnswersController < ApplicationController
  # GET /answers
  # GET /answers.json
  def index
    @questions = Answer.find_all_by_question_id(0)
    @new_answer = Answer.new

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @answers }
    end
  end

  # GET /answers/1
  # GET /answers/1.json
  def show
    @question = Answer.find(params[:id])
    @answers = @question.answers
    @new_question = Answer.new
    @new_answer = Answer.new

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @question }
    end
  end

  # GET /answers/1/edit
  def edit
    @answer = Answer.find(params[:id])
  end

  # POST /answers
  # POST /answers.json
  def create
    @questions = Answer.find_all_by_question_id(0)
    @new_answer = Answer.new
    question_id = params[:answer][:question_id].to_i
    content = params[:answer][:content]
    if question_id != 0
      content = RDiscount.new(content).to_html
    end
    answer = current_user.answers.new(:content => content,
                                       :question_id => question_id,
                                       :done => false )
    path = answers_path
    if question_id != 0
      path = Answer.find(question_id)
    end

    respond_to do |format|
      if answer.save
        format.html { redirect_to path, notice: 'Answer was successfully created.' }
        format.js # create.js.erb
        format.json { render json: answer, status: :created, location: answer }
      else
        format.html { redirect_to path, notice: 'Answer was successfully created.' }
        format.js # create.js.erb
        format.json { render json: answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /answers/1
  # PUT /answers/1.json
  def update
    @question = Answer.find(params[:id])
    @answers = @question.answers
    @new_question = Answer.new
    @new_answer = Answer.new

    respond_to do |format|
      if @new_answer.update_attributes(params[:answer])
        format.html { redirect_to @new_answer, notice: 'Answer was successfully updated.' }
        format.js # update.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # update.js.erb
        format.json { render json: @new_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to answers_url }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end
end
