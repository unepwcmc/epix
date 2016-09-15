namespace :sync do
  task :countries => :environment do
    response = HTTParty.get('http://speciesplus.net/api/v1/geo_entities')
    unless response.code == 200
      Rails.logger.info "Something went wrong while fetching countries"
      Rails.logger.info "Message: #{response.message}"
    end
    geo_entities = response["geo_entities"]
    geo_entities.each do |geo_entity|
      if geo_entity["geo_entity_type"] == "COUNTRY"
        id = geo_entity["id"]
        name = geo_entity["name"]
        iso_code2 = geo_entity["iso_code2"]
        country = Country.find_by_id(id)
        if country.present?
          updated = false
          if name != country.name
            country.update_attributes(name: name)
            updated = true
          elsif iso_code2 != country.iso_code2
            country.update_attributes(iso_code2: iso_code2) unless iso_code2 != country.iso_code2
            updated = true
          end
          Rails.logger.info "Country with ID: #{id} has been updated!" if updated
        else
          Country.create({id: id, name: geo_entity["name"], iso_code2: geo_entity["iso_code2"]})
          Rails.logger.info "Country with name: #{name} has been created!"
        end
      end
    end
  end
end
