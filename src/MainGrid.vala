/*
 *  Copyright (C) 2019-2022 Darshak Parikh
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

public class Badger.MainGrid : Gtk.Box {
    delegate void SetInterval (uint interval);

    public MainGrid (Reminder[] reminders) {
        var settings = new GLib.Settings ("com.github.elfenware.badger.timers");
        set_vexpand (true);

        margin_top = 18;
        margin_bottom = 18;
        margin_start = 24;
        margin_end = 24;
        orientation = Gtk.Orientation.VERTICAL;


        

        /************************************************/
        /*               Switch at top                  */
        /************************************************/

        var global_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 6);
        var global_switch = new Gtk.Switch () {
                    halign = Gtk.Align.END,
                    hexpand = true,
                    valign = Gtk.Align.CENTER,
        };
        settings.bind ("all", global_switch, "active", SettingsBindFlags.DEFAULT);
        var heading = new Granite.HeaderLabel (_ ("Reminders")) {
            mnemonic_widget = global_switch,
            secondary_text = _("If on, Badger will remind you to take care of yourself")
        };

        global_box.append(heading);
        global_box.append(global_switch);
        append (global_box);


        /************************************************/
        /*               Label to explain               */
        /************************************************/


        var subheading = new Gtk.Label (_ ("Decide how often Badger should remind you to relax these:")) {
            halign = Gtk.Align.START,
            margin_top = 18,
            margin_bottom = 6
        };
        subheading.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
        subheading.add_css_class ("title-4");

        append (subheading);

        var marks = new Marks ();
        append (marks);

        HashTable<string, Gtk.Scale> scales = new HashTable<string, Gtk.Scale> (str_hash, str_equal);

        // Change a single scale when the corresponding checkbox is pressed
        settings.changed.connect ((key) => {
            // just check for '-active' keys
            if (key.has_suffix ("-active")) {
                bool value = settings.get_boolean (key);
                scales.get (key).sensitive = value;
            }
        });

        // Change all the scales when the global switch is pressed
        global_switch.state_set.connect ((value) => {
            global_switch.set_active (value);
            scales.foreach ((key, scale) => {
                scale.sensitive = value ? settings.get_boolean (key) : false;
            });

            // We don't care about handling the switch animation ourselves, so return false
            return false;
        });



        /************************************************/
        /*               All the scales                 */
        /************************************************/



        var scale_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        scale_box.vexpand = true;

        for (int index = 0; index < reminders.length; index++) {
            Reminder reminder = reminders[index];

            Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
                margin_top = 12,
                margin_bottom = 12
            };

            Gtk.CheckButton check_box = new Gtk.CheckButton.with_label (reminder.display_label) {
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
                width_request = 64,
            };

            Gtk.Scale scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 60, 5) {
                hexpand = true,
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.CENTER,
                width_request = 300
            };

            // Get the scale default value
            scale.sensitive = settings.get_boolean ("all") ? settings.get_boolean (reminder.name + "-active") : false;
            
            scales.insert (reminder.name + "-active", scale);

            uint interval = settings.get_uint (reminder.name);


            // Old settings migration: interval == 0 meant "never" till 2.3.1
            //  if ( interval == 0 ) {
            //      // Reset to default value
            //      settings.reset (reminder.name);

            //      // Read interval again (interval = default_value)
            //      interval = settings.get_uint (reminder.name);

            //      // Uncheck the corresponding checkbox
            //      settings.set_boolean (reminder.name + "-active", false);
            //  }


            scale.set_value (interval);
            scale.set_tooltip_text(_ ("%.0f min").printf (interval));

            // The marks take a lotta space
            //scale.add_mark (0.0, Gtk.PositionType.TOP , null);
            //scale.add_mark (30.0, Gtk.PositionType.TOP , null);
            //scale.add_mark (60.0, Gtk.PositionType.TOP , null);

            SetInterval set_interval = reminder.set_reminder_interval;
            set_interval (interval);

            scale.change_value.connect ((scroll, duration) => {
                uint new_value = (uint) scale.get_value ();
                settings.set_uint (reminder.name, new_value);
                set_interval (new_value);

                scale.set_tooltip_text(_ ("%.0f min").printf (duration)) ;

                return false;
            });

            // If the "all" flag is false, disable all checkboxes
            settings.bind ("all", check_box, "sensitive", SettingsBindFlags.GET);

            // When the checkbox is pressed, set the option.
            settings.bind (
                reminder.name + "-active",
                check_box,
                "active",
                SettingsBindFlags.DEFAULT | SettingsBindFlags.NO_SENSITIVITY
            );

            box.append (check_box);
            box.append (scale);
            scale_box.append (box);

        } // Forloop end

        append(scale_box);



        /********************************************/
        /*               DnD Label                  */
        /********************************************/


        // User may wonder why they get no notification
        // Ok also this looks better
        var hey = new Gtk.Label (_ ("Make sure Do Not Disturb is not on!")) {
            halign = Gtk.Align.START,
            margin_top = 12,
            margin_bottom = 6
        };
        hey.add_css_class ("accent");
        append (hey);



    }
}
