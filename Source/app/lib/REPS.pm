package REPS;

use strict;
use base qw( Class::ErrorHandler );
use vars qw( $REPS_VERSION $config );

$REPS_VERSION = '1.6.9';

BEGIN {
    require CGI::Carp;
    sub parse {
        my $file = shift;
        Carp::croak "設定ファイルが見付かりません(No config file found!)"           if not defined $file or not -e $file;;
        Carp::croak "Config file $file not readable!" if not -e $file;
        return &equal_sep($file);
    }

    sub equal_sep {
        my $file = shift;
        open IN, $file or die $!;
        my %config;
        while (<IN>) {
            next if /^\s*#/;
            /^\s*(.*?)\s*=\s*(.*)\s*$/ or next;
            my ($k, $v) = ($1, $2);
            my @v;
            if ($v=~ /,/) {
                $config{$k} = [ split /\s*,\s*/, $v ];
            } elsif ($v =~ / /) { # XXX: Foo = "Bar baz"
                $config{$k} = [ split /\s+/, $v ];
            } else {
                $config{$k} = $v;
            }
        }
        while ( my ($key, $value) = each(%config) ) {
            $value =~s/[\n\r]//g;
            chomp ($value);
            $value =~s/\s//g;
            $config{$key} = $value;
        }
        return \%config;
    }

   use FindBin qw( $Bin );
   $config = &parse($Bin.'/reps-config.cgi');

}

require MLDBM;
import MLDBM "DB_File::Lock", $$config{'db_serializer'};


sub version {
    return $REPS_VERSION;
}

sub cfg {
    my $self = shift;
    my $field = shift;
    return $config->{$field} if $field;
    if (ref $config) {
        return wantarray ? %$config : $config;
    }
}



1