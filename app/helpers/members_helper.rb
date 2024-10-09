module MembersHelper
  def visible_members(club = @club)
    raise "No club" unless club.present?
    current_member = club.membership(current_user)
    club.visible_members(current_member)
  end
end
