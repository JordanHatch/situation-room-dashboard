(function() {
  "use strict";

  var root = this,
      $ = root.jQuery;
  if(typeof root.MeetingRooms === 'undefined') { root.MeetingRooms = {}; }

  var roomDisplay = {
    roomContainer: function() {
      return $('ul#room');
    },
    loadRoom: function(roomPath, initial) {
      if (initial == true || $('#loading-status').text() != "") {
        $('#loading-status').show().text("Loading, please stand by...").attr("class","loading");
      }

      $.getJSON(roomPath)
        .done(function(room) {
          roomDisplay.renderRoom(room);
          $('#loading-status').hide().text("");
        })
        .fail(roomDisplay.renderError);

      roomDisplay.scheduleNextRequest(roomPath);
    },
    renderRoom: function(room) {
      roomDisplay.clearRoom();

      $('h2#name').text(room.name);

      if (room.available) {
        var duration = "";
        if (room.available_until !== null) {
          duration = moment(room.available_until).tz("Europe/London").fromNow(true);
        }

        if (room.show_as_available) {
          roomDisplay.insertAvailableItem(true, duration);
        } else {
          roomDisplay.insertNotInUseItem(true, room.not_available_label);
        }
      }

      var endOfPreviousEvent;
      $.each(room.events, function(i, eventDetails){
        if (endOfPreviousEvent != null && endOfPreviousEvent != eventDetails.start_at) {
          var availableFrom = moment(endOfPreviousEvent).tz("Europe/London");
          var availableUntil = moment(eventDetails.start_at).tz("Europe/London");
          var availableDuration = availableUntil.from(availableFrom, true);

          roomDisplay.insertAvailableItem(false, availableDuration, availableFrom);
        }

        var current = ! room.available && endOfPreviousEvent == null;
        roomDisplay.insertEventItem(current, eventDetails, room.show_as_available);

        endOfPreviousEvent = eventDetails.end_at;
      });

      // insert final 'available' item at end of event list
      // as long as the last item in our current list isn't an "available" item
      // and the last event ends before the end of the day
      var finalItem = roomDisplay.roomContainer().find("li:not(.template)").last();

      if (finalItem.attr("class") != "available" &&
            moment(endOfPreviousEvent).isBefore(moment().endOf('day')) ) {

        var availableFrom = moment(endOfPreviousEvent).tz("Europe/London");

        if (room.show_as_available) {
          roomDisplay.insertAvailableItem(false, "", availableFrom);
        } else {
          roomDisplay.insertNotInUseItem(false, room.not_available_label, availableFrom);
        }
      }

    },
    clearRoom: function() {
      roomDisplay.roomContainer().find('li:not(.template)').remove();
    },
    template: function() {
      return roomDisplay.roomContainer().find('li.template');
    },
    insertAvailableItem: function(current, duration, startAt) {
      var item = roomDisplay.template().clone();

      item.removeClass("template").addClass("available");
      item.find("h3").text("Available");

      if (current == true) {
        item.find(".start-time").remove();

        if (duration == "") {
          duration = "the rest of the day";
        }

        item.find(".duration").text("for " + duration);
      } else {
        if (duration !== "") {
          item.find("h3").text("Available for "+ duration);
        }

        item.find(".start-time").text(startAt.format("H:mm"));
        item.find(".duration").remove();
      }

      if (!roomDisplay.listAtMaximumLength()) {
        item.insertBefore(roomDisplay.template());
      }
    },
    insertNotInUseItem: function(current, label, startAt) {
      var item = roomDisplay.template().clone();

      item.removeClass("template").addClass("not-in-use");
      item.find("h3").text(label);

      if (current == true) {
        item.find(".start-time").remove();
      } else {
        item.find(".start-time").text(startAt.format("H:mm"));
        item.find(".duration").remove();
      }

      if (!roomDisplay.listAtMaximumLength()) {
        item.insertBefore(roomDisplay.template());
      }
    },
    insertEventItem: function(current, eventDetails, showAsAvailable) {
      var item = roomDisplay.template().clone();

      if (showAsAvailable == true) {
        item.removeClass("template").addClass("not-available");
      } else {
        item.removeClass("template").addClass("in-use");
      }


      var eventLabel;
      if (eventDetails.visibility == "public") {
        eventLabel = eventDetails.name;
      } else {
        eventLabel = "Not available";
      }
      item.find("h3").text(eventLabel);

      var startAt = moment(eventDetails.start_at).tz("Europe/London").format("H:mm");
      var endAt = moment(eventDetails.end_at).tz("Europe/London").format("H:mm");

      if (current == true) {
        item.find(".start-time").remove();

        if (startAt == "0:00" && endAt == "0:00") {
          var durationLabel = "All day";
        } else {
          var durationLabel = startAt + " → " + endAt;
        }

        item.find(".duration").text(durationLabel);
      } else {
        item.find(".duration").remove();
        item.find(".start-time").text(startAt);
      }

      if (!roomDisplay.listAtMaximumLength()) {
        item.insertBefore(roomDisplay.template());
      }
    },
    listAtMaximumLength: function() {
      // trim the list at three items
      if (roomDisplay.roomContainer().find("li:not(.template)").length > 2) {
        return true;
      }
      return false;
    },
    scheduleNextRequest: function(path) {
      window.setTimeout(function() { roomDisplay.loadRoom(path); }, 10000);
    },
    init: function(path) {
      roomDisplay.loadRoom(path, true);
    }
  }

  root.MeetingRooms.roomDisplay = roomDisplay;
}).call(this);
