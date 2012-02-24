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
      @user = current_user

      #if params[:icon] != nil
      #  current_user.avatar = params[:icon]
      #  current_user.save!
      #end

      respond_to do |format|
          format.html # index.html.erb
      end
  end

  def nickname
      @user = current_user

      respond_to do |format|
          format.html  
      end
  end

  def update
      @user = current_user
      @user.update_attributes(params[:user])
      respond_to do |format|
          format.html {redirect_to '/users/index'}
      end
  end

  def crop_update
      @user = current_user
      @user.crop_x = params[:user]["crop_x"]
      @user.crop_y = params[:user]["crop_y"]
      @user.crop_h = params[:user]["crop_h"]
      @user.crop_w = params[:user]["crop_w"]
      @user.save!
      redirect_to '/users/avatar'
  end

end

