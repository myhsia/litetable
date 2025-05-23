--[==========================================[--
           L3BUILD FILE FOR LITETABLE
     Check PDF File & Directory After Build
--]==========================================]--

--[==========================================[--
                Basic Information
             Do Check Before Upload
--]==========================================]--

module       = "litetable"
version      = "v3.3H 2025-05-23"
maintainer   = "Mingyu Xia; Lijun Guo"
uploader     = "Mingyu Xia"
maintainid   = "myhsia"
email        = "myhsia@outlook.com"
repository   = "https://github.com/" .. maintainid .. "/" .. module
announcement = [[
  Version 3.3H released.
  - Optimized the implementation, and updated build.lua
]]
summary      = "Class schedules with colorful course blocks"
description  = [[
The litetable package provides a colorful timetable design, developed by expl3 based on article and TikZ
]]

--[==========================================[--
            Pack and Upload To CTAN
         Don't Modify Unless Necessary
--]==========================================]--
typesetfiles = {"*.dtx", "*-zh-cn.tex", "*-zh-hk.tex"}
typesetsourcefiles  = {"*.md"}
specialtypesetting = specialtypesetting or {}
specialtypesetting["litetable-zh-cn.tex"] =
  {cmd = "xelatex --shell-escape -interaction=nonstopmode"}
specialtypesetting["litetable-zh-hk.tex"] =
  {cmd = "xelatex --shell-escape -interaction=nonstopmode"}
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