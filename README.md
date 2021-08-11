[![Build Status](https://api.travis-ci.com/elfenware/badger.svg?branch=master)](https://travis-ci.com/github/elfenware/badger)

<p align="center">
    <img src="data/icons/128/com.github.elfenware.badger.svg" alt="Icon" />
</p>

<h1 align="center">Badger</h1>
<p align="center">Remind yourself to not sit and stare at the screen for too long</p>

<p align="center">
  <a href="https://appcenter.elementary.io/com.github.elfenware.badger"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" height="75px" /></a>
  <a href="https://flathub.org/apps/details/com.github.elfenware.badger"><img src="https://flathub.org/assets/badges/flathub-badge-en.svg" alt="Get it on Flathub" height="75px" /></a>
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

<a href="https://appcenter.elementary.io/com.github.elfenware.badger"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" height="75px" /></a>

On other distributions, you can get it on Flathub.

<a href="https://flathub.org/apps/details/com.github.elfenware.badger"><img src="https://flathub.org/assets/badges/flathub-badge-en.svg" alt="Get it on Flathub" height="75px" /></a>


## Developing and building

Development is targeted at [elementary OS]. If you want to hack on and
build Badger yourself, you'll need the following dependencies:

* libgranite-dev
* libgtk-3-dev
* meson
* valac

You can install them on elementary OS Hera with:

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

[elementary OS]: https://elementary.io
