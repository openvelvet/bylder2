class Profile < ActiveRecord::Base

	if Rails.env.development?
			has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/default.jpeg"
	else
			has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/default.jpeg",
												:storage => :dropbox,
									   	 	:dropbox_credentials => Rails.root.join("config/dropbox.yml"),
									   	  :path => ":style/:id_:filename"
 	end

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :current_title, presence: true
  validates :industry, presence: true
  validates :experience_level, presence: true
  validates :linkedin_profile_link, presence: true
  validates :years_of_experience, numericality: true
  validates :price, numericality: { greater_than: 0 }
  validates :image, :attachment_presence => true

  belongs_to :user
  has_many :orders
  

end
