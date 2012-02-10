class UsersController < ApplicationController
  def index
      @nickname = current_user.nickname
      @notes = current_user.notes
      @notes_size = current_user.notes.size
      #@comments = current_user.comments 
      respond_to do |format|
          format.html # index.html.erb
      end
  end

end
