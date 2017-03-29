window.kypsy ||= {}

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
