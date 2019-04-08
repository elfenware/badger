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

    delegate void ToggleHandler();
    delegate void ChangeInterval(uint interval);

    public MainGrid (Reminder[] reminders) {
        var old_settings = new GLib.Settings ("com.github.elfenware.badger.reminders");
        var settings = new GLib.Settings ("com.github.elfenware.badger.timers");

        /* GSettings migration code. Will be removed at some point */
        if (!settings.get_boolean ("old-settings-replaced")) {
            var key_names = new string[5];
            key_names[0] = "eyes";
            key_names[1] = "fingers";
            key_names[2] = "legs";
            key_names[3] = "arms";
            key_names[4] = "neck";

            foreach (string key in key_names) {
                bool old_value = old_settings.get_boolean (key);
                if (!old_value) {
                    settings.set_uint (key, 0);
                }
            }

            settings.set_boolean ("old-settings-replaced", true);
        }
        /* GSettings migration code ends. */

        row_spacing = 6;
        column_spacing = 12;
        orientation = Gtk.Orientation.VERTICAL;

        var heading = new Granite.HeaderLabel (_ ("Reminders"));
        attach (heading, 0, 0, 1, 1);

        var checkboxes = new Gtk.CheckButton[reminders.length];

        for (int index = 0; index < reminders.length; index++) {
            checkboxes[index] = new Gtk.CheckButton.with_label (reminders[index].switch_label);

            add (checkboxes[index]);

            old_settings.bind (reminders[index].name, checkboxes[index], "active", GLib.SettingsBindFlags.DEFAULT);

            ToggleHandler toggle_timer = reminders[index].toggle_timer;
            ChangeInterval change_interval = reminders[index].change_interval;

            var active = old_settings.get_boolean (reminders[index].name);
            if (active) {
                toggle_timer ();
            }

            checkboxes[index].toggled.connect (toggle_button => {
                toggle_timer ();
            });
        }
    }
}
