class LikesController < ApplicationController
  # POST /likes
  # POST /likes.json
  def create
    @like = current_user.likes.create(:note_id => params[:note_id], :status => false)
    note_id = @like.note_id
    comment_content = "i have marked the note"

    respond_to do |format|
      if @like and @like.save!
        create_comment!(note_id, comment_content).save!
        broadcast '/comments/new', "{ status: true }"
        format.js
      else
        format.html { redirect_to root_url, :notice => :like_create_fail }
      end
    end
  end

  # PUT /likes/1
  # PUT /likes/1.json
  def update
    @like = Like.find(params[:id])
    comment_content = "i have finished learning"
    note_id = @like.note_id

    respond_to do |format|
      if @like.update_attributes(:status => true)
        create_comment!(note_id, comment_content).save!
        broadcast '/comments/new', "{ status: true }"
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likes/1
  # DELETE /likes/1.json
  def destroy
    @like = Like.find(params[:id])
    note_id = @like.note_id
    comment_content = "i have disabled marking the note"
    @like.destroy
    create_comment!(note_id, comment_content).save!
    broadcast '/comments/new', "{ status: true }"

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end

  private 
  def create_comment!(note_id, comment_content)
    @note = Note.find(note_id);
    @comment = @note.comments.create(:comment => "#{comment_content}" )
    @comment.user_id = current_user.id
    return @comment
  end

end
