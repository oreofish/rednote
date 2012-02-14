class UsersController < ApplicationController
    before_filter :default_avatar
  def index
      @nickname = current_user.nickname
      @notes = current_user.notes
      @notes_size = current_user.notes.size
      
      respond_to do |format|
          format.html # index.html.erb
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

  private
    def default_avatar
        if current_user.avatar == nil
            current_user.avatar = "/images/icons/0.jpeg"
        end
    end
end
