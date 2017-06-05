class Notification
  require "mail"
  require "slack-notifier"

  def send_email_to(users, subject, message)
    users.each do |record, email|
      Mail.deliver do
        delivery_method :smtp, address: "localhost", port: 1025
        from     "server@monitor.com"
        to       email
        subject  subject
        body     message
      end

      puts "Server Monitor App sent message: '#{message}' to #{email}"
    end
  end

  def send_message_to(slack, message)
    notifier = Slack::Notifier.new slack["webhook_url"] do
      defaults channel: slack["channel"], username: "server-monitor"
    end

    notifier.ping message

    puts "Server Monitor App sent message: '#{message}' to slack channel #{slack['channel']}"
  end
end
