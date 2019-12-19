class Profile < ApplicationRecord
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  belongs_to :user
  has_one_attached :avatar

  def get_size
    ActiveStorage::Analyzer::ImageAnalyzer.new(avatar).metadata
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def cropped_image
    if avatar.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings['w']}x#{crop_settings['h']}"
        coord = "#{crop_settings['x']}+#{crop_settings['y']}"
        avatar.variant(
          crop: "#{dimensions}+#{coord}"
        ).processed
      else
        avatar
      end
    end
  end

  def thumbnail(size = '100x100')
    if avatar.attached?
      if crop_settings.is_a? Hash
        dimensions = "#{crop_settings['w']}x#{crop_settings['h']}"
        coord = "#{crop_settings['x']}+#{crop_settings['y']}"
        avatar.variant(
        crop: "#{dimensions}+#{coord}",
        resize: size
        ).processed
      else
        avatar.variant(resize: size).processed
      end
    end
  end
end
