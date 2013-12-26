require 'spec_helper'

describe TransactionsController do
  let(:app_id) { "TransactionsController APP #{Time.now}" }
  let(:user_id) { "TransactionsController USER #{Time.now}" }

  describe '#get' do
    context 'when the app does not exist' do
      it 'returns an empty array' do
        @request.env['HTTP_X_USER_ID'] = user_id
        get :get, app_id: app_id, last: 0
        response.should be_ok
        json_response.should == []
      end
    end

    context 'when the app has records' do
      before do
        Transaction.create!(app_id: app_id, user_id: user_id, key: "k1", value: "v1")
        Transaction.create!(app_id: app_id, user_id: user_id, key: "k2", value: "v2")
      end

      it 'returns the new records' do
        @request.env['HTTP_X_USER_ID'] = user_id
        get :get, app_id: app_id, last: 0
        response.should be_ok
        json_response.should == [
          [1, "k1", "v1"],
          [2, "k2", "v2"],
        ]
      end

      it 'returns records starting at the requested point' do
        @request.env['HTTP_X_USER_ID'] = user_id
        get :get, app_id: app_id, last: 1
        response.should be_ok
        json_response.should == [[2, "k2", "v2"]]
      end

      it 'only shows records for the authenticated user' do
        Transaction.create!(app_id: app_id, user_id: 'other user', key: 'k3', value: 'v3')
        @request.env['HTTP_X_USER_ID'] = user_id
        get :get, app_id: app_id, last: 0
        response.should be_ok
        json_response.should == [
          [1, "k1", "v1"],
          [2, "k2", "v2"],
        ]
      end
    end
  end

  describe '#create' do
    it 'creates a record in the database' do
      @request.env['HTTP_X_USER_ID'] = user_id
      post :create, [["k10", "v10"]].to_json, app_id: app_id
      response.code.should == "202"
      Transaction.find_by(app_id: app_id, user_id: user_id, key: "k10", value: "v10").should_not be_nil
    end
  end
end