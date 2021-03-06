require 'rails_helper'

RSpec.describe 'VolunteerInfos#new', type: :feature do
  subject { page }

  context 'attempt to access from unlogged user' do
    before(:each) { visit new_volunteer_info_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

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
    let(:volunteer) { create(:volunteer) }
    before(:each) { login(volunteer) }
    it { is_expected.to have_field 'Endereço*' }
    it { is_expected.to have_field 'Cidade*' }
    it {
      is_expected.to have_select 'Estado*', with_options:
      %w[AC AL AM AP BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RO RS RR SC SE SP TO]
    }
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
      fill_in 'Endereço*', with: brazilian_address
      fill_in 'Cidade*', with: Faker::Address.city
      select state_creator, from: 'Estado*'
      fill_in 'Instituição/Empresa*',	with: volunteer_info.institution
      fill_in 'Área de Estudo/Trabalho*',	with: volunteer_info.degree
      select volunteer_info.unemat_bond, from: 'Vínculo com a UNEMAT*'
      fill_in 'Instagram',	with: volunteer_info.instagram
      fill_in 'Facebook',	with: volunteer_info.facebook
      fill_in 'Lattes',	with: volunteer_info.lattes
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
