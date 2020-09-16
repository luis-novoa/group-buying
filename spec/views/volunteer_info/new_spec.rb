require 'rails_helper'

RSpec.describe 'VolunteerInfo#new', type: :feature do
  subject { page }

  context 'attempt to access from buyer' do
    let(:buyer) { create(:user) }
    before(:each) do
      login(buyer)
      visit new_volunteer_info_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'attempt to access from delivery point' do
    let(:delivery_point) { create(:delivery) }
    before(:each) do
      login(delivery_point)
      visit new_volunteer_info_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'structure' do
    before(:each) { login(volunteer) }
    let(:volunteer) { create(:volunteer) }
    it { is_expected.to have_field 'Instagram' }
    it { is_expected.to have_field 'Facebook' }
    it { is_expected.to have_field 'Lattes' }
    it { is_expected.to have_field 'Instituição/Empresa*' }
    it { is_expected.to have_field 'Área de Estudo/Trabalho*' }
    it {
      is_expected.to have_select 'Vínculo com a UNEMAT*',
                                 with_options: ['Professor', 'Aluno', 'Colaborador Externo']
    }
  end

  context 'succesful creation' do
    let(:volunteer_info) { build(:volunteer_info) }
    let(:volunteer) { create(:volunteer) }
    before(:each) do
      login(volunteer)
      fill_in 'Instituição/Empresa*',	with: volunteer_info.institution
      fill_in 'Área de Estudo/Trabalho*',	with: volunteer_info.degree
      select volunteer_info.unemat_bond, from: 'Vínculo com a UNEMAT*'
      fill_in 'Instagram',	with: volunteer_info.instagram
      fill_in 'Facebook',	with: volunteer_info.facebook
      fill_in 'Lattes',	with: volunteer_info.lattes
      sleep(5)
      click_on 'Enviar'
    end
    it('adds informations to the database') { expect(VolunteerInfo.all.count).to eq(1) }
    it('redirects to root') { is_expected.to have_current_path(root_path) }
  end

  context 'unsuccesful creation' do
    let(:volunteer) { create(:volunteer) }
    before(:each) do
      login(volunteer)
      click_on 'Enviar'
    end
    it('show errors') { is_expected.to have_css('.alert-danger') }
  end
end
