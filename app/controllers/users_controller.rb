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

  def avatar
        current_user.avatar = params[:icon]
        current_user.save!

      respond_to do |format|
          format.html # index.html.erb
      end
  end

end
