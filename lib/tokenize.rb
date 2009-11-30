# LemurTokenizer
#   Quick Dirty Token generation
#   by Nick Merwin 11.29.2009

# Usage: 
# class Foo < ActiveRecord::Base
#   tokenize :api_key, :size => 32
#   tokenize :public_token, :size => 5, :type => :base64
# end
#
# Option defaults:
# column - :token
# size - 32
# type - :hex (:base64)
# url_safe - true

module LemurTokenize
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end
  
  module ClassMethods
    def tokenize(column=:token, opts={})
      generate_method = "generate_#{column}".to_sym
      define_method generate_method do
        opts = {:column => column, :type => :hex}.merge(opts)
        while true
          proposed_token = ActiveSupport::SecureRandom.send(opts[:type],32)
          proposed_token.gsub!(/\W/,'') unless opts[:url_safe] == false
          #TODO: fill in gaps left by url safety
          proposed_token = proposed_token.to_s[0..(opts[:size] || 32)]

          break unless self.class.exists?(opts[:column] => proposed_token)
        end
        send "#{opts[:column]}=", proposed_token
        raise IncompatibleTokenColumn unless send(opts[:column]) == proposed_token
      end
      
      before_create generate_method
    end
    
  end
  
  class IncompatibleTokenColumn < StandardError; end
end