class NotesController < ApplicationController
  before_filter :authorized_user, :only => :destroy

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.offset(0).limit(5)
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
    @notes = Note.offset(currentPage * 5).limit(5)

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
    # according to kind of note to create
    # kind = {
    #   1 : blog, 
    #   2 : link,
    #   3 : image,
    #   4 : code
    #   5 : book
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

  # params[:nickname]
  def newimage
    @note = Note.new
    @note.content = 'write some comment here'
    @note.kind = 3

    respond_to do |format|
      if current_user.nickname != params[:nickname] 
        format.html { redirect_to notes_path }
      else
        format.html { render "new" }
      end
    end
  end

  # params[:nickname]
  def newbook
    @note = Note.new
    @note.kind = 5

    respond_to do |format|
      if current_user.nickname != params[:nickname] 
        format.html { redirect_to notes_path }
      else
        format.html { render "new" }
      end
    end
  end

  def newcode
    @note = Note.new
    @note.content = 'write some code here'
    @note.kind = 4
	@languages = ["C","Clojure","CSS","Delphi","DIFF","ERB","Groovy","HAML","HTML","Java","JavaScript","JSON","PHP","Python","Ruby","SQL","XML","YAML"]

    respond_to do |format|
      if current_user.nickname != params[:nickname] 
        format.html { redirect_to notes_path }
      else
        format.html { render "new" }
			end
		end
	end

  def newlink
    @note = Note.new
    @note.content = 'write something here'
    @note.kind = 2

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
    if @note.kind==4 
      @note.link = params[:language][:id].strip.downcase.to_sym
    elsif @note.kind==5
      @note.content = @note.book.url.gsub(/.*\//, '')
    end

    respond_to do |format|
      if @note.save
        broadcast '/notes/new', "{ 'kind' : #{@note.kind} }"
        format.html { redirect_to notes_path, notice: 'Note was successfully created.' }
      else
        format.html { redirect_to notes_path, notice: 'Note creation was failed.' }

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
