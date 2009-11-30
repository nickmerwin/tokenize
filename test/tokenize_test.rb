require 'test_helper'

Factory.define(:dummy) {}
Factory.define(:bad_dummy) {}

class Dummy < ActiveRecord::Base
  tokenize
  tokenize :public_token, :size => 5
  tokenize :api_key, :type => :hex
  tokenize :private_key, :type => :base64, :url_safe => false
end

class BadDummy < ActiveRecord::Base
  tokenize :int_field
end

class TokenizeTest < Test::Unit::TestCase
  context "An instance of a class that has tokenized attributes" do
    
    setup do
      @dummy = Factory(:dummy)
    end
    
    should "create generate methods" do
      assert_respond_to @dummy, :generate_token
      assert_respond_to @dummy, :generate_public_token
      assert_respond_to @dummy, :generate_api_key
      assert_respond_to @dummy, :generate_private_key
    end
    
    should "use defaults" do
      assert_match /[a-g0-9]{32}/, @dummy.token
    end
    
    should "size generated token correctly" do
      assert_match /[a-g0-9]{5}/, @dummy.api_key
    end
    
    should "use correct random method" do
      assert_match /[a-zA-Z0-9\W]{32}/, @dummy.private_key
    end
    
    should "ensure url-safe generation" do
      assert_no_match /\W/, @dummy.api_key
    end
    
  end
  
  context "An instance of a class with an incorrect field type" do
    setup do
      @bad_dummy = Factory.build(:bad_dummy)
    end
    
    should "raise an error" do
      assert_raise LemurTokenize::IncompatibleTokenColumn do
        @bad_dummy.save
      end
    end
    
  end
end