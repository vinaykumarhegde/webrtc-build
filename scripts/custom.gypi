{
  'variables': {
      'use_rtti%': 0,
      'debug_compilation_dir%': '',
  },
  'target_defaults': {
    'cflags!': ['-fvisibility=hidden'],
    'cflags_cc!': ['-fvisibility-inlines-hidden'],
    'cflags': ['-fvisibility=protected'],
    'cflags_cc': ['-fvisibility=protected'],
    'conditions': [
      ['use_rtti==1', {
       'cflags_cc!': ['-fno-rtti']
      }],
      ['clang==1 and debug_compilation_dir!=""', {
       'cflags_cc': ['-Xclang -fdebug-compilation-dir -Xclang <(debug_compilation_dir)']
      }]
    ]
  }
}
