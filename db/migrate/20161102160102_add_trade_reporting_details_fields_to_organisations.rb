class AddTradeReportingDetailsFieldsToOrganisations < ActiveRecord::Migration[5.0]
  def change
    add_column :organisations, :trade_reporting_enabled, :boolean, default: false
    add_column :organisations, :trade_error_correction_in_sandbox_enabled, :boolean, default: false
  end
end
