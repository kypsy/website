$ ->
  $.each ($ ".crush"),    (index, element) -> new Crush    $(element)
  $.each ($ ".bookmark"), (index, element) -> new Bookmark $(element)
  $.each ($ ".next"),     (index, element) -> new Next     $(element)


class UserAction
  constructor: (@element) ->
    @username = @element.data("username")
    @element.click (event) =>
      this.crush()
      false

  token: ->
    $("meta[name=csrf-token]:first").attr("content")

  crush: =>
    if this.className() == "next"
      console.log "in next if"
      this.cyclePersonCards()
    else
      $.ajax @element.attr("href") + ".json",
        type: @element.data("method"),
        data: {authenticity_token: this.token(), format: "json"},
        success: (data) => this.crushButton(@element.data("method"))

  crushButton: (method) =>
    elements = ($ ".#{this.className()}[data-username='#{@username}']")

    if $("html").attr("id") == "people"
      # People Matcher Page
      this.cyclePersonCards()
    else
      # Profile Page
      elements.toggle()

    if method == "delete"
      elements.data("method", "post")
    else
      elements.data("method", "delete")

  cyclePersonCards: =>
    currentPersonCard = $(".person-card[data-username='#{@username}']")
    currentPersonCard.hide()

    currentPersonCard.next().show()




class Crush extends UserAction
  className: => "crush"

class Bookmark extends UserAction
  className: => "bookmark"

class Next extends UserAction
  className: => "next"
