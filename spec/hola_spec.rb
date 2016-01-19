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

class PostController < Hola::BaseController
  def index
    'Post page'
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

class UsersController < Hola::BaseController
  def index
    'Index'
  end

  def show
    "Show #{params[:id]}"
  end

  def new
    'New'
  end

  def edit
    'Edit'
  end

  def create
    'Create'
  end

  def update
    'Update'
  end

  def delete
    'Delete'
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
        post '/post', 'post/index'
      end

      App.new
    end

    it 'can define route' do
      get '/'
      expect(last_response).to be_ok
    end

    it 'can define post route' do
      post '/post'
      expect(last_response).to be_ok
    end
  end

  describe 'routes with block' do
    let(:app) do
      class App < Hola::Application
        get '/test' do
          'Test block'
        end
      end

      App.new
    end

    it 'can run route with block' do
      get '/test'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Test block')
    end
  end

  describe 'routes for resources' do
    let(:app) do
      class App < Hola::Application
        resource :users
      end

      App.new
    end

    it 'has index action' do
      get '/users'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Index')
    end

    it 'has new action' do
      get '/users/new'
      expect(last_response).to be_ok
      expect(last_response.body).to include('New')
    end

    it 'has show action' do
      get '/users/show/1'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Show')
    end

    it 'has edit action' do
      get '/users/edit'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Edit')
    end

    it 'has create post action' do
      post '/users/create'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Create')
    end

    it 'has update post action' do
      post '/users/update'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Update')
    end

    it 'has delete action' do
      get '/users/delete'
      expect(last_response).to be_ok
      expect(last_response.body).to include('Delete')
    end
  end
end
