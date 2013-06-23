#!/usr/bin/env ruby
# encoding: utf-8

require 'yaml'
require 'twitter'

class Helock
  include Clockwork

  attr_accessor :users, :messages

  def initialize
    @users    = []
    @messages = []
    yield self if block_given?
  end

  def production?
    @_env ||= (ENV['HELOCK_ENV'] != 'development')
  end

  def config
    unless production?
      [10.seconds, 'dev ;)']
    else
      [1.day, 'wake up', :at => ENV['WAKEUP_TIME']]
    end
  end

  def run
    every(*config) do
      today = Time.now.wday
      action = production? ? 'send' : 'log'
      threads = []
      users.each do |user|
        threads << Thread.new do
          message = messages[today].shuffle.first
          send("#{action}_direct_message", *[user, message])
        end
      end
      threads.map(&:join)
    end
  end

  private

  def log_direct_message(user, message)
    puts "#{Time.now}: dm to @#{user} #{message}\n"
  end

  def send_direct_message(user, message)
    begin
      client.direct_message_create(user, message)
      log_direct_message(user, message)
    rescue Errno::ETIMEDOUT
      puts "Time out Error :'(\n"
    end
  end

  def client
    @_client ||= Twitter.configure do |c|
      c.consumer_key       = ENV['CONSUMER_KEY']
      c.consumer_secret    = ENV['CONSUMER_SECRET']
      c.oauth_token        = ENV['OAUTH_TOKEN']
      c.oauth_token_secret = ENV['OAUTH_TOKEN_SECRET']
    end
  end
end

helock = Helock.new do |h|
 h.users    = YAML::load(File.open('users.yml'))
 h.messages = YAML::load(File.open('messages.yml'))
end
helock.run
