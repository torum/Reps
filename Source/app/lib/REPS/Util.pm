package REPS::Util;

use strict;
use base qw( Class::ErrorHandler );
use Unicode::Japanese;
use UNIVERSAL::require;
use vars qw( $UJ );

BEGIN {
    #TODO:tobe deleted
    $UJ = Unicode::Japanese->new();

    require 'jcode.pl';
}

#TODO:tobe deleted
sub convert_charset {
    my $self = shift;
    local($_) = shift;
    my $charset = uc(shift);

    #does this work?
    #require REPS;
    #my $charset = uc(REPS->cfg('charset'));

    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {
        my $encode = $charmap->{$charset};
        return $UJ->set($_,$encode)->euc;

    }else{
        Carp::croak "Unknown charset encoding.";
    }
}

#TODO:tobe deleted
sub convert_hash_charset {
    my $self = shift;
    local($_) = shift;
    my $charset = uc(shift);

    #does this work?
    #require REPS;
    #my $charset = uc(REPS->cfg('charset'));

    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {
        my $encode = $charmap->{$charset};
        my $key;
        my $value;
        my %tmp;
        %tmp = %$_;
        while ( ($key, $value) = each(%tmp) ) {
            if ($value){
                $UJ->set($value,$encode);
                $$_{$key} =  $UJ->euc;
            }
        }
    }else{
        Carp::croak "Unknown charset encoding.";
    }
}

sub get_date_delta_from_httpDate {
    my $self = shift;
    #my @a = split(/\//, $_[0]);
    #my ($year1, $month1, $mday1) = @a;
    my ($year1, $month1, $mday1, $hour1, $min1, $sec1, $tz1) = HTTP::Date::parse_date($_[0]);
    #my ($year2, $month2, $mday2, $hour2, $min2, $sec2, $tz2) = HTTP::Date::parse_date( $self->get_datetime_now() );
    my $time = time;
    $time += 32400; #+9hour
    my($sec2, $min2, $hour2, $mday2, $month2, $year2, $wday2) = (gmtime($time))[0..6];

    $month2++;
    $year2+=1900;

    #Delta_Days
    my $dd;
    my $module;
    $module = 'Date::Calc';
    if ($module->require) {
        eval {
            $dd = Date::Calc::Delta_Days(sprintf('%04d',$year1),sprintf('%02d',$month1),sprintf('%02d',$mday1),sprintf('%04d',$year2),sprintf('%02d',$month2),sprintf('%02d',$mday2));
        };
        if ($@) {
            $dd = 0;
        }
    }else{
        $module = 'Date::Pcalc';
        if ($module->require) {
            eval {
                $dd = Date::Pcalc::Delta_Days(sprintf('%04d',$year1),sprintf('%02d',$month1),sprintf('%02d',$mday1),sprintf('%04d',$year2),sprintf('%02d',$month2),sprintf('%02d',$mday2));
            };
            if ($@) {
                $dd = 0;
            }
        }else{
            die "Error loading Date::Pcalc module.";
        }
    }

    return $dd;
}

#use Date::Simple;
sub get_date_delta {
    my $self = shift;
    my @a = split(/\//, $_[0]);
    my ($year1, $month1, $mday1) = @a;

    my ($year2, $month2, $mday2, $hour2, $min2, $sec2, $tz2) = HTTP::Date::parse_date( $self->get_datetime_now() );
    
    #Delta_Days
    my $dd;
    my $module;
    $module = 'Date::Calc';
    if ($module->require) {
            $dd = Date::Calc::Delta_Days(sprintf('%04d',$year1),sprintf('%02d',$month1),sprintf('%02d',$mday1),sprintf('%04d',$year2),sprintf('%02d',$month2),sprintf('%02d',$mday2));
    }else{
        $module = 'Date::Pcalc';
        if ($module->require) { 
            $dd = Date::Pcalc::Delta_Days(sprintf('%04d',$year1),sprintf('%02d',$month1),sprintf('%02d',$mday1),sprintf('%04d',$year2),sprintf('%02d',$month2),sprintf('%02d',$mday2));
        }else{
            die "Error loading Date::Pcalc module";
        }
    }

    return $dd;
}

# 
sub get_datetime_as_string{
    my $self = shift;
    my $datetime = shift;
    if ($datetime){
        my ($year1, $month1, $mday1, $hour1, $min1, $sec1, $tz) = HTTP::Date::parse_date( $datetime );
        $datetime = sprintf('%04d/%02d/%02d %02d:%02d:%02d', $year1, $month1, $mday1, $hour1, $min1, $sec1);
    }
    return $datetime;
}

sub get_date_as_string{
    my $self = shift;
    my $datetime = shift;
    if ($datetime){
        my ($year1, $month1, $mday1, $hour1, $min1, $sec1, $tz) = HTTP::Date::parse_date( $datetime );
        $datetime = sprintf('%04d/%02d/%02d', $year1, $month1, $mday1);
    }
    if (!$datetime){$datetime = '';}
    return $datetime;

}

sub get_datetime_now{
    my $self = shift;
    my $time = time;
    $time += 32400; #+9hour
    my($sec, $min, $hour, $mday, $mon, $year, $wday) = (gmtime($time))[0..6];

    $mon++;
    $year+=1900;
    my $datetime = sprintf('%04d-%02d-%02dT%02d:%02d:%02d', $year, $mon, $mday, $hour, $min, $sec);
    return $datetime;
}

#takes a string and converts zhk charactors
sub convert_zhk{
    my $self = shift;
    local($_) = shift;
    jcode::tr(\$_, '£°-£¹£Á-£Ú£á-£ú', '0-9A-Za-z'); #Á´³Ñ±Ñ¿ô»ú¤òÈ¾³Ñ±Ñ¿ô»ú¤Ë
    jcode::h2z_euc(\$_); #È¾³Ñ¥«¥¿¥«¥Ê¤òÁ´³Ñ¥«¥¿¥«¥Ê¤Ë
    return $_;
}

#takes a hash and converts zhk charactors
sub convert_hash_zhk {
    my $self = shift;
    local($_) = shift;
    my $key,
    my $value;
    my %tmp;
    %tmp = %$_;
    while ( ($key, $value) = each(%tmp) ) {
        if ($value){
            jcode::tr(\$value, '£°-£¹£Á-£Ú£á-£ú', '0-9A-Za-z'); #Á´³Ñ±Ñ¿ô»ú¤òÈ¾³Ñ±Ñ¿ô»ú¤Ë
            jcode::h2z_euc(\$value); #È¾³Ñ¥«¥¿¥«¥Ê¤òÁ´³Ñ¥«¥¿¥«¥Ê¤Ë
            $$_{$key} = $value;
        }
    }
}

#takes a hash and escape its values
sub escape_hash_value {
    my $self = shift;
    my $key,
    my $value;
    while ( ($key, $value) = each(%$_) ) {
        if ($value){
            $value =~ s/\&/\&amp;/g;
            $value =~ s/</\&lt;/g;
            $value =~ s/>/\&gt;/g;
            $value =~ s/"/\&quot;/g;
            $value =~ s/'/\&#39;/g;
    
            $$_{$key} = $value;
        }
    }
}

#takes a target string and a pattern and return true if match. 
sub str_match {
    my $self = shift;
    my $str = $_[0];
    my $pattern = $_[1];
    $str =~ s/¡¡//g;
    $pattern =~ s/¡¡//g;
    $str =~ s/ //g;
    $pattern =~ s/ //g;

    $pattern = $self->stripMetachars($pattern);

    #http://www.din.or.jp/~ohzaki/perl.htm#JP_Match
    my $ascii = '[\x00-\x7F]';
    my $twoBytes = '[\x8E\xA1-\xFE][\xA1-\xFE]';
    my $threeBytes = '\x8F[\xA1-\xFE][\xA1-\xFE]';

    if ($str =~ m/^(?:$ascii|$twoBytes|$threeBytes)*?(?:$pattern)/ig) {
        return 1;
    }else{
        return 0;
    }
}

#insert comma into numbers. eg 10000 -> 10,000
sub insert_comma{
    my $self = shift;
    local($_) = shift;
    $_ =~ s/(\d{1,3})(?=(?:\d\d\d)+(?!\d))/$1,/g;
    $_;
}

#de_taint. be carefull what you do here.
sub de_taint{
    my $self = shift;
    my $tainted = shift;     
    $tainted =~ m|([\w\-\_\/\.]*)|;

    return $1;
}

sub trim {
    my $self = shift;
    my $s = shift;
    #$value =~ s/\&/\&amp;/g;
    $s =~ s/^\s*(.*?)\s*$/$1/;
    return $s;
}

sub convert2htmlchars {
    my $self = shift;
    local($_) = shift;

    s/\&/\&amp;/g;
    s/</\&lt;/g;
    s/>/\&gt;/g;
    s/"/\&quot;/g;
    s/'/\&#39;/g;

    s/\(/\&#40;/g;
    s/\)/\&#41;/g;

    $_;
}

sub stripHtmlChars {
    my $self = shift;
    local($_) = shift;

    s/\&//g;
    s/<//g;
    s/>//g;
    s/"//g;
    s/'//g;

    $_;
}

sub stripMetachars {
    my $self = shift;
    local($_) = shift;
    #¥á¥¿Ê¸»ú¤Î¥¨¥¹¥±¡¼¥×
    s/\*//g;
    s/\]//g;
    s/\[//g;
    s/\\//g;
    s/\^//g;
    #s/\.//g;
    s/\$//g;
    s/\*//g;
    s/\?//g;
    s/\|//g;
    s/\(//g;
    s/\)//g;
    s/\{//g;
    s/\}//g;

    $_;
}

sub stripCrLf {
    my $self = shift;
    local($_) = shift;
    s/\r//;
    s/\n//;

    $_;
}

sub stripEmoji {
    my $self = shift;
    local($_) = shift;
    #TODO: this removes numbers and other charactors and breaks paging. needs to be fixed.
    #my $sjis  = '[\x81-\x9F\xE0-\xF7\xFA-\xFC][\x40-\x7E\x80-\xFC]|[\x00-\x7F]|[\xA1-\xDF]|[0-9A-Za-z_]';
    #my $emoji = '[\xF8\xF9][\x40-\x7E\x80-\xFC]';

    #$_ =~ s/\G((?:$sjis)*)(?:$emoji)/$1/go;
    return $_;
}


1
