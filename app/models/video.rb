class Video < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :url, presence: true, format: { with: URI.regexp(%w(http https)), message: I18n.t('videos.must_have_http') }
  validates :url, format: { with: /(youtu.be|youtube.com\/watch\?(?=[^?]*v=\w+)(?:[^\s?]*)$)/, message: I18n.t('videos.must_have_youtube') }

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def update_views(by = 1)
    self.views ||= 0
    self.views += by
    self.save
  end
end
