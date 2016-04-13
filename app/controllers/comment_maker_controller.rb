class CommentMakerController < PrivateController
  def create
    meeting = Meeting.find_by(uuid: params[:meeting_uuid])
    @comment = Comment.new(comment_params.merge({commentable: meeting, user: current_user}))

    if @comment.save
      render json: @comment.public_attributes.merge({user_name: current_user.name}), status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:title, :comment)
  end

end
