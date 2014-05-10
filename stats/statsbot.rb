require 'cinch'
require 'cinch_channel_list'
require_relative 'channel_processor'

processor = nil

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
    processor = ChannelProcessor.new(channels)
    @bot.quit
  end
end

stats_bot.start

html_template = File.read("binrev_index.html.template")
File.open('index.html', 'w') { |file| file.puts html_template.gsub(/STATSTABLE/, processor.build_stats_table) }

