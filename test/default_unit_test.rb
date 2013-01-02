require 'test/unit'
require '../lib/slapshot/main'
require 'json'
require 'rest_client'

class DefaultTest < Test::Unit::TestCase

  @@CLIENT = 'test'
  @@URL = "https://dan.test.appshot.com:8443"
  @@USER = 'super@appshot.com'
  @@PASS = 'macbethonahorse'

  def setup
    ENV['HOMEPATH'] = './'
  end

  def teardown
  end


  def test_token_retrieve
    token = create_token(@@URL, @@USER, @@PASS)
    assert_not_nil token
    assert_not_nil get_token
  end

  def test_remove_token
    token = create_token(@@URL, @@USER, @@PASS)
    remove_token(@@URL)
    client = Appshot.new @@URL, token, @@CLIENT
    assert_raises (RestClient::Unauthorized) { client.search("code:test", 20, false) }
  end

  def test_search
    token = create_token(@@URL, @@USER, @@PASS)
    client = Appshot.new @@URL, token, @@CLIENT
    resp = client.search("code:test", 20, false)
    assert_not_nil resp
  end

end
