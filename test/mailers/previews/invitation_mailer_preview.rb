# Preview all emails at http://localhost:3000/rails/mailers/issue_mailer
class InvitationMailerPreview < ActionMailer::Preview
    def deliver_invitation
        create_fixtures
        UserMailer.with(user: @user, club: @club, inviter: @inviter).invitation_instructions
    end

    private

    def create_fixtures
        @club = Club.first
        @inviter = @club.members.first.user
        @user = User.last
    end
end
