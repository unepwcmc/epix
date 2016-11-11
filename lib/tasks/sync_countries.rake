namespace :sync do
  task :countries => :environment do
    response = HTTParty.get('http://speciesplus.net/api/v1/geo_entities?geo_entity_types_set=3')
    unless response.code == 200
      Rails.logger.info 'Something went wrong while fetching countries from Species+'
      Rails.logger.info 'Message: #{response.message}'
    end
    geo_entities = response["geo_entities"]
    countries = geo_entities.select!{ |ge| ge['geo_entity_type'] == 'COUNTRY' }
    countries.each do |geo_entity|
      id = geo_entity['id']
      name = geo_entity['name']
      iso_code2 = geo_entity['iso_code2']
      country = Country.find_by_id(id)
      status = nil
      if country.present?
        country.assign_attributes(name: name, iso_code2: iso_code2)
        status = 'UPDATED' if country.changed?
        country.save
      else
        status = 'INSERTED'
        Country.create({
          id: id, name: name, iso_code2: iso_code2
        })
      end
      Rails.logger.info "#{status} country #{name} #{iso_code2}(#{id})" if status
    end
    ids = countries.map{ |c| c['id'] }
    (Country.pluck(:id) - ids).each do |id_to_delete|
      country = Country.find(id_to_delete)
      status = 'DELETED'
      unless country.organisations.empty?
        status = 'FAILED TO DELETE'
      end
      Rails.logger.warn "#{status} country #{country.name} #{country.iso_code2}(#{country.id})"
    end
  end
end
