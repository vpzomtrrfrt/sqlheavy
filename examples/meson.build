progs = {
  'async': ['async.vala'],
  'backup': ['backup.vala'],
  'common-functions': ['common-functions.vala'],
  'orm': ['orm.vala']
}

foreach name, sources : progs
  executable(name, sources, dependencies: [glib_dep, gobject_dep, gio_dep], link_with: [sqlheavy_lib], include_directories: include_directories('../sqlheavy'))
endforeach
