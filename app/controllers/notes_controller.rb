class NotesController < ApplicationController
  include ERB::Util
  before_filter :authorized_user, :only => :destroy

  # GET /notes
  # GET /notes.json
  def index
    @note = Note.new

    cookies[:limit] = 20
    cookies[:offset] = 20 # note offset
    cookies[:current_user_id] = current_user.id
    @notes = Note.where('').offset(0).limit(cookies[:limit]).reverse_order

    respond_to do |format|
      format.html # index.html.erb
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

    respond_to do |format|
      format.html # show.html.erb
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

    @ats = @note.summary.scan(/@[a-zA-Z0-9_]+/)
    @at = At.new
    @note.summary = html_escape(@note.summary).gsub(/@([a-zA-Z0-9_]+)/,'<a href=\1>@\1</a>').gsub(/(http+:\/\/[^\s]*)/,'<a href=\1>\1</a>').gsub(/\?$/,"<img height=\"18\" src=\"/images/wenhao.jpg\" width=\"18\">").html_safe

    respond_to do |format|
      if @note.save
        @ats.each do |at|
          user =  User.find_by_sql("SELECT users.* FROM users WHERE nickname='#{at.from(1)}'")
          if user.size == 1
            @at.user_id = User.find_by_sql("SELECT users.* FROM users WHERE nickname='#{at.from(1)}'")[0].id
            @at.at_type = "Note"
            @at.at_id = @note.id
            @at.save!
          end
        end
        @attachids.each do |attachid|
          attach = Attachement.find(attachid)
          attach.note_id = @note.id and attach.save if not attach.nil?
        end

        broadcast '/notes/new', %Q/
          {
            nickname: "#{current_user.nickname}", 
            status: true 
          }/

          cookies[:offset] = cookies[:offset].to_i + 1
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
        format.js 
      else
        broadcast '/notes/new', %Q/
          {
            status: false,
            errors: #{@note.errors.to_json}
          }/
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
    broadcast '/notes/destroy', %Q/
      { 
        "nickname" : "#{current_user.nickname}"
      }/

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
