require 'rails_helper'

RSpec.shared_examples 'delete files' do |deleted_files, authenticated_user|
  let(:author) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, :with_file, user: author) }
  let!(:answer) { create(:answer, :with_file, user: author) }

  it 'should change ammount of attached files by deleted files' do
    if authenticated_user == 'author'
      login(author)
    elsif authenticated_user == 'non-author'
      login(user2)
    end

    expect do
      delete :destroy, params: { id: question.files.first }, format: :js
      delete :destroy, params: { id: answer.files.first }, format: :js
    end.to change(ActiveStorage::Blob, :count).by(deleted_files)
  end
end

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #delete_file' do
    context 'delete files by author' do
      include_examples "delete files",  -2, 'author'
    end

    context 'delete files by non-author' do
      include_examples "delete files",  0, 'non-author'
    end

    context 'delete files by nonautheticated user' do
      include_examples "delete files",  0, nil
    end

    context 'render view after file deleting' do
      let(:author) { create(:user) }
      let!(:question) { create(:question, :with_file, user: author)}

      it 're-render delete_file view' do
        login(author)
        delete :destroy, params: { id: question.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end
end
