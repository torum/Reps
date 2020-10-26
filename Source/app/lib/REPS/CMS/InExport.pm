package REPS::CMS::InExport;

use strict;
use CGI::Carp qw(fatalsToBrowser);

#use HTTP::Date;
#use Date::Calc qw(Delta_Days check_date);
use File::Basename;

#use MLDBM qw(DB_File::Lock Storable);   
use Fcntl;
use File::Path;
use DB_File;

#for debug
use Data::Dumper;


sub new{
	my ($class,$app) = @_;
	my $self = {
		_app => $app,
		_ref_hash => {}
		};

	return bless $self,$class;
}


# added by n-style;
# ,と"を，と""に変換し、CSV用にダブルクオートで括って返却する
# 2006.2.21 _convert_for_csv 1.0
sub _convert_for_csv(){
	my $self = shift;
	my $cStr = shift;
	my $convTxt = shift;
	
	#$cStr =~ s/\,/，/g;
	$cStr =~ s/\"/""/g;
	$cStr =~ s!\r?\n!$convTxt!g;
	
	return "\"" . $cStr . "\"";
}


# added by n-style;
# \tを\nに変換
# 2006.4.1 _convert_tab_to_enter 1.0
sub _convert_tab_to_enter(){
	my $self = shift;
	my $cStr = shift;
	
	$cStr =~ s!\t!\n!g;
	
	return $cStr;
}


sub _get_datetime_as_string{
	my $self = shift;
	my $datetime = shift;
	if ($datetime){
		my ($year1, $month1, $mday1, $hour1, $min1, $sec1, $tz) = HTTP::Date::parse_date( $datetime );
		$datetime = sprintf('%04d/%02d/%02d %02d:%02d:%02d', $year1, $month1, $mday1, $hour1, $min1, $sec1);
	}
	return $datetime;

}
sub _get_date_as_string{
	my $self = shift;
	my $datetime = shift;
	if ($datetime){
		my ($year1, $month1, $mday1, $hour1, $min1, $sec1, $tz) = HTTP::Date::parse_date( $datetime );
		$datetime = sprintf('%04d/%02d/%02d', $year1, $month1, $mday1);
	}
	return $datetime;

}


sub _insert_comma{
	my $self = shift;
	local($_) = shift;
	$_ =~ s/(\d{1,3})(?=(?:\d\d\d)+(?!\d))/$1,/g;
	$_;
}

sub _convert_hash_charset {
	my $self = shift;
	local($_) = shift;
	my $UJ = Unicode::Japanese->new;
	#my $charset = uc($self->{_app}->cfg('charset'));
	#my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
	#if (defined($charset) and defined($charmap->{$charset})) {

		#my $encode = $charmap->{$charset};

		my $key;
		my $value;

		my %tmp;
		%tmp = %$_;
		while ( ($key, $value) = each(%tmp) ) {
			if ($value){
				#$UJ->set($value,$encode);
				$UJ->set($value,'sjis');
				$$_{$key} =  $UJ->euc;
			}
		}
	#}else{
	#	die "I don\'t understand your encoding ";
	#}
}

sub _convert_hash_zhk {
	my $self = shift;
	local($_) = shift;
	my $key,
	my $value;
	my %tmp;
	%tmp = %$_;
	require 'jcode.pl';

	while ( ($key, $value) = each(%tmp) ) {
		if ($value){
			
			jcode::tr(\$value,'０-９Ａ-Ｚａ-ｚ', '0-9A-Za-z'); #全角英数字を半角英数字に
			jcode::h2z_euc(\$value); #半角カタカナを全角カタカナに

			$$_{$key} = $value;
		}
	}
}

sub _convert_charset {
	my $self = shift;
	local($_) = shift;
	return Unicode::Japanese->new($_,'sjis')->euc;
#	my $charset = uc($self->{_app}->cfg('charset'));
#	my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
#	if (defined($charset) and defined($charmap->{$charset})) {

#		my $encode = $charmap->{$charset};
#		return Unicode::Japanese->new($_,$encode)->euc;
#	}else{
#		die "I don\'t understand your encoding ";
#	}
}

sub _get_datetime_now{
	my $self = shift;
	my $time = time;
	$time += 32400; #+9hour
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday) = (gmtime($time))[0..6];

	$mon++;
	$year+=1900;
	my $datetime = sprintf('%04d-%02d-%02dT%02d:%02d:%02d', $year, $mon, $mday, $hour, $min, $sec);
	return $datetime;
}


sub _get_datetime_now_string{
	my $self = shift;
	my $time = time;
	$time += 32400; #+9hour
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday) = (gmtime($time))[0..6];

	$mon++;
	$year+=1900;
	my $datetime = sprintf('%04d/%02d/%02d', $year, $mon, $mday);
	return $datetime;
}



1;
