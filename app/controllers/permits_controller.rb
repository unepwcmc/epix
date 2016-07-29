class PermitsController < ApplicationController
  def index
    @countries = Country.select(:id, :name)
  end
end