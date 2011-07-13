class Trust < ActiveRecord::Base
    attr_accessible :trustee_id, :interest_id

	belongs_to :interest
  	belongs_to :trustee, :class_name => "User"

	def trustor
		self.interest.user
	end

	def shared?
		interests_collection = []
		for t in trusts_by_trustee_to_me do interests_collection << t.interest end
		return (self.interest.compare_beads_with_other_interests(interests_collection)).present?
	end

	def trusted_interests
		interests_collection = []
		for t in trusts_by_trustee_to_me do interests_collection << t.interest end
		return interests_collection
	end

	def trusts_by_trustee_to_me
		Trust.where(:trustee_id => trustor)
	end

end
