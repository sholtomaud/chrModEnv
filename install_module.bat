@rem = ' Perl Script
@echo off

set drive=%~dp0
set drivep=%drive%
if #%drive:~-1%# == #\# set drivep=%drive:~0,-1%

set PATH=%drivep%\perl\site\bin;%drivep%\perl\bin;%drivep%\c\bin;%PATH%
rem env variables
set TERM=
set HOME=%~dp0data
set PLPLOT_LIB=%~dp0c\share\plplot
set PLPLOT_DRV_DIR=%~dp0c\share\plplot
rem avoid collisions with other perl stuff on your system
set PERL_JSON_BACKEND=
set PERL_YAML_BACKEND=
set PERL5LIB=
set PERL5OPT=
set PERL_MM_OPT=
set PERL_MB_OPT=
set CHRLOG=%drivep%\temp\log
set CHRLIB=%drivep%\chr
if not #%1# == ## "%drivep%\perl\bin\perl.exe" %* & goto END
rem -wS %0 %1 %2 %mycd%
set mycd=%drivep%%cd:\=\\%
rem "printf("""Perl executable: %%s\nPerl version   : %%vd / $Config{archname}\nPDL version    : %%s\n""", $^X, $^V, $PDL::VERSION)"
perl -MConfig -MPDL -e -wS %0 %1 %2 %mycd% 
if ERRORLEVEL==1 echo.&echo FATAL ERROR: 'perl' does not work; check if your strawberry pack is complete!
echo.
goto :EOF
rem 2>nul
rem cmd /K


@rem set mycd=homedir_%cd:\=\\%
@rem perl -wS %0 %1 %2 %mycd%
@rem goto :EOF
';
undef @rem; 

use strict;
use warnings;

main: {
        
    print "\nChromicon Utils \n==================\n";
    
    my $repo = lc($ARGV[1]);
    print "repo [$repo], ENV{CHRLIB} [ $ENV{CHRLIB} ]\n";
    #my $sys_command = qq(cpanm $git_repo); #  --local-lib "$ENV{INICHR}");
    my $sys_command = qq(cpanm $repo); 
    print "system output [ $sys_command ]\n";     
  
  <>;
  
}
1;


:END