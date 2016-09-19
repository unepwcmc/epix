module OrganisationsHelper

  def has_access(country)
    if @adapter.countries_with_access_ids.include?(country.id)
      content_tag(:span, '', class: 'fa fa-check') +
      content_tag(:span, 'Yes')
    else
      content_tag(:span, '', class: 'fa fa-times') +
      content_tag(:span, 'No')
    end
  end
end
