function! s:findroot(dir)
  let markers = ['root.dir', '.git/', '.hg/', '.svn/', '.bzr/', '_darcs/']
  for marker in markers
    if !empty(globpath(a:dir, marker, 1))
      return a:dir
    endif
  endfor
  let parent = matchstr(a:dir, '^.*\ze[\/][^\/]\+[\/:]\?$')
  if len(parent)
    return s:findroot(parent)
  endif
  return ""
endfunction

function! unite#sources#projectfiles#define()
  let s:source = {
  \  'name': 'projectfiles',
  \  'action' : 'edit',
  \}
  function! s:source.gather_candidates(args, context)
    let cwd = s:findroot(getcwd())
    return map(filter(split(globpath(cwd, "**/*"), "\n"), 'filereadable(v:val)'), "{
    \  'word' : substitute(v:val[len(cwd)+1: ], '\\', '/', 'g'),
    \  'kind' : 'file',
    \  'action__path' : v:val,
    \}")
  endfunction
  return [s:source]
endfunction

