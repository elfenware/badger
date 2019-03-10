# project name and programming language
project('com.github.elfenware.badger', 'vala', 'c', version: '1.0.2')

message('project name and programming language')

# Adds project arguments
message('Adds project arguments')

add_project_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

# Include the translations module
message('Include the translations module')

gnome = import('gnome')
i18n = import('i18n')

# Set our translation domain
message('Set our translation domain')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()), language:'c')

# Include GResource
asresources = gnome.compile_resources(
    'as-resources', join_paths('data', 'gresource.xml'),
    source_dir: 'data',
    c_name: 'as'
)

# Adding deps
message('Listing dependencies')

dependencies = [
    dependency ('glib-2.0'),
    dependency ('granite'),
    dependency ('gtk+-3.0'),
]

# Adds subfolders specific build system
message('Adds subfolders specific build system')

icon_sizes = ['16', '24', '32', '48', '64', '128', '256']

foreach i : icon_sizes
    install_data(
        join_paths('data/icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
    )
    install_data(
        join_paths('data/icons', i, meson.project_name() + '.svg'),
        install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
    )
endforeach

install_data(
    'data/gschema.xml',
    install_dir: join_paths(get_option('datadir'), 'glib-2.0', 'schemas'),
    rename: meson.project_name() + '.gschema.xml'
)

config_data = configuration_data()
config_data.set('EXEC_NAME', meson.project_name())

# Src build
message('Src build')

conf_data = configuration_data()
conf_data.set_quoted('PROJECT_NAME', meson.project_name())
conf_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf_data.set_quoted('VERSION', meson.project_version())
conf_data.set_quoted('PREFIX', get_option('prefix'))

message('Configuring desktop entry: ' + meson.project_name() + '.desktop')

# Translate and install our .desktop file
desktop_file = i18n.merge_file(
    input: join_paths(meson.source_root(), 'data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

# Translate and install our .appdata file
appstream_file = i18n.merge_file(
    input: join_paths(meson.source_root(), 'data', meson.project_name() + '.appdata.xml.in'),
    output: '@BASENAME@',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

message('Adds files to build')

code_files = files(
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Reminder.vala',
    'src/MainGrid.vala'
)

message('Defines executable')

executable(
    meson.project_name(),
    code_files,
    asresources,
    dependencies: dependencies,
    install: true
)

subdir('po')

meson.add_install_script('meson/post_install.py')

