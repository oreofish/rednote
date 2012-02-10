class NotesController < ApplicationController
  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all

    respond_to do |format|
      format.html # index.html.erb
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
    # according to kind of note to create
    # kind = {
    #   1 : blog, 
    #   2 : link,
    #   3 : image,
    #   4 : code
    # };
    respond_to do |format|
      format.html
    end
  end

  # params[:nickname]
  def newblog
    
    @note = Note.new
    @note.content = 'write something here'
    @note.kind = 1

    respond_to do |format|
      if current_user.nickname != params[:nickname] 
        format.html { redirect_to notes_path }
      else
        format.html { render "new" }
      end
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

    respond_to do |format|
      if @note.save
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
      else
        format.html { render action: "new" }
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

    respond_to do |format|
      format.html { redirect_to notes_url }
    end
  end
end
