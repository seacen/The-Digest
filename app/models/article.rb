class Article < ActiveRecord::Base
  validates :title, uniqueness: { case_sensitive: false }
  belongs_to :source
  belongs_to :author
  acts_as_taggable
end
