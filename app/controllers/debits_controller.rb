class DebitsController < ApplicationController
  # GET /debits
  # GET /debits.json
  def index
    @debits = Debit.all
    @debit = Debit.new

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @debits }
    end
  end

  # GET /debits/1
  # GET /debits/1.json
  def show
    @debit = Debit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @debit }
    end
  end

  # GET /debits/new
  # GET /debits/new.json
  def new
    @debit = Debit.new

    respond_to do |format|
      format.html # new.html.erb
      format.js # new.js.erb
      format.json { render json: @debit }
    end
  end

  # GET /debits/1/edit
  def edit
    @debit = Debit.find(params[:id])
  end

  # POST /debits
  # POST /debits.json
  def create
    @debits = Debit.all
    @debit = Debit.new(params[:debit])

    respond_to do |format|
      if @debit.save
        format.html { redirect_to @debit, notice: 'Debit was successfully created.' }
        format.js # create.js.erb
        format.json { render json: @debit, status: :created, location: @debit }
      else
        format.html { render action: "new" }
        format.js # create.js.erb
        format.json { render json: @debit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /debits/1
  # PUT /debits/1.json
  def update
    @debit = Debit.find(params[:id])

    respond_to do |format|
      if @debit.update_attributes(params[:debit])
        format.html { redirect_to @debit, notice: 'Debit was successfully updated.' }
        format.js # update.js.erb
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.js # update.js.erb
        format.json { render json: @debit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /debits/1
  # DELETE /debits/1.json
  def destroy
    @debit = Debit.find(params[:id])
    @debit.destroy

    respond_to do |format|
      format.html { redirect_to debits_url }
      format.js # destroy.js.erb
      format.json { head :no_content }
    end
  end
end
