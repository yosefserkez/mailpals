require "application_system_test_case"

class CommentsTest < ApplicationSystemTestCase
  setup do
    @comment = comments(:one)
  end


  test "should create comment" do
    visit comments_url
    click_on "New comment"

    fill_in "Answer", with: @comment.answer_id
    fill_in "Content", with: @comment.content
    fill_in "Member", with: @comment.member_id
    click_on "Create Comment"

    assert_text "Comment was successfully created"
    click_on "Back"
  end
end
