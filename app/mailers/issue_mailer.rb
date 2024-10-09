class IssueMailer < ApplicationMailer
  helper IssuesHelper

  def reply_reminder(member, issue)
    @member = member
    @issue = issue
    @club = issue.club
    mail to: @member.email, subject: "#{@club.title}: #{@issue.title} is open for replies"
  end

  def deliver_issue(member, issue)
    @member = member
    @issue = issue
    @club = issue.club
    @answers = @issue.enabled_answers.where(member: @club.visible_members(@member))
    mail to: @member.email, subject: "#{@club.title}"
  end
end
