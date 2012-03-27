class CommentsController < ApplicationController
  include ERB::Util
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

    @comment.comment = html_escape(@comment.comment).gsub(/@([a-zA-Z0-9_]+)/,'<a href=\1>@\1</a>').gsub(/(http+:\/\/[^\s]*)/,'<a href=\1>\1</a>').html_safe

    respond_to do |format|
      if @comment.save
        create_message(@note,@comment)

        format.js 
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.js { render "index" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_task
    @task = Task.find(params[:comment][:commentable_id])
    @comment = @task.comments.create(:comment => params[:comment][:comment])
    @comment.user_id = current_user.id

    @comment.comment = html_escape(@comment.comment).gsub(/@([a-zA-Z0-9_]+)/,'<a href=\1>@\1</a>').gsub(/(http+:\/\/[^\s]*)/,'<a href=\1>\1</a>').html_safe

    respond_to do |format|
      if @comment.save
        @task.update_attributes(:start_at => Date.today.beginning_of_week )
        format.js { render "create" }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.js { render "index_task" }
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

  def create_message(note,comment)
    @at_users = comment.comment.scan(/@[a-zA-Z0-9_]+/)
    if not note.user_id == current_user.id
      @message = comment.messages.create ({
        :user_id => note.user_id,
        :message => comment,
        :refer => 1
      })
      broadcast "/ats/new/#{@message.user_id}", "{ note_id: #{note.id}, meg_type: 'new_comment' }"
    end

    @at_users.each do |at_user|
      user = User.find_by_sql("SELECT users.* FROM users WHERE nickname='#{at_user.from(1)}'") #check user is exist
      if user.size == 1 and not user[0].id == note.user_id #the at_user is not the user who owner the note
        @message = comment.messages.create ({
          :user_id => user[0].id,
          :refer => 1,
          :message => comment
        })
        broadcast "/ats/new/#{@message.user_id}", "{ note_id: #{note.id}, meg_type: 'at_in_comment' }"
      end
    end
  end

end
