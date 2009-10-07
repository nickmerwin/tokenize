# LemurTokenizer
#   Quick Dirty Token generation
#   by Nick Merwin 02.06.2009

# Usage: 
# class Foo < ActiveRecord::Base
#   tokenize :api_key, :size => 32
# end

module LemurTokenize
  class << self
    def included(base)
      base.extend ClassMethods
    end
  end
  
  module ClassMethods
    
    # defaults:
    # column - :token
    # size - 32
    # when - :before_create
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
      send "#{self.class.tokenize_opts[:column]}=", ActiveSupport::SecureRandom.hex(self.class.tokenize_opts[:size] || 32)
    end
  end
end

if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, LemurTokenize)
end