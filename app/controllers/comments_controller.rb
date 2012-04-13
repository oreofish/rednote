class CommentsController < ApplicationController
  include ERB::Util
  before_filter :authorized_user, :only => [:destroy, :update]

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
    @commentable = Object.const_get(params[:comment][:commentable_type]).find(params[:comment][:commentable_id])
    @comment = @commentable.comments.create(:comment => params[:comment][:comment])
    @comment.user_id = current_user.id

    @comment.comment = string_replace(2 , html_escape(@comment.comment)) # repalce the string

    respond_to do |format|
      if @comment.save
        if @comment.commentable_type=='Note'
          create_message(@commentable,@comment)
        end

        format.js 
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.js { render "index" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @commentable = Object.const_get(@comment.commentable_type).find(@comment.commentable_id)

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @commentable, notice: 'Comment was successfully updated.' }
        format.json { respond_with_bip(@comment) }
      else
        format.html { render @commentable, notice: 'Comemnt was unsuccessfully updated.' }
        format.json { respond_with_bip(@comment) }
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

  def create_message(note,comment)
    @at_users = comment.comment.scan(/@[a-zA-Z0-9_]+/)
    if not note.user_id == current_user.id
      @message = comment.infos.create ({
        :user_id => note.user_id,
        :message => comment,
        :refer => 1
      })
      broadcast "/ats/new/#{@message.user_id}", "{ note_id: #{note.id}, meg_type: 'new_comment' }"
    end

    @at_users.each do |at_user|
      user = User.find_by_sql("SELECT users.* FROM users WHERE nickname='#{at_user.from(1)}'") #check user is exist
      if user.size == 1 and not user[0].id == note.user_id #the at_user is not the user who owner the note
        @message = comment.infos.create ({
          :user_id => user[0].id,
          :refer => 1,
          :message => comment
        })
        broadcast "/ats/new/#{@message.user_id}", "{ note_id: #{note.id}, meg_type: 'at_in_comment' }"
      end
    end
  end

end
