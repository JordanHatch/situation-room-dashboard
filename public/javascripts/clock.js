(function() {
  "use strict";

  var root = this,
      $ = root.jQuery;
  if(typeof root.MeetingRooms === 'undefined') { root.MeetingRooms = {}; }

  var clock = {
    update: function() {
      $('#clock').text( moment().format("h:mma") );
    },
    initialize: function() {
      window.setInterval(clock.update, 100);
    }
  }

  clock.initialize();
  root.MeetingRooms.clock = clock;
}).call(this);
