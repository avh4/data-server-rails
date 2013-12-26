class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def get
    txns = Transaction.where(app_id: params.require(:app_id))
      .where(user_id: user_id)
      .where('id > ?', params.require(:last))
      .order(:id)
    json = txns.map { |t| [t.id, t.key, t.value] }
    render json: json
  end

  def create
    txns = JSON.parse(request.raw_post)
    txns.each do |key, value|
      # TODO: rollback if there's a failure
      Transaction.create!(
        app_id: params.require(:app_id),
        user_id: user_id,
        key: key,
        value: value,
      )
    end
    head :accepted
  end
end