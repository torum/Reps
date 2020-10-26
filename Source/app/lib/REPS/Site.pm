package REPS::Site;

use strict;
use base qw( REPS CGI::Application );

use REPS::Search::Inquiry;
use REPS::User;
use REPS::Settings;
use DB_File::Lock;
use Unicode::Japanese;

use vars qw(
	$script_name
);

sub setup {
	my $self = shift;
	$self->run_modes(
		'mode_main' 			=> 'show_main',
		'mode_inquiry'			=> 'show_inquiry',
#not yet implemented        'mode_rl_inquiry'          => 'show_rl_inquiry',
#not yet implemented		'mode_bs_inquiry'		=> 'show_bs_inquiry', 
	);

    my $q = $self->query();
    $script_name = $q->url;
    $self->param('script_name'=>$script_name);

	$self->tmpl_path($self->cfg('tmpl_path'));
	$self->start_mode('mode_main');
	$self->mode_param('_mode');

	$self->param('user_logged_in'=>0);

	$self->param('script_name'=>$script_name);

    $self->param('db_usr_profile_path' => $self->cfg('db_path') . 'usr_profile.db');
    $self->param('db_settings_path' => $self->cfg('db_path') . 'usr_settings.db');

	#$UJ = Unicode::Japanese->new();

	$self->header_props(
		-charset=>$self->cfg('charset'),
		-type => 'text/html'
		#-expires=>'now',
		#-pragma=>'no-cache',
		#-cache_control=>'no-cache'
	);


}

sub cgiapp_postrun {
	my $self = shift;
	my $bodyref = shift;
	my $charset = uc($self->cfg('charset'));
    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {
        $self->header_add(-charset=> $charset);
        my $encode = $charmap->{$charset};
        #unless ($encode eq 'utf8'){
            my $UJ = Unicode::Japanese->new();
            my @lines = map { $UJ->set($_,'euc')->conv($encode) } split(/\n/, $$bodyref);
            $$bodyref = join("\n", @lines);
        #}
    }


}


sub show_main {

	my $self = shift;
	my $q = $self->query();
	my $output = "--";

	return $output;
}




sub show_bs_inquiry{
	my $self = shift;
	my $q = $self->query();
	my $output = "";
	my $texts;
	my $template;
	my $result;
	my $showForm;

	my $form_buy_on;
	my $form_sell_on;
	my $form_change_on;
	my $form_unpublished_on;

	if ($q->param("submit_Inquiry")){
		#check and send

		#########################
		if (($q->param("_type") eq 'b') or ($q->param("_type") eq 'u')) {
		###購入
	
			my $BUKKEN_SYUBETSU = $self->_convert_charset($q->param("BUKKEN_SYUBETSU"));
			my $BUKKEN_AREA = $self->_convert_charset($q->param("BUKKEN_AREA"));
			my $BUKKEN_EKI = $self->_convert_charset(join(',', $q->param("BUKKEN_EKI")));
			my $BUKKEN_AREA_SECOND = $self->_convert_charset($q->param("BUKKEN_AREA_SECOND"));
			my $BUKKEN_EKI_SECOND = $self->_convert_charset(join(',', $q->param("BUKKEN_EKI_SECOND")));
		
			my $BUKKEN_YOSAN = $self->_convert_charset($q->param("BUKKEN_YOSAN"));
			my $MENSEKI_MANSION =$self->_convert_charset( $q->param("MENSEKI_MANSION"));
			my $MENSEKI_TATEMONO = $self->_convert_charset($q->param("MENSEKI_TATEMONO"));
			my $MENSEKI_TOCHI = $self->_convert_charset($q->param("MENSEKI_TOCHI"));
			my $MADORI = $self->_convert_charset($q->param("MADORI"));
			my $MADORI_TYPE = $self->_convert_charset($q->param("MADORI_TYPE"));
			my $YOTEI = $self->_convert_charset($q->param("YOTEI"));
		
			my $NAME = $self->_convert_charset($q->param("NAME"));
			my $NAME_KANA = $self->_convert_charset($q->param("NAME_KANA"));
			my $EMAIL = $self->_convert_charset($q->param("EMAIL"));
			my $TEL = $self->_convert_charset($q->param("TEL"));
			my $TEL2 = $self->_convert_charset($q->param("TEL2"));
			my $TEL3 = $self->_convert_charset($q->param("TEL3"));
			my $YUBIN = $self->_convert_charset($q->param("YUBIN"));
			my $YUBIN2 = $self->_convert_charset($q->param("YUBIN2"));
		
			my $ADDRESS_TODOUFUKEN = $self->_convert_charset($q->param("ADDRESS_TODOUFUKEN"));
			my $ADDRESS_SIKUCYOUSON = $self->_convert_charset($q->param("ADDRESS_SIKUCYOUSON"));
			my $ADDRESS_CHYOUME = $self->_convert_charset($q->param("ADDRESS_CHYOUME"));
			my $ADDRESS_BANCHI = $self->_convert_charset($q->param("ADDRESS_BANCHI"));
			my $ADDRESS_MANSYON = $self->_convert_charset($q->param("ADDRESS_MANSYON"));
		
			my $BIRTHDAY_Y = $self->_convert_charset($q->param("BIRTHDAY_Y"));
			my $BIRTHDAY_M = $self->_convert_charset($q->param("BIRTHDAY_M"));
			my $BIRTHDAY_D = $self->_convert_charset($q->param("BIRTHDAY_D"));
		
			my $SHUDAN_EMAIL = $self->_convert_charset($q->param("SHUDAN_EMAIL"));
			if ($SHUDAN_EMAIL == 1){$SHUDAN_EMAIL="OK";}else{$SHUDAN_EMAIL="";}
			my $SHUDAN_TEL = $self->_convert_charset($q->param("SHUDAN_TEL"));
			if ($SHUDAN_TEL == 1){$SHUDAN_TEL="OK";}else{$SHUDAN_TEL="";}
			my $RENRAKU_TIME = $self->_convert_charset($q->param("RENRAKU_TIME"));
		
			my $SHUDAN_FAX = $self->_convert_charset($q->param("SHUDAN_FAX"));
			if ($SHUDAN_FAX == 1){$SHUDAN_FAX="OK";}else{$SHUDAN_FAX="";}
			my $SHUDAN_YUBIN = $self->_convert_charset($q->param("SHUDAN_YUBIN"));
			if ($SHUDAN_YUBIN == 1){$SHUDAN_YUBIN="OK";}else{$SHUDAN_YUBIN="";}
		
			my $NINTI =$self->_convert_charset( join(',', $q->param("NINTI")));
			my $OPINION = $self->_convert_charset($q->param("OPINION"));
		
		
		
		
			if ($BUKKEN_SYUBETSU eq ""){
				$output .= ('物件種別が選択されていません。<br />');
			}
			if ((!$BUKKEN_AREA) && (!$BUKKEN_EKI)){
				$output .= ('物件エリア、または最寄駅が入力されていません。<br />');
			}
			if ($BUKKEN_YOSAN eq ""){
				$output .= ('ご希望の予算が入力されていません。<br />');
			}
			if ($MADORI_TYPE eq ""){
				$output .= ('間取りのタイプが選択されていません。<br />');
			}
			if ($MADORI_TYPE ne 'ワンルーム'){
				if ($MADORI eq ""){
					$output .= ('ご希望の間取が入力されていません。<br />');
				}
			}
			if ($YOTEI eq ""){
				$output .= ('ご希望の予定時期が選択されていません。<br />');
			}
			if ($NAME eq ""){
				$output .= ('お名前が入力されていません。<br />');
			}
			if ($NAME_KANA eq ""){
				$output .= ('お名前（カナ）が入力されていません。<br />');
			}
			if (($TEL eq "")||($TEL2 eq "")||($TEL3 eq "")){
				$output .= ('電話番号が入力されていません。<br />');
			}
		
			if (($YUBIN eq "")||($YUBIN2 eq "")){
				$output .= ('郵便番号が入力されていません。<br />');
			}
		
		
			if ($ADDRESS_TODOUFUKEN eq ""){
				$output .= ('ご住所（都道府県）が選択されていません。<br />');
			}
			if ($ADDRESS_SIKUCYOUSON eq ""){
				$output .= ('ご住所（市区町村）のが入力されていません。<br />');
			}
			if ($ADDRESS_CHYOUME eq ""){
				$output .= ('ご住所（丁目）が入力されていません。<br />');
			}
			if ($ADDRESS_BANCHI eq ""){
				$output .= ('ご住所（番地）が入力されていません。<br />');
			}
		
				#RENRAKU_TIME
		
			if ($SHUDAN_EMAIL eq "" && $SHUDAN_TEL eq "" && $SHUDAN_FAX eq "" && $SHUDAN_YUBIN eq ""){
				$output .= (' ご希望のご連絡方法が選択されていません。<br />');
			}
		
			if ($SHUDAN_EMAIL){
				if ($EMAIL eq ""){
					$output .= (' メールでの御連絡を選択されましたが、メールアドレスが入力されていません。<br />');
				}
			}
			
		
			if ($q->param("buy_ID") && $q->param("buy_address")){
		

				$texts .= "公開中の物件に関する問い合わせ： "."\n";
				$texts .= "物件住所: " . $q->param("buy_address")."\n";
				$texts .= "建築確認番号: " . $q->param("buy_ID")."\n\n------------------------------------------\n\n";
		
			}

			if ($q->param("_type") eq 'u'){
				$texts .="未公開物件情報の希望メールです。\n\n"
			}elsif($q->param("_type") eq 'b'){
				$texts .="購入物件の希望メールです。\n\n"
			}
		
			$texts .= "購入希望物件種別: " . $BUKKEN_SYUBETSU."\n";
			$texts .= "購入希望物件エリア: " . $BUKKEN_AREA."\n";
			$texts .= "物件駅: " . $BUKKEN_EKI."\n";
			$texts .= "物件エリア２: " . $BUKKEN_AREA_SECOND."\n";
			$texts .= "物件駅２: " . $BUKKEN_EKI_SECOND."\n";
		
			#$texts .= ": " .  ."\n";
		
			$texts .= "予算: " . $BUKKEN_YOSAN ."\n";
			$texts .= "マンションの場合の面積: " . $MENSEKI_MANSION ."\n";
			$texts .= "土地・戸建の場合の建物面積: " . $MENSEKI_TATEMONO ."\n";
			$texts .= "土地・戸建の場合の土地面積: " . $MENSEKI_TOCHI ."\n";
			$texts .= "間取: " . $MADORI ."\n";
			$texts .= "間取タイプ: " . $MADORI_TYPE ."\n";
			$texts .= "予定: " . $YOTEI ."\n";
			$texts .= "連絡先：\n";
			$texts .= "名前: " . $NAME ."\n";
			$texts .= "名前（カナ）: " . $NAME_KANA ."\n";
			$texts .= "メールアドレス: " . $EMAIL ."\n";
			$texts .= "電話番号: " . $TEL ."-".$TEL2."-".$TEL3."\n";
			$texts .= "郵便番号: " . $YUBIN ."-". $YUBIN2."\n";
			$texts .= "住所: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME." ".$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
			$texts .= "誕生日: " . $BIRTHDAY_Y ."年". $BIRTHDAY_M . "月" . $BIRTHDAY_D . "日". "\n";
			$texts .= "連絡手段:\n";
			$texts .= "   メール: " . $SHUDAN_EMAIL ."\n";
			$texts .= "   電話: " . $SHUDAN_TEL;
			$texts .= " - 時間帯: " . $RENRAKU_TIME ."\n";
			$texts .= "   Fax: " . $SHUDAN_FAX ."\n";
			$texts .= "   郵便: " . $SHUDAN_YUBIN ."\n";
			$texts .= "\n";
			$texts .= "どのようにして知りましたか: " . $NINTI ."\n";
			$texts .= "ご意見: " . $OPINION ."\n";
	
		


		###
		}elsif ($q->param("_type") eq 's') {
		####売却
		
			my $S_BUKKEN_SYUBETSU =  $self->_convert_charset($q->param("S_BUKKEN_SYUBETSU"));
			my $S_BUKKEN_S_NAME =  $self->_convert_charset($q->param("S_BUKKEN_S_NAME"));
			my $S_BUKKEN_KAI =  $self->_convert_charset($q->param("S_BUKKEN_KAI"));
			my $S_BUKKEN_KAIDATE =  $self->_convert_charset($q->param("S_BUKKEN_KAIDATE"));
		
		
			my $S_MENSEKI_MANSION =  $self->_convert_charset($q->param("S_MENSEKI_MANSION"));
			my $S_MENSEKI_TATEMONO =  $self->_convert_charset($q->param("S_MENSEKI_TATEMONO"));
			my $S_MENSEKI_TOCHI =  $self->_convert_charset($q->param("S_MENSEKI_TOCHI"));
			my $S_MADORI =  $self->_convert_charset($q->param("S_MADORI"));
			my $S_MADORI_TYPE =  $self->_convert_charset($q->param("S_MADORI_TYPE"));
		
		
			my $S_nengo =  $self->_convert_charset($q->param("S_nengo"));
			my $S_CHIKU_Y =  $self->_convert_charset($q->param("S_CHIKU_Y"));
			my $S_BUKKEN_AREA =  $self->_convert_charset($q->param("S_BUKKEN_AREA"));
			my $S_BUKKEN_EKI = join(',',  $self->_convert_charset($q->param("S_BUKKEN_EKI")));
		
			my $S_BUKKEN_ADDRESS1 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS1"));
			my $S_BUKKEN_ADDRESS2 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS2"));
			my $S_BUKKEN_ADDRESS3 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS3"));
			my $S_BUKKEN_ADDRESS4 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS4"));
		
			my $S_YOTEI =  $self->_convert_charset($q->param("S_YOTEI"));
			my $S_KIBOU_PRICE =  $self->_convert_charset($q->param("S_KIBOU_PRICE"));
			my $S_bus =  $self->_convert_charset($q->param("S_bus"));
			my $S_toho =  $self->_convert_charset($q->param("S_toho"));




			my $NAME = $self->_convert_charset($q->param("NAME"));
			my $NAME_KANA = $self->_convert_charset($q->param("NAME_KANA"));
			my $EMAIL = $self->_convert_charset($q->param("EMAIL"));
			my $TEL = $self->_convert_charset($q->param("TEL"));
			my $TEL2 = $self->_convert_charset($q->param("TEL2"));
			my $TEL3 = $self->_convert_charset($q->param("TEL3"));
			my $YUBIN = $self->_convert_charset($q->param("YUBIN"));
			my $YUBIN2 = $self->_convert_charset($q->param("YUBIN2"));
		
			my $ADDRESS_TODOUFUKEN = $self->_convert_charset($q->param("ADDRESS_TODOUFUKEN"));
			my $ADDRESS_SIKUCYOUSON = $self->_convert_charset($q->param("ADDRESS_SIKUCYOUSON"));
			my $ADDRESS_CHYOUME = $self->_convert_charset($q->param("ADDRESS_CHYOUME"));
			my $ADDRESS_BANCHI = $self->_convert_charset($q->param("ADDRESS_BANCHI"));
			my $ADDRESS_MANSYON = $self->_convert_charset($q->param("ADDRESS_MANSYON"));
		
			my $BIRTHDAY_Y = $self->_convert_charset($q->param("BIRTHDAY_Y"));
			my $BIRTHDAY_M = $self->_convert_charset($q->param("BIRTHDAY_M"));
			my $BIRTHDAY_D = $self->_convert_charset($q->param("BIRTHDAY_D"));
		
			my $SHUDAN_EMAIL = $self->_convert_charset($q->param("SHUDAN_EMAIL"));
			if ($SHUDAN_EMAIL == 1){$SHUDAN_EMAIL="OK";}else{$SHUDAN_EMAIL="";}
			my $SHUDAN_TEL = $self->_convert_charset($q->param("SHUDAN_TEL"));
			if ($SHUDAN_TEL == 1){$SHUDAN_TEL="OK";}else{$SHUDAN_TEL="";}
			my $RENRAKU_TIME = $self->_convert_charset($q->param("RENRAKU_TIME"));
		
			my $SHUDAN_FAX = $self->_convert_charset($q->param("SHUDAN_FAX"));
			if ($SHUDAN_FAX == 1){$SHUDAN_FAX="OK";}else{$SHUDAN_FAX="";}
			my $SHUDAN_YUBIN = $self->_convert_charset($q->param("SHUDAN_YUBIN"));
			if ($SHUDAN_YUBIN == 1){$SHUDAN_YUBIN="OK";}else{$SHUDAN_YUBIN="";}
		
			my $NINTI =$self->_convert_charset( join(',', $q->param("NINTI")));
			my $OPINION = $self->_convert_charset($q->param("OPINION"));

		
		
			if ($S_BUKKEN_SYUBETSU eq ""){
				$output .= ('物件種別が選択されていません。<br />');
			}
			if ((!$S_BUKKEN_AREA) && (!$S_BUKKEN_EKI)){
				$output .= ('物件エリア、または最寄駅が入力されていません。<br />');
			}
		
			if ($S_YOTEI eq ""){
				$output .= ('ご希望の予定時期が選択されていません。<br />');
			}


			if ($NAME eq ""){
				$output .= ('お名前が入力されていません。<br />');
			}
			if ($NAME_KANA eq ""){
				$output .= ('お名前（カナ）が入力されていません。<br />');
			}
			if ($TEL eq ""){
				$output .= ('電話番号が入力されていません。<br />');
			}
			if ($TEL2 eq ""){
				$output .= ('電話番号が入力されていません。<br />');
			}
			if ($TEL3 eq ""){
				$output .= ('電話番号が入力されていません。<br />');
			}
			if ($YUBIN eq ""){
				$output .= ('郵便番号が入力されていません。<br />');
			}
			if ($YUBIN2 eq ""){
				$output .= ('郵便番号が入力されていません。<br />');
			}
		
			if ($ADDRESS_TODOUFUKEN eq ""){
				$output .= ('ご住所（都道府県）が選択されていません。<br />');
			}
			if ($ADDRESS_SIKUCYOUSON eq ""){
				$output .= ('ご住所（市区町村）のが入力されていません。<br />');
			}
			if ($ADDRESS_CHYOUME eq ""){
				$output .= ('ご住所（丁目）が入力されていません。<br />');
			}
			if ($ADDRESS_BANCHI eq ""){
				$output .= ('ご住所（番地）が入力されていません。<br />');
			}

			if ($SHUDAN_EMAIL eq "" && $SHUDAN_TEL eq "" && $SHUDAN_FAX eq "" && $SHUDAN_YUBIN eq ""){
				$output .= (' ご希望のご連絡方法が選択されていません。<br />');
			}
		
			if ($SHUDAN_EMAIL){
				if ($EMAIL eq ""){
					$output .= (' メールでの御連絡を選択されましたが、メールアドレスが入力されていません。<br />');
				}
			}

			if ($q->param("_type") eq 's'){
				$texts .="売却物件の希望メールです。\n\n"
			}
			
			$texts .= "売却希望物件種別: " . $S_BUKKEN_SYUBETSU."\n";
		
			$texts .= "売却希望物件名称: " . $S_BUKKEN_S_NAME ."\n";
			$texts .= "    " .$S_BUKKEN_KAIDATE . "階建ての" . $S_BUKKEN_KAI . "階" ."\n";
			$texts .= "マンションの場合の面積: " . $S_MENSEKI_MANSION ."\n";
			$texts .= "土地・戸建の場合の建物面積: " . $S_MENSEKI_TATEMONO ."\n";
			$texts .= "土地・戸建の場合の土地面積: " . $S_MENSEKI_TOCHI ."\n";
			$texts .= "間取: " . $S_MADORI ."\n";
			$texts .= "間取タイプ: " . $S_MADORI_TYPE ."\n";
			$texts .= "築年: " . $S_nengo . $S_CHIKU_Y ."\n";
		
			$texts .= "物件エリア: " . $S_BUKKEN_AREA."\n";
			$texts .= "物件駅: " . $S_BUKKEN_EKI."\n";
		
			$texts .= "予定: " . $S_YOTEI ."\n";
			#$texts .= ": " .  ."\n";
		
		
			$texts .= "連絡先\n";
			$texts .= "   名前: " . $NAME ."\n";
			$texts .= "   名前（カナ）: " . $NAME_KANA ."\n";
			$texts .= "   メールアドレス: " . $EMAIL ."\n";
			$texts .= "   電話番号: " . $TEL ."-".$TEL2."\n";
			$texts .= "   郵便番号: " . $YUBIN ."-". $YUBIN2."\n";
			$texts .= "   住所: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME."\n";
			$texts .= "     " .$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
		
			$texts .= "   誕生日: " . $BIRTHDAY_Y ."年". $BIRTHDAY_M . "月" . $BIRTHDAY_D . "日". "\n";
			$texts .= "連絡手段:\n";
			$texts .= "    メール: " . $SHUDAN_EMAIL ."\n";
			$texts .= "    電話: " . $SHUDAN_TEL;
			$texts .= " - 時間帯: " . $RENRAKU_TIME ."\n";
			$texts .= "    Fax: " . $SHUDAN_FAX ."\n";
			$texts .= "    郵便: " . $SHUDAN_YUBIN ."\n";
			$texts .= "\n";
			$texts .= "どのようにして知りましたか: " . $NINTI ."\n";
			$texts .= "ご意見: " . $OPINION ."\n";




		####
		}elsif ($q->param("_type") eq 'c') {
		#####買い替え
			my $S_BUKKEN_SYUBETSU =  $self->_convert_charset($q->param("S_BUKKEN_SYUBETSU"));
			my $S_BUKKEN_S_NAME =  $self->_convert_charset($q->param("S_BUKKEN_S_NAME"));
			my $S_BUKKEN_KAI =  $self->_convert_charset($q->param("S_BUKKEN_KAI"));
			my $S_BUKKEN_KAIDATE =  $self->_convert_charset($q->param("S_BUKKEN_KAIDATE"));
		
		
			my $S_MENSEKI_MANSION =  $self->_convert_charset($q->param("S_MENSEKI_MANSION"));
			my $S_MENSEKI_TATEMONO =  $self->_convert_charset($q->param("S_MENSEKI_TATEMONO"));
			my $S_MENSEKI_TOCHI =  $self->_convert_charset($q->param("S_MENSEKI_TOCHI"));
			my $S_MADORI =  $self->_convert_charset($q->param("S_MADORI"));
			my $S_MADORI_TYPE =  $self->_convert_charset($q->param("S_MADORI_TYPE"));
		
		
			my $S_nengo =  $self->_convert_charset($q->param("S_nengo"));
			my $S_CHIKU_Y =  $self->_convert_charset($q->param("S_CHIKU_Y"));
			my $S_BUKKEN_AREA =  $self->_convert_charset($q->param("S_BUKKEN_AREA"));
			my $S_BUKKEN_EKI = join(',',  $self->_convert_charset($q->param("S_BUKKEN_EKI")));
		
			my $S_BUKKEN_ADDRESS1 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS1"));
			my $S_BUKKEN_ADDRESS2 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS2"));
			my $S_BUKKEN_ADDRESS3 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS3"));
			my $S_BUKKEN_ADDRESS4 =  $self->_convert_charset($q->param("S_BUKKEN_ADDRESS4"));
		
			my $S_YOTEI =  $self->_convert_charset($q->param("S_YOTEI"));
			my $S_KIBOU_PRICE =  $self->_convert_charset($q->param("S_KIBOU_PRICE"));
			my $S_bus =  $self->_convert_charset($q->param("S_bus"));
			my $S_toho =  $self->_convert_charset($q->param("S_toho"));

			#
			my $BUKKEN_SYUBETSU = $self->_convert_charset($q->param("BUKKEN_SYUBETSU"));
			my $BUKKEN_AREA = $self->_convert_charset($q->param("BUKKEN_AREA"));
			my $BUKKEN_EKI = $self->_convert_charset(join(',', $q->param("BUKKEN_EKI")));
			my $BUKKEN_AREA_SECOND = $self->_convert_charset($q->param("BUKKEN_AREA_SECOND"));
			my $BUKKEN_EKI_SECOND = $self->_convert_charset(join(',', $q->param("BUKKEN_EKI_SECOND")));
		
			my $BUKKEN_YOSAN = $self->_convert_charset($q->param("BUKKEN_YOSAN"));
			my $MENSEKI_MANSION =$self->_convert_charset( $q->param("MENSEKI_MANSION"));
			my $MENSEKI_TATEMONO = $self->_convert_charset($q->param("MENSEKI_TATEMONO"));
			my $MENSEKI_TOCHI = $self->_convert_charset($q->param("MENSEKI_TOCHI"));
			my $MADORI = $self->_convert_charset($q->param("MADORI"));
			my $MADORI_TYPE = $self->_convert_charset($q->param("MADORI_TYPE"));
			my $YOTEI = $self->_convert_charset($q->param("YOTEI"));

			#


			my $NAME = $self->_convert_charset($q->param("NAME"));
			my $NAME_KANA = $self->_convert_charset($q->param("NAME_KANA"));
			my $EMAIL = $self->_convert_charset($q->param("EMAIL"));
			my $TEL = $self->_convert_charset($q->param("TEL"));
			my $TEL2 = $self->_convert_charset($q->param("TEL2"));
			my $TEL3 = $self->_convert_charset($q->param("TEL3"));
			my $YUBIN = $self->_convert_charset($q->param("YUBIN"));
			my $YUBIN2 = $self->_convert_charset($q->param("YUBIN2"));
		
			my $ADDRESS_TODOUFUKEN = $self->_convert_charset($q->param("ADDRESS_TODOUFUKEN"));
			my $ADDRESS_SIKUCYOUSON = $self->_convert_charset($q->param("ADDRESS_SIKUCYOUSON"));
			my $ADDRESS_CHYOUME = $self->_convert_charset($q->param("ADDRESS_CHYOUME"));
			my $ADDRESS_BANCHI = $self->_convert_charset($q->param("ADDRESS_BANCHI"));
			my $ADDRESS_MANSYON = $self->_convert_charset($q->param("ADDRESS_MANSYON"));
		
			my $BIRTHDAY_Y = $self->_convert_charset($q->param("BIRTHDAY_Y"));
			my $BIRTHDAY_M = $self->_convert_charset($q->param("BIRTHDAY_M"));
			my $BIRTHDAY_D = $self->_convert_charset($q->param("BIRTHDAY_D"));
		
			my $SHUDAN_EMAIL = $self->_convert_charset($q->param("SHUDAN_EMAIL"));
			if ($SHUDAN_EMAIL == 1){$SHUDAN_EMAIL="OK";}else{$SHUDAN_EMAIL="";}
			my $SHUDAN_TEL = $self->_convert_charset($q->param("SHUDAN_TEL"));
			if ($SHUDAN_TEL == 1){$SHUDAN_TEL="OK";}else{$SHUDAN_TEL="";}
			my $RENRAKU_TIME = $self->_convert_charset($q->param("RENRAKU_TIME"));
		
			my $SHUDAN_FAX = $self->_convert_charset($q->param("SHUDAN_FAX"));
			if ($SHUDAN_FAX == 1){$SHUDAN_FAX="OK";}else{$SHUDAN_FAX="";}
			my $SHUDAN_YUBIN = $self->_convert_charset($q->param("SHUDAN_YUBIN"));
			if ($SHUDAN_YUBIN == 1){$SHUDAN_YUBIN="OK";}else{$SHUDAN_YUBIN="";}
		
			my $NINTI =$self->_convert_charset( join(',', $q->param("NINTI")));
			my $OPINION = $self->_convert_charset($q->param("OPINION"));


	
			if ($S_BUKKEN_SYUBETSU eq ""){
				$output .= ('物件種別が選択されていません。<br />');
			}
			if ((!$S_BUKKEN_AREA) && (!$S_BUKKEN_EKI)){
				$output .= ('物件エリア、または最寄駅が入力されていません。<br />');
			}
		
			if ($S_YOTEI eq ""){
				$output .= ('ご希望の予定時期が選択されていません。<br />');
			}
		
			#

			if ($BUKKEN_SYUBETSU eq ""){
				$output .= ('物件種別が選択されていません。<br />');
			}
			if ((!$BUKKEN_AREA) && (!$BUKKEN_EKI)){
				$output .= ('物件エリア、または最寄駅が入力されていません。<br />');
			}
			if ($BUKKEN_YOSAN eq ""){
				$output .= ('ご希望の予算が入力されていません。<br />');
			}
			if ($MADORI_TYPE eq ""){
				$output .= ('ご希望の間取りタイプが入力されていません。<br />');
			}

			if ($MADORI_TYPE ne 'ワンルーム'){
				if ($MADORI eq ""){
					$output .= ('ご希望の間取が入力されていません。<br />');
				}
			}
			if ($MADORI eq ""){
				$output .= ('ご希望の間取が入力されていません。<br />');
			}
			if ($YOTEI eq ""){
				$output .= ('ご希望の予定時期が選択されていません。<br />');
			}



			if ($NAME eq ""){
				$output .= ('お名前が入力されていません。<br />');
			}
			if ($NAME_KANA eq ""){
				$output .= ('お名前（カナ）が入力されていません。<br />');
			}
			if (($TEL eq "")||($TEL2 eq "")||($TEL3 eq "")){
				$output .= ('電話番号が入力されていません。<br />');
			}
		
			if (($YUBIN eq "")||($YUBIN2 eq "")){
				$output .= ('郵便番号が入力されていません。<br />');
			}
		
			if ($ADDRESS_TODOUFUKEN eq ""){
				$output .= ('ご住所（都道府県）が選択されていません。<br />');
			}
			if ($ADDRESS_SIKUCYOUSON eq ""){
				$output .= ('ご住所（市区町村）のが入力されていません。<br />');
			}
			if ($ADDRESS_CHYOUME eq ""){
				$output .= ('ご住所（丁目）が入力されていません。<br />');
			}
			if ($ADDRESS_BANCHI eq ""){
				$output .= ('ご住所（番地）が入力されていません。<br />');
			}

			if ($SHUDAN_EMAIL eq "" && $SHUDAN_TEL eq "" && $SHUDAN_FAX eq "" && $SHUDAN_YUBIN eq ""){
				$output .= (' ご希望のご連絡方法が選択されていません。<br />');
			}
		
			if ($SHUDAN_EMAIL){
				if ($EMAIL eq ""){
					$output .= (' メールでの御連絡を選択されましたが、メールアドレスが入力されていません。<br />');
				}
			}

			if ($q->param("_type") eq 'c'){
				$texts .="買い替えの希望メールです。\n\n"
			}
			
			$texts .= "売却物件種別: " . $S_BUKKEN_SYUBETSU."\n";
		
			$texts .= "売却物件名称: " . $S_BUKKEN_S_NAME ."\n";
			$texts .= "    " .$S_BUKKEN_KAIDATE . "階建ての" . $S_BUKKEN_KAI . "階" ."\n";
			$texts .= "マンションの場合の面積: " . $S_MENSEKI_MANSION ."\n";
			$texts .= "土地・戸建の場合の建物面積: " . $S_MENSEKI_TATEMONO ."\n";
			$texts .= "土地・戸建の場合の土地面積: " . $S_MENSEKI_TOCHI ."\n";
			$texts .= "間取: " . $S_MADORI ."\n";
			$texts .= "間取タイプ: " . $S_MADORI_TYPE ."\n";
			$texts .= "築年: " . $S_nengo . $S_CHIKU_Y ."\n";
		
			$texts .= "物件エリア: " . $S_BUKKEN_AREA."\n";
			$texts .= "物件駅: " . $S_BUKKEN_EKI."\n";
		
			$texts .= "予定: " . $S_YOTEI ."\n";

			#
			$texts .= "\n\n";

			$texts .= "購入物件種別: " . $BUKKEN_SYUBETSU."\n";
			$texts .= "物件エリア: " . $BUKKEN_AREA."\n";
			$texts .= "物件駅: " . $BUKKEN_EKI."\n";
			$texts .= "物件エリア２: " . $BUKKEN_AREA_SECOND."\n";
			$texts .= "物件駅２: " . $BUKKEN_EKI_SECOND."\n";
		
			#$texts .= ": " .  ."\n";
		
			$texts .= "予算: " . $BUKKEN_YOSAN ."\n";
			$texts .= "マンションの場合の面積: " . $MENSEKI_MANSION ."\n";
			$texts .= "土地・戸建の場合の建物面積: " . $MENSEKI_TATEMONO ."\n";
			$texts .= "土地・戸建の場合の土地面積: " . $MENSEKI_TOCHI ."\n";
			$texts .= "間取: " . $MADORI ."\n";
			$texts .= "間取タイプ: " . $MADORI_TYPE ."\n";
			$texts .= "予定: " . $YOTEI ."\n";
			$texts .= "連絡先：\n";
			$texts .= "名前: " . $NAME ."\n";
			$texts .= "名前（カナ）: " . $NAME_KANA ."\n";
			$texts .= "メールアドレス: " . $EMAIL ."\n";
			$texts .= "電話番号: " . $TEL ."-".$TEL2."-".$TEL3."\n";
			$texts .= "郵便番号: " . $YUBIN ."-". $YUBIN2."\n";
			$texts .= "住所: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME." ".$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
			$texts .= "誕生日: " . $BIRTHDAY_Y ."年". $BIRTHDAY_M . "月" . $BIRTHDAY_D . "日". "\n";
			$texts .= "連絡手段:\n";
			$texts .= "   メール: " . $SHUDAN_EMAIL ."\n";
			$texts .= "   電話: " . $SHUDAN_TEL;
			$texts .= " - 時間帯: " . $RENRAKU_TIME ."\n";
			$texts .= "   Fax: " . $SHUDAN_FAX ."\n";
			$texts .= "   郵便: " . $SHUDAN_YUBIN ."\n";
			$texts .= "\n";
			$texts .= "どのようにして知りましたか: " . $NINTI ."\n";
			$texts .= "ご意見: " . $OPINION ."\n";
	
		

		}else{
			die 'no type specified.';
		}

		#-

		if ($output){
			$output = "<div class=\"warning\">$output<a href=\"javascript:history.back()\">戻る</a></div>";
		}else{

			#$send
            require REPS::Search::Inquiry;
            require REPS::Settings;
            require REPS::User;
			my $mail = REPS::Search::Inquiry->new($self);
			my $usr = REPS::User->new($self);
			my $Settings = REPS::Settings->new($self);
			
			my $tmp_settings_info = $Settings->get_settings_contact_info();
		
			#$mail->{'MAIL_TO'} = $$tmp_settings_info{'COMPANY_EMAIL'};
						if ($$tmp_settings_info{'COMPANY_SALE_EMAIL'}){
							$mail->{'MAIL_TO'} = $$tmp_settings_info{'COMPANY_SALE_EMAIL'};
						}else{
							$mail->{'MAIL_TO'} = $$tmp_settings_info{'COMPANY_EMAIL'};
						}
						if ($$tmp_settings_info{'COMPANY_SEND_BBC_ADMIN_EMAIL'}){
							$mail->{'MAIL_BCC'} = $usr->get_admin_mailaddress;
						}

			#$mail->{'MAIL_BCC'} =
			$mail->{'MAIL_SUBJECT'} = '[売買]お問い合わせです。 ';
			if (!$mail->{'MAIL_TO'}){die "no email adress is provided.";}
			$mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
			$mail->{'MAIL_TEXT'} .= "ホームページ経由でお問い合わせがありました。\n$texts";
			$result = $mail->send;
			if ($result != 1){
				$output .= $result;
			}

			if ($output){
				$output .= "<div class=\"warning\">$output</div>";
			}

			$output .= "<div class=\"information\">送信完了。<br />ありがとうございました。</div>";
			$output .= '<br /><br />';
		}
		###########

		$showForm = 0;
	}else{
		#display form
		if ($q->param("_type") eq 'b') {
			$form_buy_on = "1";
		}elsif ($q->param("_type") eq 's') {
			$form_sell_on = "1";
		}elsif ($q->param("_type") eq 'c') {
			$form_change_on = "1";

		}else{
			die 'no type specified.';
		}
		$showForm = 1;

	}

		$template = $self->load_tmpl(
				'site_bs_inquiry.tmpl'
			);
		$template->param(

			#script_name  => $script_name,

			page_charset 		=> $self->cfg('charset'),
			site_url 			=> $self->cfg('site_url'),
			cgi_url			=> $self->cfg('cgi_url'),
			script_name 		=> $script_name,
			show_form		=> $showForm,
			page_data    		=> $output,
			type_b				=> $form_buy_on,
			type_s				=> $form_sell_on,
			type_c				=> $form_change_on,

			);

	return $template->output;
}


sub show_inquiry{
	my $self = shift;
	my $q = $self->query();
	my $output = "";
	my $mailHTML;
	my $template;
	my $result;
	my $showForm;
    my $frommailaddress;
    my $tomailaddress;
    my $tobccmailaddress;

	if ($q->param("submit_Inquiry")){

		if ($q->param("c_email")){
			if ($q->param("c_email") =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
			}else{
				$output .= 'メールアドレスの形式が不正です。'."<br />";
			}
		}

		if ((!$q->param("c_email")) && (!$q->param("c_phone"))){
			$output .= '連絡先を（メールアドレスか電話番号どちらか）入力してください。'."<br />";
		}

		if (!$q->param("c_name")){
			$output .= 'お手数ですが、お名前を入力してください。'."<br />";
		}
		if (!$q->param("c_text")){
			$output .= 'お問い合わせ内容がありません。'."<br />";
		}

		if ($q->param("contact_pref") == 1){
			if (!$q->param("c_email")){
				$output .= 'メールアドレスを入力してください。'."<br />";
			}
		}
		if ($q->param("contact_pref") == 2){
			if (!$q->param("c_phone")){
				$output .= '電話番号を入力してください。'."<br />";
			}
		}

		if ($output){
			$output = "<div class=\"warning\">$output<br /><a href=\"javascript:history.back()\">戻る</a></div>";
		}else{
            $frommailaddress = $self->_convert_charset($q->param("c_email"));
			$mailHTML .= '□差出人名:' . $self->_convert_charset($q->param("c_name"))."\n";
			$mailHTML .= '□電話番号:' . $self->_convert_charset($q->param("c_phone"))."\n";
			$mailHTML .= '□メールアドレス:' . $frommailaddress ."\n";	
			if ($q->param("contact_pref") == 1){
				$mailHTML .= "□連絡は、メールで。\n";	
			}elsif($q->param("contact_pref") == 2){
				$mailHTML .= "□連絡は、電話で。\n";	
			}elsif($q->param("contact_pref") == 3){
				$mailHTML .= "□連絡方法はメール、電話どちらでも。\n";
			}else{
				$mailHTML .= "□連絡方法不明。\n";
			}
			$mailHTML .= '□問い合わせ内容:'."\n--------------------\n" . $self->_convert_charset($q->param("c_text"))."\n\n--------------------\n";	

			#$send
            require REPS::Search::Inquiry;
            require REPS::Settings;
            require REPS::User;
			my $mail = REPS::Search::Inquiry->new($self);
			my $Settings = REPS::Settings->new($self);
			my $usr = REPS::User->new($self,'','','');
			my $tmp_settings_info = $Settings->get_settings_contact_info();

			if ($$tmp_settings_info{'COMPANY_GENERAL_EMAIL'}){
				$mail->{'MAIL_TO'} = $$tmp_settings_info{'COMPANY_GENERAL_EMAIL'};
			}else{
				$mail->{'MAIL_TO'} = $$tmp_settings_info{'COMPANY_EMAIL'};
			}
            $tomailaddress = $mail->{'MAIL_TO'};
			if ($$tmp_settings_info{'COMPANY_SEND_BBC_ADMIN_EMAIL'}){
				$mail->{'MAIL_BCC'} = $usr->get_admin_mailaddress;
			}
            $tobccmailaddress = $mail->{'MAIL_BCC'};

			$mail->{'MAIL_SUBJECT'} = '[一般]お問い合わせ';
			if (!$mail->{'MAIL_TO'}){die "no email adress is provided.";}
			$mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
			$mail->{'MAIL_TEXT'} .= "ホームページ経由でお問い合わせがありました。\n$mailHTML";
			$result = $mail->send;
			if ($result != 1){
				$output .= $result;
			}
#TODO: should I return here ??

            if ($output){
                $output .= "<div class=\"warning\">$output<br /><a href=\"javascript:history.back()\">戻る</a></div>";
            }else{

                #確認メールを問い合わせ元に送る
                my $result_comfirm = '';
                if (uc($self->cfg('send_confirmation')) eq 'ON') {
    
                    if ($frommailaddress =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                        my $mail_comfirm = REPS::Search::Inquiry->new($self);
                        $mail_comfirm->{'MAIL_FROM'} = $tomailaddress;
                        $mail_comfirm->{'MAIL_TO'} = $frommailaddress;
                        $mail_comfirm->{'MAIL_BCC'} = $tobccmailaddress;
                        $mail_comfirm->{'MAIL_SUBJECT'} = '[お問い合わせの確認] お問い合わせを受け付けました。';
                        $mail_comfirm->{'MAIL_TEXT'} = 'お問い合わせ頂きましてありがとうございます。本メールは、'."\n";
                        $mail_comfirm->{'MAIL_TEXT'} .= $self->cfg('site_url')."\n";
                        $mail_comfirm->{'MAIL_TEXT'} .= 'の問い合わせフォームより、自動で送られています。'."\n";
                        $mail_comfirm->{'MAIL_TEXT'} .= '担当者から返信があるまで今しばらくお待ちください。'."\n\n";

    
                        $result_comfirm = $mail_comfirm->send;
                    }
    
                }

                $output .= "<div class=\"information\">送信完了。<br />ありがとうございました。";
                if (uc($self->cfg('send_confirmation')) eq 'ON') {
                    if ($result_comfirm == 1){
                        if ($frommailaddress =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                            $output .= '<br /><br />なお、確認のメールを送信しましたので、半日程度経っても確認メールが届かなかった場合は、メールアドレスの確認をした上で、今一度お問い合わせ頂きたく思います。';
                        }

                    }
                }
                $output .= "</div>";
            }

			$output .= '<br /><br />';
		}
		$showForm = 0;
	}else{
		$showForm = 1;

	}

		$template = $self->load_tmpl(
				'site_inquiry.tmpl', die_on_bad_params => 0
			);
		$template->param(

			#script_name  => $script_name,

			page_charset 		=> $self->cfg('charset'),
			site_url 			=> $self->cfg('site_url'),
			cgi_url			=> $self->cfg('cgi_url'),
			script_name 		=> $script_name,
			show_form		=> $showForm,
			page_data    		=> $output,
			);

	return $template->output;

}

sub _convert_charset {
    my $self = shift;
    local($_) = shift;
    my $charset;
    if ($self->param('mobile')){
        $charset = uc($self->cfg('charset_mobile'));
    }else{
        $charset = uc($self->cfg('charset'));
    }
    require Unicode::Japanese;
    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {
        my $UJ = Unicode::Japanese->new();
        my $encode = $charmap->{$charset};
        return $UJ->set($_,$encode)->euc;
        #return Unicode::Japanese->new($_,$encode)->euc;
    }else{
        die "I don\'t understand your encoding ";
    }
}

sub _convert2htmlchars {
    local($_) = shift;
    # now do conversions from ?roff to sgml
    s/\&/\&amp;/g;
    s/</\&lt;/g;
    s/>/\&gt;/g;
    s/"/\&quot;/g;
    s/'/\&#39;/g;
    $_;
}

sub _get_datetime_now_string{
	my $self = shift;
	my $time = time;
	$time += 32400; #+9hour
	(my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday) = (gmtime($time))[0..6];

	$mon++;
	$year+=1900;
	my $datetime = sprintf('%04d/%02d/%02d %02d:%02d:%02d', $year, $mon, $mday, $hour, $min, $sec);
	return $datetime;
}


1
