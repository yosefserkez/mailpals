class IssueReminderJob < ApplicationJob
  queue_as :default

  def perform(issue_id, interval)
    issue = Issue.find_by(id: issue_id)
    return unless issue

    issue.send_reminder_emails
  end
end