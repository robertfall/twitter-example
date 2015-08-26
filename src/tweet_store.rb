class TweetStore
  def initialize(follower_map)
    @map = follower_map
    @tweets_by_user = {}
  end

  def add(tweet)
    (@map.followers_for(tweet.broadcaster) + [tweet.broadcaster]).each do |follower|
      tweets = @tweets_by_user.fetch(follower, [])
      tweets << tweet
      @tweets_by_user[follower] = tweets
    end
  end

  def tweets_for(user)
    @tweets_by_user.fetch(user, [])
  end

  def tweets_by_user
    @tweets_by_user
  end
end
