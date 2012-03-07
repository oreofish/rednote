class UsersController < ApplicationController
    before_filter :default_avatar, :except => [:search_nickname, :search_email]
    before_filter :all_users, :except => [:search_nickname, :search_email]

  def show
      @user = User.find(params[:id])

      cookies[:limit] = 20
      cookies[:offset] = 20 # note offset

      @avatar = @user.avatar
      @nickname = @user.nickname
      @notes_size = @user.notes.size
      @notes = @user.notes.offset(0).limit(cookies[:limit]).reverse_order

      respond_to do |format|
          format.html
          format.js
      end
  end

  # GET /users/page
  # get next page by ajax request
  def page
    @user = User.find(params[:id])

    @notes = @user.notes.offset(cookies[:offset].to_i).limit(cookies[:limit]).reverse_order
    cookies[:offset] = @notes.size + cookies[:offset].to_i

    respond_to do |format|
      if @notes.count() > 0
        format.js
      else
        format.js { render :nothing => true }
      end
    end
  end

  def mycomments
      @user = User.find(params[:id])
      @avatar = @user.avatar
      @nickname = @user.nickname
      @comments = @user.comments

      @comments.reverse!
      
      respond_to do |format|
          format.html { render 'show' }
          format.js { render 'show' }
      end
  end

  def mytasks
    @user = User.find(params[:id])
    @avatar = @user.avatar
    @nickname = @user.nickname
    
    @tasks = @user.tasks

    respond_to do |format|
      format.html { render 'show' }
      format.js { render 'show' }
    end
  end
  
  def mytags
      @user = User.find(params[:id])
      @avatar = @user.avatar
      @nickname = @user.nickname
      @notes = Note.find_by_sql("SELECT notes.* FROM notes WHERE id IN (SELECT note_id FROM likes WHERE user_id=#{@user.id} ) ORDER BY created_at DESC")
      
      respond_to do |format|
          format.html { render 'show' }
          format.js { render 'show' }
      end
  end

  def avatar

      respond_to do |format|
          format.html { render 'settings' }
          format.js { render 'devise/registrations/edit' }
      end
  end

  def nickname
      @user = current_user

      respond_to do |format|
          format.html { render 'settings' }
          format.js { render 'devise/registrations/edit' }
      end
  end

  def avatar_update

        current_user.preview = params[:user]["preview"]
        current_user.preview_cache = params[:user]["preview_cache"]
        current_user.save!

      respond_to do |format|
          format.html {redirect_to '/users/avatar'}
      end
  end

  def crop_update
      @user = current_user
      current_user.crop_x = params[:user]["crop_x"]
      current_user.crop_y = params[:user]["crop_y"]
      current_user.crop_h = params[:user]["crop_h"]
      current_user.crop_w = params[:user]["crop_w"]
      current_user.avatar = current_user.preview
      current_user.save!

      redirect_to user_path(current_user)
  end

  def search_nickname
      @name = params[:val]
      @user_by_nickname = User.find_by_sql("SELECT users.* FROM users WHERE nickname='#{@name}'")

      if @user_by_nickname.size == 0  
        render :inline => "ture" 
      else 
        render :inline => "false" 
      end
  end

  def search_email
      @email = params[:val]
      @user_by_email = User.find_by_sql("SELECT users.* FROM users WHERE email='#{@email}'")

      if @user_by_email.size == 0
        render :inline => "ture" 
      else 
        render :inline => "false" 
      end
  end

  private
  def default_avatar
      @user = current_user

      if @user.avatar.blank? 
         @user.avatar = File.open('public/images/avatar.jpg')
         @user.preview = @user.avatar 
         @user.save
      end
  end

  def all_users
    @users = User.all
  end

end

