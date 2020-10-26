#!/usr/bin/perl

use strict;
use CGI::Carp qw(fatalsToBrowser);#Perl5.6.0 behaves weird on require, so changed CGI::Carp.
require 5.005_03;
use lib './extlib', './lib';
use CGI qw(:standard);

eval {
    require REPS::CMS;
    $CGI::POST_MAX = 1024 * 1024 * 3; #max 3M upload file
    my $q = CGI->new();
    my $app = REPS::CMS->new(QUERY =>$q);
    $app->run();
};
if ($@) {
    print "Content-Type: text/html;charset=euc-jp\n\n";
    print "$@";
}

exit(0);
