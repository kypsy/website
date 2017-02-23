window.kypsy ||= {}

$ ->
  $("#user_label_id").change ->
    # TODO this is fragile and we should make it more betterer
    if parseInt($(this).val()) == 4 # hardcoded DB ID
      $("#drug-use").removeClass('hidden')
    else
      $("#drug-use").addClass('hidden')


class @User
  constructor: (user) ->
    @id = user.id

  @where: (@form) ->
    url    = @form.attr("action")
    params = @form.serialize()
    $.ajax "#{url}?#{params}"
    .then (response) ->
      $.map response.users, (user) ->
        new User(user)
