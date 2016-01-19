require 'spec_helper'

class HomeController < Hola::BaseController
  def index
    '¡Hola! espanioles!!!!!!'
  end

  def name
    "¡Hola! #{params[:name]}"
  end
end

class LandingController < Hola::BaseController
  def index
    'Landing page'
  end
end

class QuotesController < Hola::BaseController
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

describe Hola do
  it 'has a version number' do
    expect(Hola::VERSION).not_to be nil
  end

  describe 'basic routes' do
    let(:app) do
      class App < Hola::Application
        get '/', 'home/index'
        get '/quotes', 'quotes/index'
        get '/quotes/a_quote', 'quotes/a_quote'
        get '/quotes/quotes', 'quotes/quotes'
      end

      App.new
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

  describe 'custom routes' do
    let(:app) do
      class App < Hola::Application
        get '/', 'landing/index'
      end

      App.new
    end

    it 'can define route' do
      get '/'
      expect(last_response).to be_ok
    end
  end
end
