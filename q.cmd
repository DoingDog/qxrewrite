@echo off
set MAINFOLD=%1
if not defined MAINFOLD goto :eof
if not exist %~dp0\%MAINFOLD% goto :eof

::initialize
cd /d %~dp0\%MAINFOLD%\attach
echo ### -*- -*- -*- -*- -*- -*- Start processing in %MAINFOLD% -*- -*- -*- -*- -*- -*-
chcp 65001
del /f /q *.txt>nul 2>nul
del /f /q *.exe>nul 2>nul
::bypass detection
set wgetFix=-nv --no-config -t 3 --no-netrc -T 30 --connect-timeout=10 --read-timeout=10 -w 1 -4 --no-iri --no-cache -U "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1 SearchCraft/3.9.0 (Baidu; P2 16.0)" --no-cookies --https-only --no-hsts --local-encoding=UTF-8 --remote-encoding=UTF-8 --restrict-file-names=nocontrol
set curlFix=-L -q --connect-timeout 10 -k -4 -m 30 -e "https://google.com/" -s -S -A "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1 SearchCraft/3.9.0 (Baidu; P2 16.0)"

::enable proxy in China local machine (not needed)
set isproxy=0
set httproxy=172.16.0.2:8899

if %isproxy%==1 set curlproxy= -x %httproxy%
if %isproxy%==1 set http_proxy=%httproxy%
if %isproxy%==1 set https_proxy=%httproxy%

::get binaries
curl %curlFix%%curlproxy% --url https://raw.githubusercontent.com/DoingDog/DoingDog/main/wget.exe -o wget.exe
curl %curlFix%%curlproxy% --url https://raw.githubusercontent.com/DoingDog/DoingDog/main/busybox.exe -o busybox.exe
if not exist .\wget.exe (
del /f /q *.exe>nul 2>nul
goto :eof
)
if not exist .\busybox.exe (
del /f /q *.exe>nul 2>nul
goto :eof
)

::clear old
del /f /q ..\*.txt>nul 2>nul

::down and process All rule links
echo ###Start processing ordinary rules
for /f "eol=# tokens=1,2 delims= " %%i in (rule-list.ini) do (
wget %wgetFix% -O 2.txt %%i
busybox sed -i -E "/^$/d" 2.txt
busybox sed -i -E "/^\#./d" 2.txt
busybox sed -i -E "/^\#/d" 2.txt
busybox sed -i -E "/^\/\/./d" 2.txt
busybox sed -i -E "/^;./d" 2.txt
busybox sed -i -E "/^ /d" 2.txt
busybox sed -i -E "/^h\^https/d" 2.txt
busybox sed -n -E "/^hostname.*\=/p" 2.txt>>hn.txt
busybox sed -i -E "/^hostname.*\=/d" 2.txt
busybox sed -i -E "/^URL-REGEX/d" 2.txt
busybox sed -i -E "s/^http/\^http/g" 2.txt
busybox sed -i -E "s/^\^https\?\:\\\/\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/^\^https\?\:\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/^\^https\?\:\/\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/^\^https\?\+\:\\\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/^\^https\:\\\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/^\^https\:\/\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/\^http\?\:\\\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/\^http\:\\\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/\^http\:\/\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/\^http\?\:\/\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/\^\(http\|https\)\:\\\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/\^https\\\:\\\/\\\//\^https\?\:\\\/\\\//g" 2.txt
busybox sed -i -E "s/^h\^https/\^https/g" 2.txt
busybox sed -i -E "s/^\^ttps/\^https/g" 2.txt
busybox sed -i -r "s/https?:\/\/github\.com\/(.+)\/(.+)\/raw\/(.+)$/https\:\/\/raw\.githubusercontent\.com\/\1\/\2\/\3/g" 2.txt
echo.>>.\2.txt
type .\2.txt >>fas.txt
echo Downloaded
del /f /q 2.txt
)

::deduplicate same lines
echo ###Start deduplicate same lines
set LC_ALL='C'
busybox sort -u -i -o bn.txt fas.txt
set LC_ALL=

::get hostname
busybox echo -n hostname= >>hn-rec.txt
set LC_ALL='C'
busybox sort -u -i -o h1n.txt hn.txt
set LC_ALL=
busybox sed -i -E "s/ //g" h1n.txt
busybox sed -i -E "s/^hostname\=//g" h1n.txt
busybox sed -i -E "s/,/\n/g" h1n.txt
set LC_ALL='C'
busybox sort -u -i -o hhn.txt h1n.txt
set LC_ALL=
for /f "tokens=* delims=:" %%a in (hhn.txt) do (busybox echo -n %%a,  )>>hn-rec.txt
echo.>>hn-rec.txt

::count
echo ###Counting
for /f "tokens=2 delims=:" %%a in ('find /c /v "" bn.txt') do set/a bnrnum=%%a
echo # Total line %bnrnum%>>bnr.txt
echo # Last updated %date% %time%>>bnr.txt
type bnr.txt
echo # -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*- -*->>bnr.txt
type bn.txt>>bnr.txt
echo.>>bnr.txt
type hn-rec.txt>>bnr.txt
copy /y bnr.txt ..\1.txt

::clean
if %bnrnum% gtr 20 echo ### -*- -*- -*- -*- -*- -*- %MAINFOLD% File completely processed -*- -*- -*- -*- -*- -*-
del /f /q *.txt>nul 2>nul
del /f /q *.exe>nul 2>nul
echo ###Cleaned
cd /d %~dp0
