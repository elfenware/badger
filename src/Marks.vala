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
        margin_start = 82; // 64 + 12 + 6
        margin_top = 12;
        margin_bottom = 0;
        margin_end = 6;

        append (new Gtk.Label (_("1 min")) {
            halign = Gtk.Align.START,
            hexpand = false
        });

        append (new Gtk.Label (_("30 min")) {
            halign = Gtk.Align.CENTER,
            hexpand = true
        });

        append (new Gtk.Label (_("1 hour")) {
            halign = Gtk.Align.END,
            hexpand = false
        });
    }
}
