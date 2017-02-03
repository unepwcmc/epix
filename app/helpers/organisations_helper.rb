module OrganisationsHelper

  def has_access(country)
    yes = content_tag(:span, '', class: 'fa fa-check') +
      content_tag(:span, 'Yes')
    no = content_tag(:span, '', class: 'fa fa-times') +
      content_tag(:span, 'No')
    return no unless @adapter
    @adapter.has_country?(country.id) ? yes : no
  end

  def trade_reporting_enabled?(field)
    yes = content_tag(:span, '', class: 'fa fa-check')
    no = content_tag(:span, '', class: 'fa fa-times')
    @organisation.send(field) ? yes : no
  end

  def trade_reporting_enabled_info
    info_text = "The trade reporting module allows Parties to submit annual report trade data directly into the Trade DB, either via a web service connection or CSV upload."
    content_tag('span', t('trade.reporting_enabled')) +
    content_tag('i', '', {
      class: 'fa fa-info-circle',
      title: info_text
    })
  end

  def trade_error_correction_info
    info_text = "If the trade reporting mechanism detects errors in the uploaded trade data, it will suspend the submission and errors will need to be corrected. This can be done in one of 2 ways: either by applying corrections to the source permit repository, or to the uploaded copy within an online sandbox environment. The first option is always available."
    content_tag('span', t('trade.error_correction')) +
    content_tag('i', '', {
      class: 'fa fa-info-circle',
      title: info_text
    })
  end
end
