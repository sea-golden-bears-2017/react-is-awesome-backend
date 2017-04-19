require 'rails_helper'

describe Product do
  describe 'validates' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :price }
  end
end
