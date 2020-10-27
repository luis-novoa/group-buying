require 'rails_helper'

RSpec.describe 'Users#index', type: :feature do
  let!(:buyer1) { create(:user) }
  let(:accepted_delivery) { create(:delivery) }
  let!(:pending_delivery) { create(:delivery) }
  let(:accepted_volunteer) { create(:volunteer) }
  let!(:pending_volunteer) { create(:pending_volunteer_info).user }
  let(:moderator) { create(:mod_info).user }
  subject { page }

  before(:each) do
    accepted_delivery.update(waiting_approval: false)
    accepted_volunteer.update(waiting_approval: false)
    moderator.update(waiting_approval: false)
  end

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
      is_expected.to have_text(
        'Sua conta precisa ser aprovada por um membro da equipe Terra Limpa para que você possa acessar esta página.'
      )
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
      delivery.update(waiting_approval: false)
      login(delivery)
      visit users_path
    end
    it { is_expected.to have_text 'Compradores' }
    it { is_expected.to have_text 'Voluntários' }
    it { is_expected.to have_text 'Pontos de Entrega' }
    it { is_expected.to have_no_text 'Usuários Pendentes' }
    it { is_expected.to have_text 'Nome', count: 3 }
    it { is_expected.to have_text 'Telefone', count: 3 }
    it { is_expected.to have_text 'Email', count: 3 }
    it { is_expected.to have_no_text pending_delivery.name }
    it { is_expected.to have_no_text pending_volunteer.name }
    it { within('.buyers') { is_expected.to have_text buyer1.name } }
    it { within('.buyers') { is_expected.to have_text buyer1.email } }
    it { within('.buyers') { is_expected.to have_text phone_format(buyer1.ddd1, buyer1.phone1) } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1_type } }
    it { within('.buyers') { is_expected.to have_link href: user_path(buyer1) } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.name } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.email } }
    it {
      within('.volunteers') do
        is_expected.to have_text phone_format(accepted_volunteer.ddd1, accepted_volunteer.phone1)
      end
    }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone1_type } }
    it { within('.volunteers') { is_expected.to have_link href: user_path(accepted_volunteer) } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.name } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.email } }
    it {
      within('.delivery-points') do
        is_expected.to have_text phone_format(accepted_delivery.ddd1, accepted_delivery.phone1)
      end
    }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone1_type } }
    it { within('.delivery-points') { is_expected.to have_link href: user_path(accepted_delivery) } }
  end

  context 'access with volunteer account' do
    let(:volunteer) { create(:volunteer_info).user }
    before(:each) do
      volunteer.update(waiting_approval: false)
      login(volunteer)
      visit users_path
    end
    it { is_expected.to have_text 'Compradores' }
    it { is_expected.to have_text 'Voluntários' }
    it { is_expected.to have_text 'Pontos de Entrega' }
    it { is_expected.to have_no_text 'Usuários Pendentes' }
    it { is_expected.to have_text 'Nome', count: 3 }
    it { is_expected.to have_text 'Telefone', count: 3 }
    it { is_expected.to have_text 'Email', count: 3 }
    it { is_expected.to have_no_text pending_delivery.name }
    it { is_expected.to have_no_text pending_volunteer.name }
    it { within('.buyers') { is_expected.to have_text buyer1.name } }
    it { within('.buyers') { is_expected.to have_text buyer1.email } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1 } }
    it { within('.buyers') { is_expected.to have_text buyer1.phone1_type } }
    it { within('.buyers') { is_expected.to have_link href: user_path(buyer1) } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.name } }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.email } }
    it {
      within('.volunteers') do
        is_expected.to have_text phone_format(accepted_volunteer.ddd1, accepted_volunteer.phone1)
      end
    }
    it { within('.volunteers') { is_expected.to have_text accepted_volunteer.phone1_type } }
    it { within('.volunteers') { is_expected.to have_link href: user_path(accepted_volunteer) } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.name } }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.email } }
    it {
      within('.delivery-points') do
        is_expected.to have_text phone_format(accepted_delivery.ddd1, accepted_delivery.phone1)
      end
    }
    it { within('.delivery-points') { is_expected.to have_text accepted_delivery.phone1_type } }
    it { within('.delivery-points') { is_expected.to have_link href: user_path(accepted_delivery) } }
  end

  context 'access with moderator account' do
    before(:each) do
      moderator.update(waiting_approval: false)
      login(moderator)
      visit users_path
    end
    it { is_expected.to have_text 'Nome', count: 4 }
    it { is_expected.to have_text 'Telefone', count: 4 }
    it { is_expected.to have_text 'Email', count: 4 }
    it { is_expected.to have_text 'Usuários Pendentes' }
    it { within('.pending-users') { is_expected.to have_text 'Tipo' } }
    it { within('.pending-users') { is_expected.to have_text 'Aprovar?' } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.name } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.email } }
    it {
      within('.pending-users') do
        is_expected.to have_text phone_format(pending_delivery.ddd1, pending_delivery.phone1)
      end
    }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.phone1_type } }
    it { within('.pending-users') { is_expected.to have_text pending_delivery.account_type } }
    it { within('.pending-users') { is_expected.to have_link href: user_path(pending_delivery) } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.name } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.email } }
    it {
      within('.pending-users') do
        is_expected.to have_text phone_format(pending_volunteer.ddd1, pending_volunteer.phone1)
      end
    }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.phone1_type } }
    it { within('.pending-users') { is_expected.to have_text pending_volunteer.account_type } }
    it { within('.pending-users') { is_expected.to have_link href: user_path(pending_volunteer) } }
    it {
      within('.pending-users') do
        is_expected.to have_link 'Sim', href: "/users/#{pending_volunteer.id}?waiting_approval=false"
      end
    }
    it {
      within('.pending-users') do
        is_expected.to have_link 'Não',
                                 href: "/users/#{pending_volunteer.id}?account_type=Comprador&waiting_approval=false"
      end
    }
    context 'accepts pending user' do
      before(:each) do
        pending_delivery.destroy
        visit users_path
        click_on 'Sim'
      end
      it("doesn't change account type") { expect(pending_volunteer.reload.account_type).to eq('Voluntário') }
      it('change waiting_approval') { expect(pending_volunteer.reload.waiting_approval).to eq(false) }
    end

    context 'rejects pending user' do
      before(:each) do
        pending_delivery.destroy
        visit users_path
        click_on 'Não'
      end
      it('change account type') { expect(pending_volunteer.reload.account_type).to eq('Comprador') }
      it('change waiting_approval') { expect(pending_volunteer.reload.waiting_approval).to eq(false) }
    end
  end

  context 'access with administrator account' do
    let(:administrator) { create(:adm_info).user }
    before(:each) do
      administrator.update(waiting_approval: false)
      login(administrator)
      visit users_path
    end
    it { is_expected.to have_text 'Ações', count: 3 }
    it { is_expected.to have_link 'Tornar Voluntário', href: "/users/#{buyer1.id}?account_type=Volunt%C3%A1rio" }
    it { is_expected.to have_link 'Tornar Comprador', href: "/users/#{accepted_volunteer.id}?account_type=Comprador" }
    it { is_expected.to have_link 'Tornar Comprador', href: "/users/#{accepted_delivery.id}?account_type=Comprador" }
    it {
      is_expected.to have_link 'Tornar Voluntário',
                               href: "/users/#{accepted_delivery.id}?account_type=Volunt%C3%A1rio"
    }
    it { is_expected.to have_link 'Tornar Moderador', href: "/users/#{accepted_volunteer.id}?moderator=true" }
    it { is_expected.to have_link 'Revogar Moderador', href: "/users/#{moderator.id}?moderator=false" }

    it 'turns another user into volunteer' do
      within("#buyer-#{buyer1.id}") { click_on 'Tornar Voluntário' }
      expect(buyer1.reload.account_type).to eq('Voluntário')
    end

    it 'turns another user into buyer' do
      within("#volunteer-#{accepted_volunteer.id}") { click_on 'Tornar Comprador' }
      expect(accepted_volunteer.reload.account_type).to eq('Comprador')
    end

    it 'turns a volunteer into a moderator' do
      within("#volunteer-#{accepted_volunteer.id}") { click_on 'Tornar Moderador' }
      expect(accepted_volunteer.reload.moderator).to eq(true)
    end

    it 'revokes moderator' do
      within("#volunteer-#{moderator.id}") { click_on 'Revogar Moderador' }
      expect(moderator.reload.moderator).to eq(false)
    end
  end
end
