--[==========================================[--
           L3BUILD FILE FOR LITETABLE
      Once Pushed After This File Modified
        A New Release Will Be Published
--]==========================================]--

--[==========================================[--
               Basic Information
             Do Check Before Push
--]==========================================]--

module       = "litetable"
version      = "v3.3I 2025-05-24"
maintainer   = "Mingyu Xia; Lijun Guo"
uploader     = "Mingyu Xia"
maintainid   = "myhsia"
email        = "myhsia@outlook.com"
repository   = "https://github.com/" .. maintainid .. "/" .. module
announcement = [[
Version 3.3I released.
- `build.lua` is included in the package.
]]
summary      = "Class schedules with colorful course blocks"
description  = [[
The litetable package provides a colorful timetable design, developed by expl3 based on TikZ
]]

--[==========================================[--
            Pack and Upload To CTAN
         Don't Modify Unless Necessary
--]==========================================]--
typesetfiles = {"*.dtx", "*-zh-cn.tex", "*-zh-hk.tex"}
specialtypesetting = specialtypesetting or {}
specialtypesetting["litetable-zh-cn.tex"] =
  {cmd = "xelatex --shell-escape -interaction=nonstopmode"}
specialtypesetting["litetable-zh-hk.tex"] =
  {cmd = "xelatex --shell-escape -interaction=nonstopmode"}
textfiles    = {"*.md", "LICENSE", "*.lua"}
excludefiles = {"*~"}
cleanfiles   = {"*.log", "*.pdf", "*.zip", "*.curlopt"}
ctanzip      = module

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