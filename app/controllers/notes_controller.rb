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
    session[:current_page] = 0

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /notes/page
  # get next page by ajax request
  def page
    session[:current_page] += 1
    currentPage = session[:current_page]
    @notes = Note.offset(currentPage * 5).limit(5).reverse_order

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
        broadcast '/notes/new', "{ status: true }"
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
        'kind' : #{@note.kind},
        'user' : #{current_user.nickname}
      }/

    respond_to do |format|
      format.html { redirect_to notes_url }
    end
  end

  private
  def authorized_user
    note = current_user.notes.find_by_id(params[:id])
    redirect_to root_path if note.nil?
  end
end
