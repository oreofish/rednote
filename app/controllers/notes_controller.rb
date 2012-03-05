class NotesController < ApplicationController
  before_filter :authorized_user, :only => :destroy

  # GET /notes
  # GET /notes.json
  def index
    @note = Note.new
	@languages = [
      "C","Clojure","CSS","Delphi","DIFF","ERB","Groovy","HAML","HTML",
      "Java","JavaScript","JSON","PHP","Python","Ruby","SQL","XML","YAML"
    ]

    @notes = Note.where('').offset(0).limit(5).reverse_order
    cookies[:limit] = 5
    cookies[:offset] = 5 # note offset
    cookies[:current_user_id] = current_user.id


    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /notes/page
  # get next page by ajax request
  def page
    @notes = Note.offset(cookies[:offset].to_i).limit(cookies[:limit]).reverse_order
    cookies[:offset] = 5 + cookies[:offset].to_i

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
    if @note.kind == attachmentKindValue(:code)
      # hack: insert code lang into special tag
      @note.description = 
        "@@#{params[:language][:id].strip.downcase.to_sym}@@\n" + @note.description
    end

    respond_to do |format|
      if @note.save
        broadcast '/notes/new', %Q/
          {
            nickname: "#{current_user.nickname}", 
            status: true 
          }/

        cookies[:offset] = cookies[:offset].to_i + 1
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
        format.js 
      else
        broadcast '/notes/new', "{ status: false }"
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
