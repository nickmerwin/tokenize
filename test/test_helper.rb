require 'rubygems'
require 'active_record'
require 'test/unit'
require 'shoulda'
require 'factory_girl'

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'tokenize'
require File.dirname(__FILE__) + "/../init"

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'test.db'
)

ActiveRecord::Base.connection.drop_table :dummies rescue nil
ActiveRecord::Base.connection.drop_table :bad_dummies rescue nil

ActiveRecord::Base.connection.create_table :dummies do |t|
  t.string :token
  t.string :api_key
  t.string :public_token
  
  t.string :private_key
end

ActiveRecord::Base.connection.create_table :bad_dummies do |t|
  t.integer :int_field
end