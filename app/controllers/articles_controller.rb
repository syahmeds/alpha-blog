class ArticlesController < ApplicationController

  before_action :set_article, only: [:edit, :update, :show, :destroy]


  before_action :require_same_user, only: [:edit, :update, :destroy]

  def index
    @articles = Article.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def notifications
    following = Array.new
    for @f in current_user.following do
      following.push(@f.id)
    end
    # binding.pry
    # @articles = Article.where("user_id IN (?)", following).paginate(page: params[:page], per_page: 5).order(created_at: :desc)
    # @articles = Article.find_by_sql ["select * from (select articles.*, dense_rank()
    #                                   over(partition by articles.user_id order by articles.updated_at desc)
    #                                   as t_rank from articles where articles.user_id in (#{following.join(',')}))
    #                                   as latest_articles where t_rank <= 1"]
    @articles = Article.find_by_sql(["select * from (select articles.*, dense_rank() over(partition by articles.user_id order by articles.updated_at desc) as t_rank from articles where articles.user_id in (#{following.nil? || following.empty? ? 'NULL': following.join(',')})) as latest_articles where t_rank <= 1"]).sort_by(&:updated_at).reverse
    # binding.pry
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

