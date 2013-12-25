class TransactionsController < ApplicationController
  def get
    txns = Transaction.where(app_id: params[:id]).order(:id)
    json = txns.map { |t| [t.id, t.key, t.value] }
    render json: json
  end
end