class Evolution < ActiveRecord::Base
  #attr_accessible :evolution_id
  acts_as_tree :foreign_key => 'evolution_id', :dependent => :destroy
  has_many :mutations
end
