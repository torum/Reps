package REPS::Settings;

use strict;
use REPS::Util;
use DB_File::Lock;

sub new{
    my ($class,$app,$id) = @_;
    my $self = {
        _app => $app,
        _lg_name => $id,
        _ref_hash => {
            'COMPANY_EMAIL' => '',
            'COMPANY_NAME' => '',
            'COMPANY_ADDRESS' => '',
            'COMPANY_WHO' => '',
            'COMPANY_TEL' => '',
            'COMPANY_LICENSE' => '',
            'COMPANY_RENT_EMAIL' => '',
            'COMPANY_SALE_EMAIL' => '',
            'COMPANY_GENERAL_EMAIL' => '',
            'COMPANY_SEND_BBC_ADMIN_EMAIL' => ''
            }
        };

    return bless $self,$class;
}


sub get_settings{
    my $self = shift;
    my %settings;

    my $db_path = $self->{_app}->param('db_settings_path');

    Carp::croak 'No ID param.' if (!$self->{_lg_name});

    if (-e $db_path){
        tie (%settings, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

            %{$self->{_ref_hash}} = %settings;

        untie %settings;
    }
    return 1;
}


sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();

    $self->{_ref_hash}{'COMPANY_EMAIL'} = $q->param("usr_profile_company_mail");
    $self->{_ref_hash}{'COMPANY_NAME'} = $q->param("usr_profile_company_name");
    $self->{_ref_hash}{'COMPANY_ADDRESS'} = $q->param("usr_profile_company_address");
    $self->{_ref_hash}{'COMPANY_WHO'} = $q->param("usr_profile_company_who");
    $self->{_ref_hash}{'COMPANY_TEL'} = $q->param("usr_profile_company_tel");
    $self->{_ref_hash}{'COMPANY_LICENSE'} = $q->param("usr_profile_company_license");

    $self->{_ref_hash}{'COMPANY_RENT_EMAIL'} = $q->param("usr_profile_rent_mail");
    $self->{_ref_hash}{'COMPANY_SALE_EMAIL'} = $q->param("usr_profile_sale_mail");
    $self->{_ref_hash}{'COMPANY_GENERAL_EMAIL'} = $q->param("usr_profile_general_mail");
    $self->{_ref_hash}{'COMPANY_SEND_BBC_ADMIN_EMAIL'} = $q->param("usr_profile_send_bbc_admin_mail");

    REPS::Util->convert_hash_charset($self->{_ref_hash},$self->{_app}->cfg('charset'));
    REPS::Util->convert_hash_zhk($self->{_ref_hash});

}

sub get_Settings_Form{
    my $self = shift;

    my $output = "";
    my $q = $self->{_app}->query();

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'),-name=>'settings_info');
    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        $output .= $q-> table( {-border => 1, class => 'main_table'},
                $q->Tr( {-align=>'left'}, 
                    $q->th({-align=>'left', -colspan=>2},"�����ƥ౿�Ĳ�Ҿ���") 
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"�᡼�륢�ɥ쥹�� "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_mail', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_EMAIL'}, -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'},
                        $q->td({-align=>'left', -colspan=>2},$q->checkbox(-name=>'usr_profile_send_bbc_admin_mail', -label=>'���٤Ƥ��䤤��碌�᡼��Υ��ԡ���BCC�Ǿ嵭�᡼�륢�ɥ쥹�������롣', -checked=>$self->{_ref_hash}{'COMPANY_SEND_BBC_ADMIN_EMAIL'})),
                ),
            );
    }else{
        $output .= $q-> table( {-border => 1, class => 'main_table'},
                $q->Tr( {-align=>'left'}, 
                    $q->th({-align=>'left', -colspan=>2},"��Ҿ���") 
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"���̾: "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_name', -default=>"", -value=>"$self->{_ref_hash}{'COMPANY_NAME'}", -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"����ϡ� "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_address', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_ADDRESS'}, -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"�ȵ��ֹ桧 "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_license', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_LICENSE'}, -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"������̾�� "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_who', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_WHO'}, -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"�����ֹ桧 "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_tel', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_TEL'}, -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right', -class=>'required'},"�᡼�륢�ɥ쥹�� "), 
                    $q->td($q->textfield(-name=>'usr_profile_company_mail', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_EMAIL'}, -size=>50, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
        
                        $q->td({-align=>'left', -colspan=>2},$q->checkbox(-name=>'usr_profile_send_bbc_admin_mail', -label=>'���٤Ƥ��䤤��碌�᡼��Υ��ԡ���BCC�Ǵ����԰������롣', -checked=>$self->{_ref_hash}{'COMPANY_SEND_BBC_ADMIN_EMAIL'})),
                ),
            ); 
    }
    $output .='<br />';
    #if not independent users
    if (uc($self->{_app}->cfg('independent_users')) ne 'ON') {
        $output .= $q-> table( {-border => 1, class => 'main_table'},
                $q->Tr( {-align=>'left'}, 
                    $q->th({-align=>'left', -colspan=>2},"�䤤��碌�᡼���������᡼�륢�ɥ쥹�����") 
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'left', -colspan=>2},"<small>����򤷤ʤ��Ȳ�Ҿ������Ͽ�����᡼�륢�ɥ쥹����������ޤ���</small>")
                ),
    
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right'},"����ʪ����䤤��碌�� "), 
                    $q->td($q->textfield(-name=>'usr_profile_rent_mail', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_RENT_EMAIL'}, -size=>30, -maxlength=>50)),
                ),
                $q->Tr( {-align=>'left'}, 
                    $q->td({-align=>'right'},"����ʪ����䤤��碌�� "), 
                    $q->td($q->textfield(-name=>'usr_profile_sale_mail', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_SALE_EMAIL'}, -size=>30, -maxlength=>50)),
                ),
#                $q->Tr( {-align=>'left'}, 
#                    $q->td({-align=>'right'},"����¾���̤��䤤��碌�� "), 
#                    $q->td($q->textfield(-name=>'usr_profile_general_mail', -default=>'', -value=>$self->{_ref_hash}{'COMPANY_GENERAL_EMAIL'}, -size=>30, -maxlength=>50)),
#                ),

#                $q->Tr( {-align=>'left'}, 
#                    $q->td({-align=>'left', -colspan=>2},$q->checkbox(-name=>'usr_profile_send_bbc_admin_mail', -label=>'�᡼��Υ��ԡ���BCC�Ǵ����԰������롣', -checked=>$self->{_ref_hash}{'COMPANY_SEND_BBC_ADMIN_EMAIL'})),
#                ),
            ); 
    }
    $output .= $q-> table( {-border => 1, class => 'main_table'},
            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'3',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_admin_settings'),
                    $q->submit(-name => 'update_settings' , -value =>'����', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        $output .= "<script type=\"text/javascript\"><!-- \ndocument.settings_info.usr_profile_company_mail.focus(); \n// --></script>";
    }else{
        $output .= "<script type=\"text/javascript\"><!-- \ndocument.settings_info.usr_profile_company_name.focus(); \n// --></script>";
    }
    return $output;
}

sub update_settings{

    my $self = shift;;
    my $result;

    if ($self->{_lg_name} eq ''){
        $result .= '������ID�����Ǥ������顼���������褦�Ǥ���<br />';
        return "<div class=\"warning\"><p>$result</p></div>";
    }
    if (uc($self->{_app}->cfg('independent_users')) ne 'ON') {
        if (!$self->{_ref_hash}{'COMPANY_NAME'}){$result .= '���̾�����Ϥ���Ƥ��ޤ���<br />';}
        if (!$self->{_ref_hash}{'COMPANY_ADDRESS'}){$result .= '��ҽ���Ϥ����Ϥ���Ƥ��ޤ���<br />';}

        if (!$self->{_ref_hash}{'COMPANY_TEL'}){$result .= '�����ֹ椬���Ϥ���Ƥ��ޤ���<br />';}
        if (!$self->{_ref_hash}{'COMPANY_LICENSE'}){$result .= '�ȵ��ֹ椬���Ϥ���Ƥ��ޤ���<br />';}
        if (!$self->{_ref_hash}{'COMPANY_WHO'}){$result .= 'ô����̾�����Ϥ���Ƥ��ޤ���<br />';}
    }

    unless  ($self->{_ref_hash}{'COMPANY_EMAIL'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
        $result .= '�᡼�륢�ɥ쥹�η����������Ǥ����᡼�륢�ɥ쥹�򤴳�ǧ����������<br />';
    }
    if ($self->{_ref_hash}{'COMPANY_RENT_EMAIL'} ne ''){
        unless  ($self->{_ref_hash}{'COMPANY_RENT_EMAIL'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
            $result .= '�᡼�륢�ɥ쥹�η����������Ǥ����᡼�륢�ɥ쥹�򤴳�ǧ����������<br />';
        }
    }
    if ($self->{_ref_hash}{'COMPANY_SALE_EMAIL'} ne ''){
        unless  ($self->{_ref_hash}{'COMPANY_SALE_EMAIL'} =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
            $result .= '�᡼�륢�ɥ쥹�η����������Ǥ����᡼�륢�ɥ쥹�򤴳�ǧ����������<br />';
        }
    }

    if ($self->{'_app'}->param('this_is_demo')){
        $result .= "�ǥ��ǤȤ���ư���Ƥ���Τǡ���������ޤ���";
    }

    if ($result){
        return "<div class=\"warning\"><p>$result</p></div>";
    }else{

        if ($self->{_app}->param('user_isAdmin') != 1){Carp::croak "You need to be an admin.";}

        my %settings;
        my $db_path = $self->{_app}->param('db_settings_path');
        
        tie (%settings, 'MLDBM', $db_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

            %settings = %{$self->{_ref_hash}};

        untie %settings;
        
        return $result;
    }
}

sub get_settings_contact_info {
    my $self = shift;
    my %settings;
    my $db_path = $self->{_app}->param('db_settings_path');

    my %hash;

    if (-e $db_path){
        tie (%settings, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
            %hash = (
                'COMPANY_RENT_EMAIL' => $settings{'COMPANY_RENT_EMAIL'},
                'COMPANY_SALE_EMAIL' => $settings{'COMPANY_SALE_EMAIL'},
                'COMPANY_GENERAL_EMAIL' => $settings{'COMPANY_GENERAL_EMAIL'},
                'COMPANY_SEND_BBC_ADMIN_EMAIL' => $settings{'COMPANY_SEND_BBC_ADMIN_EMAIL'},
                'COMPANY_EMAIL' => $settings{'COMPANY_EMAIL'}
            );
    
        untie %settings;
    }

    return \%hash;
}

sub get_settings_to_be_displayed {
    my $self = shift;
    my %settings;
    my $db_path = $self->{_app}->param('db_settings_path');

    my %hash;
    if (-e $db_path){
        tie (%settings, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
            %hash = (
                'COMPANY_NAME' => $settings{'COMPANY_NAME'},
                'COMPANY_TEL' => $settings{'COMPANY_TEL'},
                'COMPANY_ADDRESS' => $settings{'COMPANY_ADDRESS'},
                'COMPANY_LICENSE' => $settings{'COMPANY_LICENSE'},
                'COMPANY_EMAIL' => $settings{'COMPANY_EMAIL'}
            );
    
        untie %settings;
    }
    return \%hash;

}



1;
