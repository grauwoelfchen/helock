#!/usr/bin/env ruby
# vim fileencoding=utf-8

require 'escape_utils/url/rack'
require 'twitter'

def send message
  Twitter.configure do |config|
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.oauth_token        = ENV['OAUTH_TOKEN']
    config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
  end
  to = 'grauwoelfchen'
  puts "#{Time.now}: dm to @#{to} #{message}"
  Twitter.direct_message_create to, message
end

every(1.day, 'wake up', :at => ENV['WAKEUP_TIME']) do
  today = Time.now.wday
  messages = YAML::load(File.open('messages.yml'))
  send messages[today] unless messages[today].nil?
end
