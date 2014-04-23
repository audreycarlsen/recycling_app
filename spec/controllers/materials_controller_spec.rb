require 'spec_helper'

describe MaterialsController do
  let(:material){Material.new}

  it 'GET#show is successful' do
    get :show, id: material.id
    expect(response).to be_successful
  end
end