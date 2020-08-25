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

public class Badger.MainWindow : Gtk.ApplicationWindow {

    private GLib.Settings settings;

    public MainWindow (Gtk.Application app) {
        Object (application: app);
    }

    construct {
        set_titlebar (get_header ());
        border_width = 24;

        settings = new GLib.Settings ("com.github.elfenware.badger.state");

        move (settings.get_int ("window-x"), settings.get_int ("window-y"));
        resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

        delete_event.connect (e => {
            return before_destroy ();
        });
    }

    private Gtk.HeaderBar get_header () {
        var header = new Gtk.HeaderBar () {
            title = "Badger",
            has_subtitle = false,
            show_close_button = true
        };
        header.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        header.get_style_context ().add_class ("badger-headerbar");

        return header;
    }

    private bool before_destroy () {
        int x, y, width, height;

        get_position (out x, out y);
        get_size (out width, out height);

        settings.set_int ("window-x", x);
        settings.set_int ("window-y", y);
        settings.set_int ("window-width", width);
        settings.set_int ("window-height", height);

        hide ();
        return true;
    }
}
