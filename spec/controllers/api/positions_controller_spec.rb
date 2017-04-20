require 'rails_helper'

RSpec.describe Api::PositionsController, type: :controller do
  before do
    # loading of ports
    Rails.application.load_seed
  end

  let(:subject) { JSON.parse response.body }

  describe "GET #closest" do
    let!(:ship) { Fabricate(:ship) }
    let!(:shipment) { Fabricate(:shipment) }

    it_behaves_like "closest_service", :ship
    it_behaves_like "closest_service", :shipment
  end
end
