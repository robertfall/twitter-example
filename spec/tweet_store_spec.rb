require 'minitest/autorun'
require_relative '../src/tweet_store'
require_relative '../src/follower_map'
require_relative '../src/follow'
require_relative '../src/tweet'

FOLLOWER_MAP = FollowerMap.from_list [
  Follow.new('Rob', 'Steve'),
  Follow.new('Rob', 'Joe'),
  Follow.new('Steve', 'Joe'),
  Follow.new('Joe', 'Rob'),
]

def tw(broadcaster, body)
  Tweet.new broadcaster, body
end

describe TweetStore do
  describe '#new' do
    it 'takes a FollowerMap' do
      TweetStore.new(FollowerMap.new)
    end

    it 'creates empty tweet lists for every known user' do
      store = TweetStore.new(FOLLOWER_MAP)
      store.tweets_by_user.key?('Rob').must_equal true
      store.tweets_by_user.key?('Steve').must_equal true
      store.tweets_by_user.key?('Joe').must_equal true
    end
  end

  describe '#add' do
    let (:store) {TweetStore.new(FOLLOWER_MAP)}
    it 'adds the tweet to all the followers of the sender' do
      store.add(tw('Rob', 'Tweet'))
      store.add(tw('Steve', 'Twoot'))

      store.tweets_for('Steve').must_include tw('Rob', 'Tweet')
      store.tweets_for('Joe').must_include tw('Rob', 'Tweet')
      store.tweets_for('Joe').must_include tw('Steve', 'Twoot')
    end

    it 'adds the tweet to the sender' do
      store.add(tw('Rob', 'Tweet'))
      store.add(tw('Steve', 'Twoot'))

      store.tweets_for('Rob').must_include tw('Rob', 'Tweet')
      store.tweets_for('Steve').must_include tw('Steve', 'Twoot')
    end
  end

  describe '#tweets_for' do
    let (:store) {TweetStore.new(FOLLOWER_MAP)}
    it 'returns all tweets for user in FIFO order' do
      store.add(tw('Rob', 'Tweet'))
      store.add(tw('Steve', 'Twoot'))

      store.tweets_for('Steve').must_equal [tw('Rob', 'Tweet'), tw('Steve', 'Twoot')]
    end
  end

  describe '#tweets_by_user' do
    let (:store) {TweetStore.new(FOLLOWER_MAP)}

    it 'returns all users with tweets in insertion order' do
      store.add(tw('Rob', 'Tweet'))
      store.add(tw('Steve', 'Twoot'))

      store.tweets_by_user.must_equal({
        'Joe' => [tw('Rob', 'Tweet'), tw('Steve', 'Twoot')],
        'Steve' => [tw('Rob', 'Tweet'), tw('Steve', 'Twoot')],
        'Rob' => [tw('Rob', 'Tweet')],
      })
    end
  end
end
