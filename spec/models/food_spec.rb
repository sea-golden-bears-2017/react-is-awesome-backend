require 'rails_helper'

describe Food do
  context 'validates that' do
    [:name, :unit].each do |field|
      it {is_expected.to validate_presence_of(field)}
    end
  end
end
