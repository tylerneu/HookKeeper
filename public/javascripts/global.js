$(function() {
  var socket = new WebSocket("ws://localhost:5000/_hippie/ws");
  socket.onopen = function() {
    $('#conn-status').html('Connected');
  };
  socket.onmessage = function(e) {
    var data = JSON.parse(e.data);
    
    if (data.msg) {
      
      var pull_data = JSON.parse(data.msg);
      
      $('#pull_distance_'+pull_data.pull_id).fadeOut(300).html(pull_data.pull_distance).fadeIn(300);

    }
  };
});