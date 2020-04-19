import consumer from "./consumer"

consumer.subscriptions.create("RoomChannel", {
  connected() {
    console.log("we are connected")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    $('#msg').append('<div class = "message">'+ data.content + '</div>' )
    console.log(data.content)
    // Called when there's incoming data on the websocket for this channel
  }
});
