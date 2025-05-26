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
    public Gtk.Revealer revealer;

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
                    margin_bottom = 18
        };
        settings.bind ("all", global_switch, "active", SettingsBindFlags.DEFAULT);
        var heading = new Granite.HeaderLabel (_ ("Reminders")) {
            mnemonic_widget = global_switch,
            secondary_text = _("If on, Badger will remind you to take care of yourself")
        };

        global_box.append (heading);
        global_box.append (global_switch);
        append (global_box);

        // This is everything below the switch.
        var scale_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        scale_box.vexpand = true;



        /************************************************/
        /*               Label to explain               */
        /************************************************/

        var subheading = new Gtk.Label (_ ("Decide how often Badger should remind you to relax these:")) {
            halign = Gtk.Align.START,
            margin_top = 12,
            margin_bottom = 0
        };
        subheading.add_css_class (Granite.STYLE_CLASS_H4_LABEL);
        subheading.add_css_class ("title-4");

        scale_box.append (subheading);

        var marks = new Marks ();
        scale_box.append (marks);

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

        for (int index = 0; index < reminders.length; index++) {
            Reminder reminder = reminders[index];

            Gtk.Box box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 12) {
                margin_top = 12,
                margin_bottom = 12
            };

            Gtk.CheckButton check_box = new Gtk.CheckButton.with_label (reminder.display_label) {
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER,
                width_request = 76,
            };

            Gtk.Scale scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 1, 60, 5) {
                hexpand = true,
                halign = Gtk.Align.FILL,
                valign = Gtk.Align.CENTER,
                width_request = 330
            };

            // Get the scale default value
            scale.sensitive = settings.get_boolean ("all") ? settings.get_boolean (reminder.name + "-active") : false;

            scales.insert (reminder.name + "-active", scale);

            uint interval = settings.get_uint (reminder.name);

            scale.set_value (interval);
            scale.set_tooltip_text (_ ("%.0f min").printf (interval));

            SetInterval set_interval = reminder.set_reminder_interval;
            set_interval (interval);

            scale.change_value.connect ((scroll, duration) => {
                uint new_value = (uint) scale.get_value ();
                settings.set_uint (reminder.name, new_value);
                set_interval (new_value);

                scale.set_tooltip_text (_ ("%.0f min").printf (duration)) ;

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

        }

        /********************************************/
        /*               DnD Label                  */
        /********************************************/

        var hey = new Gtk.Label (_ ("Make sure Do Not Disturb is not on!")) {
            halign = Gtk.Align.START,
            margin_top = 12,
            margin_bottom = 6
        };
        hey.add_css_class ("accent");
        scale_box.append (hey);

        /**************************************************/
        /*               Scales revealer                  */
        /**************************************************/

        // If the "all" flag is false, the switch is off, hide the scales 
        this.revealer = new Gtk.Revealer ();
        revealer.set_transition_type (Gtk.RevealerTransitionType.SLIDE_DOWN);
        revealer.set_child (scale_box);
        append (revealer);
    }
}
