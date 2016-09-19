module OrganisationsHelper

  def has_access(country)
    yes = content_tag(:span, '', class: 'fa fa-check') +
      content_tag(:span, 'Yes')
    no = content_tag(:span, '', class: 'fa fa-times') +
      content_tag(:span, 'No')
    return no unless @adapter
    @adapter.countries_with_access_ids.include?(country.id) ? yes : no
  end
end
