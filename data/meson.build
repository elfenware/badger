
#======== SETTINGS ========
install_data (
    'badger.gschema.xml',
    install_dir: get_option('datadir') / 'glib-2.0' / 'schemas',
    rename: meson.project_name() + '.gschema.xml'
)

#======== Internationalization ========
#Translate and install our .desktop file
i18n.merge_file(
    input: 'badger.desktop.in',
    output: meson.project_name() + '.desktop',
    po_dir: meson.project_source_root() / 'po' / 'extra',
    type: 'desktop',
    install: true,
    install_dir: get_option('datadir') / 'applications'
)

#Translate and install our .metainfo file
i18n.merge_file(
    input: 'badger.metainfo.xml.in',
    output: meson.project_name() + '.metainfo.xml',
    po_dir: meson.project_source_root() / 'po' / 'extra',
    install: true,
    install_dir: get_option('datadir') / 'metainfo'
)

#======== ICONS ========

# Install our icons in all the required sizes
icon_sizes = ['16', '24', '32', '48', '64', '128', '256', '512']

foreach i : icon_sizes
    install_data(
        'icons' / 'hicolor' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i / 'apps',
        rename: meson.project_name() + '.svg'
    )
    install_data(
        'icons' / 'hicolor' / i + '.svg',
        install_dir: get_option('datadir') / 'icons' / 'hicolor' / i + 'x' + i + '@2' / 'apps',
        rename: meson.project_name() + '.svg'
    )
endforeach

install_data(
    'icons' / 'scalable.svg',
    install_dir: get_option('datadir') / 'icons' / 'scalable' / 'apps',
    rename: meson.project_name() + '.svg'
)