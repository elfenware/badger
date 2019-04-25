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

    public string name { get; set; }            // Unique name
    public string title { get; set; }           // Notification title
    public string message { get; set; }         // Notification body
    public string display_label { get; set; }   // UI label
    public uint interval { get; set; }          // Reminder interval
    public Gtk.Application app { get; set; }

    private Notification notification;
    private uint timeout_id = 0;

    public Reminder (
        string name,
        string title,
        string message,
        string display_label,
        Application app
    ) {
        this.name = name;
        this.title = title;
        this.message = message;
        this.display_label = display_label;
        this.app = app;

        notification = new Notification (title);
        notification.set_body (message);
    }

    public void set_reminder_interval (uint new_interval) {
        interval = new_interval;

        // Disable old timer to avoid repeated notifications
        if (timeout_id > 0) {
            Source.remove (timeout_id);
        }

        // Setting a zero-second timer can hang the entire OS
        if (interval > 0) {
            timeout_id = Timeout.add_seconds (interval * 60, remind);
        }
    }

    public bool remind () {
        app.send_notification (name, notification);
        return true;
    }
}
