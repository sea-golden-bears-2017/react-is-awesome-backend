require 'rails_helper'
describe Book do
  [:title, :author, :genre].each do |field|
    it {is_expected.to validate_presence_of(field)}
  end
end
