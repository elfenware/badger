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
        hide_on_close = true;
        settings = new GLib.Settings ("com.github.elfenware.badger.timers");

        // We cannot resize window if it is allowed to change
        set_size_request (12, 12);
        set_resizable (false);


        set_title (_("Badger"));
        Gtk.Label title_widget = new Gtk.Label (this.get_title ());
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

        // Avoid showing the window without content despite toggle off.
        main.revealer.reveal_child = settings.get_boolean ("all");

        // Resize window accordingly to state of global switch
        settings.changed["all"].connect ( on_toggle_changed);

        // Avoid a bug whence reopened windows cannot be closed
        close_request.connect (e => {
            return before_destroy ();
        });
    }

    private void on_toggle_changed () {
        debug ("Toggle changed!");
        main.revealer.reveal_child = settings.get_boolean ("all");

        if (!settings.get_boolean ("all")) {
            debug ("Toggle is off! Resizing window");
            set_size_request (12, 12);
            queue_resize ();
        }
    }

    // Avoid a bug whence reopened windows cannot be closed
    private bool before_destroy () {
        debug ("Window closed!");

        if (!settings.get_boolean ("all")) {
            debug ("All reminders are disabled, Badger will now go to sleep");
            ((Badger.Application)this.application).tidy_up ();
        }

        return false;
    }
}
