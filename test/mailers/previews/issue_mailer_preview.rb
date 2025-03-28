# Preview all emails at http://localhost:3000/rails/mailers/issue_mailer
class IssueMailerPreview < ActionMailer::Preview
    def deliver_issue
        create_fixtures
        IssueMailer.deliver_issue(@member, @issue)
    end

    private

    def create_fixtures
        @issue = Issue.find(58)
        @club = @issue.club
        @member = @club.members.first
        @user = @member.user
    end
end
