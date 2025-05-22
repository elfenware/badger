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

public class Badger.Application : Gtk.Application {
    public bool headless = false;
    public bool ask_autostart = false;

    private Badger.MainWindow window;

    public Application () {
        Object (
            application_id: "com.github.elfenware.badger",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE
        );
    }

    construct {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (GETTEXT_PACKAGE, LOCALEDIR);
        Intl.bind_textdomain_codeset (GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (GETTEXT_PACKAGE);
    }

    protected override void activate () {
        stdout.printf ("\n✔️ Activated");

        var settings = new GLib.Settings ("com.github.elfenware.badger.state");
        var gtk_settings = Gtk.Settings.get_default ();
        var granite_settings = Granite.Settings.get_default ();
        stdout.printf ("\n⚙️ State settings loaded");

        gtk_settings.gtk_application_prefer_dark_theme = (
            granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
        );

        granite_settings.notify["prefers-color-scheme"].connect (() => {
            gtk_settings.gtk_application_prefer_dark_theme = (
                granite_settings.prefers_color_scheme == Granite.Settings.ColorScheme.DARK
            );
        });

        // On first run, request autostart
        if (settings.get_boolean ("first-run") || ask_autostart == true) {

            // Show first run message only if really first run
            if (settings.get_boolean ("first-run")) {
                stdout.printf ("\n🎉️ First run");
                settings.set_boolean ("first-run", false);
                request_autostart ();

            } else {
                ask_autostart = false;
                request_autostart ();
            }

        }

        if (window == null) {
            var reminders = set_up_reminders ();
            var main = new MainGrid (reminders);
            window = new MainWindow (this, main);

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/elfenware/badger/Application.css");
            Gtk.StyleContext.add_provider_for_display (
                Gdk.Display.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            if (!headless) {
                window.show ();
            }
        }

        if (window != null && !headless) {
            stdout.printf ("\n▶️ Process already running. Presenting window…");
            window.show ();
            window.present ();
        }
        headless = false;
    }

    public override int command_line (ApplicationCommandLine command_line) {
        stdout.printf ("\n💲️ Command line mode started");

        OptionEntry[] options = new OptionEntry[2];
        options[0] = {
            "headless", 0, 0, OptionArg.NONE,
            ref headless, "Run without window", null
        };
        options[1] = {
            "request-autostart", 0, 0, OptionArg.NONE,
            ref ask_autostart, "Request autostart permission", null
        };

        // We have to make an extra copy of the array, since .parse assumes
        // that it can remove strings from the array without freeing them.
        string[] args = command_line.get_arguments ();
        string[] _args = new string[args.length];
        for (int i = 0; i < args.length; i++) {
            _args[i] = args[i];
        }

        try {
            var ctx = new OptionContext ();
            ctx.set_help_enabled (true);
            ctx.add_main_entries (options, null);
            unowned string[] tmp = _args;
            ctx.parse (ref tmp);
        } catch (OptionError e) {
            command_line.print ("error: %s\n", e.message);
            return 0;
        }

        hold ();
        activate ();
        return 0;
    }

    public static int main (string[] args) {
        var app = new Badger.Application ();
        return app.run (args);
    }

    private static void request_autostart () {
        Xdp.Portal portal = new Xdp.Portal ();
        GenericArray<weak string> cmd = new GenericArray<weak string> ();
        cmd.add ("com.github.elfenware.badger --headless");

        // TODO: Implicit .begin is deprecated but i have no idea how to fix that
        portal.request_background (
            null,
            "Autostart Badger in headless mode to send reminders",
            cmd,
            Xdp.BackgroundFlags.AUTOSTART,
            null);

        stdout.printf ("\n🚀 Requested autostart for Badger");
    }

    private Reminder[] set_up_reminders () {
        Reminder[] reminders = new Reminder[8];
        reminders[0] = new Reminder (
            "eyes",
            _ ("Blink your eyes"),
            _ ("Look away from the screen and slowly blink your eyes for 10 seconds."),
            _ ("Eyes:"),
            this
        );
        reminders[1] = new Reminder (
            "fingers",
            _ ("Stretch your fingers"),
            _ ("Spread out your palm wide, then close it into a fist. Repeat 5 times."),
            _ ("Fingers:"),
            this
        );
        reminders[2] = new Reminder (
            "arms",
            _ ("Stretch your arms"),
            _ ("Stretch your arms, and twist your wrists for 10 seconds."),
            _ ("Arms:"),
            this
        );
        reminders[3] = new Reminder (
            "legs",
            _ ("Stretch your legs"),
            _ ("Stand up, twist each ankle, and bend each knee."),
            _ ("Legs:"),
            this
        );
        reminders[4] = new Reminder (
            "neck",
            _ ("Turn your neck"),
            _ ("Turn your head in all directions. Repeat 3 times."),
            _ ("Neck:"),
            this
        );
        reminders[5] = new Reminder (
            "water",
            _ ("Hydrate yourself"),
            _ ("Drink a glass of water."),
            _ ("Water:"),
            this
        );
        reminders[6] = new Reminder (
            "posture",
            _ ("Watch your posture"),
            _ ("Make sure your back is straight."),
            _ ("Posture:"),
            this
        );
        reminders[7] = new Reminder (
            "breath",
            _ ("Focus on your breath"),
            _ ("Inhale and exhale deeply, thrice."),
            _ ("Breath:"),
            this
        );
        return reminders;
    }
}
