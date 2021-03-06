class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
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
    if @post.creator != current_user
      flash[:error] = 'You are not allowed to do that.'
      redirect_to post_path(@post)
    else
      render :edit
    end
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

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = 'Your vote was counted.'
        else
          flash[:error] = 'You can only vote on a post once.'
        end

        redirect_to :back
      end

      format.js do
        render :vote
      end

    end

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
