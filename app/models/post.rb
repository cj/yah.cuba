class Post < ActiveRecord::Base
  field :content

  belongs_to :user
end
Post.auto_upgrade!
