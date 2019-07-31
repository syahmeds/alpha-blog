class PagesController < ApplicationController
  def home

    redirect_to articles_path if logged_in?

  end
  def about

  end

  # back-end code for pages/explore
  def notifications
    @posts = Post.all
    @newPost = Post.new
    @toFollow = User.all.last(5)
  end

end