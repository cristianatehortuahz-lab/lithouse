@echo off
setlocal enabledelayedexpansion
title VIVO Local - Arranque Inteligente
cls

:: ---- HABILITAR COLORES ANSI Y CARACTERES ---
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
)
set "C_RST=%ESC%[0m"
set "C_RED=%ESC%[91m"
set "C_GRN=%ESC%[92m"
set "C_YEL=%ESC%[93m"
set "C_BLU=%ESC%[94m"
set "C_CYA=%ESC%[96m"

echo %C_CYA%=================================================================%C_RST%
echo %C_BLU%  __      _______      ______     _    _ _    _ ____  %C_RST%
echo %C_BLU%  \ \    / /_   _\ \    / / __ \   ^| ^|  ^| ^| ^|  ^| ^|  _ \ %C_RST%
echo %C_BLU%   \ \  / /  ^| ^|  \ \  / / ^|  ^| ^|  ^| ^|__^| ^| ^|  ^| ^| ^|_) ^|%C_RST%
echo %C_BLU%    \ \/ /   ^| ^|   \ \/ /^| ^|  ^| ^|  ^|  __  ^| ^|  ^| ^|  _ [ %C_RST%
echo %C_BLU%     \  /   _^| ^|_   \  / ^| ^|__^| ^|  ^| ^|  ^| ^| ^|__^| ^| ^|_) ^|%C_RST%
echo %C_BLU%      \/   ^|_____^|   \/   \____/   ^|_^|  ^|_^|\____/^|____/ %C_RST%
echo %C_CYA%=================================================================%C_RST%
echo %C_GRN%    Iniciando Entorno Local de Desarrollo (Pruebas)%C_RST%
echo %C_CYA%=================================================================%C_RST%
echo.

:: ---- RUTAS BASE ----
set "JAVA_HOME=C:\Program Files\Microsoft\jdk-11.0.30.7-hotspot"
set "CATALINA_HOME=C:\Users\cristian.atehortua\Desktop\HUB-UR\Nuevo_entorno_local\tomcat\tomcat9"
set "CATALINA_BASE=%CATALINA_HOME%"
set "VIVO_HOME=C:/Users/cristian.atehortua/Desktop/HUB-UR/Nuevo_entorno_local/tomcat/tomcat9/vivo-home/HUBvivo115"
set "XAMPP_HOME=C:\xampp"
set "SOLR_DIR=C:\Users\cristian.atehortua\Desktop\HUB-UR\Nuevo_entorno_local\solr"
set "PATH=%JAVA_HOME%\bin;%XAMPP_HOME%\mysql\bin;%PATH%"
set "CATALINA_OPTS=-Xmx512m -XX:MaxMetaspaceSize=128m -Dvivo.home=%VIVO_HOME%"

:: ---- 1. JAVA ----
echo %C_YEL%[1/5]%C_RST% Verificando Java...
"%JAVA_HOME%\bin\java.exe" -version >nul 2>&1
if errorlevel 1 (
    echo    %C_RED%[ERROR]%C_RST% No se encontro Java en: %JAVA_HOME%
    pause
    exit /b 1
)
echo    %C_GRN%[OK]%C_RST% Java detectado (%JAVA_HOME%)
echo.

:: ---- 2. TOMCAT (Stop anterior) ----
echo %C_YEL%[2/5]%C_RST% Verificando Tomcat (Puerto 8080)...
netstat -ano 2>nul | findstr ":8080 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 (
    echo    %C_YEL%[..]%C_RST% Tomcat ocupando puerto 8080. Deteniendo procesos fantasmas...
    call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1
    ping 127.0.0.1 -n 6 >nul
    for /f "tokens=5" %%a in ('netstat -ano 2^>nul ^| findstr ":8080 " ^| findstr "LISTENING"') do (
        taskkill /PID %%a /F >nul 2>&1
    )
    echo    %C_GRN%[OK]%C_RST% Tomcat anterior detenido.
) else (
    echo    %C_GRN%[OK]%C_RST% Puerto 8080 libre.
)
echo.

:: ---- 3. MYSQL ----
echo %C_YEL%[3/5]%C_RST% Verificando MySQL (Puerto 3306)...
netstat -ano 2>nul | findstr ":3306 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 (
    echo    %C_GRN%[OK]%C_RST% MySQL ya esta corriendo en localhost:3306.
    goto :mysql_is_running
)
echo    %C_YEL%[..]%C_RST% Iniciando MySQL (XAMPP)...
start /B "" "%XAMPP_HOME%\mysql_start.bat"
set "RETRIES=0"
:mysql_wait
if !RETRIES! GEQ 15 goto :mysql_done
ping 127.0.0.1 -n 2 >nul
netstat -ano 2>nul | findstr ":3306 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 goto :mysql_done
set /a RETRIES+=1
goto :mysql_wait
:mysql_done
netstat -ano 2>nul | findstr ":3306 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 (
    echo    %C_GRN%[OK]%C_RST% MySQL iniciado correctamente.
) else (
    echo    %C_RED%[AVISO]%C_RST% MySQL no respondio a tiempo.
)
:mysql_is_running
echo.

:: ---- 4. SOLR ----
echo %C_YEL%[4/5]%C_RST% Verificando Apache Solr (Puerto 8983)...
netstat -ano 2>nul | findstr ":8983 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 (
    echo    %C_GRN%[OK]%C_RST% Solr ya esta corriendo en http://localhost:8983/solr
    goto :solr_is_running
)
if not exist "%SOLR_DIR%\bin\solr.cmd" (
    echo    %C_RED%[ERROR]%C_RST% Solr no encontrado en %SOLR_DIR%.
    pause
    exit /b 1
)
echo    %C_YEL%[..]%C_RST% Iniciando Solr (puede tardar 1 minuto)...
call "%SOLR_DIR%\bin\solr.cmd" start -p 8983
set "RETRIES=0"
:solr_wait
if !RETRIES! GEQ 60 goto :solr_done
ping 127.0.0.1 -n 2 >nul
netstat -ano 2>nul | findstr ":8983 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 goto :solr_done
set /a RETRIES+=1
goto :solr_wait
:solr_done
netstat -ano 2>nul | findstr ":8983 " | findstr "LISTENING" >nul 2>&1
if not errorlevel 1 (
    echo    %C_GRN%[OK]%C_RST% Solr iniciado.
) else (
    echo    %C_RED%[ERROR]%C_RST% Solr fallo. Intenta iniciar Tomcat desde .bat alternativo.
    pause
    exit /b 1
)
:solr_is_running

:: Validar Core de Solr
echo    %C_YEL%[..]%C_RST% Comprobando core 'vivocore'...
set "CORE_RETRIES=0"
:core_wait
if !CORE_RETRIES! GEQ 30 goto :core_done
curl -s "http://localhost:8983/solr/admin/cores?action=STATUS&core=vivocore&wt=json" 2>nul | findstr /i "\"uptime\"" >nul 2>&1
if not errorlevel 1 (
    echo    %C_GRN%[OK]%C_RST% Core 'vivocore' ACTIVO.
    goto :core_done
)
ping 127.0.0.1 -n 2 >nul
set /a CORE_RETRIES+=1
goto :core_wait
:core_done
echo.

:: ---- 5. TOMCAT Y DESPLIEGUE ----
echo %C_YEL%[5/5]%C_RST% Desplegando Apache Tomcat / VIVO...
if exist "%CATALINA_HOME%\work\Catalina" (
    rmdir /s /q "%CATALINA_HOME%\work\Catalina" >nul 2>&1
    echo    %C_GRN%[OK]%C_RST% Cache de Tomcat limpiado.
)
call "%CATALINA_HOME%\bin\startup.bat"
echo    %C_GRN%[OK]%C_RST% Tomcat lanzado en background.
echo.

:: ---- ESPERA INTELIGENTE (SMART WAIT) ----
echo %C_CYA%=================================================================%C_RST%
echo %C_YEL%    Esperando a que la aplicacion VIVO este lista...%C_RST%
echo %C_YEL%    Esto toma aproximadamente 60-90 segundos.%C_RST%
echo %C_CYA%=================================================================%C_RST%
echo.

set "VIVO_RETRIES=0"
:vivo_wait
if !VIVO_RETRIES! GEQ 120 (
    echo %C_RED%[ERROR]%C_RST% VIVO ha tardado demasiado en responder. Revisa los logs.
    echo.
    echo Presiona cualquier tecla para abrir los logs de Tomcat (catalina.out)
    pause >nul
    start notepad "%CATALINA_HOME%\logs\catalina.out"
    exit /b 1
)

:: Hacemos un test silencioso con PowerShell para recibir el codigo 200
powershell -Command "try { $r=Invoke-WebRequest -Uri 'http://localhost:8080/' -UseBasicParsing -TimeoutSec 3; if ($r.StatusCode -eq 200) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if not errorlevel 1 (
    echo.
    echo %C_GRN%=================================================================%C_RST%
    echo %C_GRN%    [SUCCESS] VIVO ESTA OPERATIVO EN EL PUERTO 8080!%C_RST%
    echo %C_GRN%=================================================================%C_RST%
    echo.
    echo %C_CYA%Abriendo el navegador automaticamente...%C_RST%
    ping 127.0.0.1 -n 3 >nul
    start http://localhost:8080/
    goto :end_success
)

:: Mostrar indicador de carga visual
<nul set /p "=%C_YEL%.%C_RST%"
ping 127.0.0.1 -n 4 >nul
set /a VIVO_RETRIES+=1
goto :vivo_wait

:end_success
echo.
echo Entorno iniciado correctamente. Puedes minimizar o cerrar esta ventana.
exit /b 0
