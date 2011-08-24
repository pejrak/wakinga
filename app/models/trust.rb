class Trust < ActiveRecord::Base
    attr_accessible :trustee_id, :interest_id, :trustor_id

	belongs_to :interest
  	belongs_to :trustee, :class_name => "User"
    belongs_to :trustor, :class_name => "User"

	def confirmed?
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
		Trust.where(:trustor_id => trustee)
	end

end
