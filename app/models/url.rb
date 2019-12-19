class Url < ApplicationRecord
  belongs_to :urlable, polymorphic: true

  validates :url, presence: true, url: true
end
