require 'cinch'
require 'cinch_channel_list'
require_relative 'string_helper'

stats_bot = Cinch::Bot.new do
  loggers.level = :error

  configure do |c|
    c.server = 'irc.binrev.net'
    c.nick   = 'StatsBot'
    c.plugins.plugins = [ChannelList]
  end

  on :connect do 
    @bot.handlers.dispatch(:get_channel_list)
  end

  on :channel_list_received do |m, channels|
    max_chan_name_length = channels.keys.collect(&:size).max
    puts "#{'Channel'.ljust(max_chan_name_length)}\tUsers\tTopic"
    puts "-" * 80
    channels.each { |k,v| puts "#{k.ljust(max_chan_name_length)}\t#{v[:user_count].rjust(5)}\t#{v[:topic].truncate(56)}" }
    @bot.quit
  end
end

stats_bot.start
