class Post < ActiveRecord::Base
  col :content

  belongs_to :user
end
Post.auto_upgrade!
