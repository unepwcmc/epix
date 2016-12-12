class StoreWsdlEndpointNamespaceSeparately < ActiveRecord::Migration[5.0]
  def change
    rename_column :adapters, :web_service_uri, :wsdl_url
    add_column :adapters, :ws_endpoint_url, :string
    add_column :adapters, :ws_namespace, :string
  end
end
