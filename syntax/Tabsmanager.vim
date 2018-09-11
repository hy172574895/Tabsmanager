
syn match Tabmanager_ON_tab  display '^On Tab'
syn match Tabmanager_Slient_tab  display '^▼==Tab'
syn match Tabmanager_Hidden_buffer  display '^Hidden_buffers:'
syn match Tabmanager_Track_list  display '^Track:'

hi def link Tabmanager_ON_tab Special
hi def link Tabmanager_Slient_tab Keyword
hi def link Tabmanager_Hidden_buffer Keyword
hi def link Tabmanager_Track_list Keyword
