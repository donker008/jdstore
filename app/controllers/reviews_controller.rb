class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.product_id = params[:product_id]
    if @review.save
      flash[:notice] = "发表评论成功"
    else
      flash[:alert] = "发表评论失败"  + @review.error.full_messages.to_s
    end
    redirect_to :back
  end

  def destroy
    @review = Review.find(params[:id])
    if @review
       @review.delete
    end
  end

  private
  def review_params
    params.require(:review).permit(:review)
  end

end
