require 'rails_helper'

describe 'Authorization' do
  let(:user) { FactoryGirl.create(:user) }
  it 'encodes a user to a string' do
    token = Authorization.encode_token(user)
    expect(token).not_to be(nil)
  end

  it 'encodes and then decodes a token' do
    token = Authorization.encode_token(user)
    expect(Authorization.decode_token(token)).to eq(user.id)
  end

  it 'returns nil if the token is invalid' do
    expect(Authorization.decode_token('aoeu')).to be_nil
  end
end
