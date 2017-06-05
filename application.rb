module ServerMonitor
  $LOAD_PATH << "."

  require "check"

  @check = Check.new

  @check.ping
  @check.free_memory
  @check.free_space
end
