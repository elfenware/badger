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
using Granite.Widgets;
using Gtk;

public class Badger.Application : Granite.Application {

    private Badger.MainWindow window;

    public Application () {
        Object(
            application_id: "com.github.dar5hak.badger",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow (this);

        var reminders = set_up_reminders ();
        var main = new MainGrid (reminders);

        window.add (main);
        window.show_all ();
    }

    public static int main (string[] args) {
        var app = new Badger.Application ();

        return app.run (args);
    }

    private Reminder[] set_up_reminders () {
        Reminder[] reminders = new Reminder[5];
        reminders[0] = new Reminder (
            "eyes",
            "Blink your eyes",
            "Look away from the screen and blink your eyes for 10 seconds.",
            "Blink eyes:",
            300,
            this
        );
        reminders[1] = new Reminder (
            "fingers",
            "Stretch your fingers",
            "Spread out your palm wide, then close it into a fist. Repeat 10 times.",
            "Stretch fingers:",
            500,
            this
        );
        reminders[2] = new Reminder (
            "legs",
            "Stretch your legs",
            "Stand up, twist your ankles, raise each leg and bend your knee.",
            "Stretch legs:",
            700,
            this
        );
        reminders[3] = new Reminder (
            "arms",
            "Stretch your arms",
            "Stretch and twist your arms, elbows and wrists for 10 seconds.",
            "Stretch arms:",
            800,
            this
        );
        reminders[4] = new Reminder (
            "neck",
            "Twist your neck",
            "Turn your head in all directions. Repeat 5 times.",
            "Twist neck:",
            600,
            this
        );

        return reminders;
    }
}

