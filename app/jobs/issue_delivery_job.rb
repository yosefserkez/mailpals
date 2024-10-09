class IssueDeliveryJob < ApplicationJob
  queue_as :default

  def perform(issue_id)
    issue = Issue.find_by(id: issue_id)
    return unless issue

    issue.deliver
  end
end