require 'rails_helper'

RSpec.describe 'Users#index', type: :feature do
  let(:buyer1) { create(:user) }
  let(:accepted_delivery) { create(:delivery) }
  let(:pending_delivery) { create(:delivery, waiting_approval: true) }
  let(:accepted_volunteer) { create(:volunteer) }
  let(:pending_volunteer) { create(:pending_volunteer_info).user }
  let(:moderator) { create(:mod_info).user }
  subject { page }

  context 'attempt to access from unlogged user' do
    before(:each) { visit users_path }
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'Página disponível apenas para usuários cadastrados.' }
  end

  context 'attempt to access from pending user' do
    before(:each) do
      login(pending_delivery)
      visit users_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') {
      is_expected.to have_text
      'Sua conta precisa ser aprovada por um membro da equipe Terra Limpa para que você possa acessar esta página.'
    }
  end

  context 'access with buyer account' do
    let(:buyer) { create(:user) }
    before(:each) do
      login(buyer)
      visit users_path
    end
    it('redirects user to root') { is_expected.to have_current_path(root_path) }
    it('displays warning') { is_expected.to have_text 'O acesso a esta página não é permitido para sua conta.' }
  end

  context 'access with delivery point account' do
    let(:delivery) { create(:delivery) }
    before(:each) do
      login(delivery)
      visit users_path
    end
    it { is_expected.to have_text 'Compradores' }
    it { is_expected.to have_text 'Voluntários' }
    it { is_expected.to have_text 'Pontos de Entrega' }
    it { is_expected.to_not have_text 'Usuários Pendentes' }
    it { is_expected.to have_text 'Nome', count: 3 }
    it { is_expected.to have_text 'Telefone 1', count: 3 }
    # it { is_expected.to have_text 'Telefone 2', count: 3 }
    it { is_expected.to have_text 'Email', count: 3 }
    # it { is_expected.to have_text 'Endereço', count: 3 }
    it { is_expected.to_not have_text pending_delivery.name }
    it { is_expected.to_not have_text pending_volunteer.name }
    it { within('.buyers') { is_expected.to have_text buyer1.name } }
    it { within('.buyers') { is_expected.to have_text buyer1.email } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1 } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1_type } }
    it { within('.buyers') { is_expected.to have_link href: user_path(buyer1) } }
    # it { within('.buyers') { is_expected.to have_text buyer1.phone2 } }
    # it { within('.buyers') { is_expected.to have_text buyer1.phone2_type } }
    # it { within('.buyers') { is_expected.to have_text buyer1.address } }
    # it { within('.buyers') { is_expected.to have_text buyer1.city } }
    # it { within('.buyers') { is_expected.to have_text buyer1.state } }
    # it { within('.volunteers') { is_expected.to have_text 'Instagram' } }
    # it { within('.volunteers') { is_expected.to have_text 'Facebook' } }
    # it { within('.volunteers') { is_expected.to have_text 'Lattes' } }
    # it { within('.volunteers') { is_expected.to have_text 'Curso/Profissão' } }
    # it { within('.volunteers') { is_expected.to have_text 'Instituição/Empresa' } }
    # it { within('.volunteers') { is_expected.to have_text 'Vínculo com a UNEMAT' } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.name } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.email } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone1 } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone1_type } }
    it { within('.volunteers') { is_expected.to have_link href: user_path(accepted_volunteer) } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone2 } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone2_type } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.address } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.city } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.state } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.instagram } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.facebook } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.lattes } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.degree } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.institution } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.unemat_bond } }
    # it { within('.delivery-points') { is_expected.to have_text 'Parceiro Associado' } }
    # it { within('.delivery-points') { is_expected.to_not have_text 'CPF' } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.name } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.email } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone1 } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone1_type } }
    it { within('.delivery_points') { is_expected.to have_link href: user_path(accepted_delivery) } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone2 } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone2_type } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.address } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.city } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.state } }
    # it { within('.delivery-points') { is_expected.to_not have_text accepted_delivery.cpf } }
  end

  context 'access with volunteer account' do
    let(:volunteer) { create(:volunteer_info).user }
    before(:each) do
      login(volunteer)
      visit users_path
    end
    it { is_expected.to have_text 'Compradores' }
    it { is_expected.to have_text 'Voluntários' }
    it { is_expected.to have_text 'Pontos de Entrega' }
    it { is_expected.to_not have_text 'Usuários Pendentes' }
    it { is_expected.to have_text 'Nome', count: 3 }
    it { is_expected.to have_text 'Telefone 1', count: 3 }
    # it { is_expected.to have_text 'Telefone 2', count: 3 }
    it { is_expected.to have_text 'Email', count: 3 }
    # it { is_expected.to have_text 'Endereço', count: 3 }
    it { is_expected.to_not have_text pending_delivery.name }
    it { is_expected.to_not have_text pending_volunteer.name }
    it { within('.buyers') { is_expected.to have_text buyer1.name } }
    it { within('.buyers') { is_expected.to have_text buyer1.email } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1 } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1_type } }
    it { within('.buyers') { is_expected.to have_link href: user_path(buyer1) } }
    # it { within('.buyers') { is_expected.to have_text buyer1.phone2 } }
    # it { within('.buyers') { is_expected.to have_text buyer1.phone2_type } }
    # it { within('.buyers') { is_expected.to have_text buyer1.address } }
    # it { within('.buyers') { is_expected.to have_text buyer1.city } }
    # it { within('.buyers') { is_expected.to have_text buyer1.state } }
    # it { within('.volunteers') { is_expected.to have_text 'Instagram' } }
    # it { within('.volunteers') { is_expected.to have_text 'Facebook' } }
    # it { within('.volunteers') { is_expected.to have_text 'Lattes' } }
    # it { within('.volunteers') { is_expected.to have_text 'Curso/Profissão' } }
    # it { within('.volunteers') { is_expected.to have_text 'Instituição/Empresa' } }
    # it { within('.volunteers') { is_expected.to have_text 'Vínculo com a UNEMAT' } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.name } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.email } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone1 } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone1_type } }
    it { within('.volunteers') { is_expected.to have_link href: user_path(accepted_volunteer) } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone2 } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone2_type } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.address } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.city } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.state } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.instagram } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.facebook } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.lattes } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.degree } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.institution } }
    # it { within('.volunteers') { is_expected.to have_text accepted_volunteer.unemat_bond } }
    # it { within('.delivery-points') { is_expected.to have_text 'Parceiro Associado' } }
    # it { within('.delivery-points') { is_expected.to have_text 'CPF' } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.name } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.email } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone1 } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone1_type } }
    it { within('.delivery_points') { is_expected.to have_link href: user_path(accepted_delivery) } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone2 } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone2_type } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.address } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.city } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.state } }
    # it { within('.delivery-points') { is_expected.to have_text accepted_delivery.cpf } }
  end

  context 'access with moderator account' do
    before(:each) do
      login(moderator)
      visit users_path
    end
    it { is_expected.to have_text 'Nome', count: 4 }
    it { is_expected.to have_text 'Telefone 1', count: 4 }
    it { is_expected.to have_text 'Email', count: 4 }
    it { is_expected.to have_text 'Usuários Pendentes' }
    it { within('.pending-users') { is_expected.to have_text 'Tipo' } }
    it { within('.pending-users') { is_expected.to have_text 'Aprovar?' } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.name } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.email } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.phone1 } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.phone1_type } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.account_type } }
    it { within('.pending_users') { is_expected.to have_link href: user_path(pending_delivery) } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.name } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.email } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.phone1 } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.phone1_type } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.account_type } }
    it { within('.pending_users') { is_expected.to have_link href: user_path(pending_volunteer) } }
    it {
      within('.pending_users') do
        is_expected.to
        have_link 'Sim', user_path(id: pending_volunteer.id, waiting_approval: false)
      end
    }
    it {
      within('.pending_users') do
        is_expected.to
        have_link 'Não', user_path(id: pending_volunteer.id, waiting_approval: false, account_type: 'Comprador')
      end
    }
  end

  context 'access with administrator account' do
    let(:administrator) { create(:adm_info).user }
    before(:each) do
      login(administrator)
      visit users_path
    end
    it { is_expected.to have_text 'Ações' }
    it { is_expected.to have_link 'Tornar Voluntário', user_path(id: buyer1.id, account_type: 'Voluntário') }
    it { is_expected.to have_link 'Tornar Ponto de Venda', user_path(id: buyer1.id, account_type: 'Ponto de Venda') }
    it { is_expected.to have_link 'Tornar Comprador', user_path(id: accepted_volunteer.id, account_type: 'Comprador') }
    it { is_expected.to have_link 'Tornar Comprador', user_path(id: accepted_delivery.id, account_type: 'Comprador') }
    it { is_expected.to have_link 'Tornar Moderador', user_path(id: accepted_volunteer.id, moderator: true) }
    it { is_expected.to have_link 'Revogar Moderador', user_path(id: accepted_volunteer.id, moderator: false) }
  end
end
