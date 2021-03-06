require 'spec_helper'

describe Article do
  it 'should have a valid factory' do
    FactoryGirl.create(:article)
  end
  
  context 'validation' do
    it 'should not be valid without a title' do
      FactoryGirl.build(:article, title: '').should_not be_valid
    end

    it 'should not be valid with a title that has less than 5 characters' do
      FactoryGirl.build(:article, title: '1234').should_not be_valid
    end
  end

  context 'cache' do
    before(:each) do
      Rails.cache.clear # empty cache between each tests
    end

    it 'should cache with correct key' do
      Rails.cache.stub(:fetch)
      Rails.cache.should_receive(:fetch).with(['Article', 'all']).once
      Article.cached_all
    end

    it 'should cache all' do
      FactoryGirl.create(:article)

      all = Article.cached_all
      all.should be_kind_of(Array)
      all.count.should eq 1
    end

    it 'should invalidate cached_all on create' do
      Article.cached_all.count.should eq 0 # warm cache
      
      article = FactoryGirl.create(:article)

      Article.cached_all.count.should eq 1
    end

    it 'should invalidate cached_all on destroy' do
      article = FactoryGirl.create(:article)

      Article.cached_all.count.should eq 1 # warm cache
      
      article.destroy

      Article.cached_all.count.should eq 0
    end

    it 'should invalidate cached_all on update' do
      article = FactoryGirl.create(:article)

      Article.cached_all # warm cache

      article.text = 'abc'
      article.save!

      Article.cached_all.should eq [article]
    end
  end
end
