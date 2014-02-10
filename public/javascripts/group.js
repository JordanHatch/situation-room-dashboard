(function() {
  "use strict";

  var root = this,
      $ = root.jQuery;
  if(typeof root.MeetingRooms === 'undefined') { root.MeetingRooms = {}; }

  var groupDisplay = {
    calendarContainer: function() {
      return $("ul#rooms");
    },
    calendarTemplate: function() {
      return groupDisplay.calendarContainer().find('li.template');
    },
    clearCalendars: function() {
      groupDisplay.calendarContainer().find('li:not(.template)').remove();
    },
    loadCalendars: function(calendarsPath, initial) {
      if (initial == true || $('#loading-status').text() != "") {
        $('#loading-status').show().text("Loading, please stand by...").attr("class","loading");
      }

      $.getJSON(calendarsPath)
        .done(function(group) {
          groupDisplay.renderGroup(group);
          $('#loading-status').hide().text("");
        })
        .fail(groupDisplay.renderError);

      groupDisplay.scheduleNextRequest(calendarsPath);
    },
    renderGroup: function(group) {
      $('#name').text(group.name);
      if (group.display !== null) {
        groupDisplay.calendarContainer().attr('class', 'display-'+ group.display);
      }

      groupDisplay.clearCalendars();
      groupDisplay.renderCalendars(group.rooms);
    },
    renderCalendars: function(calendars) {
      $.each(calendars, groupDisplay.renderCalendar);
    },
    renderCalendar: function(id, calendar) {
      var newCalendar = groupDisplay.calendarTemplate().clone()
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
        var eventLabel;

        if (nextEvent.visibility == "public") {
          eventLabel = nextEvent.name;
        } else {
          eventLabel = "Not available";
        }
        newCalendar.find("span.event").text(eventLabel);
      }

      newCalendar.find("h3").text(id);
      newCalendar.insertBefore(groupDisplay.calendarTemplate());
    },
    renderError: function() {
      groupDisplay.clearCalendars();
      $("#loading-status").text("Error loading calendars. Trying again in a few seconds.").attr("class","error").show();
    },
    scheduleNextRequest: function(path) {
      window.setTimeout(function() { groupDisplay.loadCalendars(path); }, 10000);
    },
    init: function(path) {
      groupDisplay.loadCalendars(path, true);
    }
  }

  root.MeetingRooms.groupDisplay = groupDisplay;
}).call(this);
