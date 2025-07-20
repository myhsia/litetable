--[==========================================[--
           L3BUILD FILE FOR LITETABLE
      Once Pushed With This File Modified
        A New Release Will Be Published
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module              = "litetable"
version             = "v3.5A"
date                = "2025-07-20"
maintainer          = "Mingyu Xia; Lijun Guo"
uploader            = "Mingyu Xia"
maintainid          = "myhsia"
email               = "myhsia@outlook.com"
repository          = "https://github.com/" .. maintainid .. "/" .. module
announcement        = [[Version 3.5A released.
- Optimized `build.lua` script
- Updated the manual
- Fixed typo in `README.md`
- Restored the demo file
- Removed support for low-version LaTeX distributions]]
summary             = "A Colorful Timetable Design"
description         = "The litetable package provides a colorful timetable design, developed by expl3 based on TikZ"

--[==========================================[--
          Build, Pack, Tag, and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip             = module
cleanfiles          = {"*log", "*.pdf", "*.zip", "*.curlopt"}
excludefiles        = {"*~"}
tagfiles            = {"*.dtx", "*.tex"}
textfiles           = {"*.md", "LICENSE", "*.lua"}
typesetcmds         = "\\AtBeginDocument{\\ifdefined\\DisableImplementation" ..
                      "\\DisableImplementation\\fi}"
typesetdemofiles    = {module .. "-demo.tex"}
typesetexe          = "latexmk -pdf"
typesetfiles        = {"*.dtx", module .. "-zh-cn.tex", module .. "-zh-hk.tex"}
typesetruns         = 1
specialtypesetting  = specialtypesetting or {}
specialtypesetting["litetable-zh-cn.tex"] = {cmd = "latexmk -xelatex"}
specialtypesetting["litetable-zh-hk.tex"] = {cmd = "latexmk -xelatex"}
uploadconfig  = {
  pkg          = module,
  version      = version .. " " .. date,
  author       = maintainer,
  uploader     = uploader,
  email        = email,
  summary      = summary,
  description  = description,
  license      = "lppl1.3c",  
  ctanPath     = "/macros/latex/contrib/" .. module,
  announcement = announcement,
  home         = repository,
  bugtracker   = repository .. "/issues",
  support      = repository .. "/issues",
  repository   = repository,
  development  = "https://github.com/" .. maintainid,
  update       = true
}
function update_tag(file, content, tagname, tagdate)
  tagname = version
  tagdate = date
  if string.match(file, "%.dtx$") or string.match(file, "%.tex$") then
    content = string.gsub(content,
      "\\ProvidesExplPackage {" .. module .. "} %{[^}]+%} %{[^}]+%}[\r\n%s]*%{[^}]+%}",
      "\\ProvidesExplPackage {" .. module .. "} {" .. tagdate .. "} {" .. tagname .. "}\n  {" .. summary .. "}")
    content = string.gsub(content,
      "\\date{Released %d+%-%d+%-%d+\\quad \\texttt{v([%d%.A-Z]+)}}",
      "\\date{Released " .. tagdate .. "\\quad \\texttt{" .. tagname .. "}}")
  end
  return content
end

--[== "Hacks" to `l3build` | Do not Modify ==]--

function docinit_hook()
  cp(ctanreadme, unpackdir, currentdir)
  return 0
end
function tex(file,dir,cmd)
  dir = dir or "."
  cmd = cmd or typesetexe
  if os.getenv("WINDIR") ~= nil or os.getenv("COMSPEC") ~= nil then
    upretex_aux = "-usepretex=\"" .. typesetcmds .. "\""
    makeidx_aux = "-e \"$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\""
    sandbox_aux = "set \"TEXINPUTS=../unpacked;%TEXINPUTS%;\" &&"
  else
    upretex_aux = "-usepretex=\'" .. typesetcmds .. "\'"
    makeidx_aux = "-e \'$makeindex=q/makeindex -s " .. indexstyle .. " %O %S/\'"
    sandbox_aux = "TEXINPUTS=\"../unpacked:$(kpsewhich -var-value=TEXINPUTS):\""
  end
  return run(dir, sandbox_aux .. " " .. cmd         .. " " ..
                  upretex_aux .. " " .. makeidx_aux .. " " .. file)
end
