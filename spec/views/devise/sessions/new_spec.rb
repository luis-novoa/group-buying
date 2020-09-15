RSpec.describe 'Sessions#new', type: :feature do
  subject { page }

  context 'Volunteer login' do
    let(:volunteer) { create(:volunteer) }
    before(:each) { login(volunteer) }
    it { is_expected.to have_current_path(new_volunteer_info_path) }
  end

  context 'Buyer login' do
    let(:user) { create(:user) }
    before(:each) { login(user) }
    it { is_expected.to have_current_path(root_path) }
  end

  context 'Delivery point login' do
    let(:delivery) { create(:delivery) }
    before(:each) { login(delivery) }
    it { is_expected.to have_current_path(root_path) }
  end
end
