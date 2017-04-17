require 'rails_helper'
describe Book do
  context 'validates that' do
    [:title, :author, :genre].each do |field|
      it {is_expected.to validate_presence_of(field)}
    end
  end
  context 'associations' do
    let(:user) { FactoryGirl.create(:user) }
    let(:book) { FactoryGirl.create(:book) }
    it 'has a user relation' do
      expect(book.users).to be_an(ActiveRecord::Associations::CollectionProxy)
    end
    it 'can be associated with a user' do
      book.users << user
      expect(book.users).to include(user)
    end
  end
end
