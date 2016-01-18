require 'spec_helper'

describe Hola do
  it 'has a version number' do
    expect(Hola::VERSION).not_to be nil
  end

  describe 'basic routes' do
    let(:app) do
      class HomeController < Hola::Controller
        def index
          'Hola! espanioles!!!!!!'
        end
      end
      class QuotesController < Hola::Controller
        def index
          'Quotes index'
        end
        def a_quote
          'There is quote'
        end
        def quotes
          'There are quotes'
        end
      end
      Hola::Application.new
    end

    it 'has home page' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Hola!')
    end

    it 'has quotes index page' do
      get '/quotes'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Quotes index')
    end

    it 'has quote page' do
      get '/quotes/a_quote'
      expect(last_response).to be_ok
      expect(last_response.body).to include('There is quote')
    end

    it 'has quotes page' do
      get '/quotes/quotes'
      expect(last_response).to be_ok
      expect(last_response.body).to include('There are quotes')
    end
  end
end
