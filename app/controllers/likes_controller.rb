class LikesController < ApplicationController
  # POST /likes
  # POST /likes.json
  def create
    @like = current_user.likes.create(:note_id => params[:note_id], :status => false)

    respond_to do |format|
      if @like and @like.save!
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

    respond_to do |format|
      if @like.update_attributes(:status => true)
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
    @like.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.js
    end
  end
end
