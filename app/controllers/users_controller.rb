# frozen_string_literal: true

class UsersController < ApplicationController
  SERVICE = Mongo::Atlas::Api::Users

  def index
    render json: SERVICE.all(limit: 100)
  end

  def show
    render json: SERVICE.find_one(filter: { _id: { '$oid': params[:id] } })
  end

  def create
    render json: SERVICE.insert(user_params)
  end

  def update
    render json: SERVICE.update(where: { _id: { '$oid': params[:id] } }, set: user_params)
  end

  def destroy
    render json: SERVICE.destroy(where: { _id: { '$oid': params[:id] } })
  end

  private

  def user_params
    params.require(:user).permit(:_id, :name, :email, :text)
  end
end
