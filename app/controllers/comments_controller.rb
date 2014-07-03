class CommentsController < ApplicationController

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      flash[:notice] = 'Comment created successfully'
      redirect_to post_path
    else
      render :new
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end