#!/usr/bin/ruby

require_relative '../src/user_line'
require_relative '../src/tweet_line'
require_relative '../src/follower_map'
require_relative '../src/tweet_store'

map = FollowerMap.new

IO.foreach('users.txt') do |line|
  user = UserLine.new(line)
  next unless user.valid?

  map.add_follows(user.follows)
end

store = TweetStore.new(map)

IO.foreach('tweets.txt') do |line|
  tweet_line = TweetLine.new(line)
  next unless tweet_line.valid?

  store.add(tweet_line.tweet)
end

store.tweets_by_user.tap do |users|
  users.keys.sort.each do |user|
    puts "#{user}\n"
    users.fetch(user).each do |tweet|
      puts "\t" + tweet.to_s
    end
  end
end
