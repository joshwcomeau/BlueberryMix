# == Schema Information
#
# Table name: mixes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Mix < ActiveRecord::Base

  belongs_to :user
end
