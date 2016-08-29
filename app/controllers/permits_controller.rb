class PermitsController < ApplicationController
  def index
    @countries = Organisation.cites_mas.with_available_adapters.
      joins(:country).
      select('countries.iso_code2, countries.name').
      group('countries.iso_code2, countries.name')
  end

  def show
  end
end
