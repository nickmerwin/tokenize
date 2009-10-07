# LemurTokenizer
#   Quick Dirty Token generation
#   by Nick Merwin 02.06.2009

# Usage: 
# class Foo < ActiveRecord::Base
#   tokenize :api_key, :size => 32
# end
#
# Option defaults:
# column - :token
# size - 32
# when - :before_create
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
      include InstanceMethods
      
      opts.merge!({:column => column})
      write_inheritable_attribute :tokenize_opts, opts
      
      before_create :set_token
      
      opts
    end
    
    def tokenize_opts
      read_inheritable_attribute(:tokenize_opts)
    end
  end

  module InstanceMethods
    def set_token
      opts = self.class.tokenize_opts
      
      while true
        proposed_token = ActiveSupport::SecureRandom.send(opts[:type],32)
        proposed_token.gsub!(/\W/,'') unless opts[:url_safe] == false
        proposed_token = proposed_token.to_s[0..(opts[:size] || 32)]
        
        break unless self.class.exists?(opts[:column] => proposed_token)
      end
      send "#{opts[:column]}=", proposed_token
    end
  end
end

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, LemurTokenize)
end