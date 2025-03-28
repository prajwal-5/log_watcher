class TailHandlerController < ApplicationController
  def broadcast_logs
    LogBroadcastJob.perform_later
  end
end
