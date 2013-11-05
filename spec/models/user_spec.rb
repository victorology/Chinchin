require 'spec_helper'

describe User do
  before(:each) do
    User.delete_all
    @user = FactoryGirl.create(:user, name: 'kim', gender: 'male', uid: '0000', status: 1, oauth_token: '1234')

    #request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  #context 'OmniAuth' do
  #  it 'return valid user when authentication success' do
  #    get :index
  #    auth = OmniAuth.config.mock_auth[:facebook]
  #    auth_obj = OpenStruct.new auth
  #    user = User.create_from_omniauth(auth_obj)
  #  end
  #end

  context 'fb_graph' do
    it 'should call FbGraph method when access user facebook' do
      FbGraph::User.should_receive(:me).with(@user.oauth_token)
      @user.facebook
    end

    it 'should call FbGraph method when access user friends' do
      FbGraph::User.any_instance.should_receive(:friends)
      @user.friends
    end

    it 'should add friend to chinchin service' do
      @user.add_friend_to_chinchin(friend)
    end
  end

  context 'Chinchin' do
    it 'return false when a given chinchin has same gender' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = FactoryGirl.create(:chinchin, gender:'male')
      user.pass_default_chinchin_filter(chinchin).should == false
    end
    it 'return false when a given chinchin is married' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = FactoryGirl.create(:chinchin, gender:'female', relationship_status:'Married')
      user.pass_default_chinchin_filter(chinchin).should == false
    end
    it 'return false when a given chinchin is engaged' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = FactoryGirl.create(:chinchin, gender:'female', relationship_status:'Engaged')
      user.pass_default_chinchin_filter(chinchin).should == false
    end
  end

  context 'Like' do
    it 'can like somebody' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = stub(:user_or_chinchin, id: "100", first_name: "my_name", users: [], user: nil)
      user.like(chinchin)
      user.liked(chinchin).should be_true
    end
  end

  context 'View' do
    it 'can view somebody' do
      user = FactoryGirl.create(:user, gender: 'male')
      chinchin = stub(:user_or_chinchin, id: "100", first_name: "my_name", users: [], user: nil)
      user.view(chinchin)
      user.viewed(chinchin).should be_true
    end
  end

  context 'sorted_chinchin' do
    it 'should pop the first chinchin in sorted_chinchin when user chose the chinchin' do
      user = FactoryGirl.create(:user, id: 100, gender: 'male', sorted_chinchin: [101, 102])
      chinchin_1 = FactoryGirl.create(:user, id: 101, gender: 'female')
      chinchin_2 = FactoryGirl.create(:user, id: 102, gender: 'female')

      user.sorted_chinchin.should eq [chinchin_1.id, chinchin_2.id]
      user.chinchin.should eq [chinchin_1]
      user.sorted_chinchin.should eq [chinchin_2.id]
    end

    it 'should pop the second chinchin in sorted_chinchin when the first chinchin is same gender' do
      user = FactoryGirl.create(:user, id: 100, gender: 'male', sorted_chinchin: [101, 102])
      chinchin_1 = FactoryGirl.create(:user, id: 101, gender: 'male')
      chinchin_2 = FactoryGirl.create(:user, id: 102, gender: 'female')

      user.sorted_chinchin.should eq [chinchin_1.id, chinchin_2.id]
      user.chinchin.should eq [chinchin_2]
      user.sorted_chinchin.should eq []
    end

    it 'should push the poped chinchin in sorted_chinchin to chosen_chinchin' do
      user = FactoryGirl.create(:user, id: 100, gender: 'male', sorted_chinchin: [101, 102])
      chinchin_1 = FactoryGirl.create(:user, id: 101, gender: 'female')
      chinchin_2 = FactoryGirl.create(:user, id: 102, gender: 'female')

      user.sorted_chinchin.should eq [chinchin_1.id, chinchin_2.id]
      user.chinchin.should eq [chinchin_1]
      user.sorted_chinchin.should eq [chinchin_2.id]
      user.chosen_chinchin.should eq [chinchin_1.id]
    end

    it 'should substract chosen_chinchin from sorted_chinchin after regenerate sorted_chinchin' do
      user = FactoryGirl.create(:user, id: 100, gender: 'male', sorted_chinchin: [101, 102, 103, 104])
      chinchin_0 = FactoryGirl.create(:user, id: 99, gender: 'male')
      chinchin_1 = FactoryGirl.create(:user, id: 101, gender: 'male')
      chinchin_2 = FactoryGirl.create(:user, id: 102, gender: 'male')
      chinchin_3 = FactoryGirl.create(:user, id: 103, gender: 'female')
      chinchin_4 = FactoryGirl.create(:user, id: 104, gender: 'female')
      user.stub(:friends_in_chinchin) { [chinchin_0] }
      chinchin_0.stub(:friends_in_chinchin) { [chinchin_1] }
      chinchin_0.stub(:chinchins) { [chinchin_2, chinchin_3, chinchin_4] }

      user.sorted_chinchin.should eq [chinchin_1.id, chinchin_2.id, chinchin_3.id, chinchin_4.id]
      user.chinchin.should eq [chinchin_3]
      user.sorted_chinchin.should eq [chinchin_4.id]
      user.chosen_chinchin.should eq [chinchin_1.id, chinchin_2.id, chinchin_3.id]
      user.generate_sorted_chinchin
      user.sorted_chinchin.first.should eq chinchin_1.id
      user.sorted_chinchin.sort.should eq [chinchin_1.id, chinchin_2.id, chinchin_3.id, chinchin_4.id]
    end

    it 'should empty chosen_chinchin when regenerate sorted_chinchin with empty sorted_chinchin' do
      user = FactoryGirl.create(:user, id: 100, gender: 'male', sorted_chinchin: [], chosen_chinchin: [102, 103, 104])
      chinchin = FactoryGirl.create(:user, id: 101, gender: 'male')
      chinchin_1 = FactoryGirl.create(:user, id: 102, gender: 'male')
      chinchin_2 = FactoryGirl.create(:user, id: 103, gender: 'male')
      chinchin_3 = FactoryGirl.create(:user, id: 104, gender: 'female')
      user.stub(:friends_in_chinchin) { [chinchin] }

      chinchin.stub(:friends_in_chinchin) { [chinchin_1] }
      chinchin.stub(:chinchins) { [chinchin_2, chinchin_3] }

      user.sorted_chinchin.empty?.should be_true
      user.chosen_chinchin.empty?.should be_false
      user.generate_sorted_chinchin
      user.chosen_chinchin.should be_nil
      user.sorted_chinchin.first.should eq 102
      user.sorted_chinchin.sort.should eq [102, 103, 104]
    end
  end
end