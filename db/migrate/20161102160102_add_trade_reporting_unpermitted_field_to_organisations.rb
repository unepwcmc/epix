class AddTradeReportingUnpermittedFieldToOrganisations < ActiveRecord::Migration[5.0]
  def change
    add_column :organisations, :trade_reporting_unpermitted, :boolean, default: false
  end
end
