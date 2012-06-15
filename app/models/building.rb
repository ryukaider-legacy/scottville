# == Schema Information
#
# Table name: buildings
#
#  id         :integer         not null, primary key
#  residence  :integer
#  credit     :integer
#  aether     :integer
#  item       :integer
#  stealth    :integer
#  defense    :integer
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Building < ActiveRecord::Base
  attr_accessible :aether, :credit, :defense, :item, :residence, :stealth
  belongs_to :user
  
  validates :user_id, presence: true
end
