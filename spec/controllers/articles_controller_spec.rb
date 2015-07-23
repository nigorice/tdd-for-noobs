require 'spec_helper'

describe ArticlesController do
  describe 'GET #index' do
    it 'renders the index view' do
      get :index
      response.should render_template :index
    end

    it 'populates an array of articles' do
      article = FactoryGirl.create(:article)
      get :index

      assigns(:articles).should eq [article]
    end
  end
  
  #phendy
  context 'GET #show' do
    it 'should load new article page' do
      article = FactoryGirl.create(:article)
      get :show, { id: article.id }

      expect(response.code).to eq('200')
    end

    it 'should load comment on article page' do
      article = FactoryGirl.create(:article)
      comment = FactoryGirl.create(:comment, article_id: article.id)

      get :show, { id: article.id }

      expect(assigns(:comments)).to eq([comment])
    end
  end
end
