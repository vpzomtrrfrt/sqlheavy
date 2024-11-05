gnome = import('gnome')
pkg = import('pkgconfig')

api_version = '0.2'

sources = files('''
  sqlheavy-backup.vala
  sqlheavy-common-function.vala
  sqlheavy-cursor.vala
  sqlheavy-database.vala
  sqlheavy-enums.vala
  sqlheavy-error.vala
  sqlheavy-mutable-record.vala
  sqlheavy-profiling-database.vala
  sqlheavy-query.vala
  sqlheavy-queryable.vala
  sqlheavy-query-result.vala
  sqlheavy-record.vala
  sqlheavy-record-set.vala
  sqlheavy-row.vala
  sqlheavy-table.vala
  sqlheavy-table-cursor.vala
  sqlheavy-transaction.vala
  sqlheavy-user-functions.vala
  sqlheavy-value.vala
  sqlheavy-versioned-database.vala
'''.split())

resources = gnome.compile_resources(
  'sqlheavy-resources',
  'resources/resources.xml',
  source_dir: 'resources'
)

glib_dep = dependency('glib-2.0')
gobject_dep = dependency('gobject-2.0')
gio_dep = dependency('gio-2.0')

sqlheavy_lib = library(
  'SQLHeavy',
  sources,
  resources,
  version: api_version,
  vala_gir: 'SQLHeavy-' + api_version + '.gir',
  dependencies: [glib_dep, gobject_dep, gio_dep, dependency('gmodule-2.0'), dependency('sqlite3')],
  install: true,
  install_dir: [
    true,
    true,
    true,
    true
  ]
)

pkg.generate(
  sqlheavy_lib,
  description: 'GObject wrapper for SQLite.',
  requires: ['glib-2.0', 'gobject-2.0', 'gio-2.0'],
  version: api_version
)
