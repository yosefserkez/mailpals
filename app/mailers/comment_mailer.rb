class CommentMailer < ApplicationMailer
  def new_comment_notification(comment)
    @comment = comment
    @answer = comment.answer
    @author = @answer.member
    @commenter = comment.member

    return if @author == @commenter
    mail(
      to: @author.user.email,
      subject: "New comment on your answer in #{@answer.issue.club.title}"
    )
  end
end
