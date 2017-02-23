$ ->
  $('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
    if $(e.target).attr('href') == "#preview"
      md = $("#new_message textarea").val()
      md ||= "Use [Markdown](https://daringfireball.net/projects/markdown/) to write your message"
      $("#preview").html(markdown.toHTML(md))