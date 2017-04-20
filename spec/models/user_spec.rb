require 'rails_helper'
describe User do
  describe 'validates that' do
    it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
  end
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

    it 'can be associated with another friend' do
      user2 = FactoryGirl.create(:user)
      user.friends << user2
      expect(user.friends).to include(user2)
    end

    it 'has one-directional association' do
      user2 = FactoryGirl.create(:user)
      user.friends << user2
      expect(user2.friends).not_to include(user2)
    end
  end
end
