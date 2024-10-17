class CommentsController < ApplicationController
  def create
    @answer = Answer.find(params[:answer_id])
    @comment = @answer.comments.build(comment_params)
    @comment.member = current_user.membership(@answer.club)

    respond_to do |format|
      if @comment.save
        CommentMailer.new_comment_notification(@comment).deliver_later unless @comment.member == @answer.member
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend("comments-#{@answer.id}", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.update("comment-count-#{@answer.id}", @answer.comments.count)
          ]
        end
        format.html { redirect_to [ @answer.club, @answer.issue, @answer ], notice: "Comment was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_comment_form_#{@answer.id}", partial: "form", locals: { comment: @comment })
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def comment_params
      params.expect(comment: [ :content, :member_id, :answer_id ])
    end
end
