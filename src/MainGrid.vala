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

        row_spacing = 6;
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

        var labels = new Gtk.Label[reminders.length];
        var scales = new Gtk.Scale[reminders.length];

        for (int index = 0; index < reminders.length; index++) {
            Reminder reminder = reminders[index];

            Gtk.Label label = labels[index] = new Gtk.Label (reminder.display_label);
            label.halign = Gtk.Align.END;
            label.valign = Gtk.Align.START;
            label.xalign = 1;
            label.width_request = 60;
            label.margin_top = 24;

            Gtk.Scale scale = scales[index] = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 0, 60, 5);
            scale.hexpand = true;
            scale.width_request = 360;
            scale.margin_top = 24;

            scale.add_mark (0, Gtk.PositionType.BOTTOM, _ ("Never"));
            scale.add_mark (15, Gtk.PositionType.BOTTOM, null);
            scale.add_mark (30, Gtk.PositionType.BOTTOM, _ ("30 min"));
            scale.add_mark (45, Gtk.PositionType.BOTTOM, null);
            scale.add_mark (60, Gtk.PositionType.BOTTOM, _ ("1 hour"));

            uint interval = settings.get_uint (reminder.name);
            scale.set_value (interval);

            SetInterval set_interval = reminder.set_reminder_interval;
            set_interval (interval);

            scale.value_changed.connect (() => {
                uint new_value = (uint) scale.get_value ();
                settings.set_uint (reminder.name, new_value);
                set_interval (new_value);
            });

            scale.format_value.connect (duration => {
                if (duration == 0) {
                    return _ ("Never");
                }

                return _ ("%.0f min").printf (duration);
            });

            attach (label, 0, index + 2, 1, 1);
            attach (scale, 1, index + 2, 1, 1);
        }
    }
}
