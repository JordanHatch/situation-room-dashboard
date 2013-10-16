(function() {
  "use strict";

  var root = this,
      $ = root.jQuery;
  if(typeof root.MeetingRooms === 'undefined') { root.MeetingRooms = {}; }

  var MeetingRooms = {
    calendarContainer: function() {
      return $("ul#rooms");
    },
    calendarTemplate: function() {
      return MeetingRooms.calendarContainer().find('li.template');
    },
    clearCalendars: function() {
      MeetingRooms.calendarContainer().find('li:not(.template)').remove();
    },
    loadCalendars: function(calendarsPath, initial) {
      if (initial == true || $('#loading-status').text() != "") {
        $('#loading-status').show().text("Loading, please stand by...").attr("class","loading");
      }

      $.getJSON(calendarsPath)
        .done(function(group) {
          MeetingRooms.renderGroup(group);
          $('#loading-status').hide().text("");
        })
        .fail(MeetingRooms.renderError);
    },
    renderGroup: function(group) {
      $('#name').text(group.name);
      if (group.display !== null) {
        MeetingRooms.calendarContainer().attr('class', 'display-'+ group.display);
      }

      MeetingRooms.clearCalendars();
      MeetingRooms.renderCalendars(group.rooms);
    },
    renderCalendars: function(calendars) {
      $.each(calendars, MeetingRooms.renderCalendar);
    },
    renderCalendar: function(id, calendar) {
      var newCalendar = MeetingRooms.calendarTemplate().clone()
                          .removeClass("template");
      var nextEvent = calendar.events[0];

      if (calendar.available == true)  {
        newCalendar.find("span.availability").text("Available");

        if (calendar.available_until !== undefined) {
          var availableUntil = moment(calendar.available_until).tz("Europe/London");
          newCalendar.find("span.availability").text("Available until "+ availableUntil.format("h:mma"));
        }
      } else {
        newCalendar.removeClass("available").addClass("not-available");
        newCalendar.find("span.event").text(nextEvent.name);
      }

      newCalendar.find("h3").text(id);
      newCalendar.insertBefore(MeetingRooms.calendarTemplate());
    },
    renderError: function() {
      MeetingRooms.clearCalendars();
      $("#loading-status").text("Error loading calendars. Trying again in a few seconds.").attr("class","error").show();
    },
    initializeClock: function() {
      window.setInterval(MeetingRooms.updateClock, 100);
    },
    updateClock: function() {
      $('#clock').text( moment().format("h:mma") );
    },
    init: function(path) {
      MeetingRooms.loadCalendars(path, true);
      window.setInterval(function() { MeetingRooms.loadCalendars(path); }, 10000);
    }
  }

  MeetingRooms.initializeClock();
  root.MeetingRooms = MeetingRooms;
}).call(this);
