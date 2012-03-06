class DebitsController < ApplicationController
  # GET /debits/new
  # GET /debits/new.json
  def new
    @debit = Debit.new
    @debit.book_id = params[:book_id]
    @debit.user_id = current_user.id
    @debit.save!

    respond_to do |format|
        format.html { redirect_to books_path }
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

  def unwaiting
      @book = Book.find(params[:book_id])
      @relevance_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id} and book_id=#{@book.id}")[0]
      if @relevance_debit != nil
          @relevance_debit.destroy
      end

      respond_to do |format|
          format.html { redirect_to books_path }
      end
  end

end
