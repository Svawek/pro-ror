RSpec.shared_examples 'check votes in model' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:vote) { create(:vote, votable: obj, user: user) }

  it 'object of user vote' do
    expect(obj.user_vote_obj(user).id).to be(vote.id)
  end

  it 'is user vote?' do
    expect(obj).to be_vote(user)
  end

end
