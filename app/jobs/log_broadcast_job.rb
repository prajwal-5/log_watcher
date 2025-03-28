class LogBroadcastJob < ApplicationJob
  queue_as :default

  def perform(*args)
    log_file_path = Rails.root.join("log", "development.log")
    no_of_log_lines = 10

    # last_lines = File.readlines(log_file_path).last(no_of_log_lines)

    last_lines = []
    File.open(log_file_path, "r") do |file|
      file.seek(0, IO::SEEK_END)
      buffer = ""

      while last_lines.size < no_of_log_lines 
        break if file.pos == 0

        file.seek(-2, IO::SEEK_CUR)
        char = file.read(1)

        if char == "\n"
          last_lines.unshift(buffer.reverse)
          buffer = ""
        else
          buffer += char
        end
      end

      last_lines.unshift(buffer.reverse) unless buffer.empty?
    end
      
    ActionCable.server.broadcast(
      "stream_log",
      ApplicationController.render(
        partial: "tail_handler/stream_log",
        locals: { logs: last_lines }
      )
    )

    sleep 1
  end
end
