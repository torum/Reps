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
		###����
	
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
				$output .= ('ʪ����̤����򤵤�Ƥ��ޤ���<br />');
			}
			if ((!$BUKKEN_AREA) && (!$BUKKEN_EKI)){
				$output .= ('ʪ�泌�ꥢ���ޤ��ϺǴ�ؤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($BUKKEN_YOSAN eq ""){
				$output .= ('����˾��ͽ�������Ϥ���Ƥ��ޤ���<br />');
			}
			if ($MADORI_TYPE eq ""){
				$output .= ('�ּ��Υ����פ����򤵤�Ƥ��ޤ���<br />');
			}
			if ($MADORI_TYPE ne '���롼��'){
				if ($MADORI eq ""){
					$output .= ('����˾�δּ褬���Ϥ���Ƥ��ޤ���<br />');
				}
			}
			if ($YOTEI eq ""){
				$output .= ('����˾��ͽ����������򤵤�Ƥ��ޤ���<br />');
			}
			if ($NAME eq ""){
				$output .= ('��̾�������Ϥ���Ƥ��ޤ���<br />');
			}
			if ($NAME_KANA eq ""){
				$output .= ('��̾���ʥ��ʡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if (($TEL eq "")||($TEL2 eq "")||($TEL3 eq "")){
				$output .= ('�����ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
		
			if (($YUBIN eq "")||($YUBIN2 eq "")){
				$output .= ('͹���ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
		
		
			if ($ADDRESS_TODOUFUKEN eq ""){
				$output .= ('���������ƻ�ܸ��ˤ����򤵤�Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_SIKUCYOUSON eq ""){
				$output .= ('������ʻԶ�Į¼�ˤΤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_CHYOUME eq ""){
				$output .= ('����������ܡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_BANCHI eq ""){
				$output .= ('����������ϡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
		
				#RENRAKU_TIME
		
			if ($SHUDAN_EMAIL eq "" && $SHUDAN_TEL eq "" && $SHUDAN_FAX eq "" && $SHUDAN_YUBIN eq ""){
				$output .= (' ����˾�Τ�Ϣ����ˡ�����򤵤�Ƥ��ޤ���<br />');
			}
		
			if ($SHUDAN_EMAIL){
				if ($EMAIL eq ""){
					$output .= (' �᡼��Ǥθ�Ϣ������򤵤�ޤ��������᡼�륢�ɥ쥹�����Ϥ���Ƥ��ޤ���<br />');
				}
			}
			
		
			if ($q->param("buy_ID") && $q->param("buy_address")){
		

				$texts .= "�������ʪ��˴ؤ����䤤��碌�� "."\n";
				$texts .= "ʪ�ｻ��: " . $q->param("buy_address")."\n";
				$texts .= "���۳�ǧ�ֹ�: " . $q->param("buy_ID")."\n\n------------------------------------------\n\n";
		
			}

			if ($q->param("_type") eq 'u'){
				$texts .="̤����ʪ�����δ�˾�᡼��Ǥ���\n\n"
			}elsif($q->param("_type") eq 'b'){
				$texts .="����ʪ��δ�˾�᡼��Ǥ���\n\n"
			}
		
			$texts .= "������˾ʪ�����: " . $BUKKEN_SYUBETSU."\n";
			$texts .= "������˾ʪ�泌�ꥢ: " . $BUKKEN_AREA."\n";
			$texts .= "ʪ���: " . $BUKKEN_EKI."\n";
			$texts .= "ʪ�泌�ꥢ��: " . $BUKKEN_AREA_SECOND."\n";
			$texts .= "ʪ��أ�: " . $BUKKEN_EKI_SECOND."\n";
		
			#$texts .= ": " .  ."\n";
		
			$texts .= "ͽ��: " . $BUKKEN_YOSAN ."\n";
			$texts .= "�ޥ󥷥��ξ�������: " . $MENSEKI_MANSION ."\n";
			$texts .= "���ϡ��ͷ��ξ��η�ʪ����: " . $MENSEKI_TATEMONO ."\n";
			$texts .= "���ϡ��ͷ��ξ�����������: " . $MENSEKI_TOCHI ."\n";
			$texts .= "�ּ�: " . $MADORI ."\n";
			$texts .= "�ּ西����: " . $MADORI_TYPE ."\n";
			$texts .= "ͽ��: " . $YOTEI ."\n";
			$texts .= "Ϣ���衧\n";
			$texts .= "̾��: " . $NAME ."\n";
			$texts .= "̾���ʥ��ʡ�: " . $NAME_KANA ."\n";
			$texts .= "�᡼�륢�ɥ쥹: " . $EMAIL ."\n";
			$texts .= "�����ֹ�: " . $TEL ."-".$TEL2."-".$TEL3."\n";
			$texts .= "͹���ֹ�: " . $YUBIN ."-". $YUBIN2."\n";
			$texts .= "����: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME." ".$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
			$texts .= "������: " . $BIRTHDAY_Y ."ǯ". $BIRTHDAY_M . "��" . $BIRTHDAY_D . "��". "\n";
			$texts .= "Ϣ�����:\n";
			$texts .= "   �᡼��: " . $SHUDAN_EMAIL ."\n";
			$texts .= "   ����: " . $SHUDAN_TEL;
			$texts .= " - ������: " . $RENRAKU_TIME ."\n";
			$texts .= "   Fax: " . $SHUDAN_FAX ."\n";
			$texts .= "   ͹��: " . $SHUDAN_YUBIN ."\n";
			$texts .= "\n";
			$texts .= "�ɤΤ褦�ˤ����Τ�ޤ�����: " . $NINTI ."\n";
			$texts .= "���ո�: " . $OPINION ."\n";
	
		


		###
		}elsif ($q->param("_type") eq 's') {
		####���
		
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
				$output .= ('ʪ����̤����򤵤�Ƥ��ޤ���<br />');
			}
			if ((!$S_BUKKEN_AREA) && (!$S_BUKKEN_EKI)){
				$output .= ('ʪ�泌�ꥢ���ޤ��ϺǴ�ؤ����Ϥ���Ƥ��ޤ���<br />');
			}
		
			if ($S_YOTEI eq ""){
				$output .= ('����˾��ͽ����������򤵤�Ƥ��ޤ���<br />');
			}


			if ($NAME eq ""){
				$output .= ('��̾�������Ϥ���Ƥ��ޤ���<br />');
			}
			if ($NAME_KANA eq ""){
				$output .= ('��̾���ʥ��ʡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($TEL eq ""){
				$output .= ('�����ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
			if ($TEL2 eq ""){
				$output .= ('�����ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
			if ($TEL3 eq ""){
				$output .= ('�����ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
			if ($YUBIN eq ""){
				$output .= ('͹���ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
			if ($YUBIN2 eq ""){
				$output .= ('͹���ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
		
			if ($ADDRESS_TODOUFUKEN eq ""){
				$output .= ('���������ƻ�ܸ��ˤ����򤵤�Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_SIKUCYOUSON eq ""){
				$output .= ('������ʻԶ�Į¼�ˤΤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_CHYOUME eq ""){
				$output .= ('����������ܡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_BANCHI eq ""){
				$output .= ('����������ϡˤ����Ϥ���Ƥ��ޤ���<br />');
			}

			if ($SHUDAN_EMAIL eq "" && $SHUDAN_TEL eq "" && $SHUDAN_FAX eq "" && $SHUDAN_YUBIN eq ""){
				$output .= (' ����˾�Τ�Ϣ����ˡ�����򤵤�Ƥ��ޤ���<br />');
			}
		
			if ($SHUDAN_EMAIL){
				if ($EMAIL eq ""){
					$output .= (' �᡼��Ǥθ�Ϣ������򤵤�ޤ��������᡼�륢�ɥ쥹�����Ϥ���Ƥ��ޤ���<br />');
				}
			}

			if ($q->param("_type") eq 's'){
				$texts .="���ʪ��δ�˾�᡼��Ǥ���\n\n"
			}
			
			$texts .= "��Ѵ�˾ʪ�����: " . $S_BUKKEN_SYUBETSU."\n";
		
			$texts .= "��Ѵ�˾ʪ��̾��: " . $S_BUKKEN_S_NAME ."\n";
			$texts .= "    " .$S_BUKKEN_KAIDATE . "�����Ƥ�" . $S_BUKKEN_KAI . "��" ."\n";
			$texts .= "�ޥ󥷥��ξ�������: " . $S_MENSEKI_MANSION ."\n";
			$texts .= "���ϡ��ͷ��ξ��η�ʪ����: " . $S_MENSEKI_TATEMONO ."\n";
			$texts .= "���ϡ��ͷ��ξ�����������: " . $S_MENSEKI_TOCHI ."\n";
			$texts .= "�ּ�: " . $S_MADORI ."\n";
			$texts .= "�ּ西����: " . $S_MADORI_TYPE ."\n";
			$texts .= "��ǯ: " . $S_nengo . $S_CHIKU_Y ."\n";
		
			$texts .= "ʪ�泌�ꥢ: " . $S_BUKKEN_AREA."\n";
			$texts .= "ʪ���: " . $S_BUKKEN_EKI."\n";
		
			$texts .= "ͽ��: " . $S_YOTEI ."\n";
			#$texts .= ": " .  ."\n";
		
		
			$texts .= "Ϣ����\n";
			$texts .= "   ̾��: " . $NAME ."\n";
			$texts .= "   ̾���ʥ��ʡ�: " . $NAME_KANA ."\n";
			$texts .= "   �᡼�륢�ɥ쥹: " . $EMAIL ."\n";
			$texts .= "   �����ֹ�: " . $TEL ."-".$TEL2."\n";
			$texts .= "   ͹���ֹ�: " . $YUBIN ."-". $YUBIN2."\n";
			$texts .= "   ����: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME."\n";
			$texts .= "     " .$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
		
			$texts .= "   ������: " . $BIRTHDAY_Y ."ǯ". $BIRTHDAY_M . "��" . $BIRTHDAY_D . "��". "\n";
			$texts .= "Ϣ�����:\n";
			$texts .= "    �᡼��: " . $SHUDAN_EMAIL ."\n";
			$texts .= "    ����: " . $SHUDAN_TEL;
			$texts .= " - ������: " . $RENRAKU_TIME ."\n";
			$texts .= "    Fax: " . $SHUDAN_FAX ."\n";
			$texts .= "    ͹��: " . $SHUDAN_YUBIN ."\n";
			$texts .= "\n";
			$texts .= "�ɤΤ褦�ˤ����Τ�ޤ�����: " . $NINTI ."\n";
			$texts .= "���ո�: " . $OPINION ."\n";




		####
		}elsif ($q->param("_type") eq 'c') {
		#####�㤤�ؤ�
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
				$output .= ('ʪ����̤����򤵤�Ƥ��ޤ���<br />');
			}
			if ((!$S_BUKKEN_AREA) && (!$S_BUKKEN_EKI)){
				$output .= ('ʪ�泌�ꥢ���ޤ��ϺǴ�ؤ����Ϥ���Ƥ��ޤ���<br />');
			}
		
			if ($S_YOTEI eq ""){
				$output .= ('����˾��ͽ����������򤵤�Ƥ��ޤ���<br />');
			}
		
			#

			if ($BUKKEN_SYUBETSU eq ""){
				$output .= ('ʪ����̤����򤵤�Ƥ��ޤ���<br />');
			}
			if ((!$BUKKEN_AREA) && (!$BUKKEN_EKI)){
				$output .= ('ʪ�泌�ꥢ���ޤ��ϺǴ�ؤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($BUKKEN_YOSAN eq ""){
				$output .= ('����˾��ͽ�������Ϥ���Ƥ��ޤ���<br />');
			}
			if ($MADORI_TYPE eq ""){
				$output .= ('����˾�δּ�꥿���פ����Ϥ���Ƥ��ޤ���<br />');
			}

			if ($MADORI_TYPE ne '���롼��'){
				if ($MADORI eq ""){
					$output .= ('����˾�δּ褬���Ϥ���Ƥ��ޤ���<br />');
				}
			}
			if ($MADORI eq ""){
				$output .= ('����˾�δּ褬���Ϥ���Ƥ��ޤ���<br />');
			}
			if ($YOTEI eq ""){
				$output .= ('����˾��ͽ����������򤵤�Ƥ��ޤ���<br />');
			}



			if ($NAME eq ""){
				$output .= ('��̾�������Ϥ���Ƥ��ޤ���<br />');
			}
			if ($NAME_KANA eq ""){
				$output .= ('��̾���ʥ��ʡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if (($TEL eq "")||($TEL2 eq "")||($TEL3 eq "")){
				$output .= ('�����ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
		
			if (($YUBIN eq "")||($YUBIN2 eq "")){
				$output .= ('͹���ֹ椬���Ϥ���Ƥ��ޤ���<br />');
			}
		
			if ($ADDRESS_TODOUFUKEN eq ""){
				$output .= ('���������ƻ�ܸ��ˤ����򤵤�Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_SIKUCYOUSON eq ""){
				$output .= ('������ʻԶ�Į¼�ˤΤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_CHYOUME eq ""){
				$output .= ('����������ܡˤ����Ϥ���Ƥ��ޤ���<br />');
			}
			if ($ADDRESS_BANCHI eq ""){
				$output .= ('����������ϡˤ����Ϥ���Ƥ��ޤ���<br />');
			}

			if ($SHUDAN_EMAIL eq "" && $SHUDAN_TEL eq "" && $SHUDAN_FAX eq "" && $SHUDAN_YUBIN eq ""){
				$output .= (' ����˾�Τ�Ϣ����ˡ�����򤵤�Ƥ��ޤ���<br />');
			}
		
			if ($SHUDAN_EMAIL){
				if ($EMAIL eq ""){
					$output .= (' �᡼��Ǥθ�Ϣ������򤵤�ޤ��������᡼�륢�ɥ쥹�����Ϥ���Ƥ��ޤ���<br />');
				}
			}

			if ($q->param("_type") eq 'c'){
				$texts .="�㤤�ؤ��δ�˾�᡼��Ǥ���\n\n"
			}
			
			$texts .= "���ʪ�����: " . $S_BUKKEN_SYUBETSU."\n";
		
			$texts .= "���ʪ��̾��: " . $S_BUKKEN_S_NAME ."\n";
			$texts .= "    " .$S_BUKKEN_KAIDATE . "�����Ƥ�" . $S_BUKKEN_KAI . "��" ."\n";
			$texts .= "�ޥ󥷥��ξ�������: " . $S_MENSEKI_MANSION ."\n";
			$texts .= "���ϡ��ͷ��ξ��η�ʪ����: " . $S_MENSEKI_TATEMONO ."\n";
			$texts .= "���ϡ��ͷ��ξ�����������: " . $S_MENSEKI_TOCHI ."\n";
			$texts .= "�ּ�: " . $S_MADORI ."\n";
			$texts .= "�ּ西����: " . $S_MADORI_TYPE ."\n";
			$texts .= "��ǯ: " . $S_nengo . $S_CHIKU_Y ."\n";
		
			$texts .= "ʪ�泌�ꥢ: " . $S_BUKKEN_AREA."\n";
			$texts .= "ʪ���: " . $S_BUKKEN_EKI."\n";
		
			$texts .= "ͽ��: " . $S_YOTEI ."\n";

			#
			$texts .= "\n\n";

			$texts .= "����ʪ�����: " . $BUKKEN_SYUBETSU."\n";
			$texts .= "ʪ�泌�ꥢ: " . $BUKKEN_AREA."\n";
			$texts .= "ʪ���: " . $BUKKEN_EKI."\n";
			$texts .= "ʪ�泌�ꥢ��: " . $BUKKEN_AREA_SECOND."\n";
			$texts .= "ʪ��أ�: " . $BUKKEN_EKI_SECOND."\n";
		
			#$texts .= ": " .  ."\n";
		
			$texts .= "ͽ��: " . $BUKKEN_YOSAN ."\n";
			$texts .= "�ޥ󥷥��ξ�������: " . $MENSEKI_MANSION ."\n";
			$texts .= "���ϡ��ͷ��ξ��η�ʪ����: " . $MENSEKI_TATEMONO ."\n";
			$texts .= "���ϡ��ͷ��ξ�����������: " . $MENSEKI_TOCHI ."\n";
			$texts .= "�ּ�: " . $MADORI ."\n";
			$texts .= "�ּ西����: " . $MADORI_TYPE ."\n";
			$texts .= "ͽ��: " . $YOTEI ."\n";
			$texts .= "Ϣ���衧\n";
			$texts .= "̾��: " . $NAME ."\n";
			$texts .= "̾���ʥ��ʡ�: " . $NAME_KANA ."\n";
			$texts .= "�᡼�륢�ɥ쥹: " . $EMAIL ."\n";
			$texts .= "�����ֹ�: " . $TEL ."-".$TEL2."-".$TEL3."\n";
			$texts .= "͹���ֹ�: " . $YUBIN ."-". $YUBIN2."\n";
			$texts .= "����: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME." ".$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
			$texts .= "������: " . $BIRTHDAY_Y ."ǯ". $BIRTHDAY_M . "��" . $BIRTHDAY_D . "��". "\n";
			$texts .= "Ϣ�����:\n";
			$texts .= "   �᡼��: " . $SHUDAN_EMAIL ."\n";
			$texts .= "   ����: " . $SHUDAN_TEL;
			$texts .= " - ������: " . $RENRAKU_TIME ."\n";
			$texts .= "   Fax: " . $SHUDAN_FAX ."\n";
			$texts .= "   ͹��: " . $SHUDAN_YUBIN ."\n";
			$texts .= "\n";
			$texts .= "�ɤΤ褦�ˤ����Τ�ޤ�����: " . $NINTI ."\n";
			$texts .= "���ո�: " . $OPINION ."\n";
	
		

		}else{
			die 'no type specified.';
		}

		#-

		if ($output){
			$output = "<div class=\"warning\">$output<a href=\"javascript:history.back()\">���</a></div>";
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
			$mail->{'MAIL_SUBJECT'} = '[����]���䤤��碌�Ǥ��� ';
			if (!$mail->{'MAIL_TO'}){die "no email adress is provided.";}
			$mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
			$mail->{'MAIL_TEXT'} .= "�ۡ���ڡ�����ͳ�Ǥ��䤤��碌������ޤ�����\n$texts";
			$result = $mail->send;
			if ($result != 1){
				$output .= $result;
			}

			if ($output){
				$output .= "<div class=\"warning\">$output</div>";
			}

			$output .= "<div class=\"information\">������λ��<br />���꤬�Ȥ��������ޤ�����</div>";
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
				$output .= '�᡼�륢�ɥ쥹�η����������Ǥ���'."<br />";
			}
		}

		if ((!$q->param("c_email")) && (!$q->param("c_phone"))){
			$output .= 'Ϣ�����ʥ᡼�륢�ɥ쥹�������ֹ�ɤ��餫�����Ϥ��Ƥ���������'."<br />";
		}

		if (!$q->param("c_name")){
			$output .= '������Ǥ�������̾�������Ϥ��Ƥ���������'."<br />";
		}
		if (!$q->param("c_text")){
			$output .= '���䤤��碌���Ƥ�����ޤ���'."<br />";
		}

		if ($q->param("contact_pref") == 1){
			if (!$q->param("c_email")){
				$output .= '�᡼�륢�ɥ쥹�����Ϥ��Ƥ���������'."<br />";
			}
		}
		if ($q->param("contact_pref") == 2){
			if (!$q->param("c_phone")){
				$output .= '�����ֹ�����Ϥ��Ƥ���������'."<br />";
			}
		}

		if ($output){
			$output = "<div class=\"warning\">$output<br /><a href=\"javascript:history.back()\">���</a></div>";
		}else{
            $frommailaddress = $self->_convert_charset($q->param("c_email"));
			$mailHTML .= '�����п�̾:' . $self->_convert_charset($q->param("c_name"))."\n";
			$mailHTML .= '�������ֹ�:' . $self->_convert_charset($q->param("c_phone"))."\n";
			$mailHTML .= '���᡼�륢�ɥ쥹:' . $frommailaddress ."\n";	
			if ($q->param("contact_pref") == 1){
				$mailHTML .= "��Ϣ��ϡ��᡼��ǡ�\n";	
			}elsif($q->param("contact_pref") == 2){
				$mailHTML .= "��Ϣ��ϡ����äǡ�\n";	
			}elsif($q->param("contact_pref") == 3){
				$mailHTML .= "��Ϣ����ˡ�ϥ᡼�롢���äɤ���Ǥ⡣\n";
			}else{
				$mailHTML .= "��Ϣ����ˡ������\n";
			}
			$mailHTML .= '���䤤��碌����:'."\n--------------------\n" . $self->_convert_charset($q->param("c_text"))."\n\n--------------------\n";	

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

			$mail->{'MAIL_SUBJECT'} = '[����]���䤤��碌';
			if (!$mail->{'MAIL_TO'}){die "no email adress is provided.";}
			$mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
			$mail->{'MAIL_TEXT'} .= "�ۡ���ڡ�����ͳ�Ǥ��䤤��碌������ޤ�����\n$mailHTML";
			$result = $mail->send;
			if ($result != 1){
				$output .= $result;
			}
#TODO: should I return here ??

            if ($output){
                $output .= "<div class=\"warning\">$output<br /><a href=\"javascript:history.back()\">���</a></div>";
            }else{

                #��ǧ�᡼����䤤��碌��������
                my $result_comfirm = '';
                if (uc($self->cfg('send_confirmation')) eq 'ON') {
    
                    if ($frommailaddress =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                        my $mail_comfirm = REPS::Search::Inquiry->new($self);
                        $mail_comfirm->{'MAIL_FROM'} = $tomailaddress;
                        $mail_comfirm->{'MAIL_TO'} = $frommailaddress;
                        $mail_comfirm->{'MAIL_BCC'} = $tobccmailaddress;
                        $mail_comfirm->{'MAIL_SUBJECT'} = '[���䤤��碌�γ�ǧ] ���䤤��碌������դ��ޤ�����';
                        $mail_comfirm->{'MAIL_TEXT'} = '���䤤��碌ĺ���ޤ��Ƥ��꤬�Ȥ��������ޤ����ܥ᡼��ϡ�'."\n";
                        $mail_comfirm->{'MAIL_TEXT'} .= $self->cfg('site_url')."\n";
                        $mail_comfirm->{'MAIL_TEXT'} .= '���䤤��碌�ե������ꡢ��ư�������Ƥ��ޤ���'."\n";
                        $mail_comfirm->{'MAIL_TEXT'} .= 'ô���Ԥ����ֿ�������ޤǺ����Ф餯���Ԥ�����������'."\n\n";

    
                        $result_comfirm = $mail_comfirm->send;
                    }
    
                }

                $output .= "<div class=\"information\">������λ��<br />���꤬�Ȥ��������ޤ�����";
                if (uc($self->cfg('send_confirmation')) eq 'ON') {
                    if ($result_comfirm == 1){
                        if ($frommailaddress =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                            $output .= '<br /><br />�ʤ�����ǧ�Υ᡼����������ޤ����Τǡ�Ⱦ�����ٷФäƤ��ǧ�᡼�뤬�Ϥ��ʤ��ä����ϡ��᡼�륢�ɥ쥹�γ�ǧ�򤷤���ǡ������٤��䤤��碌ĺ�������פ��ޤ���';
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
