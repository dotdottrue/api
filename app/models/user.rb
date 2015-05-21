class User < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: :slugged
	has_many :messages

	def should_generate_new_friendly_id?
    new_record?
  end
end
