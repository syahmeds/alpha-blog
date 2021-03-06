class ArticlesController < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]


  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def notifications
    @articles = Article.sorted_latest_articles(current_user.following.ids)
    @articles = @articles.paginate(page: params[:page], per_page: 5)
  end

  def new

    @article = Article.new

  end

  def create
    @article = Article.new(article_params)

    @article.user = current_user

    if @article.save

      flash[:success] = "Tweet was successfully created"

      redirect_to article_path(@article)

    else

      render 'new'

    end

  end

  def show

  end

  def destroy

    @article.destroy

    flash[:danger] = "Tweet was successfully deleted"

    redirect_to articles_path

  end

  private

  def set_article

    @article = Article.find(params[:id])

  end

  def article_params

    params.require(:article).permit(:title, :description)

  end

  def require_same_user

    if current_user != @article.user && !current_user.admin?

      flash[:danger] = "You can only edit or delete your own articles"

      redirect_to root_path

    end

  end

end

