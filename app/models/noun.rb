class Noun < ActiveRecord::Base

  def self.search(search)
	if search
	  find(:all, :limit => 30, :conditions => ['UPPER(nouns.title) LIKE UPPER(?) AND nouns.b_active <> ?', "%#{search}%", 1], :order => 'nouns.title')
	else
	  find(:all, :limit => 10, :order => 'nouns.title' )
	end
  end

end