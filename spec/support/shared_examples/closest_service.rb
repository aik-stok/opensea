shared_examples "closest_service" do |type|
  context "for #{type}" do
    let(:opponent) { send %i[ship shipment].find { |t| t != type } }
    let(:position) { Fabricate(:position, shippable: send(type), port: Port.find_by_title("Seaham")) }
    let(:request) { get :closest, params: { id: position.id } }

    before { opponent.update(hold_capacity: send(type).hold_capacity * 0.9) }

    context 'when position is not found' do
      it do
        get :closest, params: { id: 0 }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'with results' do
      let!(:position_closest) { Fabricate(:position, shippable: opponent, port: Port.find_by_title("Benghazi") ) }
      let!(:position_far) { Fabricate(:position, shippable: opponent, port: Port.find_by_title("Hirao") ) }
      let(:position_closest_two) { Fabricate(:position, shippable: opponent, port: Port.find_by_title("Benghazi") ) }

      context "when there is only one position for the date" do
        context 'the volume is suitable' do
          it do
            request
            expect(subject.count).to eq 1
            expect(subject.first["id"]).to eq position_closest.id
          end
        end

        context 'the volume is not suitable' do
          before { opponent.update(hold_capacity: send(type).hold_capacity * 0.89) }

          it do
            request
            expect(response).to have_http_status(:success)
            expect(subject["message"]).to eq "Nothing suitable is not found"
          end
        end
      end

      context 'when there are many positions for the date' do
        before { position_closest_two }

        it 'returns a few results' do
          request
          expect(subject.count).to eq 2
          expect(subject.map { |e| e["id"] }).to match_array [position_closest.id, position_closest_two.id]
        end
      end
    end

    context 'when there is no position for the date but there is for another date in the interval of 7 days' do
      let!(:position_closest_out_of_interval) { Fabricate(:position, shippable: opponent, port: Port.find_by_title("Dingle Harbour"), opened_at: 8.days.from_now) }
      let!(:position_closest) { Fabricate(:position, shippable: opponent, port: Port.find_by_title("Benghazi"), opened_at: 7.days.from_now) }
      let!(:position_far) { Fabricate(:position, shippable: opponent, port: Port.find_by_title("Hirao"), opened_at: 1.day.from_now) }

      it do
        request
        expect(subject.count).to eq 1
        expect(subject.first["id"]).to eq position_closest.id
      end
    end

    context 'when there is none position' do
      it 'returns empty array' do
        request
        expect(response).to have_http_status(:success)
        expect(subject["message"]).to eq "Nothing suitable is not found"
      end
    end
  end
end
