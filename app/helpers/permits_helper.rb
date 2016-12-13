module PermitsHelper
  TOKEN_INFO =
    'Please fill in for permit numbers protected by an additional security code.'
  def security_token_label
    label_tag(:security_token, class: 'security-token-label') do
      content_tag(:span, t('enter_security_token')) +
      content_tag(:i, ' ', class: 'fa fa-info-circle blue', title: TOKEN_INFO)
    end
  end
end
