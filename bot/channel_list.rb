require 'cinch'

class ChannelList
  include Cinch::Plugin

  attr_accessor :channels

  listen_to :get_channel_list,                :method => :send_list
  listen_to Cinch::Constants::RPL_LISTSTART,  :method => :clear_channels
  listen_to Cinch::Constants::RPL_LIST,       :method => :add_channel
  listen_to Cinch::Constants::RPL_LISTEND,    :method => :send_channel_list

  def send_list(message)
    bot.irc.send "LIST"
  end

  def clear_channels(message)
    @channels = {}
  end

  def add_channel(message)
    channels[message.params[1]] = { :user_count => message.params[2], :topic => message.params[3].sub(/\[.*\] /, '') }
  end

  def send_channel_list(message)
    @bot.handlers.dispatch(:channel_list_received, nil, @channels)
  end
end

