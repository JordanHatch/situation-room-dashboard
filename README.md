# Situation Room Dashboard

Situation Room Dashboard displays the status of meeting rooms from an instance of [Situation Room](https://github.com/JordanHatch/situation-room). It's ideal for an at-a-glance view of which rooms are available right now. It's a small Ruby application built on the Sinatra framework.

## Configuration

The app is configured using environment variables.

- `SITUATION_ROOM_API_ENDPOINT` - a URL to an instance of Situation Room
- `SITUATION_ROOM_API_USER` - if required, the username to use to authenticate with Situation Room's HTTP Basic auth
- `SITUATION_ROOM_API_PASSWORD` - if required, the password to use to authenticate with Situation Room's HTTP Basic auth
- `SITUATION_ROOM_DASHBOARD_USER` - an optional username to require to access the dashboard using Basic auth
- `SITUATION_ROOM_DASHBOARD_PASSWORD` - an optional password to require to access the dashboard using Basic auth

### Groups

By default, the dashboard will display all the rooms returned from the Situation Room API. In addition, you can configure groups of calendars to be shown, for example just the calendars on the 3rd Floor.

You can start using groups by setting the `SITUATION_ROOM_CONFIG` environment variable to a JSON string resembling the example below.

    {
      "groups": {
        "3rd-floor": {
          "name": "3rd floor meeting rooms",
          "calendars": ["301", "303", "304", "305", "306", "307"]
        },
        "6th-7th-floor": {
          "name": "6th and 7th floor meeting rooms",
          "calendars": ["603", "708", "709", "710", "712"]
        }
      }
    }

The values in the `calendars` array correspond to the hash keys returned in the API response.
