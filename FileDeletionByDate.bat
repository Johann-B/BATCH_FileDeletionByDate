@echo off
color 1F
TITLE Batch Suppression de fichier

:: Version du 14/09/2015

echo        ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo        º               BATCH DE SUPPRESSION             º
echo        º               DE FICHIERS PAR DATE             º
echo        º                PAR JOHANN BARON                º
echo        ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼


	:: Choix du r‚pertoire et de la date pour ‚puration

echo.
echo Cet outil va vous permettre de supprimer uniquement les fichiers obsolŠtes d'un r‚pertoire
echo jusqu'… une date donn‚e.
echo.

:deb
set /p choixmois= Entrez le mois d‚sir‚ (sous la forme MM) : 
echo.
set /p choixannee= Entrez l'ann‚e d‚sir‚e (sous la forme AAAA) : 
echo.
set /p RepCible= Entrez le chemin complet du r‚pertoire … analyser : 
echo.
set /p LogCible= Choisissez l'emplacement d'enregistrement du fichier log (ne pas oublier le "\" final) : 
echo.
echo Vous recherchez des fichiers sur "%RepCible%" jusqu'au %choixmois%/%choixannee%.
echo Le fichier log sera sauvegard‚ sur %LogCible% .
echo.
goto quest1

:quest1
set /p answer1= Validez-vous votre choix ? (o/n) 
if /i %answer1%==o (goto oui1)
if /i %answer1%==n (goto dowhat1) else (echo Choix invalide. Merci de r‚pondre par "o" ou "n".)& (goto quest1)

:dowhat1
set /p what1= Que voulez-vous faire ? Saisissez "q" pour quitter ou  "r" pour modifier votre recherche : 
if /i %what1%==r (goto deb)
if /i %what1%==q (goto :fin) else (echo Choix invalide. Merci de r‚pondre par "o" ou "n".)& (goto dowhat1)

:: Listing pour analyse ou fin du programme

:oui1
:: G‚n‚ration du rapport

set nbrfic=0
echo.
echo Analyse des fichiers pr‚sents sur %RepCible% en cours.
echo Merci de patienter...
echo.
:: Mise en forme du rapport
(
echo.
echo                        BATCH SUPPRESSION DE FICHIERS
echo.
echo *******************************************************************************
echo                   Rapport de suppression des fichiers jusqu'au
echo                     %choixmois%/%choixannee% sur %RepCible%
echo.
echo                          Créé le %date% par %username%
echo *******************************************************************************
echo.
echo.
echo ========= Eléments présents =========
echo.
echo.
) >> %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt

for /r "%RepCible%\" %%i in (*.*) do set NamFic=%%~dpnxi& set DatFic=%%~ti&set sizefic=%%~zi& call :log

goto rapport

:log
if %DatFic:~3,2% leq %choixmois% if %DatFic:~6,4% equ %choixannee% echo %DatFic% %NamFic% >> %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt
if %DatFic:~3,2% leq %choixmois% if %DatFic:~6,4% equ %choixannee% call :cumul
if %DatFic:~6,4% lss %choixannee% echo %DatFic% %NamFic% >> %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt
if %DatFic:~6,4% lss %choixannee% call :cumul

goto :eof

:: Compteurs
:cumul
set /a nbrfic+=1
set /a tailfic=%tailfic%+%sizefic%

goto :eof

:: Visualisation du rapport

:rapport
::set /a somnbr=%nbrfic1%+%nbrfic2%
echo.
echo Analyse termin‚e.
echo %nbrfic% fichier(s) a/ont ‚t‚ trouv‚(s) pour une taille totale de %tailfic% octets.
echo.
echo Un rapport a ‚t‚ cr‚‚ et enregistr‚ dans le r‚pertoire %LogCible% .
echo V‚rifiez les fichiers trouv‚s avant la suppression.
echo.
echo Appuyez sur une touche pour visualiser le rapport.
echo.
pause>nul
notepad.exe %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt
echo.
goto quest2

:quest2
set /p answer2= Voulez-vous supprimer les fichiers trouv‚s ? (o/n)
if /i %answer2%==o (goto suppr)
if /i %answer2%==n (goto dowhat1) else (echo Choix invalide. Merci de r‚pondre par "o" ou "n".)& (goto quest2)

:: Processus de suppression

:suppr
echo.
echo Suppression en cours. Merci de patienter...
echo.
(
echo.
echo.
echo.
echo.
echo ========= Eléments supprimés =========
echo.
echo.
) >> %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt
for /r "%RepCible%\" %%i in (*.*) do set NamFic=%%~dpnxi& set DatFic=%%~ti& call :process
goto rapport2

:process
if %DatFic:~6,4% leq %choixannee% if %DatFic:~3,2% leq %choixmois% del /s "%NamFic%" /q /f >> %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt

goto :eof

:: Visualisation du rapport2

:rapport2
echo.
echo Suppression termin‚e. Appuyez sur une touche pour visualiser le rapport.
echo.
pause>nul
notepad.exe %LogCible%log_%date:~6,4%%date:~3,2%%date:~0,2%.txt
echo.

:fin

:: Fin du programme

:fin
echo.
echo Fin du processus, appuyez sur une touche pour quitter cet outil.
pause>nul
exit