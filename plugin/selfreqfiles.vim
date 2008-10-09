"""""""""""""""""""""""""""""""" Reference to Author
" GetLatestVimScripts: 2028 1 :AUTOINSTALL: SelectFreqFiles

" MarkLines:  Allows you to select frequently used files across directory.
" Author:     Vijayandra Singh (vsingh@vjrc.com)
" Date:       Oct,10 2008
" Version:    1.0
" License:  

" Copyright (c) 2008, Vijayandra Singh
" All rights reserved.
" 
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"     * Redistributions of source code must retain the above copyright
"       notice, this list of conditions and the following disclaimer.
"     * Redistributions in binary form must reproduce the above copyright
"       notice, this list of conditions and the following disclaimer in the
"       documentation and/or other materials provided with the distribution.
"     * The names of the contributors may not be used to endorse or promote
"       products derived from this software without specific prior written
"       permission.
" 
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER ``AS IS'' AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SelectFreqFiles.txt 
" VIM c:\sw\vim\vim72\plugin selfreqfiles.vim
" genericCAT C:\NDev\CnewFirmware main.c
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Abort if running in vi-compatible mode or the user doesn't want us.    {{{1

if exists("loaded_selectfrequentFilesvim") || &cp
    finish
endif
set guioptions+=v
let loaded_selectfrequentFilesvim=1
let g:initialized=0

silent map <silent> <f1>     :call SelectDynProject()<CR>
silent map <silent> <s-f1>   :call SelectDynProject()<CR>

function SelectDynProject()

   let x=1
   let allchoicess=0
   let random=localtime()

   let icounter=0
   let prjName=''
   let ext=tolower(expand("%:e"))
   let fname=tolower(expand('%<'))
   let curfile=fname . '.' . ext
   let menuchoice=''

   if(g:initialized==0)
       let g:projdir=[]
       let g:projfile=[]
       let g:projname=[]

       let g:initialized=1
       let xfile = $VIM . "/vim72/plugin/selfreqfiles.txt"
       execute('sp ' . xfile)
       let s=line('.')
       let g:initialized=line('1')+1
       let pend=line("$")
       while (g:initialized <= pend)
    
          let items = split(getline(g:initialized), ' ')
          let xdefHeading = items[0]
          let xdir        = items[1]
          let xdefFname   = items[2]
          "echo xdefHeading
          "echo xdir
          "echo xdefFname
              if g:initialized==1
                  let  menuchoice = "&" . xdefHeading
              else
                  let  menuchoice = menuchoice . "\n&" . xdefHeading
              endif
              "echo xdir
              "echo xdefFname
              call add(g:projdir,xdir)
              call add(g:projfile,xdefFname)
              call add(g:projname,xdefHeading)
              let allchoicess=allchoicess+1
          let g:initialized = g:initialized + 1
       endwhile
       execute('q!')
   endif
   let plength=0
   "echo g:initialized

   while(plength!=g:initialized-1)
       if plength==0
          let  menuchoice = "&" . g:projname[plength]
       else
          let  menuchoice = menuchoice . "\n&" . g:projname[plength]
       endif
       let plength=plength+1
   endwhile

   let defchoice=random%g:initialized-1
   if(defchoice==0) 
       let defchoice=1
   endif
   let choice = confirm("Select project", menuchoice, defchoice)
   if(choice>0) 
       let choice=choice-1
   endif

   let ccDir=g:projdir[choice]
   let ccFile=g:projfile[choice]

   let ccPath=escape(ccDir, ' \')
   if isdirectory(ccPath)
       exe 'cd ' . ccDir

       let $tarfile = ccFile
       if filereadable($tarfile)
           exe 'e ' . ccFile
       else
           echo $tarfile . ' does not exits'
       endif
       if choice==0 
           "exe 'sil tabnew ' . 'selfreqfiles.txt'
       endif
   else
       echo "Directory " . ccDir . " does not exists"
   endif


endfunction
