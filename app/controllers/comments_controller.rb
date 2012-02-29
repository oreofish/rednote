class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @note = Note.find(params[:note_id])
    @note.touch if @note.user_id == current_user.id

    @like = current_user.likes.find_by_note_id(@note.id)
    @like.touch if not @like.nil?

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
        broadcast '/comments/new', "{ status: true }"
         @comments = @note.comments
         @comment = Comment.new(:commentable_id => @note.id)
        format.js { render "index" }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        broadcast '/comments/new', "{ status: false }"
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
end
