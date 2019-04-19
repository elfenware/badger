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
using Gtk;

public class Badger.Application : Granite.Application {

    public bool headless = false;

    private Badger.MainWindow window;

    public Application () {
        Object (
            application_id: "com.github.elfenware.badger",
            flags: ApplicationFlags.HANDLES_COMMAND_LINE
        );
    }

    protected override void activate () {
        stdout.printf ("\n✔️ Activated");

        var settings = new GLib.Settings ("com.github.elfenware.badger.state");
        stdout.printf ("\n⚙️ State settings loaded");

        var first_run = settings.get_boolean ("first-run");

        if (first_run) {
            stdout.printf ("\n🎉️ First run");
            install_autostart ();
            settings.set_boolean ("first-run", false);
        }

        if (window == null) {
            var reminders = set_up_reminders ();
            var main = new MainGrid (reminders);
            window = new MainWindow (this);
            window.add (main);

            var provider = new Gtk.CssProvider ();
            provider.load_from_resource ("/com/github/elfenware/badger/Application.css");
            Gtk.StyleContext.add_provider_for_screen (
                Gdk.Screen.get_default (),
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
            );

            if (!headless) {
                window.show_all ();
            }
        }

        if (window != null && !headless) {
            stdout.printf ("\n▶️ Process already running. Presenting window…");
            window.show_all ();
            window.present ();
        }
    }

    public override int command_line (ApplicationCommandLine command_line) {
        stdout.printf ("\n💲️ Command line mode started");

        bool headless_mode = false;
        OptionEntry[] options = new OptionEntry[1];
        options[0] = {
            "headless", 0, 0, OptionArg.NONE,
            ref headless_mode, "Run without window", null
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

        headless = headless_mode;

        hold ();
        activate ();
        return 0;
    }

    public static int main (string[] args) {
        var app = new Badger.Application ();

        if (args.length > 1 && args[1] == "--headless") {
            app.headless = true;
        }

        return app.run (args);
    }

    private void install_autostart () {
        var desktop_file_name = application_id + ".desktop";
        var desktop_file_path = new DesktopAppInfo (desktop_file_name).filename;
        var desktop_file = File.new_for_path (desktop_file_path);
        var dest_path = Path.build_path (
            Path.DIR_SEPARATOR_S,
            Environment.get_user_config_dir (),
            "autostart",
            desktop_file_name
        );
        var dest_file = File.new_for_path (dest_path);
        try {
            desktop_file.copy (dest_file, FileCopyFlags.OVERWRITE);
            stdout.printf ("\n📃️ Copied desktop file at: %s", dest_path);
        } catch (Error e) {
            warning ("Error making copy of desktop file for autostart: %s", e.message);
        }

        var keyfile = new KeyFile ();
        try {
            keyfile.load_from_file (dest_path, KeyFileFlags.NONE);
            keyfile.set_boolean ("Desktop Entry", "X-GNOME-Autostart-enabled", true);
            keyfile.set_string ("Desktop Entry", "Exec", application_id + " --headless");
            keyfile.save_to_file (dest_path);
        } catch (Error e) {
            warning ("Error enabling autostart: %s", e.message);
        }
    }

    private Reminder[] set_up_reminders () {
        Reminder[] reminders = new Reminder[5];
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

        return reminders;
    }
}
