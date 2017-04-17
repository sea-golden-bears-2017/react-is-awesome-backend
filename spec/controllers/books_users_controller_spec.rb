require 'rails_helper'

describe BooksUsersController do
  let(:user) { FactoryGirl.create :user }
  let(:book) { FactoryGirl.create :book }

  it 'responds with json containing books for a specific user' 
end
