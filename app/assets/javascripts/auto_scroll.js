$(document).on("turbolinks:load", function(){

  // Scroll message container container down
  $("#chat-box-inner").delay(350).animate({ scrollTop: $('#chat-box-inner').height()}, 2250);
  // End of scroll message container down

  // AUTO SCROLL ON CHAT SEND MESSAGE
  $("#text-send-button").on("click", function(){
    $("#chat-box-inner").animate({ scrollTop: $("#chat-box-inner").height() * 10 }, 3000);
  });
  // END OF AUTO SCROLL ON CHAT SEND MESSAGE
})
