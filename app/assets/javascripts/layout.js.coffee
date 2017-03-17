$ ->
  $.each ($ ".crush"),    (index, element) -> new Crush    $(element)
  $.each ($ ".bookmark"), (index, element) -> new Bookmark $(element)


class UserAction
  constructor: (@element) ->
    @username = @element.data("username")
    @element.click (event) =>
      this.crush()
      false

  token: ->
    $("meta[name=csrf-token]:first").attr("content")

  crush: =>
    $.ajax @element.attr("href") + ".json",
      type: @element.data("method"),
      data: {authenticity_token: this.token(), format: "json"},
      success: (data) => this.crushButton(@element.data("method"))

  crushButton: (method) =>
    elements = ($ ".#{this.className()}[data-username='#{@username}']")

    if $("html").attr("id") == "people"
      # People Matcher Page
      personCard = $(".person-card[data-username='#{@username}']")
      personCard.hide()
      # console.log "show current person card"
    else
      # Profile Page
      elements.toggle()

    if method == "delete"
      elements.data("method", "post")
    else
      elements.data("method", "delete")


class Crush extends UserAction
  className: => "crush"

class Bookmark extends UserAction
  className: => "bookmark"
