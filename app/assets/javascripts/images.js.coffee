rotateImage = (obj, degrees, flip, flop) =>
  y = if flip then -1 else 1
  x = if flop then -1 else 1
  obj.css("transform", "rotate(#{degrees}deg) scaleX(#{x}) scaleY(#{y})")
  obj.css("-webkit-transform", "rotate(#{degrees}deg) scaleX(#{x}) scaleY(#{y})")
  obj.css("-moz-transform", "rotate(#{degrees}deg) scaleX(#{x}) scaleY(#{y})")
  obj.css("-ms-transform", "rotate(#{degrees}deg) scaleX(#{x}) scaleY(#{y})")
  
$ ->
  $(".image-manipulator").click ->
    obj = $("#photo_manipulate")
    rotate = $('<input>').attr {type: 'hidden'}
    rotate.attr("name", "photo[manipulate][rotate]")
    switch $(this).attr("href")
      when "#rotate-left"
        obj.data("rotate", obj.data("rotate") - 90)
      when "#rotate-right"
        obj.data("rotate", obj.data("rotate") + 90)
      when "#flip-vertical"
        flip = if obj.data("flip") then false else true
        obj.data("flip", flip)
      when "#flip-horizontal"
        flop = if obj.data("flop") then false else true
        obj.data("flop", flop)

    rotateImage($("#preview img"), obj.data('rotate'), obj.data("flip"), obj.data("flop"))
    
    flop = if obj.data("flop")
      $('<input>').attr {type: 'hidden', name: "photo[manipulate][flop]", value: true}

    flip = if obj.data("flip")
      $('<input>').attr {type: 'hidden', name: "photo[manipulate][flip]", value: true}
      
    rotate.val obj.data("rotate")
    $("#photo_manipulate").html([rotate, flop, flip])
    