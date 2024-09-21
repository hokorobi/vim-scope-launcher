vim9script
scriptencoding utf-8

import autoload 'scope/popup.vim'
export def Launcher(profile: string = null_string)
  var config_file = get(g:, 'scope_launcher_file', '~/.scope-launcher')
  if !empty(profile)
    config_file ..= '-' .. profile
  endif
  var file = fnamemodify(expand(config_file), ':p')
  var list = filereadable(file) ? filter(map(readfile(file), 'split(iconv(v:val, "utf-8", &encoding), "\\t\\+")'), 'len(v:val) > 0 && v:val[0] !~ "^#"') : []
  list += [['--edit-menu--', printf('botright split %s', fnameescape(config_file))]]

  var menu = []
  for item in list
    menu->add({text: item[0], cmd: item[1]})
  endfor
  popup.NewFilterMenu("launcher", menu,
    (res, key) => {
      silent execute res.cmd
    },
    (winid, _) => {
      win_execute(winid, $"syn match FilterMenuLineNr '(\\d\\+)$'")
      hi def link FilterMenuLineNr Comment
    })
enddef
