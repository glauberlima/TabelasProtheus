@echo off
stripreloc *.exe
setcsum *.exe /a
upx --best *.exe
setcsum *.exe /a
