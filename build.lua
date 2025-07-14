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
version       = "v3.3J 2025-05-27"
maintainer    = "Mingyu Xia; Lijun Guo"
uploader      = "Mingyu Xia"
maintainid    = "myhsia"
email         = "myhsia@outlook.com"
repository    = "https://github.com/" .. maintainid .. "/" .. module
announcement  = [[
Version 3.4A released.
- Enhanced: The ratio of the workdays' widths supports f.p. numbers
- Update the `build.lua` script to support building the project via `latexmk`
]]
summary       = "Class schedules with colorful course blocks"
description   = [[
The litetable package provides a colorful timetable design, developed by expl3 based on TikZ
]]

--[==========================================[--
            Pack and Upload To CTAN
         Don't Modify Unless Necessary
--]==========================================]--
ctanzip       = module
excludefiles  = {"*~"}
textfiles     = {"*.md", "LICENSE", "*.lua"}
typesetcmds   = [[\\AtBeginDocument\\DisableImplementation]]
typesetexe    = "latexmk -pdf"
typesetfiles  = {module .. ".dtx", "*.tex"}
typesetruns   = 1

specialtypesetting = specialtypesetting or {}
specialtypesetting["litetable-zh-cn.tex"] = {cmd = "latexmk -xelatex"}
specialtypesetting["litetable-zh-hk.tex"] = {cmd = "latexmk -xelatex"}

uploadconfig = {
  pkg          = module,
  version      = version,
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

function docinit_hook()
  run (typesetdir, [[echo '$makeindex = "makeindex -s gind.ist";' > latexmkrc]])
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
function unpack(sources, sourcedirs)
  local errorlevel = dep_install(unpackdeps)
  if errorlevel ~= 0 then
    return errorlevel
  end
  errorlevel = bundleunpack(sourcedirs, sources)
  if errorlevel ~= 0 then
    return errorlevel
  end
  for _,i in ipairs(installfiles) do
    errorlevel = cp(i, unpackdir, localdir)
    if errorlevel ~= 0 then
      return errorlevel
    end
  end
  cp("*.md", unpackdir, currentdir)
  return 0
end
