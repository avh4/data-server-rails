require 'spec_helper'

describe TransactionsController do
  let(:app_id) { 'new app' }

  describe '#get' do
    context 'when the app does not exist' do
      it 'returns an empty array' do
        get :get, app_id: app_id, last: 0
        response.should be_ok
        json_response.should == []
      end
    end

    context 'when the app has records' do
      before do
        Transaction.create!(app_id: app_id, key: "k1", value: "v1")
        Transaction.create!(app_id: app_id, key: "k2", value: "v2")
      end

      it 'returns the new records' do
        get :get, app_id: app_id, last: 0
        response.should be_ok
        json_response.should == [
          [1, "k1", "v1"],
          [2, "k2", "v2"],
        ]
      end

      it 'returns records starting at the requested point' do
        get :get, app_id: app_id, last: 1
        response.should be_ok
        json_response.should == [[2, "k2", "v2"]]
      end
    end
  end
end