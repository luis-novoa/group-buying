require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { Payment.new }

  it { is_expected.to have_many(:orders) }
end
