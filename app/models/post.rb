class Post < ActiveRecord::Base
  attr_accessible :body, :ip_address, :name, :subject
end
