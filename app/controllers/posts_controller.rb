class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator_or_above, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
    respond_to do |format|
      format.html {}
      format.json { render json: @posts }
      format.xml  { render xml:  @posts }
    end
  end

  def show
    @comment = Comment.new

    respond_to do |format|
      format.html {}
      format.json { render json: sanitize_for_external_api(@post) }
      format.xml  { render xml: sanitize_for_external_api(@post)  }
    end

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
    @post = Post.find_by(slug: params[:id])
  end

  def vote_params
    params.require(:post)
  end

  def require_creator_or_above
    access_denied('You cannot edit that.') unless @post.creator == current_user or
      current_user.admin?
  end

  def sanitize_for_external_api(post)
    post_attrs = post.attributes
    post_attrs["username"] = post.creator.username
    sanitized_attrs = post_attrs.select{ |key, val| not ['id', 'user_id'].include?(key) }
  end

end
