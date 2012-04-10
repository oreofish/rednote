class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.json
  def index
    @project= Project.find(params[:project])
    @documents = @project.documents

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])
    @project = @document.project
    @comment = Comment.new
    @comments = @document.comments


    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @document }
    end
  end


  # POST /documents
  # POST /documents.json
  def create
    @project = Project.find(params[:project])
    @document = current_user.documents.new(:project_id => @project.id)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.js # create.js.erb
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.js # create.js.erb
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.js # update.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # update.js.erb
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @project = @document.project
    @document.destroy

    respond_to do |format|
      format.html { redirect_to @project }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end
end
