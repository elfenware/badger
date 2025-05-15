# project name and programming language
project('io.github.ellie_commons.badger', 'vala', 'c', version: '4.4.0')

gnome = import('gnome')
i18n = import('i18n')

add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')


#================================
# Import the stylesheet

## Set de config data
config_data = configuration_data()
config_data.set_quoted('LOCALEDIR', get_option('prefix') / get_option('localedir'))
config_data.set_quoted('GETTEXT_PACKAGE', meson.project_name())
config_file = configure_file(
    input: 'src/Config.vala.in',
    output: '@BASENAME@',
    configuration: config_data
)

# Le stylesheet
gresource = gnome.compile_resources(
    'gresource',
    'data' / 'gresource.xml',
    source_dir: 'data'
)

executable(
    meson.project_name(),
    gresource,
    config_file,
    'src/Application.vala',
    'src/MainWindow.vala',
    'src/Reminder.vala',
    'src/MainGrid.vala',
    'src/Marks.vala',
    dependencies: [
        dependency ('glib-2.0'),
        dependency('granite-7'),
        dependency('gobject-2.0'),
        dependency('gtk4')
    ],
    install : true
)

# Add subfolders for Meson to look
subdir('data')
subdir('po')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
  )

