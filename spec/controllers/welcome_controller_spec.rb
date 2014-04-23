require 'spec_helper'

describe WelcomeController do
  it 'GET#index is successful' do
    get :index
    expect(response).to be_successful
  end
end