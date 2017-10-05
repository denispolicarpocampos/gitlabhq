require 'spec_helper'

describe Gitlab::Git::User do
  let(:username) { 'janedo' }
  let(:name) { 'Jane Doe' }
  let(:email) { 'janedoe@example.com' }
  let(:gl_id) { 'user-123' }

  subject { described_class.new(username, name, email, gl_id) }

  describe '.from_gitaly' do
    let(:gitaly_user) { Gitaly::User.new(name: name, email: email, gl_id: gl_id) }
    subject { described_class.from_gitaly(gitaly_user) }

    it { expect(subject).to eq(described_class.new('', name, email, gl_id)) }
  end

  describe '.from_gitlab' do
    let(:user) { build(:user) }
    subject { described_class.from_gitlab(user) }

    it { expect(subject).to eq(described_class.new(user.username, user.name, user.email, 'user-')) }
  end

  describe '#==' do
    def eq_other(username, name, email, gl_id)
      eq(described_class.new(username, name, email, gl_id))
    end

    it { expect(subject).to eq_other(username, name, email, gl_id) }

    it { expect(subject).not_to eq_other(nil, nil, nil, nil) }
    it { expect(subject).not_to eq_other(username + 'x', name, email, gl_id) }
    it { expect(subject).not_to eq_other(username, name + 'x', email, gl_id) }
    it { expect(subject).not_to eq_other(username, name, email + 'x', gl_id) }
    it { expect(subject).not_to eq_other(username, name, email, gl_id + 'x') }
  end
end
