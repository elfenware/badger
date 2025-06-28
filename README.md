<p align="center">
    <img src="data/icons/hicolor/128.svg" alt="Icon" />
</p>

<h1 align="center">Badger</h1>
<p align="center">Remind yourself to not sit and stare at the screen for too long</p>

<p align="center">
  <a href="https://appcenter.elementary.io/com.github.elfenware.badger">
    <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" />
  </a>
</p>

<p align="center">
    <img src="data/window-screenshot.png" alt="Screenshot">
</p>


## Badgers you to be ergonomic

Badger will periodically send notifications to remind you to relax your eyes,
stretch your fingers, and turn your neck among other things. It helps you keep
your muscles free and your eyes unstrained.


## Built for elementary OS

While Badger will happily compile on any Linux distribution, it is primarily
built for [elementary OS].

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)][AppCenter]


## Reset autostart

You can run:

```shell
flatpak run com.github.elfenware.badger --request-autostart
```

To run in headless mode (in the background)

```shell
flatpak run com.github.elfenware.badger --headless
```


## Developing and building

Development is targeted at [elementary OS]. If you want to hack on and
build Badger yourself, you'll need the following dependencies:

* libgranite-7-dev
* libgtk-4-dev
* meson
* valac

You can install them on elementary OS with:

```shell
sudo apt install elementary-sdk
```

Run `meson build` to configure the build environment and run `ninja install`
to install:

```shell
meson build --prefix=/usr
cd build
sudo ninja install
```

Then run it with:

```shell
com.github.elfenware.badger
```

Alternatively, on elementary OS or with its AppCenter remote installed, you run the following command:

```shell
flatpak-builder --force-clean --user --install-deps-from=appcenter --install builddir ./com.github.elfenware.badger.yml
```

[elementary OS]: https://elementary.io
[AppCenter]: https://appcenter.elementary.io/com.github.elfenware.badger
