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
  end
end
