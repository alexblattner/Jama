// Action Cable provides the framework to deal with WebSockets in Rails.
(function() {
    this.App || (this.App = {});
  
    App.cable = ActionCable.createConsumer($('meta[name=action-cable-url]').attr('content'));
  
  }).call(this);