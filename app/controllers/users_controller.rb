class UsersController < ApplicationController
  def index
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @notes = current_user.notes.offset(0).limit(5).reverse_order
      @notes_size = current_user.notes.size

      cookies[:limit] = 5
      cookies[:offset] = 5 # note offset

      respond_to do |format|
          format.html
          format.js
      end
  end

  # GET /users/page
  # get next page by ajax request
  def page
    @notes = current_user.notes.offset(cookies[:offset].to_i).limit(cookies[:limit]).reverse_order

    cookies[:offset] = 5 + cookies[:offset].to_i

    respond_to do |format|
      if @notes.count() > 0
        format.js
      else
        format.js { render :nothing => true }
      end
    end
  end

  def mycomments
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @comments = current_user.comments

      @comments.reverse!
      
      respond_to do |format|
          format.html { render 'index' }
          format.js { render 'index' }
      end
  end

  def comments
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @comments = Comment.find_by_sql("SELECT comments.* FROM comments WHERE commentable_id IN (SELECT id FROM notes WHERE user_id = #{current_user.id}) ORDER BY created_at DESC")
      
      respond_to do |format|
          format.html { render 'index' } 
          format.js { render 'index' }
      end
  end

  def mytags
      @avatar = current_user.avatar
      @nickname = current_user.nickname
      @notes = Note.find_by_sql("SELECT notes.* FROM notes WHERE id IN (SELECT note_id FROM likes WHERE user_id=#{current_user.id} ) ORDER BY created_at DESC")
      
      respond_to do |format|
          format.html { render 'index' }
          format.js { render 'index' }
      end
  end

  def avatar
      @user = current_user

      #if params[:icon] != nil
      #  current_user.avatar = params[:icon]
      #  current_user.save!
      #end

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

