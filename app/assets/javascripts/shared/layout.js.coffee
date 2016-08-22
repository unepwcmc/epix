$(document).on('turbolinks:load', ->
  $('.btn-menu').on('click', (e) ->
    e.stopPropagation()
    $('.menu').slideToggle()
  )
)
