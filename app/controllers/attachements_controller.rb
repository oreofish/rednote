class AttachementsController < ApplicationController
  # POST /attachments
  def create
    @attachement = current_user.attachements.new
    @attachement.user_id = current_user.id
    @attachement.url = params[:file]

    respond_to do |format|
      if @attachement.save
        #format.html { render :json => '{"jsonrpc" : "2.0", "result" : null, "id" : "id"}' }
        format.html { render :json => %Q/
        {
          "jsonrpc": "2.0",
          "attachment_id": "#{@attachement.id}",
          "url": "#{@attachement.url.url}",
          "name": "#{@attachement.url.identifier}"
        }
        /}
      else
        format.html { render :nothing => true }
      end
    end
  end

end
