#!/usr/bin/env ruby
# encoding: utf-8

require 'twitter'

def users
  @users ||= (YAML::load(File.open('users.yml')) || [])
end
def messages
  @messages ||= (YAML::load(File.open('messages.yml')) || [])
end
def production?
  ENV['HELOCK_ENV'] != 'development'
end
def config
  unless production?
    [10.seconds, 'dev ;)']
  else
    [1.day, 'wake up', :at => ENV['WAKEUP_TIME']]
  end
end
def log_direct_message user, message
  puts "#{Time.now}: dm to @#{user} #{message}"
end
def send_direct_message user, message
  Twitter.configure do |config|
    config.consumer_key       = ENV['CONSUMER_KEY']
    config.consumer_secret    = ENV['CONSUMER_SECRET']
    config.oauth_token        = ENV['OAUTH_TOKEN']
    config.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
  end
  log_direct_message user, message
  Twitter.direct_message_create user, message
end

every(*config) do
  today = Time.now.wday
  action = production? ? 'send' : 'log'
  users.each do |user|
    message = messages[today].shuffle.first
    send("#{action}_direct_message".to_sym, *[user, message])
  end
end
