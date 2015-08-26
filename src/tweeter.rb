require_relative 'user_line'
require_relative 'tweet_line'
require_relative 'follower_map'
require_relative 'tweet_store'

class Tweeter
  def self.run(users_file, tweets_file)
    tweeter = new

    map = tweeter.parse_users(users_file)
    store = tweeter.parse_tweets(tweets_file, map)
    tweeter.print_tweets(store)
  end

  def parse_users(users_file)
    map = FollowerMap.new

    IO.foreach(users_file) do |line|
      user = UserLine.new(line)
      next unless user.valid?

      map.add_follows(user.follows)
    end
    map
  end

  def parse_tweets(tweets_file, map)
    store = TweetStore.new(map)

    IO.foreach(tweets_file) do |line|
      tweet_line = TweetLine.new(line)
      next unless tweet_line.valid?

      store.add(tweet_line.tweet)
    end
    store
  end

  def print_tweets(store)
    users = store.tweets_by_user

    users.keys.sort.each do |user|
      puts "#{user}\n"
      users.fetch(user).each do |tweet|
        puts "\t" + tweet.to_s
      end
    end
  end
end
