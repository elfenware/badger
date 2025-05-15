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

public class Badger.Marks : Gtk.Box {
    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        hexpand = true;
        margin_top = 12;
        margin_bottom = 6;

        append (new Gtk.Label (_("1 min")) {
            halign = Gtk.Align.START
        });

        append (new Gtk.Label (_("30 min")) {
            halign = Gtk.Align.CENTER
        });

        append (new Gtk.Label (_("1 hour")) {
            halign = Gtk.Align.END
        });
    }
}

public class Badger.Headerbox : Gtk.Box {
    construct {
        orientation = Gtk.Orientation.HORIZONTAL;
        hexpand = true;
        margin_top = 12;
        margin_bottom = 6;

        var global_switch = new Gtk.Switch () {
                    halign = Gtk.Align.END,
                    hexpand = true,
                    valign = Gtk.Align.CENTER,
        };


        var heading = new Granite.HeaderLabel (_ ("Reminders")) {
            mnemonic_widget = global_switch,
            secondary_text = _("Badger will remind you to take care of yourself")
        };
        heading.add_css_class (Granite.STYLE_CLASS_H2_LABEL);

        append(heading);

        var settings = new GLib.Settings ("com.github.elfenware.badger.timers");
        settings.bind ("all", global_switch, "active", SettingsBindFlags.DEFAULT);
        
    }
}