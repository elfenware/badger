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

        settings = new GLib.Settings ("io.github.ellie_commons.badger.state");

        set_default_size (
            settings.get_int ("window-width"), 
            settings.get_int ("window-height")
        );

        set_title("Badger");

        this.headerbar = new Gtk.HeaderBar ();
        headerbar.set_title_widget (new Gtk.Label("Badger"));
        headerbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        set_titlebar (headerbar);


        var content = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        content.append (main);




            /*************************************************/
            // Bar at the bottom
            var actionbar = new Gtk.ActionBar () {
                margin_end = 12
            };
            actionbar.set_hexpand (true);
            actionbar.set_vexpand (false);
            actionbar.add_css_class (Granite.STYLE_CLASS_FLAT);
        

            // Reset
            var reset_button = new Gtk.Button();
            reset_button.set_label( _("Reset to Default"));
            reset_button.tooltip_markup = (_("Reset all settings to defaults"));
            actionbar.pack_end (reset_button);

            reset_button.activate.connect (() => {
                print("");
            });

        // content.append(actionbar);


        var handle = new Gtk.WindowHandle () {
            child = content
        };

        set_child (handle);



        close_request.connect (e => {
            return before_destroy ();
        });
    }


    private bool before_destroy () {
        int width, height;

        get_default_size (out width, out height);

        settings.set_int ("window-width", width);
        settings.set_int ("window-height", height);

        hide ();
        return true;
    }
}
