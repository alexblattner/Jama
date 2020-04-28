import consumer from "./consumer"

consumer.subscriptions.create("ChatChannel", {
  connected() {
    console.log("Connected to the chat channel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("Disconnected to the chat channel");
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    var messages = $('#messages');
		messages.append(data['message']);
    messages.scrollTop($('#messages')[0].scrollHeight);
    console.log("111111")
    console.log(messages)
  }
});
