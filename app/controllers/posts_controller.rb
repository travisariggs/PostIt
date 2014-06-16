class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def create
  end

  def new
  end

  def edit
  end

  def update
  end

end
