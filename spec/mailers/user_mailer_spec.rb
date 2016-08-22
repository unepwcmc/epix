require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'instructions' do
    let(:user) { FactoryGirl.create(:user,{ first_name: 'Gandalf', email: 'gandalf@email.com' }) }
    let(:mail) { described_class.welcome_email(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to EPIX')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['no-reply@epix.org'])
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.first_name)
    end
  end
end