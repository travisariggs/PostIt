class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)

    # Hard code the first user as the commentor for now...
    @user = User.first
    @comment.user = @user

    if @comment.save
      flash[:notice] = 'Comment created successfully'
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end