class Check
  require "net/ping"
  require "notifications"
  require "vmstat"
  require "yaml"

  def initialize
    data = YAML.load_file "config.yaml"
    @values = data["values"]
  end

  def ping
    @values["pings"].each do |record, ping|
      unless up?(ping)
        send_notifications("Ping check fail!", "Checking ping #{ping} was fail!")
      end
    end
  end

  def free_memory
    @values["free_memory"].each do |record, free_memory|
      if Vmstat.memory.free < free_memory
        send_notifications("Free memory check fail!", "Checking free memory #{free_memory} was fail!")
      end
    end
  end

  def free_space
    @values["free_space"].each do |path, free_space|
      folder = Vmstat.disk(path)

      if folder && folder.free_bytes < free_space
        send_notifications("Free space check fail!", "Checking free space #{free_space} was fail!")
      end
    end
  end

  private

  def up?(host)
    check = Net::Ping::External.new(host)
    check.ping?
  end

  def send_notifications(subject, message)
    notification = Notification.new
    notification.send_email_to(@values["users"], subject, message)
    notification.send_message_to(@values["slack"], message)
  end
end
