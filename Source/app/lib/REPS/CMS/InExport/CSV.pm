package REPS::CMS::InExport::CSV;
#CSVファイルのエクスポート用ルーチンです。
# added by n-style;
# 2006.2.24 csvController 1.0

use base qw(REPS::CMS::InExport);
use strict;
use CGI::Carp qw(fatalsToBrowser);

use DB_File;
use File::Path;

#for debug
use Data::Dumper;

sub new{
	my ($class,$app) = @_;
	my $self = {
		_app => $app
		};
	return bless $self,$class;
}


# added by n-style;
# 2006.2.24 export_Data 1.0
sub export_Data {
	my $self = shift;
    eval{
	   my $strDbPath = shift;
	   my $strFileName = shift;
	   my $dlFileName = shift;
	   my $key;
	   my $value;
	   
	   my $param;
	   my %objDBData;
	   # TEXTAREAの項目について、改行をどのように変換するかハッシュで定義
	   my %conv = (
		  'APART_DAIGAKU_LIST' => "\t",
		  'APART_SETUBI' => ' ',
		  'APART_BIKOU' => ' ',
		  'BUSINESS_SETUBI' => ' ',
		  'BUSINESS_BIKOU' => ' ',
		  'LAND_SETUBI' => ' ',
		  'LAND_BIKOU' => ' ',
		  'MANSION_BIKOU' => ' ',
		  'MANSION_SETUBI' => ' ',
		  'HOUSE_BIKOU' => ' ',
		  'HOUSE_SETUBI' => ' '
	   );
	   my $strCsv;
	   my $convTxt;
	   tie (%objDBData, 'MLDBM', $strDbPath, O_RDONLY, 0666, $DB_BTREE, 'read') or croak $!;
    
	   # ヘッダファイル読み込み
	   open(FILE, $strFileName) or die $!;
	   my @rec = <FILE>;
	   close(FILE);
    
	   # ヘッダ吐き出し
    #	foreach $param (@rec) {
    #		$param =~ s!\r?\n!!g;
    #		$strCsv .= $param . "," ;
    #	}
    #	$strCsv =~ s/,*$/\r\n/;

	   # Octet-streamとして処理
	   print "Content-type: application/octet-stream; charset=Shift_JIS\n";
	   print "Content-Disposition: attachment; filename=\"$dlFileName\"\n\n";
    
	   # データ吐き出し
	   while ( ($key, $value) = each(%objDBData) ) {
		  if (defined $objDBData{$key}){
			 if($value eq ''){
				    next;
			 }
			 my %hash = %$value;
			 $strCsv = '';
			 foreach $param (@rec) {
				    $param =~ s!\r?\n!!g;
				    if ( exists $conv{$param} ){
					   $convTxt = $conv{$param};
				    }else{
					   $convTxt = "";
				    }
				    $strCsv .= $self->_convert_for_csv( $hash{$param}, $convTxt ) . "," ;
			 }
			 
			 # 行末のカンマを改行(CR+LF)に変換
			 $strCsv =~ s/,*$/\r\n/;
			 
			 jcode::convert(\$strCsv, 'sjis');
			 print STDOUT $strCsv;
		  }
	   }

	   untie %objDBData;
    };
    if ($@) {
        return "$@";
    }else{
        if(exists $ENV{MOD_PERL}){Apache::exit();}else{exit(0);};
    }
	
}

# added by n-style;
# 2006.3.20 import_Data 1.0
sub import_Data {
	my $self = shift;
	my $label = shift;
	my $strDbPath = shift;
	my $TruncateData = shift;
	my $DataType = shift;
	my $strUser_ID = shift;
	my $strTargetFileName = shift;
	my $strHeaderFileName = shift;
    my $offset = shift;

    if (!$DataType){die "DataType is needed.";}

	my %rb_hash = (
			'BUSINESS_ID' => '',
			'BUSINESS_PUBLISHED' => '',
            'BUSINESS_IS_SPECIAL' => '',
			'BUSINESS_NAME' => '',
			'BUSINESS_LOCATION' => '',
			'BUSINESS_STATION_1' => '',
			'BUSINESS_BUS_1' => '',
			'BUSINESS_WALK_MINUTES_1' => '',
			'BUSINESS_BUS_MINUTES_1' => '',
			'BUSINESS_BUSWALK_MINUTES_1' => '',
			'BUSINESS_STATION_2' => '',
			'BUSINESS_BUS_2' => '',
			'BUSINESS_WALK_MINUTES_2' => '',
			'BUSINESS_BUS_MINUTES_2' => '',
			'BUSINESS_BUSWALK_MINUTES_2' => '',
			'BUSINESS_PRICE' => '',
			'BUSINESS_PRICE_KANRIHI' => '',
			'BUSINESS_PRICE_SIKIKIN' => '',
			'BUSINESS_PRICE_SIKIKIN_UNIT' => '',
			'BUSINESS_PRICE_REIKIN' => '',
			'BUSINESS_PRICE_REIKIN_UNIT' => '',
			'BUSINESS_PRICE_HOSYOUKIN' => '',
			'BUSINESS_PRICE_SYOUKYAKU' => '',
			'BUSINESS_PRICE_SIKIBIKI' => '',
			'BUSINESS_PRICE_OTHER' => '',
			'BUSINESS_INSURANCE' => '',
			#'BUSINESS_CHUUTOKAIYAKU' => '',
			'BUSINESS_TOTI_SQUARE' => '',
			'BUSINESS_SENYUU_SQUARE' => '',
			'BUSINESS_KIND' => '',
			'BUSINESS_BUILDING_STRUCTURE' => '',
			'BUSINESS_STORY' => '',
			'BUSINESS_FLOOR' => '',
			'BUSINESS_AGE' => '',
			'BUSINESS_CONDITION' => '',
			'BUSINESS_TORIHIKITAIYOU' => '',
			'BUSINESS_YOUR_ID' => '',	
			'BUSINESS_OPTIONS_PARKING' => '',
			'BUSINESS_ADS_TEXT' => '',
			'BUSINESS_SETUBI' => '',
			'BUSINESS_BIKOU' => '',
			'BUSINESS_PICS_OUTSIDE' => '',
			'BUSINESS_PICS_INSIDE' => '',
			'BUSINESS_PICS_MADORIZU' => '',
			'BUSINESS_PICS_TIZU' => '',
			'BUSINESS_PICS_OUTSIDE_THUMB' => '',
			'BUSINESS_PICS_INSIDE_THUMB' => '',
			'BUSINESS_PICS_MADORIZU_THUMB' => '',
			'BUSINESS_PICS_TIZU_THUMB' => '',
			'BUSINESS_MOVIE_FILE_URL' => '',
			'BUSINESS_TASYAKANRI' => '',
			'BUSINESS_RYUUTUU' => '',
			'BUSINESS_KANRIKAISYA' => '',
			'BUSINESS_KANRIKAISYA_CONTACT' => '',
			'BUSINESS_USER_ID' => $strUser_ID,
			'BUSINESS_CREATED' => '',
			'BUSINESS_LAST_UPDATED' => ''
	);
	my %bm_hash = (
			'MANSION_ID' => '',
			'MANSION_PUBLISHED' => '',
			'MANSION_IS_SPECIAL' => '',
			'MANSION_NAME' => '',
			'MANSION_LOCATION' => '',
			'MANSION_STATION_1' => '',
			'MANSION_BUS_1' => '',
			'MANSION_WALK_MINUTES_1' => '',
			'MANSION_BUS_MINUTES_1' => '',
			'MANSION_BUSWALK_MINUTES_1' => '',
			'MANSION_STATION_2' => '',
			'MANSION_BUS_2' => '',
			'MANSION_WALK_MINUTES_2' => '',
			'MANSION_BUS_MINUTES_2' => '',
			'MANSION_BUSWALK_MINUTES_2' => '',
			'MANSION_PRICE' => '',
			'MANSION_PRICE_TAX_INC' => '',
			'MANSION_PRICE_KANRIHI' => '',
			'MANSION_MADORI' => '',
			'MANSION_MADORI_DETAIL' => '',
			'MANSION_BUILDING_STRUCTURE' => '',
			'MANSION_STORY' => '',
			'MANSION_FLOOR' => '',
			'MANSION_AGE' => '',
			'MANSION_ROOM_NUMBER' => '',
			'MANSION_SOUKOSUU' => '',
			'MANSION_SYUYOUSAIKOUMEN' => '',
			'MANSION_BARUKONI_SQUARE' => '',
			'MANSION_BARUKONI_SQUARE_TUBO' => '',
			'MANSION_CHUSYAJYOU' => '',
			'MANSION_SQUARE' => '',
			'MANSION_SQUARE_TEXT' => '',
			'MANSION_SQUARE_TUBO' => '',
			'MANSION_GAISOU_AGE' => '',
			'MANSION_KENRI' => '',
			'MANSION_SYUUZENTUMITATEKIN' => '',
			#'MANSION_TIMOKU' => '',
			'MANSION_TISEI' => '',
			'MANSION_YOUTOTIIKI' => '',
			'MANSION_SETUBI' => '',
			'MANSION_JYOUKEN' => '',
			'MANSION_BIKOU' => '',
			'MANSION_HIKIWATASI' => '',
			'MANSION_GENKYOU' => '',
			'MANSION_TORIHIKITAIYOU' => '',
			'MANSION_OPTIONS_KAKUBEYA' => '',
			'MANSION_OPTIONS_AUTOLOCK' => '',
			'MANSION_OPTIONS_ELEVATOR' => '',
			'MANSION_OPTIONS_TVPHONE' => '',
			'MANSION_OPTIONS_SYSTEM_KITCHIN' => '',
			'MANSION_OPTIONS_SHOWERTOILETE' => '',
			'MANSION_OPTIONS_WALKIN_CLOSET' => '',
			'MANSION_OPTIONS_YUKASITA_SYUUNOU' => '',
			'MANSION_OPTIONS_YUKADANBOU' => '',
			'MANSION_OPTIONS_SENYOUNIWA' => '',
			'MANSION_OPTIONS_PARKING' => '',
			'MANSION_OPTIONS_PARKING_BYKE' => '',
			'MANSION_OPTIONS_PARKING_JITENSYA' => '',
			'MANSION_OPTIONS_BARUKONI' => '',
			'MANSION_OPTIONS_BARIAFURI' => '',
			'MANSION_OPTIONS_TOSIGASU' => '',
			'MANSION_OPTIONS_PET' => '',
			'MANSION_YOUR_ID' => '',
			'MANSION_ADS_TEXT' => '',
			'MANSION_PICS_OUTSIDE' => '',
			'MANSION_PICS_INSIDE' => '',
			'MANSION_PICS_MADORIZU' => '',
			'MANSION_PICS_TIZU' => '',
			'MANSION_PICS_OUTSIDE_THUMB' => '',
			'MANSION_PICS_INSIDE_THUMB' => '',
			'MANSION_PICS_MADORIZU_THUMB' => '',
			'MANSION_PICS_TIZU_THUMB' => '',
			'MANSION_MOVIE_FILE_URL' => '',
			#'MANSION_TASYAKANRI' => '',
			'MANSION_RYUUTUU' => '',
			'MANSION_BUNJYOU_KAISYA' => '',
			'MANSION_SEKOU_KAISYA' => '',
			'MANSION_KANRIKAISYA' => '',
			'MANSION_KANRIKAISYA_CONTACT' => '',
			'MANSION_KANRI_JININ' => '',
			'MANSION_KANRI_KEITAI' => '',
			'MANSION_USER_ID' => $strUser_ID,
			'MANSION_CREATED' => '',
			'MANSION_LAST_UPDATED' => '',
	);
	my %bl_hash = (
			'LAND_ID' => '',
			'LAND_PUBLISHED' => '',
			'LAND_IS_SPECIAL' => '',
			'LAND_LOCATION' => '',
			'LAND_STATION_1' => '',
			'LAND_BUS_1' => '',
			'LAND_WALK_MINUTES_1' => '',
			'LAND_BUS_MINUTES_1' => '',
			'LAND_BUSWALK_MINUTES_1' => '',
			'LAND_STATION_2' => '',
			'LAND_BUS_2' => '',
			'LAND_WALK_MINUTES_2' => '',
			'LAND_BUS_MINUTES_2' => '',
			'LAND_BUSWALK_MINUTES_2' => '',
			'LAND_PRICE' => '',
			'LAND_TUBOTANKA' => '',
			'LAND_SQUARE_M' => '',
			'LAND_SQUARE_TEXT' => '',
			'LAND_SQUARE_T' => '',
			'LAND_SETUDOU' => '',
			'LAND_KENRI' => '',
			'LAND_SETBACK' => '',
			'LAND_SIDOUFUTAN_SQUARE' => '',
			'LAND_TIMOKU' => '',
			'LAND_TISEI' => '',
			'LAND_KENPEIRITU' => '',
			'LAND_YOUSEKIRITU' => '',
			'LAND_YOUTOTIIKI' => '',
			'LAND_TOSIKEIKAKU' => '',
			'LAND_KOKUDOHOUTODOKEDE' => '',
			'LAND_JYOUKEN' => '',
			'LAND_OPTIONS_KAKUTI' => '',
			'LAND_OPTIONS_GUS' => '',
			'LAND_OPTIONS_SUIDOU' => '',
			'LAND_OPTIONS_HAISUI' => '',
			'LAND_OPTIONS_OSUI' => '',
			'LAND_SETUBI' => '',
			'LAND_BIKOU' => '',
			'LAND_HIKIWATASI' => '',
			'LAND_GENKYOU' => '',
			'LAND_TORIHIKITAIYOU' => '',
			'LAND_YOUR_ID' => '',
			'LAND_ADS_TEXT' => '',
			'LAND_PICS_OUTSIDE' => '',
			'LAND_PICS_INSIDE' => '',
			'LAND_PICS_TIZU' => '',
			'LAND_PICS_OUTSIDE_THUMB' => '',
			'LAND_PICS_INSIDE_THUMB' => '',
			'LAND_PICS_TIZU_THUMB' => '',
			'LAND_MOVIE_FILE_URL' => '',
			'LAND_TASYAKANRI' => '',
			'LAND_RYUUTUU' => '',
			'LAND_KANRIKAISYA' => '',
			'LAND_KANRIKAISYA_CONTACT' => '',
			'LAND_USER_ID' => $strUser_ID,
			'LAND_CREATED' => '',
			'LAND_LAST_UPDATED' => ''
	);
	my %bh_hash = (
			'HOUSE_ID' => '',
			'HOUSE_PUBLISHED' => '',
			'HOUSE_IS_SPECIAL' => '',
			'HOUSE_LOCATION' => '',
			'HOUSE_STATION_1' => '',
			'HOUSE_BUS_1' => '',
			'HOUSE_WALK_MINUTES_1' => '',
			'HOUSE_BUS_MINUTES_1' => '',
			'HOUSE_BUSWALK_MINUTES_1' => '',
			'HOUSE_STATION_2' => '',
			'HOUSE_BUS_2' => '',
			'HOUSE_WALK_MINUTES_2' => '',
			'HOUSE_BUS_MINUTES_2' => '',
			'HOUSE_BUSWALK_MINUTES_2' => '',
			'HOUSE_PRICE' => '',
			'HOUSE_PRICE_TAX_INC' => '',
			'HOUSE_BUILDING_SQUARE' => '',
			'HOUSE_TOTI_SQUARE' => '',
			'HOUSE_TOTI_SQUARE_TEXT' => '',
			'HOUSE_TOTI_SQUARE_TUBO' => '',
			'HOUSE_MADORI' => '',
			'HOUSE_MADORI_DETAIL' => '',
			'HOUSE_BUILDING_STRUCTURE' => '',
			'HOUSE_AGE' => '',
			'HOUSE_SETUDOUJYOUKYOU' => '',
			'HOUSE_CHUSYAJYOU' => '',
			'HOUSE_SYAKUTIRYOU' => '',
			'HOUSE_SYAKUTIKIKAN' => '',
			'HOUSE_SETBACK' => '',
			'HOUSE_SIDOUFUTAN_SQUARE' => '',
			'HOUSE_TOTIKENRI' => '',
			'HOUSE_TIMOKU' => '',
			'HOUSE_TISEI' => '',
			'HOUSE_KENPEIRITU' => '',
			'HOUSE_YOUSEKIRITU' => '',
			'HOUSE_YOUTOTIIKI' => '',
			'HOUSE_TOSIKEIKAKU' => '',
			'HOUSE_KOKUDOHOUTODOKEDE' => '',
			'HOUSE_SETUBI' => '',
			'HOUSE_JYOUKEN' => '',
			'HOUSE_BIKOU' => '',
			'HOUSE_HIKIWATASI' => '',
			'HOUSE_GENKYOU' => '',
			'HOUSE_TORIHIKITAIYOU' => '',
			'HOUSE_OPTIONS_SINTIKU' => '',
			'HOUSE_OPTIONS_TVPHONE' => '',
			'HOUSE_OPTIONS_SYSTEM_KITCHIN' => '',
			'HOUSE_OPTIONS_SHOWERTOILETE' => '',
			'HOUSE_OPTIONS_WALKIN_CLOSET' => '',
			'HOUSE_OPTIONS_YUKASITA_SYUUNOU' => '',
			'HOUSE_OPTIONS_YUKADANBOU' => '',
			'HOUSE_OPTIONS_PARKING' => '',
			'HOUSE_OPTIONS_BARIAFURI' => '',
			'HOUSE_OPTIONS_TOSIGASU' => '',
			'HOUSE_YOUR_ID' => '',
			'HOUSE_ADS_TEXT' => '',
			'HOUSE_PICS_OUTSIDE' => '',
			'HOUSE_PICS_INSIDE' => '',
			'HOUSE_PICS_MADORIZU' => '',
			'HOUSE_PICS_TIZU' => '',
			'HOUSE_PICS_OUTSIDE_THUMB' => '',
			'HOUSE_PICS_INSIDE_THUMB' => '',
			'HOUSE_PICS_MADORIZU_THUMB' => '',
			'HOUSE_PICS_TIZU_THUMB' => '',
			'HOUSE_MOVIE_FILE_URL' => '',
			'HOUSE_TASYAKANRI' => '',
			'HOUSE_RYUUTUU' => '',
			'HOUSE_KANRIKAISYA' => '',
			'HOUSE_KANRIKAISYA_CONTACT' => '',
			'HOUSE_USER_ID' => $strUser_ID,
			'HOUSE_CREATED' => '',
			'HOUSE_LAST_UPDATED' => ''
	);
	my %rl_hash = (
			'APART_ID' => '',
			'APART_PUBLISHED' => '',
			'APART_IS_SPECIAL' => '',
			'APART_NAME' => '',
			'APART_LOCATION' => '',
			'APART_STATION_1' => '',
			'APART_BUS_1' => '',
			'APART_WALK_MINUTES_1' => '',
			'APART_BUS_MINUTES_1' => '',
			'APART_BUSWALK_MINUTES_1' => '',
			'APART_STATION_2' => '',
			'APART_BUS_2' => '',
			'APART_WALK_MINUTES_2' => '',
			'APART_BUS_MINUTES_2' => '',
			'APART_BUSWALK_MINUTES_2' => '',
			'APART_PRICE' => '',
			'APART_PRICE_KANRIHI' => '',
			'APART_PRICE_SIKIKIN' => '',
			'APART_PRICE_SIKIKIN_UNIT' => '',
			'APART_PRICE_REIKIN' => '',
			'APART_PRICE_REIKIN_UNIT' => '',
			'APART_PRICE_HOSYOUKIN' => '',
			'APART_PRICE_SIKIBIKI' => '',
			'APART_PRICE_OTHER' => '',
			'APART_INSURANCE' => '',
			'APART_MADORI' => '',
			'APART_MADORI_DETAIL' => '',
			'APART_SQUARE' => '',
            'APART_SQUARE_TUBO' => '',
			'APART_KIND' => '',
			'APART_BUILDING_STRUCTURE' => '',
			'APART_STORY' => '',
			'APART_FLOOR' => '',
			'APART_AGE' => '',
			'APART_CONDITION' => '',
			'APART_TORIHIKITAIYOU' => '',
			'APART_ROOM_NUMBER' => '',
			'APART_YOUR_ID' => '',
			'APART_OPTIONS_KAKUBEYA' => '',
			'APART_OPTIONS_MINAMI' => '',
			'APART_OPTIONS_AUTOLOCK' => '',
			'APART_OPTIONS_ELEVATOR' => '',
			'APART_OPTIONS_TVPHONE' => '',
			'APART_OPTIONS_BATHTOILET' => '',
			'APART_OPTIONS_AIRCON' => '',
			'APART_OPTIONS_OITAKI' => '',
			'APART_OPTIONS_GASCONRO' => '',
			'APART_OPTIONS_SITUNAISENTAKUKI' => '',
			'APART_OPTIONS_LOFT' => '',
			'APART_OPTIONS_FLOORING' => '',
			'APART_OPTIONS_CATV' => '',
			'APART_OPTIONS_CS' => '',
			'APART_OPTIONS_BS' => '',
			'APART_OPTIONS_JIMUSYOKA' => '',
			'APART_OPTIONS_PARKING' => '',
			'APART_OPTIONS_PET' => '',
			'APART_OPTIONS_HOSYOUNIN' => '',
			'APART_OPTIONS_INSTRUMENT' => '',
            'APART_OPTIONS_INTERNET' => '',
            'APART_OPTIONS_BICYCLE' => '',
			'APART_SHOUGAKKOUKU' => '',
			'APART_CYUUGAKKOUKU' => '',
			'APART_DAIGAKU_LIST' => '',
			'APART_HTML_TEXT' => '',
			'APART_ADS_TEXT' => '',
			'APART_BIKOU' => '',
			'APART_NYUUKYOJIKI' => '',
			'APART_SETUBI' => '',
			'APART_PICS_OUTSIDE' => '',
			'APART_PICS_INSIDE' => '',
			'APART_PICS_MADORIZU' => '',
            'APART_PICS_TIZU' => '',
			'APART_PICS_OUTSIDE_THUMB' => '',
			'APART_PICS_INSIDE_THUMB' => '',
			'APART_PICS_MADORIZU_THUMB' => '',
            'APART_PICS_TIZU_THUMB' => '',
			'APART_MOVIE_FILE_URL' => '',
			'APART_TASYAKANRI' => '',
			'APART_RYUUTUU' => '',
			'APART_KANRIKAISYA' => '',
			'APART_KANRIKAISYA_CONTACT' => '',
			'APART_USER_ID' => $strUser_ID,
			'APART_CREATED' => '',
			'APART_LAST_UPDATED' => ''
	);

    my %bb_hash = (
            'BUSINESS_ID' => '',
            'BUSINESS_PUBLISHED' => '',
            'BUSINESS_IS_SPECIAL' => '',
            'BUSINESS_NAME' => '',
            'BUSINESS_LOCATION' => '',
            'BUSINESS_STATION_1' => '',
            'BUSINESS_WALK_MINUTES_1' => '',
            'BUSINESS_BUS_1' => '',
            'BUSINESS_BUS_MINUTES_1' => '',
            'BUSINESS_BUSWALK_MINUTES_1' => '',
            'BUSINESS_STATION_2' => '',
            'BUSINESS_WALK_MINUTES_2' => '',
            'BUSINESS_BUS_2' => '',
            'BUSINESS_BUS_MINUTES_2' => '',
            'BUSINESS_BUSWALK_MINUTES_2' => '',
            'BUSINESS_KIND' => '',
            'BUSINESS_KIND_DETAIL' => '',
            'BUSINESS_PRICE' => '',
            'BUSINESS_PRICE_KANRIHI' => '',
            'BUSINESS_MADORI_DETAIL' => '',
            'BUSINESS_SQUARE' => '',
            'BUSINESS_SQUARE_TEXT' => '',
            'BUSINESS_TATEMONO_SQUARE' => '',
            'BUSINESS_MOCHIBUN_SQUARE' => '',
            'BUSINESS_SOU_SQUARE' => '',
            'BUSINESS_BUILDING_STRUCTURE' => '',
            'BUSINESS_STORY' => '',
            'BUSINESS_FLOOR' => '',
            'BUSINESS_AGE' => '',
            'BUSINESS_SOUKOSUU' => '',
            'BUSINESS_CHUSYAJYOU' => '',
            'BUSINESS_KENRI' => '',
            'BUSINESS_SIDOUFUTAN_SQUARE' => '',
            'BUSINESS_SYUUZENTUMITATEKIN' => '',
            'BUSINESS_KENPEIRITU' => '',
            'BUSINESS_YOUSEKIRITU' => '',
            'BUSINESS_YOUTOTIIKI' => '',
            'BUSINESS_TOSIKEIKAKU' => '',
            'BUSINESS_KOKUDOHOUTODOKEDE' => '',
            'BUSINESS_JYOUKEN' => '',
            'BUSINESS_SETUBI' => '',
            'BUSINESS_BIKOU' => '',
            'BUSINESS_HIKIWATASI' => '',
            'BUSINESS_GENKYOU' => '',
            'BUSINESS_TORIHIKITAIYOU' => '',
            'BUSINESS_YOUR_ID' => '',
            'BUSINESS_OPTIONS_PARKING' => '',
            'BUSINESS_ADS_TEXT' => '',
            'BUSINESS_PICS_OUTSIDE' => '',
            'BUSINESS_PICS_INSIDE' => '',
            'BUSINESS_PICS_MADORIZU' => '',
            'BUSINESS_PICS_TIZU' => '',
            'BUSINESS_PICS_OUTSIDE_THUMB' => '',
            'BUSINESS_PICS_INSIDE_THUMB' => '',
            'BUSINESS_PICS_MADORIZU_THUMB' => '',
            'BUSINESS_PICS_TIZU_THUMB' => '',
            'BUSINESS_MOVIE_FILE_URL' => '',
            'BUSINESS_KANRI_KEITAI' => '',
            'BUSINESS_USER_ID' => $strUser_ID,
            'BUSINESS_CREATED' => '',
            'BUSINESS_LAST_UPDATED' => '',
    );

	my $result;
	my @parsed;
	my @csvData;
	my $count = 0;

	# ヘッダファイルを配列に読み込む
	open(FILE, $strHeaderFileName) or croak $!;
	my @Header = <FILE>;
	close(FILE);

	# ヘッダの改行を削除する
	my $head;
	foreach $head (@Header) {
		#chomp $head;
		#上記だとどうもlfのみ削除されてcrが残ってしまうっぽい。。。
		$head =~ s!\r?\n$!!;
	}
	
	# ターゲットファイル(CSV)を配列に読み込む
	(my $extension = $strTargetFileName) =~ s!.*\.([^.]+)$!$1!;
	if ( $extension eq 'csv' ){
		open(FILE, $strTargetFileName) or croak "$strTargetFileName: $!";

        # データベースのオープン
        my %data;
        if (! -e $strDbPath ){
            $TruncateData = 'on';
        }

my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%data, 'MLDBM', $strDbPath, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or croak $!;
        # 削除オプションが指定されている場合は初期化
        if ( $TruncateData eq 'on' ){
            %data = ();
        }


        #全て読み込むのではなく、
        #	@csvData = <FILE>;
        #ファイルを一行づつ読み込んで処理。サーバーにやさしく

        while(my $item = <FILE>) {
            if ($count < $offset){$count++;next;}

            if ($count >= $offset+40) {
                #reset offset
                $offset = $offset+40;

                #close db and file
                untie %data;
                close(FILE);
                umask($old);

                my $url = $self->{_app}->param('script_name').'?'.
                        '_mode='.$self->{_app}->query()->param("_mode").'&'.
                        '_action='.$self->{_app}->query()->param("_action").'&'.
                        'strUser_ID='.$self->{_app}->query()->param("strUser_ID").'&'.
                        #'Truncate='.$self->{_app}->query()->param("Truncate").'&'.  # make sure this is off!
                        '_type='.$DataType.'&'.
                        'offset='.$offset;


                #torum - prints out to STDOUT - 2007-01-05
                # text/plain として画面に書きだし
                print "Content-type: text/html; charset=UTF-8\n";
                print "Refresh: 2; url=$url\n\n";

                my $out = "\n\n<html><title>REPS - インポート中...（現在$count件）</title></head><body> お待ちください…<br />\n";
                $out .= '<img src="'.$self->{_app}->cfg('static_url').'icons/pleasewait.gif'.'" width ="214" height="15" /><br /><br />'."$label のインポートを実行中です...（$count件）<br /><br />";
                $out .= '<small><a href="'.$self->{_app}->param('script_name').'"><img src="'.$self->{_app}->cfg('static_url').'/icons/12-em-cross.png'.'" border="0" />キャンセル</a></small></body></html>';

                #torum - prints out to STDOUT - 2007-01-05
                print Unicode::Japanese->new($out,'euc')->utf8;
                if(exists $ENV{MOD_PERL}){Apache::exit();}else{exit(0);};
            }

            #末尾の改行を削除
            chomp $item;

            # ハッシュ定義のバインド
            my %_hash;
            my $idFieldName;
            if ( $DataType eq 'rl' ){
                %_hash = %rl_hash;
                $idFieldName = 'APART_ID';
            }elsif ( $DataType eq 'rb' ){
                %_hash = %rb_hash;
                $idFieldName = 'BUSINESS_ID';
            }elsif ( $DataType eq 'bm' ){
                %_hash = %bm_hash;
                $idFieldName = 'MANSION_ID';
            }elsif ( $DataType eq 'bl' ){
                %_hash = %bl_hash;
                $idFieldName = 'LAND_ID';
            }elsif ( $DataType eq 'bh' ){
                %_hash = %bh_hash;
                $idFieldName = 'HOUSE_ID';
            }elsif ( $DataType eq 'bb' ){
                %_hash = %bb_hash;
                $idFieldName = 'BUSINESS_ID';
            }
    
            # CSVボディのパース
            $item =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
            @parsed = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}($item =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
            
    
            my $i = 0;
            my $num_keys;
            
            # ヘッダの取得
            foreach $head (@Header) {
                # ハッシュに追加
                if ( $head eq $idFieldName ) {
                    $num_keys = $self->_convert_charset( $parsed[$i] );
                    if ( defined $data{$num_keys} && $data{$num_keys} ){
                        %_hash = %{$data{$num_keys}};
                    }
                    $i++;
                    next;
                }elsif ( $head eq 'APART_DAIGAKU_LIST' ){
                    $_hash{$head} = $self->_convert_charset( $self->_convert_tab_to_enter( $parsed[$i] ) );
                }elsif ( exists $_hash{$head} ){
                    $_hash{$head} = $self->_convert_charset( $parsed[$i] );
                }
                $i++;
            }
    
            # 削除オプションが指定されている場合は新規取得
            if ( $TruncateData eq 'on' || !exists $data{$num_keys}){
                # id取得
                $num_keys = scalar keys (%data);
                $num_keys = sprintf('%06d', $num_keys++);
            }else{
            # そうでない場合は上書き
                # $num_keysは上のループで設定済
            }

            require REPS::Util;
            if ( $DataType eq 'rl' ){
                if (!$_hash{'APART_CREATED'}){
                    $_hash{'APART_CREATED'} = REPS::Util->get_datetime_now();
                }
            }elsif ( $DataType eq 'rb' ){
                if (!$_hash{'BUSINESS_CREATED'}){
                    $_hash{'BUSINESS_CREATED'} = REPS::Util->get_datetime_now();
                }
            }elsif ( $DataType eq 'bm' ){
                if (!$_hash{'MANSION_CREATED'}){
                    $_hash{'MANSION_CREATED'} = REPS::Util->get_datetime_now();
                }
            }elsif ( $DataType eq 'bl' ){
                if (!$_hash{'LAND_CREATED'}){
                    $_hash{'LAND_CREATED'} = REPS::Util->get_datetime_now();
                }
            }elsif ( $DataType eq 'bh' ){
                if (!$_hash{'HOUSE_CREATED'}){
                    $_hash{'HOUSE_CREATED'} = REPS::Util->get_datetime_now();
                }
            }elsif ( $DataType eq 'bb' ){
                if (!$_hash{'BUSINESS_CREATED'}){
                    $_hash{'BUSINESS_CREATED'} = REPS::Util->get_datetime_now();
                }
            }

            #
            REPS::Util->convert_hash_zhk(\%_hash);

            $_hash{$idFieldName} = $num_keys;
            $data{$num_keys} = \%_hash;
    
            #torum - prints out to STDOUT - 2007-01-05
            #print 'ID: '. $num_keys." - OK\n";
            # - 
            $count++;
        }
        untie %data;
		close(FILE);
umask($old);
        #単に、アドレスを戻すだけの為の処理
        my $url = $self->{_app}->param('script_name').'?'.
                '_mode='.$self->{_app}->query()->param("_mode").'&'.
                '_action='.$self->{_app}->query()->param("_action").'&'.
                '_type='.$DataType.'&'.
                '_result=done';
        print "Content-type: text/html; charset=UTF-8\n";
        print "Refresh: 2; url=$url\n\n";
        my $out = "\n\n<html><head><title>REPS - インポート</title></head><body> このままお待ちください…。<br />$label のインポートを完了しています...（$count件）。<br /><br />\n";
        #$out .= '<small><a href="'.$self->{_app}->param('script_name').'">キャンセル</a></small></body></html>';

        print Unicode::Japanese->new($out,'euc')->utf8;
        if(exists $ENV{MOD_PERL}){Apache::exit();}else{exit(0);};
        #-
	}else{
		return "この形式は現在サポートされていません。";
	}

    ## CMS.pmに移動
	#if ( $result eq '' ){
	#	$result .= "$label は追加されました。データの内容を確認してください。<br />";
	#}

	return $result;
}


# moved CMS.pm

# # added by n-style;
# # 2006.02.28 Backup 1.0a
# sub export{
# 	my $self = shift;
# 	my $type = shift;
# 	my $label = shift;
# 	my $contents = shift;
# 	my $result = '';
# 
# 	my $dir='export';
# 	
# 	# ディレクトリが存在しない場合に作成
# 	if (! -d $dir){
# 		eval { mkpath($dir) };
# 		if ($@) {
# 		$result .= "$@<br />";
# 		}
# 	}
# 	my $tainted = $dir.'/reps-' . $type . '-export.csv';
# 	$tainted =~ m|([\w\-\_\/\.]*)|;
# 	my $filename = $1;
# 
# 	# ファイルの作成と書き込み
# 	if($contents){
# 		open( OUT, ">$filename" ) or croak $!;
# 		print OUT $contents;
# 		close( OUT );
# 		return "$label データのエクスポートが完了しました。<br />";
# 	}else{
# 		return "$label データは存在しません。<br />";
# 	}
# 
# }


1
