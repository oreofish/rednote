class UsersController < ApplicationController
  def index
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @notes = current_user.notes
      @notes_size = current_user.notes.size
      
      respond_to do |format|
          format.html # index.html.erb
      end
  end

  def mycomments
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @comments = current_user.comments

      @comments.reverse!
      
      respond_to do |format|
          format.html 
      end
  end

  def comments
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @comments = Comment.find_by_sql("SELECT comments.* FROM comments WHERE commentable_id IN (SELECT id FROM notes WHERE user_id = #{current_user.id}) ORDER BY created_at DESC")
      
      respond_to do |format|
          format.html 
      end
  end

  def mytags
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @notes = Note.find_by_sql("SELECT notes.* FROM notes WHERE id IN (SELECT note_id FROM likes WHERE user_id=#{current_user.id} ) ORDER BY created_at DESC")
      
      respond_to do |format|
          format.html 
      end
  end

  def avatar
      if params[:icon] != nil
        current_user.avatar = params[:icon]
        current_user.save!
      end

      respond_to do |format|
          format.html # index.html.erb
      end
  end

end
