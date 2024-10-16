# Preview all emails at http://localhost:3000/rails/mailers/issue_mailer
class ReplyReminderMailerPreview < ActionMailer::Preview
    def reply_reminder
        create_fixtures
        IssueMailer.reply_reminder(@member, @issue)
    end

    private

    def create_fixtures
        @issue = Issue.find(1856)
        @club = @issue.club
        @member = @club.members.first
        @user = @member.user
    end
end
