if Object.const_defined?("ActiveRecord")
  ActiveRecord::Base.send(:include, LemurTokenize)
end