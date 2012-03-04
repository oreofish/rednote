class BooksController < ApplicationController
    # GET /books
    # GET /books.json
    def index
        @arrs = Array.new()
        @books = Book.all
        @user_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id}")
        @reading_book = Book.find_by_sql("SELECT books.* FROM books WHERE user_id=#{current_user.id} and status='reading' ")

        @books.each do |book|
            @book_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE book_id=#{book.id} ORDER BY created_at ASC")
            if @reading_book.size == 0
                if @user_debit.size == 0
                    if book.status == "keep" && @book_debit.size == 0
                        list = {"book" => book, "display" => "borrow"}
                    else
                        list = {"book" => book, "display" => "want_wait"}
                    end
                elsif @user_debit.size == 1
                    if @user_debit[0].book_id == book.id 
                        if @book_debit.first.user_id == current_user.id && book.status == "keep"
                            list = {"book" => book, "display" => "borrow"}
                        else
                            list = {"book" => book, "display" => "waiting"}
                        end
                    else
                        list = {"book" => book, "display" => ""}
                    end
                end
            elsif @reading_book.size == 1
                if @reading_book[0].id == book.id
                    list = {"book" => book, "display" => "reading"}
                else
                    list = {"book" => book, "display" => ""}
                end
            end
            @arrs.push(list)
        end

        respond_to do |format|
            format.html # index.html.erb
            format.js # index.js.erb
            format.json { render json: @books }
        end
    end

    def borrow
        @book = Book.find(params[:book_id])
        if @book.status == "keep"
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

    def unwaiting
        @book = Book.find(params[:book_id])
        @relevance_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id} and book_id=#{@book.id}")[0]
        @relevance_debit.destroy

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
