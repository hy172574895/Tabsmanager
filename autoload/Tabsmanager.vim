" DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
"         Version 2, December 2004
" Everyone is permitted to copy and distribute verbatim or modified
" copies of this license document, and changing it is allowed as long
" as the name is changed.
" DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
" TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
"
" 0. You just DO WHAT THE FUCK YOU WANT TO.
"version 0.0.02
function! s:Bufwinnr()
    "{{{
    let tbm = filter(range(1, winnr('$')), 'bufname(winbufnr(v:val)) ==
                \ "Tabsmanager"')
    return empty(tbm) ? 0 : tbm[0]
    "}}}
endfunction
"
function! Tabsmanager#Updating_inrealtime()
    "{{{
    call s:Tabsmanager_visist_track()
    let l:window_nr=s:If_exist_Tabmanager_window_in_curren_tab()
    if l:window_nr
        let g:tabmanager_curren_buffferNr =winbufnr(0)
        let l:curren_windows=winnr()
        if l:curren_windows!=l:window_nr 
            silent! execute l:window_nr.'winc w'
            call s:Tabsmanager_Update_context()
            silent! execute l:curren_windows.'winc w'
        else
            call s:Tabsmanager_Update_context()
        endif
    endif
    "}}}
endfunction
"
function! s:beep()
    "{{{
    exe "norm! \<Esc>"
    return ""
    "}}}
endfunction
"
function! Tabsmanager#_goto_last_tab()
    "{{{
    " let l:len_of_tracker=len(g:full_contextOf_visist_track)
    " while l:len_of_tracker>=0
    "     let l:last_tab_ID=matchstr(
    "                 \get(g:full_contextOf_visist_track,
    "                 \l:len_of_tracker,'NONE'),'^\d\+\#')
    "     let l:last_tab_ID=matchstr(l:last_tab_ID,'\d\+')
    "     if l:last_tab_ID!='' && l:last_tab_ID!=tabpagenr()
    "         call s:Switch_tab(l:last_tab_ID,'')
    "         return 
    "     endif
    "     let l:len_of_tracker-=1
    " endwhile
    if exists('g:tabmanager_record_tabNr')
        call s:Switch_tab(g:tabmanager_record_tabNr,'')
    else
        redraw!
        echo 'No recorded Tabs number.'
    endif

    "}}}
endfunction
function! Tabsmanager#record_tabNr()
    "{{{
    let g:tabmanager_record_tabNr=tabpagenr()
    "}}}
endfunction
"
function! g:Tabmanager_goto_tabs_by_getting_charater()
    "{{{
    echom 'Typing the number of tabs that you want to go:'
    let l:tabNr=s:Tabmanager_getchar()
    redraw!
    if l:tabNr =~ '\d'
        let l:tabscount=tabpagenr('$') 
        if l:tabNr>l:tabscount
            call s:beep()
            return
        endif
        if l:tabNr*10<=l:tabscount
            echom 'Typing the number of tabs that you want to go:'.l:tabNr
            let l:tabNr2=s:Tabmanager_getchar()
            redraw!
            if l:tabNr2=~ '\d'
                let l:tabNr=l:tabNr*10+l:tabNr2
            endif
        endif
        call s:Switch_tab(l:tabNr,'')
    else
        echo 'Quit to Tabsmanager.'
    endif
    "}}}
endfunction
"
function! g:Tabmanager_goto_buffer_by_getting_charater(how_to_open)
    "{{{
    echom 'Typing the number of buffers that you want to go:'
    let l:burNr=s:Tabmanager_getchar()
    redraw!
    if l:burNr =~ '\d'
        let l:bufcount=bufnr('$') 
        if l:burNr>l:bufcount
            call s:beep()
            return
        endif
        if l:burNr*10<=l:bufcount
            echom 'Typing the number of buffers that you want to go:'.l:burNr
            let l:bufNr2=s:Tabmanager_getchar()
            redraw!
            if l:bufNr2=~ '\d'
                let l:burNr=l:burNr*10+l:bufNr2
            endif
        endif
        if a:how_to_open=='v'
            call s:Open_buffer_in_current_tab(l:burNr,'v')
        elseif a:how_to_open=='s'
            call s:Open_buffer_in_current_tab(l:burNr,'s')
        elseif a:how_to_open=='incurrenbuf'
            call s:Open_buffer_in_curren_buffer(l:burNr)
        elseif a:how_to_open=='innewtab'
            call s:Open_buffer_inA_new_tab(l:burNr)
        endif
    else
        echo 'Quit to Tabsmanager.'
    endif
    "}}}
endfunction
"
function! s:If_exist_Tabmanager_window_in_curren_tab()
    "{{{
    let t:tabmanager_windowNr=s:Bufwinnr()
    if  (t:tabmanager_windowNr==0)|| getbufinfo(t:tabmanager_bufferNr)==[]
        return 0
    else
        return t:tabmanager_windowNr
    endif
    "}}}
endfunction
"
function! Tabsmanager#Init_buffer()
    "{{{
    let l:window_nr=s:If_exist_Tabmanager_window_in_curren_tab()
    if l:window_nr
        if s:If_on_tabmanager_window()
            silent! execute g:tabsmanager_from_windows.'winc w'
        else
            silent! execute l:window_nr.'winc w'
        endif
        return 1
    endif
    silent! execute g:tabmanager_win_pos.' '.g:tabmanager_win_width.
                \' vnew Tabsmanager'
    setlocal buftype=nofile bufhidden=wipe nobuflisted nolist noswapfile 
                \nowrap cursorline nomodifiable nospell number norelativenumber 
                \winfixwidth syntax=Tabsmanager
    let t:tabmanager_bufferNr=winbufnr('.')
    call Tabsmanager#Tabsmanager_Init_mapping()
    call Tabsmanager#Updating_inrealtime()
    "}}}
endfunction
"
function! s:Tabsmanager_Update_context()
    "{{{
    setl modifiable
    let l:cursor_pos=getcurpos()
    " echo l:cursor_pos
    silent! normal! gg"_dG
    if !exists('g:tabmanager_doNot_show_tabs')
        silent! put=s:Tabsmanager_Update_tabs()
    endif
    if !exists('g:tabmanager_doNot_show_hidden_buffers')
        silent! put=s:Hidden_buffers()
    endif
    if !exists('g:tabmanager_doNot_show_last_track')
        silent! put=''
        silent! put='Track:'
        silent! put=g:full_contextOf_visist_track
    endif
    exe 'vert res'.g:tabmanager_win_width
    call setpos('.',l:cursor_pos)
    setl nomodifiable
    "}}}
endfunction
"
function! s:Tabsmanager_visist_track()
    "{{{
    if s:If_on_tabmanager_window()==0
        let g:tabsmanager_from_tabNr = tabpagenr()
        let g:tabsmanager_from_windows =winnr()
        " echo g:tabsmanager_from_windows
    endif
    if !exists('g:full_contextOf_visist_track')
        let g:full_contextOf_visist_track=[]
    endif
    if !exists('g:tabsmanager_last_tabNr')
        let g:tabsmanager_last_tabNr=0
    endif
    if !exists('g:tabsmanager_last_bufNr')
        let g:tabsmanager_last_bufNr=0
    endif

    let last_buf=getbufinfo(winbufnr(0))
    if !last_buf[0]['listed']
        return
    endif

    if g:tabsmanager_last_tabNr==tabpagenr()
       \ && g:tabsmanager_last_bufNr==winbufnr(0)
        return
    endif

    if empty(fnamemodify(last_buf[0]['name'],':t')) ||
                \exists('g:tabmanager_doNot_show_last_track') 
        return
    endif

    let g:tabsmanager_last_tabNr = tabpagenr()
    let g:tabsmanager_last_bufNr = winbufnr(0)
    let i=0
    let g:tabsmanager_last_buf_name=fnamemodify(
                \bufname(g:tabsmanager_last_bufNr),':t')
    let g:itemOf_last_track=g:tabsmanager_last_tabNr.
                \'#['.g:tabsmanager_last_bufNr.']'.
                \g:tabsmanager_last_buf_name
    while i <=  g:Tabsmanager_the_countOf_track_items
        if i==g:Tabsmanager_the_countOf_track_items
            call remove(g:full_contextOf_visist_track,0)
            call add(g:full_contextOf_visist_track,g:itemOf_last_track)
            return
        elseif  get(g:full_contextOf_visist_track, i, 'NONE')=='NONE'
            call add(g:full_contextOf_visist_track,g:itemOf_last_track)
            return
        endif
        let i+=1
    endwhile
    "}}}
endfunction
"
function! s:Tabsmanager_Update_tabs()
    "{{{
    let tabnr = tabpagenr('$')
    let tabs_tree = {}
    for i in range(1, tabnr)
        let buffers = tabpagebuflist(i)
        let tabs_tree[i] = buffers
    endfor
    let full_context_of_tabs=[]
    for page in sort(keys(tabs_tree), 'N')
        call add(full_context_of_tabs,
                    \(page==tabpagenr() ? 'On Tab ':'▼==Tab ').'#'.page)
        for _buf in tabs_tree[page]
            let buf=getbufinfo(_buf)
            if getbufvar(_buf, '&buflisted')
                call add(full_context_of_tabs,
                            \(buf[0]['bufnr']==g:tabmanager_curren_buffferNr
                            \? '  *[' :'  [').
                            \ buf[0]['bufnr'] . ']' . 
                            \fnamemodify(empty(bufname(_buf))? 'No Name' : 
                            \bufname(_buf), ':t').
                            \(buf[0]['changed']?' +':' '))
            elseif getbufvar(_buf, '&buftype') ==# 'terminal'
                call add(full_context_of_tabs, '   [' . buf[0]['bufnr'] . 
                            \']Terminal')
            endif
        endfor
    endfor
    return full_context_of_tabs
    "}}}
endfunction
"
function! s:Hidden_buffers()
    "{{{
    let s:full_context_of_hidden_buffers=[]
    call add(s:full_context_of_hidden_buffers,'')
    call add(s:full_context_of_hidden_buffers,'Hidden_buffers:')
    for buf in getbufinfo()
        if buf.listed
            if buf.loaded==0 || buf.hidden==1
                call add(s:full_context_of_hidden_buffers,
                            \'  ['.buf.bufnr.']'.
                            \fnamemodify(
                            \empty(bufname(buf.bufnr))? 'No Name' : 
                            \bufname(buf.bufnr),':t'))
            endif
        endif
    endfor
    return s:full_context_of_hidden_buffers
    "}}}
endfunction
"
function! s:Tabmanager_getchar()
    "{{{
    let l:c = getchar()
    let l:c = nr2char(l:c)
    return l:c
    "}}}
endfunction

function! s:Tabmanager_get_curren_line_ID_info()
    "{{{
    let t:Tabmanager_tab_ID=0
    let t:Tabmanager_buf_ID=0
    let t:Tabmanager_buf_name=''
    let l:curren_line_Nr=line('.')
    let l:curren_line_context=getline(l:curren_line_Nr)
    let l:curren_line_buf_ID=matchstr(l:curren_line_context,'\[\d\+\]')
    let l:curren_line_buf_ID=matchstr(l:curren_line_buf_ID,'\d\+')
    let t:Tabmanager_buf_ID=l:curren_line_buf_ID
    if l:curren_line_buf_ID!=''
        let t:Tabmanager_buf_name=bufname(l:curren_line_buf_ID+1-1)
        "the t:Tabmanager_buf_ID is not the int Typing when using regular
        "expression
        " echo bufname(l:curren_line_buf_ID+1-1)
        let l:curren_line_tab_ID=matchstr(l:curren_line_context,'^\d\+\#')
        if l:curren_line_tab_ID==''
            let l:i=l:curren_line_Nr
            while l:i !=0
                let l:i-=1
                let l:curren_line_context=getline(l:i)
                if matchstr(l:curren_line_context,'Hidden_buffers:')!=''
                    return
                endif
                let l:curren_line_tab_ID=matchstr(l:curren_line_context,'\#\d\+$')
                let l:curren_line_tab_ID=matchstr(l:curren_line_tab_ID,'\d\+')
                if l:curren_line_tab_ID!=''
                    let t:Tabmanager_tab_ID=l:curren_line_tab_ID
                    return
                endif
            endwhile
        else
            let l:curren_line_tab_ID=matchstr(l:curren_line_tab_ID,'\d\+')
            let t:Tabmanager_tab_ID=l:curren_line_tab_ID
        endif
    else
        let l:curren_line_tab_ID=matchstr(l:curren_line_context,'\#\d\+$')
        let l:curren_line_tab_ID=matchstr(l:curren_line_tab_ID,'\d\+')
        let t:Tabmanager_tab_ID=l:curren_line_tab_ID
    endif
    "}}}
endfunction

function! g:Tabmanager_window_operate(style)
    "{{{
    call s:Tabmanager_get_curren_line_ID_info()
    if t:Tabmanager_buf_ID!=0
        if a:style=='OpenBufInANewTab' 
            call s:Open_buffer_inA_new_tab(t:Tabmanager_buf_ID)
        elseif a:style=='OpenBufInCurrenBuf' 
            call s:Open_buffer_in_curren_buffer(t:Tabmanager_buf_ID)
        elseif a:style=='SplitBuff' 
            call s:Open_buffer_in_current_tab(t:Tabmanager_buf_ID,'s')
        elseif a:style=='SplitBuffVertically' 
            call s:Open_buffer_in_current_tab(t:Tabmanager_buf_ID,'v')
        elseif a:style=='PointToPosition' 
            call s:Previous_buf(t:Tabmanager_tab_ID,t:Tabmanager_buf_ID)
        elseif a:style=='DeleteTabOrBuffer' 
            call s:Delete_A_buffer(t:Tabmanager_buf_ID)
        endif
    elseif t:Tabmanager_tab_ID!=0 && a:style=='DeleteTabOrBuffer'
        call s:Delete_A_tab(t:Tabmanager_tab_ID)
    endif
      
    "}}}
endfunction
"
" ==============================================================================
" Init
"{{{
function! s:Init_var(var_name,values)
    "{{{
    if !exists(a:var_name)
        execute 'let '.a:var_name.'='.a:values
    endif
    "}}}
endfunction
"
function! g:Tabmanager_theStyle_goto_buf()
"{{{
    echo 'Choose the style to show buffer:'
    let l:style=s:Tabmanager_getchar()
    redraw!
    if l:style=='v'
        call g:Tabmanager_goto_buffer_by_getting_charater('v')
        return
    elseif l:style=='s'
        call g:Tabmanager_goto_buffer_by_getting_charater('s')
        return
    elseif l:style=='b'
        call g:Tabmanager_goto_buffer_by_getting_charater('incurrenbuf')
        return
    elseif l:style=='t'
        call g:Tabmanager_goto_buffer_by_getting_charater('innewtab')
        return
    endif
    echo 'No['.l:style.'] mode'
"}}}
endfunction
"
function! Tabsmanager#Tabsmanager_Init_mapping()
    "{{{
    nnoremap <silent> <buffer> q :bd<cr>
    nnoremap <silent> <buffer> s :call g:Tabmanager_window_operate('SplitBuff')<cr>
    nnoremap <silent> <buffer> v :call g:Tabmanager_window_operate('SplitBuffVertically')<cr>
    nnoremap <silent> <buffer> t :call g:Tabmanager_window_operate('OpenBufInANewTab')<cr>
    nnoremap <silent> <buffer> o :call g:Tabmanager_window_operate('OpenBufInCurrenBuf')<cr>
    nnoremap <silent> <buffer> p :call g:Tabmanager_window_operate('PointToPosition')<cr>
    nnoremap <silent> <buffer> tx :call g:Tabmanager_window_operate('DeleteTabOrBuffer')<cr>
    "}}}
endfunction
function! s:If_on_tabmanager_window()
    "{{{
    return bufname(winbufnr(winnr()))=='Tabsmanager'?1:0
    "}}}
endfunction
"
"}}}
" ==============================================================================
"operate
"{{{
function! s:Switch_tab(tab_id,buffer_id)
    "{{{
    silent! execute 'tabnext '.a:tab_id
    "}}}
endfunction
function! s:Previous_buf(tab_id,buffer_id)
    "{{{
    silent! execute 'tabnext '.a:tab_id
    let tbm = filter(range(1, winnr('$')), 'bufname(winbufnr(v:val)) == 
                \t:Tabmanager_buf_name')
    redraw!
    if empty(tbm)
        echo "Tabsmanager don't know where this buf is."
        call s:beep()
    else
        silent! execute tbm[0].'winc w'
    endif
    "}}}
endfunction
"
function! s:Open_buffer_inA_new_tab(buffer_id)
    "{{{
    silent! execute 'tabedit '
    silent! execute 'b '.a:buffer_id
    if exists('g:tabmanager_show_tabwindow_when_open_new_tab')
        let l:curren_windows=winnr()
        call Tabsmanager#Init_buffer()
        silent! execute l:window_nr.'winc w'
    endif
    "}}}
endfunction
"
function! s:Open_buffer_in_current_tab(buffer_id,style)
    "{{{
    if s:If_on_tabmanager_window()==1
        silent! execute g:tabsmanager_from_windows.'winc w'
    endif
    if a:style=='v'
        silent! execute 'vnew'
        silent! execute 'b '.a:buffer_id
    else
        silent! execute 'sb '.a:buffer_id
    endif
    "}}}
endfunction
"
function! s:Open_buffer_in_curren_buffer(buffer_id)
    "{{{
    if s:If_on_tabmanager_window()==1
        silent! execute g:tabsmanager_from_windows.'winc w'
    endif
    silent! execute 'b '.a:buffer_id
    "}}}
endfunction
"
function! s:Delete_A_buffer(buffer_id)
    "{{{
    silent! execute 'bd '.a:buffer_id
    call s:Tabsmanager_Update_context()
    "}}}
endfunction
"
function! s:Delete_A_tab(tab_id)
    "{{{
    silent! execute 'tabclose '.a:tab_id
    call s:Tabsmanager_Update_context()
    "}}}
endfunction
"
"}}}
"
" ==============================================================================
