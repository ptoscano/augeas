# Parse mail aliases in /etc/aliases

map
  grammar aliases
  include '/etc/aliases' '/system/config/aliases'
end

grammar aliases
  token COMMENT /^[ \t]*(#.*?)?\n/ = '#\n'
  token COMMA /,[ \t]+(\n[ \t]+)?/ = ', '
  token NAME /([^ \t\n#:@]+|"[^"]*")/ = 'missing' # "
  token COLON /:[ \t]+/ = ': '
  token EOL /[ \t]*\n/ = '\n'

  file: (comment | alias)*

  comment: [ COMMENT ]

  alias: [ seq 'alias' .
           [ label 'name' . store NAME ] .
           COLON .
           counter 'values' .
           [ label 'values' .
             [ seq 'values' . store ... ] .
             ([COMMA . seq 'values' . store ...])*
           ]
         ] . EOL
end
