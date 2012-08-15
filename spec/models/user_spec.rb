# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  provider            :string(255)
#  uid                 :string(255)
#  name                :string(255)
#  email               :string(255)
#  first_name          :string(255)
#  last_name           :string(255)
#  birthday            :string(255)
#  location            :string(255)
#  hometown            :string(255)
#  employer            :string(255)
#  position            :string(255)
#  gender              :string(255)
#  relationship_status :string(255)
#  school              :string(255)
#  locale              :string(255)
#  oauth_token         :string(255)
#  oauth_expires_at    :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
