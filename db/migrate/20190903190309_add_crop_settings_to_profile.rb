class AddCropSettingsToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :crop_settings, :json
  end
end
