@echo ON

if "%VS_VERSION%" == "9.0" (
  set VL_MSC=1500
  set MSVSVER=90
) else if "%VS_VERSION%" == "10.0" (
  set VL_MSC=1700
  set MSVSVER=100
) else if "%VS_VERSION%" == "14.0" (
  set VL_MSC=1900
  set MSVSVER=140
)

set VL_ARCH=win%ARCH%

rmdir bin\%VL_ARCH% /S /Q
md bin\%VL_ARCH%
nmake /f Makefile.mak ARCH=%VL_ARCH% VL_MSVC=%VS_VERSION% VL_MSVS=%VS_MAJOR% VL_MSC=%VL_MSC% MSVSVER=%MSVSVER% VERB=1
if errorlevel 1 exit 1

copy "bin\%VL_ARCH%\sift.exe" "%LIBRARY_BIN%\sift.exe"
if errorlevel 1 exit 1
copy "bin\%VL_ARCH%\mser.exe" "%LIBRARY_BIN%\mser.exe"
if errorlevel 1 exit 1
copy "bin\%VL_ARCH%\aib.exe"  "%LIBRARY_BIN%\aib.exe"
if errorlevel 1 exit 1

copy "bin\%VL_ARCH%\vl.dll" "%LIBRARY_BIN%\vl.dll"
if errorlevel 1 exit 1
copy "bin\%VL_ARCH%\vl.lib" "%LIBRARY_BIN%\vl.lib"
if errorlevel 1 exit 1

robocopy "vl" "%LIBRARY_INC%\vl" *.h /MIR
if %ERRORLEVEL% GEQ 2 (exit 1) else (exit 0)
