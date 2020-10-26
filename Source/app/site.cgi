#!/usr/bin/perl

use strict;
use CGI::Carp qw(fatalsToBrowser);
require 5.005_03;
use lib './extlib', './lib';
use CGI qw(:standard);

eval {
    require REPS::Site;
	$CGI::POST_MAX = 1024 * 1024; #max 1M upload file
	my $q = CGI->new();
	my $app = REPS::Site->new(QUERY =>$q);
	$app->run();
};
if ($@) {
    print "Content-Type: text/html;charset=euc-jp\n\n";
    print "$@";
}


