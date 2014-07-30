@rem = ' Perl Script
@echo off
set mycd=homedir_%cd:\=\\%
perl -wS %0 %1 %2 %mycd%
set R="C:\Program Files\R\R-3.1.0patched\bin\x64\R.exe" 
goto :EOF
';

#!/usr/bin/perl
use strict;
use warnings;
use JSON qw(encode_json from_json);
use FileHandle;
use DateTime;
use Cwd;
use Statistics::Descriptive;
use Data::Dumper;
use Cwd 'abs_path';

my $dir = getcwd();
#my $abs_path = abs_path($file);
my $output_folder = $dir.'\\output\\';

#my $d = shift;
print "current directory is [$dir]\n";
opendir(D, "$dir") || die "Can't open directory $dir: $!\n";
my @list = readdir(D);
closedir(D);

print "config_dir  [$dir]\n";
my @files = <$dir/*.txt>;

my %data;
my %files_sites;

my $fileNum = $#files +1;
print "files [$fileNum]\n";
#print "Press <Enter> or <Return> to continue: ";
#my $resp = <STDIN>;
my %temp;
foreach my $f ( 0 .. $#files) {
    my $file_count = $f +1;
    print "Importing [$file_count/$fileNum] : $files[$f] \n";
    
    #my $file = 'SnPmaster.txt';
    open my $filedata, $files[$f] or die "Could not open $files[$f]: $!";
    
    while( my $line = <$filedata>)  {   
        my ($site,$date,$time,$value) = split( /\s+/,$line);
        #print "Site: $site   Date: $date   Time: $time   Value: $value      \r";
        $files_sites{$files[$f]}{$site}++;
        my ($day,$month,$year) = split(/\//,$date);
        my $yyyymmdd = $year.$month.$day;
        
        if ( ! defined ( $temp{$site}{$yyyymmdd} )  ){
          #$temp{$site}{data}{$yyyymmdd}[0] = $value;
        
          $temp{$site}{files}{$files[$f]}++;
        }
        
        push @{$temp{$site}{data}{$yyyymmdd}}, $value;
        
        #$temp{$site}{$yyyymmdd}[$f]{value} = $value // 0;
        #$temp{$site}{'files'}{$files[$f]}++;
        #print "site [$site] date [$date] contents [$line]\r";    
        
    }
    
    close ($filedata);
}

my $tsLog = $dir.'\\sitelog.csv';
print "\nFile-Site check @ [$tsLog]\n";

open (LOG, ">$tsLog");

foreach my $f ( 0 .. $#files) {
  foreach my $site ( keys %temp ){
  print "  checking file [$files[$f]     ]  site [$site]      \r";
    if (!defined $temp{$site}{files}{$files[$f]} ) {
          print "    problem with [$files[$f]]\n";
          print LOG "$files[$f]\n";
    }
  }
}

close (LOG);  

=skip
foreach my $site ( keys %data ){
  print LOG ",$site";
}  
print LOG "\n";

foreach my $file ( keys %files_sites ){
  print LOG "$file";
  foreach my $site ( keys %data ){
    if (!defined $files_sites{$file}{$site}){
      print LOG ",NO";
    }
    else{
      print LOG ",YES";
    }
  }
  print LOG "\n";
}

print LOG "\n\n";
=cut




my %fls;
foreach my $site ( keys %temp ){
  my $site_data_file = $output_folder.$site.'.csv';
  open (DATA, ">$site_data_file") or die $1;
  print "Creating CSV & dumperlog output for [$site]    \r";
  
  open OUTFILE, "> C:\\dev\\R\\dumperlog\\$site.dumper.txt" or die $1;  
  print OUTFILE Dumper \%{$temp{$site}{files}};


  foreach my $date ( sort keys %{$temp{$site}{data}} ) {
    print DATA "$site,$date";

    my @values = @{$temp{$site}{data}{$date}};
    
    print OUTFILE Dumper \@values;
    
    #$temp{$site}{data}{$yyyymmdd}
    #my $keys = keys %{$temp{$site}{$date}};
    my $cols = $#values + 1;
    #print "cols [$cols]               \r";
    foreach my $col_no ( 0 .. $#values ){
      my $col_num = $col_no + 1;
      #print " col [$col_num/$cols] \r";
      print DATA ",$values[$col_no]";
      #$fls{$values[$col_no]{'files'}}++;
    }
    print DATA "\n";
   
  }

  close (OUTFILE);
  close (DATA);
  delete $temp{$site};
    
  
}

my @datafiles = glob ($output_folder);
foreach (@datafiles){
  system(R )
}

1;