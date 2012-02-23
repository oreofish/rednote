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
      
      respond_to do |format|
          format.html 
      end
  end

  def comments
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @comments = Comment.find_by_sql("SELECT * FROM comments")
      
      respond_to do |format|
          format.html 
      end
  end

  def reading
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @notes = Note.find_by_sql("SELECT * FROM notes")
      
      respond_to do |format|
          format.html 
      end
  end

  def done
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @notes = Note.find_by_sql("SELECT * FROM notes")
      
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

end
