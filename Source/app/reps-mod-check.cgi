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

print '<h2>システム環境</h2>';
print '    <ul>';
print '        <li>';
print 'Perlのバージョン：&nbsp;<strong>';
if ($] >= 5.006) {
    printf "%vd\n", $^V;
    print "($])";
}else{
    print "$]";
}
print '</strong>';
if ($] < 5.006){
    print '<div class="attention">Perl 5.00503等はかなり古いバージョンなので一部の機能が制限されます。推奨バージョンは、Perl 5.6.1以上です。自動的に機能がオフにされる機能はRSS・Atomフィードの生成です（この機能はREPSが動作するにあたって特に必須ではありません）。</div>';
}
if ($] == 5.006){
    print '<div class="warning">Perl 5.6.0は不具合が多い為、既に利用は推奨されていません。推奨バージョンは、不具合を修正したPerl 5.6.1以上です。REPSもPerl 5.6.0上では取り合えず動作するかもしれませんが、動作は保証しかねます…。</div>';
}
print '        </li>';
if(exists $ENV{MOD_PERL}){
print '        <li>';
print "mod_perl環境です。設定ファイルにて、パスはフルパスで設定し、Perlモジュール(extlib,lib内のファイル)は適切な場所に移動する必要があります。";
print '        </li>';
}
print '    </ul>';

print '<h2>Perlモジュールの確認</h2>';


my $module = 'Storable';
if (! $module->require) {
    my $module = 'Data::Dumper';
    if ( $module->require) {
        print '<div class="attention">Storableモジュールがインストールされていません。<br />';
        print '設定ファイルの<u>db_serializer</u>の値を、シリアライズ形式として、<u><strong>Data::Dumper</strong></u>を指定してください。</div>';
    }else{
        print '<div class="warning">Storableモジュールがインストールされていません。<br />';
        print '代わりに使う、Data::Dumperモジュールもインストールされていません。</div>';
        $c++;
    }
    $i++;
}else{
    print 'Storable: OK<br />';
}

my $module = 'Date::Calc';
if (! $module->require) {
    print '<div class="information">Date::Calcモジュールがインストールされていません。<br />代わりにDate::Pcalcを使います。動作には問題も制限もありません。</div>';
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
                print '<div class="warning">Digest::SHA1,Digest::SHA::PurePerlモジュールがインストールされていません。</div>';
                $c++;
            }else{
                print '<div class="information">Digest::SHA1モジュールがインストールされていません。<br />代わりにDigest::SHA::PurePerlを使います。動作には問題も制限もありません。</div>';
                $i++;
            }
        }else{
            my $module = 'Digest::MD5';
            if (! $module->require) {
                print '<div class="warning">Digest::SHA1,Digest::MD5モジュールがインストールされていません。</div>';
                $c++;
            }else{
                print '<div class="information">Digest::SHA1モジュールがインストールされていません。<br />代わりにDigest::MD5を使います。動作には問題も制限もありません。</div>';
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
#     print '<div class="warning">Digest::MD5モジュールがインストールされていません。</div>';
#     $c++;
# }else{
#     print 'Digest::MD5: OK<br />';
# }

my $module = 'Image::Magick';
if (! $module->require) {
    print '<div class="attention">Image::Magickモジュールがインストールされていません。<br />画像の縮小が出来ません。サムネイルの代わりに文字列でリンクが表示されます。NetPBMが利用出来る環境でしたら、設定ファイルの<u>NetPBMPath</u>の値にパスを指定する事で、一部制限付きで代用する事が出来ます。</div>';
    $i++;
}else{
    print 'Image::Magick: OK<br />';
}

my $module = 'MIME::Base64';
if (! $module->require) {
    print '<div class="attention">MIME::Base64モジュールがインストールされていません。<br />RSS・Atomフィードの生成に必要です。設定ファイルで、<u>syndicate</u>の値を<u>Off</u>にしてください。</div>';
    $i++;
}else{
    print 'MIME::Base64: OK<br />';
}

my $module = 'File::Path';
if (! $module->require) {
    print '<div class="warning">File::Pathモジュールがインストールされていません。</div>';
    $c++;
}else{
    print 'File::Path: OK<br />';
}

my $module = 'FindBin';
if (! $module->require) {
    print '<div class="warning">FindBinモジュールがインストールされていません。</div>';
    $c++;
}else{
    print 'FindBin: OK<br />';
}

my $module = 'DB_File';
if (! $module->require) {
    print '<div class="warning">DB_Fileモジュールがインストールされていません。</div>';
    $c++;
}else{
    print 'DB_File: OK<br />';
}

my $module = 'File::Basename';
if (! $module->require) {
    print '<div class="warning">File::Basenameモジュールがインストールされていません。</div>';
    $c++;
}else{
    print 'File::Basename: OK<br />';
}


if ($c > 0) {
    $string = "<br /><strong>動作に必要なモジュールが$c個インストールされていません。足りない一般モジュールは$i個, 足りない必須モジュールは$c個でした。</strong>";
}else{
    if ($i > 0){
        $string = "<br /><strong>$i個のモジュールが足りませんでした。別のモジュールで代用しますが、モジュールによっては一部動作に制限がある場合があります。その他動作に必須なモジュールはインストールされていることが確認されました。</strong>";
    }else{
        $string = '<br /><strong>必要なモジュールは全てインストールされているようです。</strong>';
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
