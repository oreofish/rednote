class BooksController < ApplicationController
    # GET /books
    # GET /books.json
    def index
        @arrs = Array.new()
        @books = Book.all
        @books.each do |book|
            @user_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id} and book_id=#{book.id}")
            @book_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE book_id=#{book.id} ORDER BY created_at ASC")
            if book.status == "reading"
                if book.user_id == current_user.id
                    list = {"book" => book, "display" => "reading"}
                else
                    if @user_debit.size == 0 #not in list
                        list = {"book" => book, "display" => "want_wait"}
                    elsif @user_debit.size == 1 #in list
                        list = {"book" => book, "display" => "waiting"}
                    end
                end
            elsif book.status == "keep"
                if @user_debit.size == 0 #not in list
                    if @book_debit.size == 0 # nobody in list
                        list = {"book" => book, "display" => "borrow"}
                    elsif #at least one in list
                        list = {"book" => book, "display" => "want_wait"}
                    end
                elsif @user_debit.size == 1 #in list
                    if @book_debit.first == @user_debit[0] # is the first one
                        list = {"book" => book, "display" => "borrow"}
                    elsif
                        list = {"book" => book, "display" => "waiting"}
                    end
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
            @user_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id} and book_id=#{@book.id}")[0]
            if @user_debit != nil
                @user_debit.destroy
            end
        end

        respond_to do |format|
            format.html { redirect_to books_path }
        end
    end

    def unwaiting
        @book = Book.find(params[:book_id])
        @user_debit = Debit.find_by_sql("SELECT debits.* FROM debits WHERE user_id=#{current_user.id} and book_id=#{@book.id}")[0]
        @user_debit.destroy

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

        respond_to do |format|
            if @book.save
                format.html { redirect_to @book, notice: 'Debit was successfully created.' }
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
