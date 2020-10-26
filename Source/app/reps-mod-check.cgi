#!/usr/bin/perl

use lib './extlib';
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);

require UNIVERSAL::require;

eval {
    require 5.005_03;
};
if ($@) {
    print "Content-Type: text/plain;\n\n";
    print "Error: $@";
    exit(0);
}

my $string='';
my $i=0;
my $c=0;


print "Content-Type: text/html;charset=euc-jp\n\n";

print <<"_HTML_";
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ja" xml:lang="ja-JP">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-jp" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<title>Module Check</title>
<style type="text/css">
body {
    font-family:Verdana, sans-serif;
    font-size:small;
}

form, input {
    font-family:Verdana, sans-serif;
}

.information {
    background-color: lightgreen;
    font-weight: bold;
    padding:3px;
    border:2px solid green;
    margin-top: 5px;
    margin-bottom: 5px; 
}

.warning {
    background-color: pink;
    font-weight: bold;
    padding:3px;
    border:2px solid red;
    margin-top: 5px;
    margin-bottom: 5px; 
}

.attention {
    background-color: lightyellow;
    font-weight: bold;
    padding:3px;
    border:2px solid yellow;
    margin-top: 5px;
    margin-bottom: 5px; 
}

pre {
    font-family:'Courier New', monospace;
}
</style>
</head>
<body>


_HTML_
print '<h1>REPS - Perl Module Check</h1>';

print '<h2>�����ƥ�Ķ�</h2>';
print '    <ul>';
print '        <li>';
print 'Perl�ΥС������&nbsp;<strong>';
if ($] >= 5.006) {
    printf "%vd\n", $^V;
    print "($])";
}else{
    print "$]";
}
print '</strong>';
if ($] < 5.006){
    print '<div class="attention">Perl 5.00503���Ϥ��ʤ�Ť��С������ʤΤǰ����ε�ǽ�����¤���ޤ����侩�С������ϡ�Perl 5.6.1�ʾ�Ǥ�����ưŪ�˵�ǽ�����դˤ���뵡ǽ��RSS��Atom�ե����ɤ������Ǥ��ʤ��ε�ǽ��REPS��ư���ˤ����ä��ä�ɬ�ܤǤϤ���ޤ���ˡ�</div>';
}
if ($] == 5.006){
    print '<div class="warning">Perl 5.6.0���Զ�礬¿���١��������ѤϿ侩����Ƥ��ޤ��󡣿侩�С������ϡ��Զ���������Perl 5.6.1�ʾ�Ǥ���REPS��Perl 5.6.0��Ǥϼ��礨��ư��뤫�⤷��ޤ��󤬡�ư����ݾڤ����ͤޤ��ġ�</div>';
}
print '        </li>';
if(exists $ENV{MOD_PERL}){
print '        <li>';
print "mod_perl�Ķ��Ǥ�������ե�����ˤơ��ѥ��ϥե�ѥ������ꤷ��Perl�⥸�塼��(extlib,lib��Υե�����)��Ŭ�ڤʾ��˰�ư����ɬ�פ�����ޤ���";
print '        </li>';
}
print '    </ul>';

print '<h2>Perl�⥸�塼��γ�ǧ</h2>';


my $module = 'Storable';
if (! $module->require) {
    my $module = 'Data::Dumper';
    if ( $module->require) {
        print '<div class="attention">Storable�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />';
        print '����ե������<u>db_serializer</u>���ͤ򡢥��ꥢ�饤�������Ȥ��ơ�<u><strong>Data::Dumper</strong></u>����ꤷ�Ƥ���������</div>';
    }else{
        print '<div class="warning">Storable�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />';
        print '����˻Ȥ���Data::Dumper�⥸�塼��⥤�󥹥ȡ��뤵��Ƥ��ޤ���</div>';
        $c++;
    }
    $i++;
}else{
    print 'Storable: OK<br />';
}

my $module = 'Date::Calc';
if (! $module->require) {
    print '<div class="information">Date::Calc�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />�����Date::Pcalc��Ȥ��ޤ���ư��ˤ���������¤⤢��ޤ���</div>';
    $i++;
}else{
    print 'Date::Calc: OK<br />';
}

my $module = 'Digest::SHA1';
if (!$module->require) {

    #my $module = 'Digest::SHA';
    #if (! $module->require) {
        if ($] >= 5.006) {
            my $module = 'Digest::SHA::PurePerl';
            if (! $module->require) {
            ##if (&eval_require($module)){
                print '<div class="warning">Digest::SHA1,Digest::SHA::PurePerl�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
                $c++;
            }else{
                print '<div class="information">Digest::SHA1�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />�����Digest::SHA::PurePerl��Ȥ��ޤ���ư��ˤ���������¤⤢��ޤ���</div>';
                $i++;
            }
        }else{
            my $module = 'Digest::MD5';
            if (! $module->require) {
                print '<div class="warning">Digest::SHA1,Digest::MD5�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
                $c++;
            }else{
                print '<div class="information">Digest::SHA1�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />�����Digest::MD5��Ȥ��ޤ���ư��ˤ���������¤⤢��ޤ���</div>';
                $i++;
            }
        }

    #}else{
    #    if ($] >= 5.006) {
    #        print 'Digest::SHA: OK<br />';
    #    }
    #}
    
}else{
    print 'Digest::SHA1: OK<br />';
}

# my $module = 'Digest::MD5';
# if (! $module->require) {
#     print '<div class="warning">Digest::MD5�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
#     $c++;
# }else{
#     print 'Digest::MD5: OK<br />';
# }

my $module = 'Image::Magick';
if (! $module->require) {
    print '<div class="attention">Image::Magick�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />�����ν̾�������ޤ��󡣥���ͥ���������ʸ����ǥ�󥯤�ɽ������ޤ���NetPBM�����ѽ����Ķ��Ǥ����顢����ե������<u>NetPBMPath</u>���ͤ˥ѥ�����ꤹ����ǡ����������դ������Ѥ����������ޤ���</div>';
    $i++;
}else{
    print 'Image::Magick: OK<br />';
}

my $module = 'MIME::Base64';
if (! $module->require) {
    print '<div class="attention">MIME::Base64�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���<br />RSS��Atom�ե����ɤ�������ɬ�פǤ�������ե�����ǡ�<u>syndicate</u>���ͤ�<u>Off</u>�ˤ��Ƥ���������</div>';
    $i++;
}else{
    print 'MIME::Base64: OK<br />';
}

my $module = 'File::Path';
if (! $module->require) {
    print '<div class="warning">File::Path�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
    $c++;
}else{
    print 'File::Path: OK<br />';
}

my $module = 'FindBin';
if (! $module->require) {
    print '<div class="warning">FindBin�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
    $c++;
}else{
    print 'FindBin: OK<br />';
}

my $module = 'DB_File';
if (! $module->require) {
    print '<div class="warning">DB_File�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
    $c++;
}else{
    print 'DB_File: OK<br />';
}

my $module = 'File::Basename';
if (! $module->require) {
    print '<div class="warning">File::Basename�⥸�塼�뤬���󥹥ȡ��뤵��Ƥ��ޤ���</div>';
    $c++;
}else{
    print 'File::Basename: OK<br />';
}


if ($c > 0) {
    $string = "<br /><strong>ư���ɬ�פʥ⥸�塼�뤬$c�ĥ��󥹥ȡ��뤵��Ƥ��ޤ���­��ʤ����̥⥸�塼���$i��, ­��ʤ�ɬ�ܥ⥸�塼���$c�ĤǤ�����</strong>";
}else{
    if ($i > 0){
        $string = "<br /><strong>$i�ĤΥ⥸�塼�뤬­��ޤ���Ǥ������̤Υ⥸�塼������Ѥ��ޤ������⥸�塼��ˤ�äƤϰ���ư������¤������礬����ޤ�������¾ư���ɬ�ܤʥ⥸�塼��ϥ��󥹥ȡ��뤵��Ƥ��뤳�Ȥ���ǧ����ޤ�����</strong>";
    }else{
        $string = '<br /><strong>ɬ�פʥ⥸�塼������ƥ��󥹥ȡ��뤵��Ƥ���褦�Ǥ���</strong>';
    }
}


print <<"_HTML_";
<div>
$string 
</div>
</body>
</html>
_HTML_

sub eval_require {
    my $mod = shift;
    $mod =~ s!::!/!g;

    eval { require "$mod.pm"};
}
