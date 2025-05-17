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

public class Badger.MainWindow : Gtk.Window {
    private GLib.Settings settings;
    private Gtk.HeaderBar headerbar;

    public MainGrid main { get; construct; }

    public MainWindow (Gtk.Application app, MainGrid main) {
        Object (
            application: app,
            main: main
        );
    }

    construct {
            Intl.setlocale ();
        settings = new GLib.Settings ("com.github.elfenware.badger.state");

        set_default_size (
            settings.get_int ("window-width"),
            settings.get_int ("window-height")
        );

        set_title (_("Badger"));
        Gtk.Label title_widget = new Gtk.Label (_("Badger"));
        title_widget.add_css_class (Granite.STYLE_CLASS_TITLE_LABEL);

        this.headerbar = new Gtk.HeaderBar ();
        headerbar.set_title_widget (title_widget);
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        set_titlebar (headerbar);

        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        content.append (main);

        // Allow grabbing on whole window
        var handle = new Gtk.WindowHandle () {
            child = content
        };

        set_child (handle);

        // save state
        close_request.connect (e => {
            return before_destroy ();
        });
    }


    // save state
    private bool before_destroy () {
        int width, height;

        get_default_size (out width, out height);

        settings.set_int ("window-width", width);
        settings.set_int ("window-height", height);

        hide ();
        return true;
    }
}
