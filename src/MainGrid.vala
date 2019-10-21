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

    delegate void SetInterval (uint interval);

    public MainGrid (Reminder[] reminders) {
        var settings = new GLib.Settings ("com.github.elfenware.badger.timers");

        /* GSettings migration code. Will be removed at some point. */
        if (!settings.get_boolean ("old-settings-replaced")) {
            var old_settings = new GLib.Settings ("com.github.elfenware.badger.reminders");
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

        row_spacing = 4;
        column_spacing = 12;
        margin_bottom = 12;
        orientation = Gtk.Orientation.VERTICAL;

        var top = new Gtk.Grid ();

        var heading = new Gtk.Label (_ ("Reminders"));
        heading.halign = Gtk.Align.START;
        heading.hexpand = true;
        heading.get_style_context ().add_class (Granite.STYLE_CLASS_H2_LABEL);
        top.attach (heading, 0, 0, 1, 1);

        var global_switch = new Gtk.Switch ();
        global_switch.halign = Gtk.Align.END;
        global_switch.valign = Gtk.Align.CENTER;
        top.attach (global_switch, 1, 0, 1, 1);

        attach (top, 0, 0, 2, 1);

        settings.bind ("all", global_switch, "active", SettingsBindFlags.DEFAULT);

        var subheading = new Gtk.Label (_ ("Decide how often Badger should remind you to relax these:"));
        subheading.halign = Gtk.Align.START;
        subheading.margin_bottom = 12;
        attach (subheading, 0, 1, 2, 1);

        HashTable<string, Scale> scales = new HashTable<string, Scale> (str_hash, str_equal);

        // Change a single scale when the corresponding checkbox is pressed
        settings.changed.connect ((key) => {
            // just check for '-active' keys
            if (key.has_suffix("-active")) {
                bool value = settings.get_boolean(key);
                scales.get(key).sensitive = value;
            }
        });

        // Change all the scales when the global switch is pressed
        global_switch.state_set.connect ((value) => {
            global_switch.set_active(value);
            scales.foreach ((key, scale) => {
                scale.sensitive = value ? settings.get_boolean (key) : false;
            });
            
            // We don't care about handling the switch animation ourselves, so return false
            return false;
        });

        for (int index = 0; index < reminders.length; index++) {
            Reminder reminder = reminders[index];

            Gtk.CheckButton check_box = new Gtk.CheckButton.with_label (reminder.display_label);
            check_box.halign = Gtk.Align.BASELINE;
            check_box.valign = Gtk.Align.START;
            check_box.margin_top = 24;

            Gtk.Scale scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 60, 5);
            scale.hexpand = true;
            scale.width_request = 360;
            scale.margin_top = 24;

            scale.add_mark (1, Gtk.PositionType.BOTTOM, _ ("1 min"));
            scale.add_mark (15, Gtk.PositionType.BOTTOM, null);
            scale.add_mark (30, Gtk.PositionType.BOTTOM, _ ("30 min"));
            scale.add_mark (45, Gtk.PositionType.BOTTOM, null);
            scale.add_mark (60, Gtk.PositionType.BOTTOM, _ ("1 hour"));

            // Get the scale default value
            scale.sensitive = settings.get_boolean("all") ? settings.get_boolean(reminder.name + "-active") : false;
            
            scales.insert(reminder.name + "-active", scale);

            uint interval = settings.get_uint (reminder.name);
            // Old settings migration: interval == 0 meant "never" till 2.3.1
            if ( interval == 0 ) {
                // Reset to default value
                settings.reset (reminder.name);
                
                // Read interval again (interval = default_value)
                interval = settings.get_uint (reminder.name);

                // Uncheck the corresponding checkbox
                settings.set_boolean (reminder.name + "-active", false);
            }
            scale.set_value (interval);

            SetInterval set_interval = reminder.set_reminder_interval;
            set_interval (interval);

            scale.value_changed.connect (() => {
                uint new_value = (uint) scale.get_value ();
                settings.set_uint (reminder.name, new_value);
                set_interval (new_value);
            });

            scale.format_value.connect (duration => {
                return _ ("%.0f min").printf (duration);
            });

            // If the "all" flag is false, disable all checkboxes
            settings.bind ("all", check_box, "sensitive", SettingsBindFlags.GET);

            // When the checkbox is pressed, set the option.
            settings.bind (reminder.name + "-active", check_box, "active", SettingsBindFlags.DEFAULT | SettingsBindFlags.NO_SENSITIVITY);

            attach (check_box, 0, index + 2, 1, 1);
            attach (scale, 1, index + 2, 1, 1);
        }
    }
}
