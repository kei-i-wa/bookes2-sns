class BooksController < ApplicationController
  impressionist :actions=> [:show]
  before_action :authenticate_user!
  before_action :ensure_correct_user, only:
  

  def new
    @book=Book.new
  end

  def create
    @book=Book.new(book_params)
    @book.user_id=current_user.id
    if @book.save
    redirect_to book_path(@book.id),notice:'You have created book successfully.'
    else
    @books=Book.page(params[:page]).reverse_order
    render:index
    end
  end

  def index
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    books = Book.includes(:favorited_users).
      sort {|a,b| 
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
     @books=Kaminari.paginate_array(books).page(params[:page]).per(25)
     @book = Book.new
  end


  def show
    @books=Book.find(params[:id])
    impressionist(@books, nil, unique: [:session_hash.to_s])
    @book=Book.new
    @book_comment = BookComment.new
    @book_comments = @book.book_comments.order(created_at: :desc)

  end

  def edit
    @book=Book.find(params[:id])
  end


  def update
    @book=Book.find(params[:id])
    if @book.update(book_params)
    redirect_to book_path(@book.id),notice:'You have updated book successfully.'
    else
    render:edit
    end
  end

  def destroy
    @book=Book.find(params[:id])
    if @book.destroy
    redirect_to books_path
    end
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
    redirect_to books_path
    end
  end
  


  private
  def book_params
    params.require(:book).permit(:title,:body)
  end
end