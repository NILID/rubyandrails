class Article < ApplicationRecord
  belongs_to :user, optional: true, counter_cache: true
  has_many :urls, dependent: :destroy, as: :urlable

  STATUSES = %w[hidden published deleted].freeze

  scope :unpublished, -> { with_status(:hidden) }
  scope :published,   -> { with_status(:published) }
  scope :deleted,     -> { with_status(:deleted) }

  validates :title, :content, presence: true

  accepts_nested_attributes_for :urls, reject_if: :all_blank, allow_destroy: true

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def statuses=(statuses)
    self.statuses_mask = (statuses & DISPLAY_STATUSES).map { |s| 2**STATUSES.index(s) }.inject(0, :+)
  end

  def statuses
    STATUSES.reject do |s|
      ((statuses_mask.to_i || 0) & 2**STATUSES.index(s)).zero?
    end
  end

  def has_status?(status)
    statuses.include?(status.to_s)
  end

  def self.with_status(status)
    where('statuses_mask & ? > 0', 2**STATUSES.index(status.to_s))
  end
end
