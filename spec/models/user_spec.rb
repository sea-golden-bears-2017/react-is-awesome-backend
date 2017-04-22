require 'rails_helper'
describe User do
  context 'associations' do
    let(:user) { FactoryGirl.create(:user) }
    let(:book) { FactoryGirl.create(:book) }
    it 'has a user relation' do
      expect(user.books).to be_an(ActiveRecord::Associations::CollectionProxy)
    end
    it 'can be associated with a user' do
      user.books << book
      expect(user.books).to include(book)
    end
  end

  context 'friends' do
    let(:user) { FactoryGirl.create(:user) }
    let(:friend) { FactoryGirl.create(:user) }
    before(:each) { user.friends << friend }

    it 'has friend as a friend' do
      expect(user.has_friend?(friend.id)).to be(true)
    end

    it 'is not a friend of friend' do
      expect(user.is_friend_of?(friend.id)).to be(false)
    end

    it 'can be associated with another friend' do
      user.friends << friend
      expect(user.friends).to include(friend)
    end

    it 'has one-directional association' do
      friend = FactoryGirl.create(:user)
      user.friends << friend
      expect(friend.friends).not_to include(user)
    end
  end
end
