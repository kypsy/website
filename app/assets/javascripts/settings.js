$(".activities-group input[type=checkbox]").change(function() {
  group         = $(".activities-group");
  checked_count = $("input[type=checkbox]:checked", group).length;
  unchecked     = $("input[type=checkbox]:not(:checked)", group);

  // hide/show category headings and their events based on max choosable count
  if (checked_count >= 3) {
    unchecked.attr("disabled", "true");
  } else {
    $("input[type=checkbox]", group).removeAttr("disabled");
  }
});
