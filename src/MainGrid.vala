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

using Granite;
using Gtk;

public class Badger.MainGrid : Gtk.Grid {

    public Reminder[] reminders;

    public MainGrid (Reminder[] reminders) {
        this.reminders = reminders;

        var settings = new GLib.Settings ("com.github.elfenware.badger.reminders");

        row_spacing = 6;
        column_spacing = 12;
        orientation = Gtk.Orientation.VERTICAL;

        var heading = new Granite.HeaderLabel (_ ("Reminders"));
        heading.get_style_context ().add_class ("heading");
        attach (heading, 0, 0, 1, 1);

        var checkboxes = new Gtk.CheckButton[reminders.length];

        for (int index = 0; index < reminders.length; index++) {
            checkboxes[index] = new Gtk.CheckButton.with_label (reminders[index].switch_label);

            add (checkboxes[index]);

            settings.bind (reminders[index].name, checkboxes[index], "active", GLib.SettingsBindFlags.DEFAULT);

            var active = settings.get_boolean (reminders[index].name);
            if (active) {
                reminders[index].toggle_timer (true);
            }

            checkboxes[index].state_flags_changed.connect (flags => {
                reminders[index].toggle_timer (flags == Gtk.StateFlags.ACTIVE);
            });
        }
    }
}
