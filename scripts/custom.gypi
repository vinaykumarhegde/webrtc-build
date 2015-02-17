{
  'variables': {
      'use_rtti%': 0
  },
  'target_defaults': {
    'conditions': [
      ['use_rtti==1', {
       'cflags_cc!': ['-fno-rtti']
      }]
    ]
  }
}
