package REPS::User;

use strict;
use base qw( Class::ErrorHandler );
use DB_File::Lock;
use HTTP::Date;
use vars qw( %COOKIE );

sub new{
    my ($class,$app,$id,$pass) = @_;
    my $self = {
        _app => $app,
        _lg_name => $id,
        _lg_password => $pass,
        _ref_hash => {
            'PASSWORD' => '',
            'ADMIN' => 0,
            'USER_EMAIL' => '',
            'USER_WHO' => '',
            'COMPANY_NAME' => '',
            'COMPANY_ADDRESS' => '',
            'COMPANY_TEL' => '',
            'COMPANY_LICENSE' => '',
            'COMPANY_HP' => '',
            'PREF_PRICE_SIKIKIN_UNIT' => '',
            'PREF_PRICE_REIKIN_UNIT' => ''
            }
        };

    return bless $self,$class;
}

sub init_db {
    my ($self,$id,$newPass,$newPass_check) = @_;
    my %profile = ();
    my %hash;
    my $result;
    #setting up 
    my $db_path = $self->{_app}->param('db_usr_profile_path');
    if (-f $db_path){
        Carp::croak "The database already exists!";
    }

    if (!$id){$result .= 'IDが入力されていません。<br />';}
    unless ($id =~ /[0-9A-Za-z_]{4,18}/){$result .= 'IDの形式が不正です。半角英数字4文字以上18文字までです。<br />';}
    if ($newPass && $newPass_check){
        if ($newPass ne $newPass_check){

            $result .= '新しいパスワードが二つめの確認用パスワードと異なっています。<br />';
        }else{
            if ($newPass =~ /[0-9A-Za-z_]{8,20}/){
                #$newPass = $newPass;
            }else{
                $result .= 'パスワードの形式が不正です。半角英数字8文字以上20文字までです。<br />';
            }
        }
    }else{
        $result .= 'パスワードが入力されていません。<br />';
    }

    if ($result){
        return "<div class=\"warning\"><p>$result</p></div>";
    }else{
        #create usr db
        $self->{_ref_hash}{'PASSWORD'} = $self->_hash2($newPass);
my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%profile, 'MLDBM', $db_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, &_writeLocking($db_path)) or Carp::croak $!;#
        $self->{_ref_hash}{ADMIN} = 1;

        $profile{$id} = $self->{_ref_hash};
        untie %profile;
umask($old);
        $result .= "<div class=\"information\"><p>セットアップ完了しました。<br />設定したユーザー名とパスワードでログインし、<a href=\"".$self->{_app}->param('script_name')."?_mode=mode_admin_settings\">会社情報</a>と<a href=\"".$self->{_app}->param('script_name')."?_mode=mode_profile\">ユーザー情報</a>を設定してください。</p></div>";
    }
}

sub auth{
    my $self = shift;
    my $result;
    if (($self->{_lg_name} eq '') || ($self->{_lg_password} eq '')){ $result = 0;return $result;}

    my $pass = $self->get_pass_from_id($self->{_lg_name});
    if ($pass eq $self->_hash2($self->{_lg_password})){
        $result = 1;
    }else{
        $result = 0;
    }
    return $result;
}

sub auth_from_Cookie{
    my ($self) = @_;
    my $digest;

    #for mod_perl. Var has to be initialized.
    %COOKIE = ();

    $self->_getCookie();
    if (!$COOKIE{'reps_user'}){
        return 0;
    }
    my $cookie = $COOKIE{'reps_user'};

    $cookie=~s/%([0-9a-f][0-9a-f])/pack("C",hex($1))/egi; #decode http encoded cookie string
    my ($cookieName, $hash, $datetime) = split(/\|/,$cookie);

    $self->{_lg_name} = $cookieName;
    $self->{_app}->param('user_id'=>$cookieName);

    if ((!$cookieName) or (!$hash) or (!$datetime)) {
        return 0;
    }

    #check if too old

    #datetime from cookie
    my ($year1, $month1, $mday1, $hour1, $min1, $sec1, $tz) = HTTP::Date::parse_date( $datetime );
    my $datetime_cookie = sprintf('%04d-%02d-%02dT%02d:%02d:%02d%s', $year1, $month1, $mday1, $hour1, $min1, $sec1, $tz);

    #datetime now
    my $time = time;
    $time += 32400; #+9hour
    (my $sec2,my $min2,my $hour2,my $mday2,my $month2,my $year2,my $wday2) = (gmtime($time))[0..6];
    $month2++;
    $year2+=1900;
    my $datetime_now = sprintf('%04d-%02d-%02dT%02d:%02d:%02d+09:00', $year2, $month2, $mday2, $hour2, $min2, $sec2);

    #Delta_Days
    my $dd;
    my $module = 'Date::Calc';
    if ($module->require) {
        $dd = Date::Calc::Delta_Days(sprintf('%04d',$year1),sprintf('%02d',$month1),sprintf('%02d',$mday1),sprintf('%04d',$year2),sprintf('%02d',$month2),sprintf('%02d',$mday2));
    }else{
        $module = 'Date::Pcalc';
        if ($module->require) { 
            $dd = Date::Pcalc::Delta_Days(sprintf('%04d',$year1),sprintf('%02d',$month1),sprintf('%02d',$mday1),sprintf('%04d',$year2),sprintf('%02d',$month2),sprintf('%02d',$mday2));
        }else{
            Carp::croak "Error loading Date::Pcalc module.";
        }
    }

    #need to be much shorter (like 3 hours)
    if (($dd > 30)) {
        return 0;;
    }

    my $pass = $self->get_pass_from_id($self->{_lg_name});
    if (!$pass){
        return 0;
    }

    my $module = 'Digest::SHA1';
    if ($module->require) {
        $digest = Digest::SHA1::sha1_base64("$pass" . "$datetime");
    }else{

        if ($] >= 5.006) {
            require Digest::SHA::PurePerl;
            $digest = Digest::SHA::PurePerl::sha1_base64($_); #need to fix, but it breaks previous users
        }else{
            require Digest::MD5;
            $digest = Digest::MD5::md5_base64($_); #need to fix, but it breaks previous users
        }

    }

    if ($hash eq $digest) {
        return 1;
    }else{
        return 0;
    }
}

sub create_hash{
    my $self = shift;
    my $digest;
    if (($self->{_lg_name} eq '') || ($self->{_lg_password} eq '')) {Carp::croak 'Need an ID or a password'};
    
    my $time = time;
    $time += 32400; #+9hour
    (my $sec,my $min,my $hour,my $mday,my $mon,my $year,my $wday) = (gmtime($time))[0..6];
    $mon++;
    $year+=1900;
    my $datetime = sprintf('%04d-%02d-%02dT%02d:%02d:%02d+09:00', $year, $mon, $mday, $hour, $min, $sec);


    my $module = 'Digest::SHA1';
    if ($module->require) {
        $digest = Digest::SHA1::sha1_base64($self->_hash2($self->{_lg_password}).$datetime);
    }else{
        if ($] >= 5.006) {
            require Digest::SHA::PurePerl;
            $digest = Digest::SHA::PurePerl::sha1_base64($_);#need to fix, but it breaks previous users
        }else{
            require Digest::MD5;
            $digest = Digest::MD5::md5_base64($_);#need to fix, but it breaks previous users
        }
    }

    return $digest.'|'.$datetime;
}

sub get_pass_from_id{
    my ($self,$id) = @_;
    my $pass;
    my $ref_hash;
    my %hash = ();
    my %profile;
    my $db_path = $self->{_app}->param('db_usr_profile_path');
    

    tie (%profile, 'MLDBM', $db_path, O_RDONLY, 0660,$DB_BTREE,&_readLocking($db_path)) or Carp::croak $!;

    if (exists $profile{$id}){
        $pass = $profile{$id}{'PASSWORD'};
        if ($profile{$id}{'ADMIN'} == 1){
            $self->{_app}->param('user_isAdmin' => 1);
        }
        #check 
        if (!$profile{$id}{'USER_EMAIL'}){
            $self->{_app}->param('user_info_needed' => 1);
        }
        #set pref setting
        $self->{_app}->param('user_pref_price_sikikin_unit'=>$profile{$id}{'PREF_PRICE_SIKIKIN_UNIT'});
        $self->{_app}->param('user_pref_price_reikin_unit'=>$profile{$id}{'PREF_PRICE_REIKIN_UNIT'});

    }else{
        $pass='';
    }
    untie %profile;

    return $pass;
}

sub get_Profile{
    my $self = shift;
    my %profile;

    my $db_path = $self->{_app}->param('db_usr_profile_path');

    Carp::croak 'No ID param.' if (!$self->{_lg_name});
    if (-e $db_path){

        tie (%profile, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, &_readLocking($db_path)) or Carp::croak $!;
        if (exists $profile{$self->{_lg_name}}){

            $self->{_ref_hash} = $profile{$self->{_lg_name}};
        }else{
            untie %profile;
            Carp::croak 'The ID does not exists.';

        }
        untie %profile;
    }else{
        Carp::croak "データベースが存在していません。";
    }
    return 1;
}

sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();
    
    $self->{_ref_hash}{'PASSWORD'} = '';
    $self->{_ref_hash}{'ADMIN'} = 0;
    $self->{_ref_hash}{'USER_EMAIL'} = $q->param("usr_profile_company_mail");
    $self->{_ref_hash}{'USER_WHO'} = $q->param("usr_profile_company_who");

    $self->{_ref_hash}{'COMPANY_NAME'} = $q->param("usr_profile_company_name");
    $self->{_ref_hash}{'COMPANY_ADDRESS'} = $q->param("usr_profile_company_address");
    $self->{_ref_hash}{'COMPANY_TEL'} = $q->param("usr_profile_company_tel");
    $self->{_ref_hash}{'COMPANY_LICENSE'} = $q->param("usr_profile_company_license");
    $self->{_ref_hash}{'COMPANY_HP'} = $q->param("usr_profile_company_HP_address");


    $self->{_ref_hash}{'PREF_PRICE_SIKIKIN_UNIT'} = $q->param("pref_price_sikikin_unit");
    $self->{_ref_hash}{'PREF_PRICE_REIKIN_UNIT'} = $q->param("pref_price_reikin_unit");

    REPS::Util->convert_hash_charset($self->{_ref_hash},$self->{_app}->cfg('charset'));
    REPS::Util->convert_hash_zhk($self->{_ref_hash});
}

sub get_Profile_Form{
    my $self = shift;
    my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'),-name=>'user');

    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        $output .= $q-> table( {-border => 1, class => 'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->th({-align=>'left', -colspan=>2},"ユーザー会社情報") 
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"ID: "), 
                $q->td($self->{_app}->param('user_id')), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"パスワード"), 
                $q->td($q->password_field(-name=>'usr_profile_password', -default=>'', -size=>50, -maxlength=>50)),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"新パスワード（変更時のみ）："), 
                $q->td($q->password_field(-name=>'usr_profile_password_new', -default=>'', -size=>50, -maxlength=>50)),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"新パスワード（確認のため）："), 
                $q->td($q->password_field(-name=>'usr_profile_password_new_check', -default=>'', -size=>50, -maxlength=>50)),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"会社名: "), 
                $q->td($q->textfield(-name=>'usr_profile_company_name', -default=>"", -value=>"$self->{_ref_hash}{'COMPANY_NAME'}", -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"所在地： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_address', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_ADDRESS'}, -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"免許番号： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_license', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_LICENSE'}, -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"ホームページアドレス： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_HP_address', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_HP'}, -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"担当者名： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_who', -default=>'', -value=>$self->{_ref_hash}{'USER_WHO'}, -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"電話番号： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_tel', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_TEL'}, -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"メールアドレス： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_mail', -default=>'', -value=>$self->{_ref_hash}{'USER_EMAIL'}, -size=>50, -maxlength=>50)),
            ),

        ); 

    }else{

        $output .= $q-> table( {-border => 1, class => 'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"ID: "), 
                $q->td($self->{_app}->param('user_id')), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"パスワード"), 
                $q->td($q->password_field(-name=>'usr_profile_password', -default=>'', -size=>50, -maxlength=>50)),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"新パスワード（変更時のみ）："), 
                $q->td($q->password_field(-name=>'usr_profile_password_new', -default=>'', -size=>50, -maxlength=>50)),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"新パスワード（確認のため）："), 
                $q->td($q->password_field(-name=>'usr_profile_password_new_check', -default=>'', -size=>50, -maxlength=>50)),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"担当者名： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_who', -default=>'', -value=>$self->{_ref_hash}{'USER_WHO'}, -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"メールアドレス： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_mail', -default=>'', -value=>$self->{_ref_hash}{'USER_EMAIL'}, -size=>50, -maxlength=>50)),
            ),
        ); 
    }
    $output .= $q-> table( {-border => 1, class => 'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->th({-align=>'left', -colspan=>2},"お好みの初期値") 
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'left', -colspan=>2},
                        '&nbsp;&nbsp;&nbsp;&nbsp;敷金の単位の初期値は、',
                        $q->popup_menu(-name=>'pref_price_sikikin_unit', 
                            -default=>$$ref_hash{'PREF_PRICE_SIKIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'}),'にしておく。',

                ) 
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'left', -colspan=>2},
                        '&nbsp;&nbsp;&nbsp;&nbsp;礼金の単位の初期値は、',
                        $q->popup_menu(-name=>'pref_price_reikin_unit', 
                            -default=>$$ref_hash{'PREF_PRICE_REIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'}),'にしておく。',

                ) 
            ),

             $q->Tr( {-align=>'center', -valign=>'middle'}, 
                $q->td({colspan=>'3',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_profile'),
                    $q->submit(-name => 'update_usr_profile' , -value =>'更新', -class=>'submit')
                )
            )   
        );
    $output .= $q->end_form();

    $output .= "<script type=\"text/javascript\"><!-- \ndocument.user.usr_profile_password.focus(); \n// --></script>";

    return $output;
}

sub update_profile{

    my($self,$oldPass,$newPass,$newPass_check) = @_;
    my $result;

    if ($self->{_lg_name} eq ''){
        $result .= 'ログインIDが空です。エラーが起きたようです。<br />';
        return "<div class=\"warning\"><p>$result</p></div>";
        exit(0);
    }

    if (!$oldPass){$result .= 'パスワードが入力されていません。<br />';}

#check pass!
#   if (!$oldPass){$result .= 'パスワードが入力されていません。<br />';}

    if (!$self->{_ref_hash}{'USER_WHO'}){$result .= '担当者名が入力されていません。<br />';}
    unless  ($self->{_ref_hash}{'USER_EMAIL'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
        $result .= 'メールアドレスの形式が不正です。メールアドレスをご確認ください。<br />';
    }
    if ($newPass || $newPass_check){
        if ($newPass ne $newPass_check){
            $result .= '新しいパスワードが二つめの確認用パスワードと異なっています。<br />';
        }else{
            if ($newPass =~ /[0-9A-Za-z_]{8,20}/){
                #$newPass = $newPass;
            }else{
                $result .= 'パスワードの形式が不正です。半角英数字8文字以上20文字までです。<br />';
            }
        }

    }

    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        if (!$self->{_ref_hash}{'COMPANY_NAME'}){$result .= '会社名が入力されていません。<br />';}
        if (!$self->{_ref_hash}{'COMPANY_ADDRESS'}){$result .= '会社所在地が入力されていません。<br />';}
        if (!$self->{_ref_hash}{'COMPANY_TEL'}){$result .= '電話番号が入力されていません。<br />';}
        if (!$self->{_ref_hash}{'COMPANY_LICENSE'}){$result .= '免許番号が入力されていません。<br />';}
    }

    if ($self->{'_app'}->param('this_is_demo')){
        $result .= "デモ版として動いているので、更新されません。";
    }

    if ($result){
        return "<div class=\"warning\"><p>$result</p></div>";
    }else{

        my $pass = $self->get_pass_from_id($self->{_lg_name});
        if (($pass) && ($pass eq $self->_hash2($oldPass))){

            my $admin;
            if ($self->{_app}->param('user_isAdmin') == 1){$admin = 1;}else{$admin = 0;}
            my $status;
            my %profile;
            my $db_path = $self->{_app}->param('db_usr_profile_path');

            tie (%profile, 'MLDBM', $db_path, O_RDWR, 0660, $DB_BTREE, &_writeLocking($db_path)) or Carp::croak $!;
            if (!exists($profile{$self->{_lg_name}})){
                $result .= 'このIDは存在していません。<br />';
                $status = 0;
            }else{
                if (($newPass) && ($pass ne $self->_hash2($newPass))){
                    $self->{_ref_hash}{'PASSWORD'} = $self->_hash2($newPass);
                    #update cooke?
                }else{
                    $self->{_ref_hash}{'PASSWORD'} = $pass;
                }
                $self->{_ref_hash}{'ADMIN'} = $admin;

                $profile{$self->{_lg_name}} = $self->{_ref_hash};

                #update pref setting. Do I need this?
                $self->{_app}->param('user_pref_price_sikikin_unit'=>$self->{_ref_hash}{'PREF_PRICE_SIKIKIN_UNIT'});
                $self->{_app}->param('user_pref_price_reikin_unit'=>$self->{_ref_hash}{'PREF_PRICE_REIKIN_UNIT'});


                $status = 1;
            }
    
            untie %profile; 

            if($status != 1){
                $result = "<div class=\"warning\"><p>$result<br />更新されませんでした。</p></div>";
            }
        
            return $result;
            
        }else{
            $result = "<div class=\"warning\"><p>パスワードが違います。</p></div>";
        }
        return $result;
    }
}

sub get_Admin_Create_Profile_Form{
    my $self = shift;
    my $usr_id= $_[0];
    my $output = "";
    my $q = $self->{_app}->query();
    $output .= $q->start_form(-action => $self->{_app}->param('script_name'),-name=>'c_user');
    $output .= $q-> table( {-border => 1, class => 'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"ユーザーID: "), 
                $q->td($q->textfield(-name=>'usr_profile_id_new', -default=>"", -value=>"$usr_id", -size=>50, -maxlength=>50)), 
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"パスワード："), 
                $q->td($q->password_field(-name=>'usr_profile_password_new', -default=>'', -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"パスワード(確認)："), 
                $q->td($q->password_field(-name=>'usr_profile_password_new_check', -default=>'', -size=>50, -maxlength=>50)),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"担当者名： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_who', -default=>'', -value=>"$self->{_ref_hash}{'USER_WHO'}", -size=>50, -maxlength=>50)),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"メールアドレス： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_mail', -default=>'', -value=>"$self->{_ref_hash}{'USER_EMAIL'}", -size=>50, -maxlength=>50)),
            ),
            $q->Tr( {-align=>'center', -valign=>'middle'}, 
                $q->td({colspan=>'3',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_admin_addUser'),
                    $q->submit(-name => 'add_usr_profile' , -value =>'追加', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.c_user.usr_profile_id_new.focus(); \n// --></script>";
    return $output;
}

sub create_profile{

    my($self,$newID,$newPass,$newPass_check) = @_;
    my $result;

    if ($self->{_app}->param('user_isAdmin') != 1){
        $result .= 'You do not have admin privilege<br />';
        return "<div class=\"warning\"><p>$result</p></div>";
    }

    if (!$newID){$result .= 'IDが入力されていません。<br />';}
    unless ($newID =~ /[0-9A-Za-z_]{4,18}/){$result .= 'IDの形式が不正です。半角英数字4文字以上18文字までです。<br />';}

    if (!$self->{_ref_hash}{'USER_WHO'}){$result .= '担当者名が入力されていません。<br />';}

    unless  ($self->{_ref_hash}{'USER_EMAIL'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
        $result .= 'メールアドレスの形式が不正です。メールアドレスをご確認ください。<br />';
    }
    
    if ($newPass && $newPass_check){
        if ($newPass ne $newPass_check){
            $result .= '新しいパスワードが二つめの確認用パスワードと異なっています。<br />';
        }else{
            if ($newPass =~ /[0-9A-Za-z_]{8,20}/){
                #$newPass = $newPass;
            }else{
                $result .= 'パスワードの形式が不正です。半角英数字8文字以上20文字までです。<br />';
            }
        }
    }else{
        $result .= 'パスワードが入力されていません。<br />';
    }
    if ($result){
        return "<div class=\"warning\"><p>$result</p></div>";
    }else{
        my $status;
        my %profile;
        my $db_path = $self->{_app}->param('db_usr_profile_path');

        tie (%profile, 'MLDBM', $db_path, O_RDWR, 0660, $DB_BTREE, &_writeLocking($db_path)) or Carp::croak $!;
        if (exists($profile{$newID})){
            $result .= 'このIDはすでに存在しています。<br />';
            $status = 0;
        }else{

            $self->{_ref_hash}{'PASSWORD'} = $self->_hash2($newPass);
            $self->{_ref_hash}{'ADMIN'} = 0;
            $profile{$newID} = $self->{_ref_hash};

            $status = 1;
            $self->{_lg_name} = $newID;
        }

        untie %profile;

        if($status != 1){
            $result = "<div class=\"warning\"><p>$result<br />ユーザーの追加に失敗しました。</p></div>";
        }
    
        return $result;
    }

}

sub get_usr_list{
    my $self = shift;
    my %profile;
    my %hash = ();
    my %tmp;
    my $key;
    my $value;
    my @loop_data;
    my $db_path = $self->{_app}->param('db_usr_profile_path');

    if (-e $db_path){

        tie (%profile, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, &_readLocking($db_path)) or Carp::croak $!;

        while ( ($key, $value) = each(%profile) ) {

            my %tmp = %$value;
            my %hash = (
                'ID' =>$key,
                'USER_WHO' => $tmp{'USER_WHO'}
            );
            push(@loop_data, \%hash);

        }

        untie %profile;
    }else{
        Carp::croak "データベースが存在していません。";
    }
    return \@loop_data;
}

sub get_UserProfile_Form{
    my $self = shift;
    my $output = "";
    my $q = $self->{_app}->query();

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'),-name=>'user');
    $output .= $q-> table( {-border => 1, class => 'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"ID: "), 
                $q->td($q->textfield(-name=>'usr_profile_company_name', -default=>"", -value=>$q->param("_usr_id"), -size=>50, -maxlength=>50)), 
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"担当者名： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_who', -default=>'', -value=>$self->{_ref_hash}{'USER_WHO'}, -size=>50, -maxlength=>50)),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"メールアドレス： "), 
                $q->td($q->textfield(-name=>'usr_profile_company_mail', -default=>'', -value=>$self->{_ref_hash}{'USER_EMAIL'}, -size=>50, -maxlength=>50)),
            )

        ); 


    $output .= $q->end_form();
    
    return $output;

}

sub delete_profile{
    my $self = shift;
    my @to_be_deleted = @_;
    my %profile;
    my $db_path = $self->{_app}->param('db_usr_profile_path');

    if ($self->{'_app'}->param('this_is_demo')){
        return 0;
    }

    tie (%profile, 'MLDBM', $db_path, O_RDWR, 0660, $DB_BTREE, &_writeLocking($db_path)) or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9A-Za-z_]{4,18}/){
            if ($self->{_lg_name} ne $_){
                delete $profile{$_};
            }
        }
    }

    untie %profile;

    return 1;
}


sub get_usr_to_be_displayed{
    my $self = shift;
    my $usr_id = $_[0];
    my %profile;
    my $db_path = $self->{_app}->param('db_usr_profile_path');

    my %hash;

    if (!$usr_id){Carp::croak "No ID provided.";}

    tie (%profile, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        if (exists $profile{$usr_id}){
            %hash = (
                'USER_EMAIL' => $profile{$usr_id}{'USER_EMAIL'},
                'USER_WHO' => $profile{$usr_id}{'USER_WHO'}
            );
        }

    untie %profile;

    return \%hash;

}

sub get_settings_to_be_displayed {
    my $self = shift;
    my @to_be_displayed = @_;
    my %settings;
    my $db_path = $self->{_app}->param('db_usr_profile_path');

    my $ref_hash;

    if (-e $db_path){
        tie (%settings, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        foreach (@to_be_displayed){
            if ($_ =~ /[0-9A-Za-z_]{4,18}/){
    
                if (exists $settings{$_}){
                    my %hash = (
                        'COMPANY_NAME' => $settings{$_}{'COMPANY_NAME'},
                        'COMPANY_TEL' => $settings{$_}{'COMPANY_TEL'},
                        'COMPANY_ADDRESS' => $settings{$_}{'COMPANY_ADDRESS'},
                        'COMPANY_LICENSE' => $settings{$_}{'COMPANY_LICENSE'},
                        'COMPANY_HP' => $settings{$_}{'COMPANY_HP'},
                        'USER_EMAIL' => $settings{$_}{'USER_EMAIL'}
                    );
                    $$ref_hash{$_} = \%hash;
                }
            }
        }
        untie %settings;
    }
    return $ref_hash;

}

sub get_admin_mailaddress{
    my $self = shift;
    my %profile;
    my $key;
    my $value;

    my $db_path = $self->{_app}->param('db_usr_profile_path');

    my $admin_mailaddress;

    if (-e $db_path){

        tie (%profile, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, &_readLocking($db_path)) or Carp::croak $!;

        while ( ($key, $value) = each(%profile) ) {
            if ($profile{$key}{'ADMIN'} == 1){
                $admin_mailaddress = $profile{$key}{'USER_EMAIL'};
                last;
            }
        }

        untie %profile;

    }
    return $admin_mailaddress;
}

sub _hash2{
    my $self = shift;
    local($_) = shift;

    my $module = 'Digest::SHA1';
    my $digest;
    if ($module->require) {
        $digest = Digest::SHA1::sha1_base64($_);
    }else{

        if ($] >= 5.006) {
            require Digest::SHA::PurePerl;
            $digest = Digest::SHA::PurePerl::sha1_base64($_);
        }else{
            require Digest::MD5;
            $digest = Digest::MD5::md5_base64($_);
        }

    }
    return $digest;
}

sub _getCookie {
    my $self = shift;
    my ($xx, $name, $value);
    if (defined($ENV{'HTTP_COOKIE'})){
        for $xx (split(/; */, $ENV{'HTTP_COOKIE'})) {
            ($name, $value) = split(/=/, $xx);
            $COOKIE{$name} = $value;
        }
    }
}

sub _readLocking {
    my $ReadLocking = {
        mode            => "read",
        nonblocking     => 0,
        lockfile_name   => $_[0] . ".lock",
        lockfile_mode   => 0600,
    };
}
sub _writeLocking {
    my $WriteLocking = {
        mode            => "write",
        nonblocking     => 0,
        lockfile_name   => $_[0] . ".lock",
        lockfile_mode   => 0600,
    };
}




1;
