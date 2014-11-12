class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user

    if @post.save
      flash[:notice] = 'Post successfully created'
      redirect_to posts_path
    else
      render :new
    end

  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = 'The post was updated'
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(voteable: @post, user: current_user, vote: params[:vote])

    if @vote.valid?
      flash[:notice] = 'Your vote was counted.'
    else
      flash[:error] = 'Your vote was not counted.'
    end

    redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: [])
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def vote_params
    params.require(:post)
  end

end
