# Preview all emails at http://localhost:3000/rails/mailers/issue_mailer
class InvitationMailerPreview < ActionMailer::Preview
    def deliver_invitation
        create_fixtures
        UserMailer.with(member: @member, club: @club, inviter: @inviter).invitation_instructions
    end

    private

    def create_fixtures
        @club = Club.first
        @inviter = @club.members.first.user
        @club.members.create(user: User.last, display_name: "Test Member")
        @member = Member.last
    end
end
