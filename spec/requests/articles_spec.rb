require 'rails_helper'

RSpec.describe ArticlesController do
  describe '#index' do
    it 'should return a success responce' do
      get '/articles'
      expect(response).to have_http_status(:ok)
    end

    it 'should return a proper JSON' do
      article = create :article
      get '/articles'

      aggregate_failures do
        expect(json_data.length).to eq(1)
        expected = json_data.first

        expect(expected[:id]).to eq(article.id.to_s)
        expect(expected[:type]).to eq('article')
        expect(expected[:attributes]).to eq(
          {
            title: article.title,
            content: article.content,
            slug: article.slug
          }
        )
      end
    end

    it 'should return articles in the correct order' do
      recent_article = create(:article)
      older_article = create(:article, created_at: 1.hour.ago)

      get '/articles'
      ids = json_data.map {_1[:id].to_i }

      expect(ids).to eq([recent_article.id, older_article.id])
    end

    it 'should paginate results' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json_data.length).to eq(1)
      expect(json_data.first[:id]).to eq(article2.id.to_s)
    end

    it 'should contain pagination links in the response' do
      article1, article2, article3 = create_list(:article, 3)
      get '/articles', params: { page: { number: 2, size: 1 } }
      expect(json[:links].length).to eq(5)
      expect(json[:links].keys).to contain_exactly(
        :first, :prev, :next, :last, :self
      )
    end
  end

  describe '#show' do
    let(:article) { create :article }
    subject { get "/articles/#{article.id}" }
    before { subject }

    it 'should return a success response' do
      expect(response).to have_http_status(:ok)
    end

    it 'should return a proper JSON' do
      aggregate_failures do
        expect(json_data[:id]).to eq(article.id.to_s)
        expect(json_data[:type]).to eq('article')
        expect(json_data[:attributes]).to eq(
          title: article.title,
          content: article.content,
          slug: article.slug
        )
      end
    end
  end
end
