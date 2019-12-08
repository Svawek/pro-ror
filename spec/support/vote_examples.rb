RSpec.shared_examples 'check votes in model' do
  it { should have_many(:votes).dependent(:destroy) }

  let!(:vote) { create(:vote, votable: obj, user: user) }

  it 'object of user vote' do
    expect(obj.user_vote_obj(user)).to eq(vote)
  end

  it 'is user vote?' do
    expect(obj).to be_vote(user)
  end

  context 'count votes(positive)' do
    let!(:vote1) { create_list(:vote, 3, votable: obj, choice: false) }
    let!(:vote2) { create_list(:vote, 7, votable: obj) }

    it {expect(obj.count_votes).to eq(5)}
  end

  context 'count votes(negative)' do
    let!(:vote1) { create_list(:vote, 7, votable: obj, choice: false) }
    let!(:vote2) { create_list(:vote, 3, votable: obj) }

    it {expect(obj.count_votes).to eq(-3)}
  end

end
