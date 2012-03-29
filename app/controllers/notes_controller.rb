class NotesController < ApplicationController
  include ERB::Util
  before_filter :authorized_user, :only => :destroy

  # GET /notes
  # GET /notes.json
  def index
    @note = Note.new

    cookies = {
      :limit => 20,
      :offset => 20, # note offset
      :current_user_id => current_user.id
    }

    @notes = Note.where('').offset(0).limit(cookies[:limit]).reverse_order
    @tags = Note.tag_counts.map {|tag| tag.name}

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /notes/taglist
  # get tags
  def taglist
    @tags = Note.tag_counts.map {|tag| tag.name}

    respond_to do |format|
      format.json { render json: @tags }
    end
  end

  # GET /notes/page
  # get next page by ajax request
  def page
    @notes = Note.offset(cookies[:offset].to_i).limit(cookies[:limit]).reverse_order
    cookies[:offset] = @notes.size + cookies[:offset].to_i

    respond_to do |format|
      if @notes.count() > 0
        format.js
      else
        format.js { render :nothing => true }
      end
    end
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note = Note.find(params[:id])
    @comments = @note.comments
    @messages = Array.new

    @note.infos.each do |message|
      @messages << message
    end

    @comments.each do |comment|
      comment.infos.each do |message|
        @messages << message
      end
    end

    @messages.each do |message|
      if message.user_id == current_user.id
        message.read = 0 # 0 means read and 1 means unread
        message.refer = 0
        message.save!
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
    end
  end

  # GET /notes/new
  # GET /notes/new.json
  def new
    respond_to do |format|
      format.html
    end
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = current_user.notes.build(params[:note])
    @attachids = params[:attachments].split(',')

    @at_users = @note.summary.scan(/@[a-zA-Z0-9_]+/)
    
    @note.summary = string_replace(3 , html_escape(@note.summary)) # repalce the string

    if @note.save
      @at_users.each do |at_user|
        user = User.find_by_sql("SELECT users.* FROM users WHERE nickname='#{at_user.from(1)}'") #check user is exist
        if user.size == 1 #because note can not edit so the create note unexist in message table
          @message = @note.infos.create( {
            :user_id => user[0].id,
            :message => @note,
            :refer => 1
          } )
          broadcast "/ats/new/#{@message.user_id}", "{ note_id: #{@note.id}, meg_type: 'at_in_note' }"
        end
      end
      @attachids.each do |attachid|
        attach = Attachement.find(attachid)
        attach.note_id = @note.id and attach.save if not attach.nil?
      end

      broadcast '/notes/new', %Q/ { nickname: "#{current_user.nickname}", status: true } /

          cookies[:offset] = cookies[:offset].to_i + 1
      respond_to do |format|
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
        format.js 
      end
    else
      broadcast '/notes/new', %Q/ { status: false, errors: #{@note.errors.to_json} } /
      respond_to do |format|
        format.html { redirect_to notes_path, notice: 'Note creation was failed.' }
        format.js 
      end
    end
  end

  # PUT /notes/1
  # PUT /notes/1.json
  def update
    @note = Note.find(params[:id])

    respond_to do |format|
      if @note.update_attributes(params[:note])
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note = Note.find(params[:id])
    @note.destroy

    broadcast '/notes/destroy', %Q/ { "nickname" : "#{current_user.nickname}" } /

    cookies[:offset] = cookies[:offset].to_i - 1
    respond_to do |format|
      format.html { redirect_to notes_url }
      format.js
    end
  end

  private
  def authorized_user
    note = current_user.notes.find_by_id(params[:id])
    redirect_to root_path if note.nil?
  end
end
