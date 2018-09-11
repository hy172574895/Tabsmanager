
if ( exists('g:Tabmanager_loaded')  ) || v:version < 700 || &cp
    finish
endif
let g:Tabmanager_loaded = 1

function! s:InitVar(var, DefaultValue)
    if !exists(a:var)
        exec 'let '.a:var.'='.string(a:DefaultValue)
    endif
endfunction
call s:InitVar('g:tabmanager_win_pos', 'bo')
call s:InitVar('g:tabmanager_win_width', '30')
call s:InitVar('g:tabmanager_show_tabwindow_when_open_new_tab', '1')
call s:InitVar('g:Tabsmanager_the_countOf_track_items', '5')

call s:InitVar('g:tabmanager_mapping_tt', 'tt')
call s:InitVar('g:tabmanager_mapping_tg', 'tg')
call s:InitVar('g:tabmanager_mapping_tb', 'tb')
call s:InitVar('g:tabmanager_mapping_gt', 'gt')
execute 'nnoremap <silent> ' g:tabmanager_mapping_tt ' :<C-U>call g:Tabsmanager#Init_buffer()<CR>'
execute 'nnoremap <silent> ' g:tabmanager_mapping_tg ' :<C-U>call g:Tabmanager_goto_tabs_by_getting_charater()<CR>'
execute 'nnoremap <silent> ' g:tabmanager_mapping_tb ' :<C-U>call g:Tabmanager_theStyle_goto_buf()<CR>'
execute 'nnoremap <silent> ' g:tabmanager_mapping_gt ' :<C-U>call Tabsmanager#_goto_last_tab()<CR>'
augroup tab_manager_init
    autocmd!
    autocmd BufEnter,TabEnter * call Tabsmanager#Updating_inrealtime()
    autocmd TabLeave * call Tabsmanager#record_tabNr()
augroup END
