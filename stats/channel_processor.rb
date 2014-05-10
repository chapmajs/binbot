require_relative 'string_helper'

class ChannelProcessor
  attr_accessor :channel_data

  def initialize ( channels = {} )
    @channel_data = channels
  end

  def build_stats_table
    return_string = ""
    max_chan_name_length = @channel_data.keys.collect(&:size).max
    return_string << "#{'Channel'.ljust(max_chan_name_length)}    Users    Topic                                                     \n"
    return_string << "#{"-" * 80}\n"
    @channel_data.sort.each do |k,v|
      first_half =  "#{k.ljust(max_chan_name_length)}    #{v[:user_count].rjust(5)}    "
      return_string << "#{first_half}#{v[:topic].truncate(80 - first_half.length).ljust(80 - first_half.length)}\n"
    end

    return_string
  end
end

