class AddFieldToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :current_title, :string
    add_column :profiles, :industry, :string
    add_column :profiles, :experience_level, :string
    add_column :profiles, :linkedin_profile_link, :string
  end
end
