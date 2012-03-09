class BooksController < ApplicationController
  # GET /books
  # GET /books.json
  def index
    @bookstatuslist= Array.new()
    @books = Book.all
    @user_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id}")
    @reading_book = Book.find_by_sql("SELECT books.* FROM books WHERE user_id=#{current_user.id} and status='reading' ")

    @books.each do |book|
    @owner = User.find_by_sql("SELECT users.* FROM users WHERE id=#{book.user_id}")[0].nickname
      if @reading_book.size == 0
        @book_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE book_id=#{book.id} ORDER BY created_at ASC")
        if @user_debit.size == 0
          if book.status == "keep" && @book_debit.size == 0
            bookstatus = {"book" => book, "display" => "borrow", "owner" => @owner}
          else
            bookstatus = {"book" => book, "display" => "want_wait", "owner" => @owner}
          end
        elsif @user_debit.size == 1
          if @user_debit[0].book_id == book.id 
            if @book_debit.first.user_id == current_user.id && book.status == "keep"
              bookstatus = {"book" => book, "display" => "borrow", "owner" => @owner}
            else
              bookstatus = {"book" => book, "display" => "waiting", "owner" => @owner}
            end
          else
            bookstatus = {"book" => book, "display" => "", "owner" => @owner}
          end
        end
      elsif @reading_book.size == 1
        if @reading_book[0].id == book.id
          bookstatus = {"book" => book, "display" => "reading", "owner" => @owner}
        else
          bookstatus = {"book" => book, "display" => "", "owner" => @owner}
        end
      end
      @bookstatuslist.push(bookstatus)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.js # index.js.erb
      format.json { render json: @books }
    end
  end

  def borrow
    @book = Book.find(params[:book_id])
    @reading_book = Book.find_by_sql("SELECT books.* FROM books WHERE user_id=#{current_user.id} and status='reading' ")
    if @book.status == "keep" && @reading_book.size == 0
      @book.user_id = current_user.id
      @book.status = 'reading'
      @book.save!
      @relevance_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id} and book_id=#{@book.id}")[0]
      if @relevance_debit != nil
        @relevance_debit.destroy
      end
    end

    respond_to do |format|
      format.html { redirect_to books_path }
    end
  end

  # GET /debits/new
  # GET /debits/new.json
  def new
    @book = Book.new

    respond_to do |format|
      format.html 
    end
  end

  # POST /debits
  # POST /debits.json
  def create
    @books = Book.all
    @book = Book.new(params[:book])
    @book.user_id = current_user.id

    respond_to do |format|
      if @book.save
        format.html { redirect_to books_path, notice: 'Debit was successfully created.' }
        format.js # create.js.erb
        format.json { render json: @book, status: :created, location: @book}
      else
        format.html { render action: "new" }
        format.js # create.js.erb
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book = Book.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js # show.js.erb
      format.json { render json: @book }
    end
  end

end
