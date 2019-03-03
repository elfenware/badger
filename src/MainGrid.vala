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

        var settings = new GLib.Settings ("com.github.dar5hak.badger.reminders");

        row_spacing = 6;
        column_spacing = 12;

        var heading = new Granite.HeaderLabel (_ ("Reminders"));
        heading.get_style_context ().add_class ("heading");
        attach (heading, 0, 0, 2, 1);

        Gtk.Switch[] switches = new Gtk.Switch[reminders.length];

        for (int index = 0; index < reminders.length; index++) {
            var label = new Gtk.Label (reminders[index].switch_label);
            switches[index] = new Gtk.Switch ();

            label.margin_start = 12;
            label.halign = Gtk.Align.END;
            switches[index].halign = Gtk.Align.START;
            switches[index].valign = Gtk.Align.CENTER;

            attach (label, 0, index + 1, 1, 1);
            attach_next_to (switches[index], label, Gtk.PositionType.RIGHT, 1, 1);

            settings.bind (reminders[index].name, switches[index], "active", GLib.SettingsBindFlags.DEFAULT);

            var active = settings.get_boolean (reminders[index].name);
            if (active) {
                reminders[index].toggle_timer (true);
            }

            switches[index].state_set.connect (reminders[index].toggle_timer);
        }
    }
}
