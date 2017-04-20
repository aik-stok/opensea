class Api::PositionsController < ApplicationController
  api! 'Find closest position(s) by id in the interval of 7 days'
  param :id, :number, required: true, desc: 'Position ID (ship or shipment)'
  error code: 404, desc: 'Position does not exist'
  desc 'Returns message: `Nothing suitable is not found` if results is empty'

  def closest
    result = ClosestService.new(params[:id]).find
    render json: result.presence || { message: "Nothing suitable is not found" }
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: 'Not found' }, status: 404
  end
end
