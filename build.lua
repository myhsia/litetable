--[==========================[--
   L3BUILD FILE FOR LITETABLE
--]==========================]--

module       = "litetable"
ctanzip      = module
typesetfiles = {"*.dtx", "*-zh-cn.tex", "*-zh-hk.tex"}
specialtypesetting = specialtypesetting or {}
specialtypesetting["litetable-zh-cn.tex"] =
  {cmd = "xelatex --shell-escape -interaction=nonstopmode"}
specialtypesetting["litetable-zh-hk.tex"] =
  {cmd = "xelatex --shell-escape -interaction=nonstopmode"}

uploadconfig = {
  pkg          = "litetable",
  version      = "v3.3G 2025-03-28",
  author       = "Mingyu Xia; Lijun Guo",
  uploader     = "Mingyu Xia",
  email        = "myhsia@outlook.com",
  summary      = "Class schedules with colorful course blocks",
  description  = [[
    The litetable package provides a colorful timetable design,
    developed by expl3 based on article and TikZ
  ]],
  license      = "lppl1.3c",  
  ctanPath     = "/macros/latex/contrib/litetable",
  announcement = [[
    Version 3.3G released.
    - Updated README.md.
  ]],
  home         = "https://github.com/myhsia/litetable",
  bugtracker   = "https://github.com/myhsia/litetable/issues",
  support      = "https://qm.qq.com/q/RGFmHwBecC",
  repository   = "https://github.com/myhsia/litetable",
  development  = "https://github.com/myhsia",
  update       = true
}