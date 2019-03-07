$(document).on("turbolinks:load", function(){

  // HANDLE bigBox SIZING
  var menuSize = $("#menu").outerHeight(true)
  var windowSize = $(window).height();
  var diffSize = windowSize - menuSize;
  $("#big-box").css("height", diffSize + "px");
  // END OF HANDLE bigBox SIZING

})
