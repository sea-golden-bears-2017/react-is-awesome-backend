require 'rails_helper'
describe User do
  describe 'validates that' do
    it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
  end
end
