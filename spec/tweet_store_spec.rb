require 'minitest/autorun'
require_relative '../src/tweet_store'
require_relative '../src/follower_map'
require_relative '../src/follow'

FOLLOWER_MAP = FollowerMap.from_list [
  Follow.new('Rob', 'Steve'),
  Follow.new('Rob', 'Joe'),
  Follow.new('Steve', 'Joe'),
  Follow.new('Joe', 'Rob'),
]

Tweet = Struct.new(:broadcaster, :body)

describe TweetStore do
  describe '#new' do
    it 'takes a FollowerMap' do
      TweetStore.new(FollowerMap.new)
    end
  end

  describe '#add' do
    let (:store) {TweetStore.new(FOLLOWER_MAP)}
    it 'adds the tweet to all the followers of the sender' do
      store.add(Tweet.new('Rob', 'Tweet'))
      store.add(Tweet.new('Steve', 'Twoot'))

      store.tweets_for('Steve').must_include 'Tweet'
      store.tweets_for('Joe').must_include 'Tweet'
      store.tweets_for('Joe').must_include 'Twoot'
    end

    it 'adds the tweet to the sender' do
      store.add(Tweet.new('Rob', 'Tweet'))
      store.add(Tweet.new('Steve', 'Twoot'))

      store.tweets_for('Rob').must_include 'Tweet'
      store.tweets_for('Steve').must_include 'Twoot'
    end
  end

  describe '#tweets_for' do
    let (:store) {TweetStore.new(FOLLOWER_MAP)}
    it 'returns all tweets for user in FIFO order' do
      store.add(Tweet.new('Rob', 'Tweet'))
      store.add(Tweet.new('Steve', 'Twoot'))

      store.tweets_for('Steve').must_equal ['Tweet', 'Twoot']
    end
  end

  describe '#tweets_by_user' do
    let (:store) {TweetStore.new(FOLLOWER_MAP)}

    it 'returns all users with tweets in insertion order' do
      store.add(Tweet.new('Rob', 'Tweet'))
      store.add(Tweet.new('Steve', 'Twoot'))

      store.tweets_by_user.must_equal({
        'Joe' => ['Tweet', 'Twoot'],
        'Steve' => ['Tweet', 'Twoot'],
        'Rob' => ['Tweet'],
      })
    end
  end
end
