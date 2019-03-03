/*
 *  Copyright (C) 2019 Darshak Parikh
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *  Authored by: Darshak Parikh <darshak@protonmail.com>
 *
 */

using Gtk;

public class Badger.Reminder : GLib.Object {

    public string name { get; set; }      // Unique name
    public string title { get; set; }           // Notification title
    public string message { get; set; }         // Notification body
    public string switch_label { get; set; }    // On/off switch label
    public int interval { get; set; }           // Reminder interval
    public Gtk.Application app { get; set; }

    private Notification notification;
    private bool active = true;

    public Reminder (
        string name,
        string title,
        string message,
        string switch_label,
        int interval,
        Application app
    ) {
        this.name = name;
        this.title = title;
        this.message = message;
        this.switch_label = switch_label;
        this.interval = interval;
        this.app = app;

        notification = new Notification (title);
        notification.set_body (message);
    }

    // Connected to the state_set signal on each switch
    // Returns false because we never want to stop handling the change
    public bool toggle_timer (bool state) {
        active = state;

        if (state) {
            Timeout.add_seconds (interval, remind);
        }

        return false;
    }

    public bool remind () {
        // Stop timer if the reminder has been turned off
        if (!active) {
            return false;
        }

        app.send_notification (name, notification);

        return true;
    }
}

