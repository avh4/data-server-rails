class TransactionsController < ApplicationController
  def get
    txns = Transaction.where(app_id: params.require(:app_id))
      .where('id > ?', params.require(:last))
      .order(:id)
    json = txns.map { |t| [t.id, t.key, t.value] }
    render json: json
  end
end