--[==========================================[--
           L3BUILD FILE FOR LITETABLE
      Once Pushed With This File Modified
        A New Release Will Be Published
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module        = "litetable"
version       = "v3.4B"
date          = "2025-07-16"
maintainer    = "Mingyu Xia; Lijun Guo"
uploader      = "Mingyu Xia"
maintainid    = "myhsia"
email         = "myhsia@outlook.com"
repository    = "https://github.com/" .. maintainid .. "/" .. module
announcement  = "Version " .. version .. " released.\n" .. [[
- Fix the bug that `build.lua` script works improperly on Windows OS.]]
summary       = "A Colorful Timetable Design"
description   = [[
The litetable package provides a colorful timetable design, developed by expl3 based on TikZ]]

--[==========================================[--
          Build, Pack, Tag, and Upload
         Do not Modify Unless Necessary
--]==========================================]--

ctanzip       = module
cleanfiles    = {"*log", "*.pdf", "*.zip", "*.curlopt"}
excludefiles  = {"*~"}
latexmk       = "$makeindex = \"makeindex -s gind.ist\";"
textfiles     = {"*.md", "LICENSE", "*.lua"}
typesetcmds   = "\\AtBeginDocument\\DisableImplementation"
typesetexe    = "latexmk -pdf"
typesetfiles  = {"*.dtx", "*.tex"}
typesetruns   = 1
specialtypesetting = specialtypesetting or {}
specialtypesetting["litetable-zh-cn.tex"] = {cmd = "latexmk -xelatex"}
specialtypesetting["litetable-zh-hk.tex"] = {cmd = "latexmk -xelatex"}

uploadconfig = {
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

tagfiles = {"*.dtx", "*.tex"}
function update_tag(file, content, tagname, tagdate)
  tagname = version
  tagdate = date
  if string.match(file, "%.dtx$") or string.match(file, "%.tex$") then
    content = string.gsub(content,
      "\\ProvidesExplPackage {" .. module .. "} %{[^}]+%} %{[^}]+%} %{[^}]+%}",
      "\\ProvidesExplPackage {" .. module .. "} {" .. tagdate .. "} {" .. tagname .. "} {" .. summary .. "}")
    content = string.gsub(content,
      "\\date{Released %d+%-%d+%-%d+\\quad \\texttt{v([%d%.A-Z]+)}}",
      "\\date{Released " .. tagdate .. "\\quad \\texttt{" .. tagname .. "}}")
  end
  return content
end

--[== "Hacks" to `l3build` | Do not Modify ==]--

function docinit_hook()
  cp("*.md", unpackdir, currentdir)
  if os_type == "windows" then
    patch_typeset = "echo " .. latexmk .. " > latexmkrc"
  else
    patch_typeset = "echo '" .. latexmk .. "' > latexmkrc"
  end
  run(typesetdir, patch_typeset)
  for _,i in ipairs(installfiles) do
    errorlevel = cp(i, unpackdir, typesetdir)
  end
  return 0
end
function tex(file,dir,cmd)
  dir = dir or "."
  cmd = cmd or typesetexe
  return run(dir, cmd .. " " .. typesetopts .. " -usepretex='" .. typesetcmds .. "' " .. file)
end
