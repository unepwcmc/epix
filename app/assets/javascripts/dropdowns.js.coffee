$(document).ready( ->
  $(".dropdown-menu li a").click((e) ->
    e.preventDefault()
    $(@).parents(".languages-dropdown").find('.btn').html($(@).text() + ' <span class="caret"></span>')
    $(@).parents(".languages-dropdown").find('.btn').val($(@).data('value'))
  )
)
