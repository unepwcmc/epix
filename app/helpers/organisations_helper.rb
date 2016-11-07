module OrganisationsHelper

  def has_access(country)
    yes = content_tag(:span, '', class: 'fa fa-check') +
      content_tag(:span, 'Yes')
    no = content_tag(:span, '', class: 'fa fa-times') +
      content_tag(:span, 'No')
    return no unless @adapter
    @adapter.has_country?(country.id) ? yes : no
  end

  def trade_reporting_enabled?
    yes = content_tag(:span, '', class: 'fa fa-check')
    no = content_tag(:span, '', class: 'fa fa-times')
    return no unless @adapter
    @organisation.trade_reporting_enabled ? yes : no
  end

  def trade_error_correction_in_sandbox?
    yes = content_tag(:span, '', class: 'fa fa-check')
    no = content_tag(:span, '', class: 'fa fa-times')
    return no unless @adapter
    @organisation.trade_error_correction_in_sandbox_enabled ? yes : no
  end
end
