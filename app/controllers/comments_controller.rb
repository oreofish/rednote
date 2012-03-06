class CommentsController < ApplicationController
  before_filter :authorized_user, :only => [:destroy]

  # GET /comments
  # GET /comments.json
  def index
    @note = Note.find(params[:note_id])
    if @note.user_id == current_user.id
      @note.message = 0
      @note.save
    end

    @comment = Comment.new(:commentable_id => @note.id)
    @comments = @note.comments

    respond_to do |format|
      format.js # index.js.erb
      format.json { render json: @comments }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @note = Note.find(params[:comment][:commentable_id])
    @comment = @note.comments.create(:comment => params[:comment][:comment])
    @comment.user_id = current_user.id

    respond_to do |format|
      if @comment.save
        if not @note.user_id == @comment.user_id
          broadcast "/comments/new/#{@note.user_id}", "{ note_id: #{@note.id} }"
          @note.message += 1 
          @note.save
        end
         @comments = @note.comments
         @comment = Comment.new(:commentable_id => @note.id)
        format.js { render "index" }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.js { render "index" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.js 
    end
  end
  
  def dono
    @note_id = params[:note_id]

    respond_to do |format|
      format.js
    end
  end

  def authorized_user
    comment = current_user.comments.find_by_id(params[:id])
    redirect_to root_url if comment.nil?
  end
end
