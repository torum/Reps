package REPS::CMS;

use strict;

use base qw( REPS CGI::Application );
#require REPS;
#require CGI::Application;
#use vars qw(@ISA);
#@ISA = qw( REPS CGI::Application);


use CGI::Application::Plugin::Redirect;
use CGI::Carp;
use File::Spec;
use File::Path;
use FindBin qw( $RealBin );
use URI::URL;

#use DB_File::Lock;
#use Fcntl;
use REPS::Util;
use REPS::User;
use REPS::Settings;


#change use to require
#use REPS::CMS::Realestate::R_Apartment;
#use REPS::CMS::Realestate::R_Business;
#use REPS::CMS::Realestate::B_Land;
#use REPS::CMS::Realestate::B_Mansion;
#use REPS::CMS::Realestate::B_House;
#use REPS::CMS::Search;
#use REPS::CMS::Backup;
#use REPS::CMS::InExport::CSV;


use vars qw( $script_name );

sub setup {
    my $self = shift;
    $self->run_modes(
        'mode_init'                   => 'show_init',
        'mode_main'                   => 'show_main',
        'mode_logout'                 => 'show_logout',
        'mode_add'                    => 'show_add',
        'mode_list'                   => 'show_list',
        'mode_edit'                   => 'show_edit',
        'mode_search'                 => 'show_search',
        'mode_profile'                => 'show_profile',
        'mode_admin_setting'          => 'show_admin_setting',
        'mode_admin_addUser'          => 'show_admin_addUser',
        'mode_admin_showUsers_list'   => 'show_admin_showUsers_list',
        'mode_admin_showUser_profile' => 'show_admin_showUser_profile',
        'mode_admin_showUser_items'   => 'show_admin_showUser_items',
        'mode_admin_inexport'         => 'show_admin_inexport',

        'mode_admin_settings'         => 'show_admin_settings',
        'mode_admin_batch'            => 'show_admin_batch',
        'mode_admin_backup'           => 'show_admin_backup'
    );

    my $q = $self->query();

    #workaround for Cobalt (BlueQuartz)
    if (my $path_info = $ENV{PATH_INFO}) {
        if ($path_info =~ m/\.cgi$/) {
            delete $ENV{PATH_INFO};
        }
    }
    $script_name = $q->url;#$ENV{'SCRIPT_NAME'};

    $self->param('script_name'=>$script_name);

    #convert it to full path
    $self->tmpl_path(File::Spec->catdir($RealBin, 'system/templates'));
    #$self->tmpl_path($Bin.'/system/templates/');

    $self->start_mode('mode_main');
    $self->mode_param('_mode');

    #init params
    $self->param('user_id'=>'');
    $self->param('user_logged_in'=>0);
    $self->param('user_isAdmin'=>0);
    $self->param('user_info_needed'=>0);

    $self->param('user_pref_price_sikikin_unit'=>0);
    $self->param('user_pref_price_reikin_unit'=>0);

    require REPS; #for older version of perl.

    if (uc($self->cfg('this_is_demo')) eq 'ON'){
        $self->param('this_is_demo'=>1);
    }else{
        $self->param('this_is_demo'=>0);
    }

    if (uc($self->cfg('r_visible')) ne 'OFF'){$self->param('r_visible'=>1);}
    if (uc($self->cfg('rl_visible')) ne 'OFF'){$self->param('rl_visible'=>1);}
    if (uc($self->cfg('rb_visible')) ne 'OFF'){$self->param('rb_visible'=>1);}
    if (uc($self->cfg('b_visible')) ne 'OFF'){$self->param('b_visible'=>1);}
    if (uc($self->cfg('bl_visible')) ne 'OFF'){$self->param('bl_visible'=>1);}
    if (uc($self->cfg('bm_visible')) ne 'OFF'){$self->param('bm_visible'=>1);}
    if (uc($self->cfg('bh_visible')) ne 'OFF'){$self->param('bh_visible'=>1);}
    if (uc($self->cfg('bb_visible')) ne 'OFF'){$self->param('bb_visible'=>1);}



    #TODO: db driver specific
    $self->param('db_usr_profile_path' => $self->cfg('db_path') . 'usr_profile.db');
    $self->param('db_settings_path' => $self->cfg('db_path') . 'usr_settings.db');

    $self->param('db_r_apart_path' => $self->cfg('db_path') . 'rl.db');
    $self->param('db_r_apart_access_path' => $self->cfg('db_path') . 'rl_access.db');
    $self->param('db_r_apart_inquiry_path' => $self->cfg('db_path') . 'rl_inquiry.db');
    $self->param('db_r_apart_special_path' => $self->cfg('db_path') . 'rl_recommend.db');

    $self->param('db_r_business_path' => $self->cfg('db_path') . 'rb.db');
    $self->param('db_r_business_access_path' => $self->cfg('db_path') . 'rb_access.db');
    $self->param('db_r_business_inquiry_path' => $self->cfg('db_path') . 'rb_inquiry.db');

    $self->param('db_b_land_path' => $self->cfg('db_path') . 'bl.db');
    $self->param('db_b_land_access_path' => $self->cfg('db_path') . 'bl_access.db');
    $self->param('db_b_land_inquiry_path' => $self->cfg('db_path') . 'bl_inquiry.db');

    $self->param('db_b_mansion_path' => $self->cfg('db_path') . 'bm.db');
    $self->param('db_b_mansion_access_path' => $self->cfg('db_path') . 'bm_access.db');
    $self->param('db_b_mansion_inquiry_path' => $self->cfg('db_path') . 'bm_inquiry.db');

    $self->param('db_b_house_path' => $self->cfg('db_path') . 'bh.db');
    $self->param('db_b_house_access_path' => $self->cfg('db_path') . 'bh_access.db');
    $self->param('db_b_house_inquiry_path' => $self->cfg('db_path') . 'bh_inquiry.db');

    $self->param('db_b_business_path' => $self->cfg('db_path') . 'bb.db');
    $self->param('db_b_business_access_path' => $self->cfg('db_path') . 'bb_access.db');
    $self->param('db_b_business_inquiry_path' => $self->cfg('db_path') . 'bb_inquiry.db');


    #if no-chache, IE forgets everything a user input in textfields. So don't no-cache here.
    #IE だと、cacheを無効にすると、POST後にブラウザのBackしても、空になってしまうため、Cacheはここでは指定しない。
    #Opera keeps reading pages from cache even if you posted (kinda stupid). So make sure no-cache especially in the main page and the login page(reps.cgi).
    #Operaだと、cacheを無効にしないと、直前の画面(ログイン画面reps.cgi)をcacheから読み込むため、問題がある。だから必要な所はそこだけ、cacheを無効にするように。

   $self->header_props(
       -charset=>$self->cfg('charset'),
       -type => 'text/html'
       #-expires=>'now',
       #-pragma=>'no-cache',
       #-cache_control=>'no-cache'
   );
}

sub cgiapp_prerun {
    my $self = shift;
    my $q = $self->query();

    $self->param('user_logged_in'=>0);

    my $db_path = $self->param('db_usr_profile_path');
    if (-f $db_path){
        my $usr = REPS::User->new($self,'','');
        if ($usr->auth_from_Cookie()) {
            if ($q->param("Logout")) {
                $self->prerun_mode('mode_logout');
            }else{
                $self->param('user_logged_in'=>1);
            }
        }else{
            #just to make sure.
            $self->param('user_logged_in'=>0);
            #this line ensures login. Without this, one can access without login.
            $self->prerun_mode('mode_main');
        }
    }else{
        $self->prerun_mode('mode_init');
    }
}

sub cgiapp_postrun {
    my $self = shift;

    my $bodyref = shift;
    my $charset = uc($self->cfg('charset'));

    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis','Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };

    if (defined($charset) and defined($charmap->{$charset})) {
        $self->header_add(-charset=> $charset);
        my $encode = $charmap->{$charset};
        my $UJ = Unicode::Japanese->new();
        my @lines = map { $UJ->set($_,'euc')->conv($encode) } split(/\n/, $$bodyref);
        $$bodyref = join("\n", @lines);
    } else {
        croak("Please specify a charset encoding.");
    }
}

sub show_init {
    my $self = shift;
    my $q = $self->query();

    my $output = "";
    my $page_title = "";

    if ($q->param("Register")) {
        my $usr = REPS::User->new($self,'','');
        $page_title =  "REPS :: 初期化確認 :: Real Estate Publishing System";

        $output .=  $usr->init_db($q->param('lg_name'),$q->param('lg_pass'),$q->param('lg_pass_check'));
        my $template = $self->load_tmpl(
                'init.tmpl'
            );
        $template->param(
            script_version  => $self->version,
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),
            page_title => $page_title,
            page_charset => $self->cfg('charset'),
            page_data => $output
            );
        return $template->output;

    }else{
        $page_title =  "REPS :: 初期化 :: Real Estate Publishing System";
        $output .= '<p>データベースの初期化を行います。管理者のユーザーIDと初期パスワードを登録してください。</p>';
        $output .= $q->start_form(-action => $script_name,-name=>'lg');
    
        $output .= "ユーザーID: ";
        $output .= $q->br;
        $output .= $q->textfield(-name => 'lg_name');
        $output .= $q->br;
        $output .= "パスワード: ";
        $output .= $q->br;
        $output .= $q->password_field(-name => 'lg_pass');
        $output .= $q->br;
        $output .= "パスワード(確認): ";
        $output .= $q->br;
        $output .= $q->password_field(-name => 'lg_pass_check');
        $output .= $q->br;
        $output .= $q->br;
        $output .= $q->submit(-name=> 'Register', -value => '登録', -class=>'submit');
        $output .= $q->hidden(-name => '_mode', -value => 'mode_init');
        $output .= $q->end_form();
    
        my $template = $self->load_tmpl(
                'init.tmpl'
            );

        $template->param(
            script_version  => $self->version,
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),
            page_title => $page_title,
            page_charset => $self->cfg('charset'),
            page_data => $output
            );
        return $template->output;
    }
}

sub show_main {
    my $self = shift;
    my $q = $self->query();

    my $output = "";
    my $page_title = "";

    if ($self->param('user_logged_in') != 1){
        if ($q->param("Login")) {
            my $usr = REPS::User->new($self,$q->param('lg_name'),$q->param('lg_pass'));

            if ($usr->auth){
                $self->param('user_id',$usr->{_lg_name});
                my $expr;
                if ($q->param("lg_remember_me")){
                    if ($q->param("lg_remember_me") eq 'yes'){
                        $expr = '+1M'
                    }
                }

                my $url = URI::URL->new($self->cfg('cgi_url'));
                my $path = $url->path;

                my $cookie = $q->cookie(
                    -name => 'reps_user',
                    -value => $usr->{_lg_name}.'|'.$usr->create_hash,
                    -path => $path,
                    #-domain => '',
                    -expires=> $expr
                );
                $self->header_props(-cookie=>[$cookie]);

                $self->param('user_logged_in'=>1);
            }else{  
                $output .= "<div class=\"warning\"><p>パスワードまたはユーザーIDをご確認ください。 </p></div>";
                $self->param('user_logged_in'=>0);
                $q->delete('lg_pass');
            }
    
        }
    }

    if ($self->param('user_logged_in') != 1){
        $page_title =  "REPS :: 認証 :: Real Estate Publishing System";
        $output .= $q->start_form(-action => $script_name,-name=>'lg',-method=>'post');

        #Operaがこのページをcacheし続けてしまうため
        $self->header_add(-pragma=>'no-cache');
        $self->header_add(-cache_control=>'no-cache');

        $output .= "ユーザーID: ";
        $output .= $q->br;
        $output .= $q->textfield(-name => 'lg_name', -size=>30, -maxlength=>50);
        $output .= $q->br;
        $output .= "パスワード: ";

        $output .= $q->br;
        $output .= $q->password_field(-name => 'lg_pass', -value => '', -size=>30, -maxlength=>50);
        $output .= $q->br;
        $output .= $q->label('',
                    $q->checkbox(-name=> 'lg_remember_me',
                        -value => 'yes',
                        -label => ' このパソコンで次回から入力を省略'
                    )
                );
        $output .= $q->br;
        $output .= $q->br;
        $output .= $q->submit(-name=> 'Login', -value => 'ログイン', -class=>'submit');
        $output .= $q->hidden(-name => '_mode', -value => 'mode_main');
        $output .= $q->hidden(-name => '_qstring', -value => $ENV{QUERY_STRING});
        $output .= $q->end_form();

        my $template = $self->load_tmpl(
                'login.tmpl'
            );
        $template->param(
            script_version  => $self->version,
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),
            page_title => $page_title,
            page_charset => $self->cfg('charset'),
            page_data => $output
            );
        return $template->output;
    }else{
        if($q->param("_qstring")){
            #convert $script_name to full abs url
            if ($q->param('_mode') eq 'mode_logout'){
                return $self->redirect($self->param('script_name'));
            }else{
                return $self->redirect($self->param('script_name').'?'.$q->param("_qstring"));
            }
        }else{
            $page_title =  "REPS :: Real Estate Publishing System";
            $output .= '<br />';

            my $err_message;
            if ($self->param('user_info_needed')){
                $err_message .= "<a href=\"$script_name?_mode=mode_profile\">ユーザー情報</a>を入力してください。";
            }
            if ($self->param('user_isAdmin')) {
                if (!-e $self->param('db_settings_path')){
                    $err_message .= "<a href=\"$script_name?_mode=mode_admin_settings\">会社情報</a>を入力してください。";
                }
            }
            if ($err_message){
                $output .= "<div class=\"warning\"><p>$err_message</p></div>";
            }

            require REPS::CMS::Realestate::R_Apartment;
            my $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
            my $ref_hash_count = $Realestate->get_Count();
            my $rl_count_all=$$ref_hash_count{'count_all'};
            my $rl_count_published=$$ref_hash_count{'count_published'};
            my $rl_last_updated=$$ref_hash_count{'last_updated'};

            my $ref_hash_access = $Realestate->get_AccessLog();
            my $rl_access_loop=$$ref_hash_access{'access_loop'};
            my $rl_access_count_all=$$ref_hash_access{'access_count_all'};

            my $ref_hash_inquiry = $Realestate->get_InquiryLog();
            my $rl_inquiry_loop=$$ref_hash_inquiry{'inquiry_loop'};
            my $rl_inquiry_count_all=$$ref_hash_inquiry{'inquiry_count_all'};

            require REPS::CMS::Realestate::R_Business;
            $Realestate = REPS::CMS::Realestate::R_Business->new($self);
            $ref_hash_count = $Realestate->get_Count();
            my $rb_count_all=$$ref_hash_count{'count_all'};
            my $rb_count_published=$$ref_hash_count{'count_published'};
            my $rb_last_updated=$$ref_hash_count{'last_updated'};

            $ref_hash_access = $Realestate->get_AccessLog();
            my $rb_access_loop=$$ref_hash_access{'access_loop'};
            my $rb_access_count_all=$$ref_hash_access{'access_count_all'};

            $ref_hash_inquiry = $Realestate->get_InquiryLog();
            my $rb_inquiry_loop=$$ref_hash_inquiry{'inquiry_loop'};
            my $rb_inquiry_count_all=$$ref_hash_inquiry{'inquiry_count_all'};

            require REPS::CMS::Realestate::B_Land;
            $Realestate = REPS::CMS::Realestate::B_Land->new($self);
            $ref_hash_count = $Realestate->get_Count();
            my $bl_count_all=$$ref_hash_count{'count_all'};
            my $bl_count_published=$$ref_hash_count{'count_published'};
            my $bl_last_updated=$$ref_hash_count{'last_updated'};

            $ref_hash_access = $Realestate->get_AccessLog();
            my $bl_access_loop=$$ref_hash_access{'access_loop'};
            my $bl_access_count_all=$$ref_hash_access{'access_count_all'};

            $ref_hash_inquiry = $Realestate->get_InquiryLog();
            my $bl_inquiry_loop=$$ref_hash_inquiry{'inquiry_loop'};
            my $bl_inquiry_count_all=$$ref_hash_inquiry{'inquiry_count_all'};

            require REPS::CMS::Realestate::B_Mansion;
            $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
            $ref_hash_count = $Realestate->get_Count();
            my $bm_count_all=$$ref_hash_count{'count_all'};
            my $bm_count_published=$$ref_hash_count{'count_published'};
            my $bm_last_updated=$$ref_hash_count{'last_updated'};

            $ref_hash_access = $Realestate->get_AccessLog();
            my $bm_access_loop=$$ref_hash_access{'access_loop'};
            my $bm_access_count_all=$$ref_hash_access{'access_count_all'};

            $ref_hash_inquiry = $Realestate->get_InquiryLog();
            my $bm_inquiry_loop=$$ref_hash_inquiry{'inquiry_loop'};
            my $bm_inquiry_count_all=$$ref_hash_inquiry{'inquiry_count_all'};

            require REPS::CMS::Realestate::B_House;
            $Realestate = REPS::CMS::Realestate::B_House->new($self);
            $ref_hash_count = $Realestate->get_Count();
            my $bh_count_all=$$ref_hash_count{'count_all'};
            my $bh_count_published=$$ref_hash_count{'count_published'};
            my $bh_last_updated=$$ref_hash_count{'last_updated'};

            $ref_hash_access = $Realestate->get_AccessLog();
            my $bh_access_loop=$$ref_hash_access{'access_loop'};
            my $bh_access_count_all=$$ref_hash_access{'access_count_all'};

            $ref_hash_inquiry = $Realestate->get_InquiryLog();
            my $bh_inquiry_loop=$$ref_hash_inquiry{'inquiry_loop'};
            my $bh_inquiry_count_all=$$ref_hash_inquiry{'inquiry_count_all'};

            require REPS::CMS::Realestate::B_Business;
            $Realestate = REPS::CMS::Realestate::B_Business->new($self);
            $ref_hash_count = $Realestate->get_Count();
            my $bb_count_all=$$ref_hash_count{'count_all'};
            my $bb_count_published=$$ref_hash_count{'count_published'};
            my $bb_last_updated=$$ref_hash_count{'last_updated'};

            $ref_hash_access = $Realestate->get_AccessLog();
            my $bb_access_loop=$$ref_hash_access{'access_loop'};
            my $bb_access_count_all=$$ref_hash_access{'access_count_all'};

            $ref_hash_inquiry = $Realestate->get_InquiryLog();
            my $bb_inquiry_loop=$$ref_hash_inquiry{'inquiry_loop'};
            my $bb_inquiry_count_all=$$ref_hash_inquiry{'inquiry_count_all'};





            my $template = $self->load_tmpl(
                    'main.tmpl'
                );
            $template->param(
                script_version  => $self->version,
                user_id => $self->param('user_id'),
                admin => $self->param('user_isAdmin'),
                script_name  => $script_name,
                static_url => $self->cfg('static_url'),
                page_title   => $page_title,
                page_charset => $self->cfg('charset'),
                page_data    => $output,

                r_visible    => $self->param('r_visible'),
                rl_visible    => $self->param('rl_visible'),
                rb_visible    => $self->param('rb_visible'),
                b_visible    => $self->param('b_visible'),
                bl_visible    => $self->param('bl_visible'),
                bm_visible    => $self->param('bm_visible'),
                bh_visible    => $self->param('bh_visible'),
                bb_visible    => $self->param('bb_visible'),

                rl_last_updated => $rl_last_updated,
                rl_count_all => $rl_count_all,
                rl_count_published => $rl_count_published,
                rl_access_loop => $rl_access_loop,
                rl_access_count_all => $rl_access_count_all,
                rl_inquiry_loop => $rl_inquiry_loop,
                rl_inquiry_count_all => $rl_inquiry_count_all,

                rb_last_updated => $rb_last_updated,
                rb_count_all => $rb_count_all,
                rb_count_published => $rb_count_published,
                rb_access_loop => $rb_access_loop,
                rb_access_count_all => $rb_access_count_all,
                rb_inquiry_loop => $rb_inquiry_loop,
                rb_inquiry_count_all => $rb_inquiry_count_all,

                bl_last_updated => $bl_last_updated,
                bl_count_all => $bl_count_all,
                bl_count_published => $bl_count_published,
                bl_access_loop => $bl_access_loop,
                bl_access_count_all => $bl_access_count_all,
                bl_inquiry_loop => $bl_inquiry_loop,
                bl_inquiry_count_all => $bl_inquiry_count_all,

                bm_last_updated => $bm_last_updated,
                bm_count_all => $bm_count_all,
                bm_count_published => $bm_count_published,
                bm_access_loop => $bm_access_loop,
                bm_access_count_all => $bm_access_count_all,
                bm_inquiry_loop => $bm_inquiry_loop,
                bm_inquiry_count_all => $bm_inquiry_count_all,

                bh_last_updated => $bh_last_updated,
                bh_count_all => $bh_count_all,
                bh_count_published => $bh_count_published,
                bh_access_loop => $bh_access_loop,
                bh_access_count_all => $bh_access_count_all,
                bh_inquiry_loop => $bh_inquiry_loop,
                bh_inquiry_count_all => $bh_inquiry_count_all,
                #info_string            => $str

                bb_last_updated => $bb_last_updated,
                bb_count_all => $bb_count_all,
                bb_count_published => $bb_count_published,
                bb_access_loop => $bb_access_loop,
                bb_access_count_all => $bb_access_count_all,
                bb_inquiry_loop => $bb_inquiry_loop,
                bb_inquiry_count_all => $bb_inquiry_count_all,
                );
            return $template->output;
        }
    }

}

sub show_logout {
    my $self = shift;
    my $q = $self->query();
    my $output = '';

    #my $url = URI::URL->new($script_name);
    my $url = URI::URL->new($self->cfg('cgi_url'));
    my $path = $url->path;

    my $cookie = $q->cookie(
        -name => 'reps_user',
        -value => 'bye',
        -path => $path,
        #-domain => '',
        -expires=>'-1y'
    );
    $self->header_props(-cookie=>[$cookie]);

    #Opera用
    #$self->header_add(-pragma=>'no-cache');
    #$self->header_add(-cache_control=>'no-cache');

    $output = 'ログアウトしました。';

    my $page_title =  "REPS :: Real Estate Publishing System";
    my $template = $self->load_tmpl(
            'logout.tmpl'
        );

    $template->param(
        script_version  => $self->version,
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output
        );
    
    return $template->output;
}

sub show_add {
    my $self = shift;
    my $q = $self->query();
    my $output = "";
    my $ref_hash = ();
    my $err_result;

    my $Realestate;
    my $label_where;

    if ($q->param("_type") eq 'rl') {
        $label_where = '賃貸::住居用';
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '賃貸::事業用';
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '売買::土地';
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '売買::マンション';
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '売買::一戸建て';
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '売買::投資用';
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
    }else{
        return "No type specified.";
    }

    $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;<strong>' . $label_where . '</strong>&nbsp;&gt;&nbsp;新規追加</div><br />'; 
    my $page_title =  "REPS :: $label_where :新規追加 :: Real Estate Publishing System";

    if ($q->param("add_new_object")) {

        $Realestate->set_Query;
        
        $err_result .= $Realestate->create_Realestate();
        
        if ($err_result){
            #re-display form with data
            $output .= $err_result;
            $q->delete_all();
            $output .= $Realestate->get_Create_Realestate_Form();
        }else{
            $output .= "<div class=\"information\"><p>追加されました。</p></div>";
            $q->delete_all();
            $output .= $Realestate->get_Edit_Realestate_Form();
if ($] >= 5.006) {
#XML::Atom::Syndication module does not work under perl 5.00503
            if ((uc($self->cfg('syndicate_rss')) eq 'ON') or (uc($self->cfg('syndicate')) eq 'ON')) {
                $Realestate->syndicate();
            }
}
        }

        my $template = $self->load_tmpl(
                    'object_add.tmpl'
                );

        $template->param(
            script_version  => $self->version,
            user_id => $self->param('user_id'),
            admin => $self->param('user_isAdmin'),
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),

            r_visible    => $self->param('r_visible'),
            rl_visible    => $self->param('rl_visible'),
            rb_visible    => $self->param('rb_visible'),
            b_visible    => $self->param('b_visible'),
            bl_visible    => $self->param('bl_visible'),
            bm_visible    => $self->param('bm_visible'),
            bh_visible    => $self->param('bh_visible'),
            bb_visible    => $self->param('bb_visible'),

            page_title   => $page_title,
            page_charset => $self->cfg('charset'),
            page_data    => $output
            );

        return $template->output;
    }else{

        $output .= $Realestate->get_Create_Realestate_Form();

        my $template = $self->load_tmpl(
                'object_add.tmpl'
            );

        $template->param(
            script_version  => $self->version,
            user_id => $self->param('user_id'),
            admin => $self->param('user_isAdmin'),
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),

            r_visible    => $self->param('r_visible'),
            rl_visible    => $self->param('rl_visible'),
            rb_visible    => $self->param('rb_visible'),
            b_visible    => $self->param('b_visible'),
            bl_visible    => $self->param('bl_visible'),
            bm_visible    => $self->param('bm_visible'),
            bh_visible    => $self->param('bh_visible'),
            bb_visible    => $self->param('bb_visible'),

            page_title   => $page_title,
            page_charset => $self->cfg('charset'),
            page_data    => $output
            );

        return $template->output;
    }
}

sub show_list {
    my $self = shift;
    my $q = $self->query();

    my $output_over = '';
    my $output_lower_delete = '';
    my $output_lower_paging = '';
    my $output_paging_nav;
    my $output_paging_select_limit;
    my $output_lower_end ='';

    my $Realestate;
    my $label_where;
    my $tmpl_file;

    if ($q->param("_type") eq 'rl') {
        $label_where = '賃貸::住居用';
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
        $tmpl_file = 'object_rl_view_list.tmpl';
    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '賃貸::事業用';
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
        $tmpl_file = 'object_rb_view_list.tmpl';
    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '売買::土地';
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
        $tmpl_file = 'object_bl_view_list.tmpl';
    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '売買::マンション';
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
        $tmpl_file = 'object_bm_view_list.tmpl';
    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '売買::一戸建て';
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
        $tmpl_file = 'object_bh_view_list.tmpl';
    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '売買::投資用';
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
        $tmpl_file = 'object_bb_view_list.tmpl';
    }else{
        return "No type specified.";
    }

    $output_over .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;<strong>' . $label_where . '</strong>&nbsp;&gt;&nbsp;物件一覧</div><br />'; 
    my $page_title =  "REPS :: $label_where :物件一覧 :: Real Estate Publishing System";

    $output_over .= $q->start_form(-action => $script_name, -name => 'rdelete');
    
    if ($q->param("delete_object")) {
        if ($q->param("_object_id_to_be_deleted")){
            $Realestate->delete_Realestate($q->param("_object_id_to_be_deleted"));
#shoud I ?
$self->recommend_static_write_file();
        }
    }

    #other action for checked items
    if ($q->param("multiple_object")){
        if ($q->param("_object_id_to_be_deleted")){
            #make it public or private
            if ($q->param("_action") eq 'public'){
                $Realestate->toggle_Realestate(1,$q->param("_object_id_to_be_deleted"));
#shoud I ?
$self->recommend_static_write_file();

            }elsif ($q->param("_action") eq 'private'){
                $Realestate->toggle_Realestate(0,$q->param("_object_id_to_be_deleted"));
#shoud I ?
$self->recommend_static_write_file();
            }elsif ($q->param("_action") eq 'duplicate'){
                $Realestate->dup_Realestate($q->param("_object_id_to_be_deleted"));
            }elsif ($q->param("_action") eq 'make_special'){
                $Realestate->special_Realestate(1,$q->param("_object_id_to_be_deleted"));
                $self->recommend_static_write_file();
            }elsif ($q->param("_action") eq 'undo_special'){
                $Realestate->special_Realestate(0,$q->param("_object_id_to_be_deleted"));
                $self->recommend_static_write_file();
            }
            $q->delete('_object_id_to_be_deleted');
        }
        $q->delete('multiple_object');
    }

    my $off_set;
    if ($q->param("_off_set")){
        $off_set = $q->param("_off_set");
    }else{
        $off_set = 0;
    }
    
    if ($off_set < 0){$off_set = 0;}

    my $sort_by;
    if ($q->param("_sort_by")){
        $sort_by = $q->param("_sort_by");
    }else{
        $sort_by = '';
    }

    my $items_per_page;
    if ($q->param("_limit")){
        $items_per_page = $q->param("_limit");
    }else{
        $items_per_page = $self->cfg('items_per_page');
    }
    if ($items_per_page > 50){$items_per_page = 50;}
    if ($items_per_page < 5){$items_per_page = 5;}
    #becouse we are not in the admin mode. Make sure the forth parameter is empty here.
    my ($ref_loop, $result_count) = $Realestate->get_Realestate_List($sort_by,$off_set,$items_per_page,'');

    $output_lower_delete .= $q->hidden(-name => '_mode', -value => 'mode_list');
    $output_lower_delete .= $q->hidden(-name => '_type', -value => $q->param("_type"));
    #$output_lower_delete .= $q->submit(-name => 'delete_object' , -value =>'削除' , -class => 'submit');

    $output_lower_paging .= $q->hidden(-name => '_off_set', -value => $off_set );
    $output_lower_paging .= $q->hidden(-name => '_sort_by', -value => $sort_by);
    $output_lower_paging .= $q->hidden(-name => '_limit', -value => $items_per_page);

    if ($off_set <= 0 ){
        $output_lower_paging .= '';#'[ 前の0件 ] ';
        if ($result_count > 0){
            $output_paging_nav = $result_count."件中 1〜";#.($items_per_page)."件まで表示しています。";
        }else{
            $output_paging_nav = $result_count."件中 0〜";
        }
    }else{
        if ($off_set >= $result_count){$off_set = $result_count;}
        my $off_set_pre = $off_set - $items_per_page;
        if ($off_set_pre < 0){$off_set_pre = 0;}
        my $items_per_page_pre = $items_per_page;
        if ($off_set < $items_per_page_pre){
            $items_per_page_pre = $items_per_page - ($items_per_page_pre - $off_set);
        }
        $output_lower_paging .= "[ <a href=\"".$script_name."?_mode=mode_list&_type=".$q->param("_type")."&_off_set=".$off_set_pre."&_sort_by=".$sort_by."&_limit=".$items_per_page."\">前の ".$items_per_page_pre."件</a> ] ";

        if (($off_set+1) < $result_count){
            $output_paging_nav = $result_count."件中 ".($off_set+1)."〜";
        }else{
            $output_paging_nav = $result_count."件中 ".($off_set+1)."〜";
        }

    }
    $output_paging_select_limit = '
    <select name="_limit" onchange="if(this.options[this.selectedIndex].value){window.location=\''.$script_name.'?_mode=mode_list&_type='.$q->param("_type").'&_off_set='.$off_set.'&_sort_by='.$sort_by.'&_limit='.'\' + this.options[this.selectedIndex].value + \''.'\'}"><option value=""';
    my $limt = $q->param("_limit");
    if (!$limt){$limt = 0;}
        if (!$limt){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>表示件数</option><option value="5"';
        if ($limt == 5){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>5 件</option><option value="10"';
        if ($limt == 10){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>10 件</option><option value="20"';
        if ($limt == 20){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>20 件</option><option value="60"';
        if ($limt == 50){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>50 件</option></select>';
    
    $output_lower_paging .= $output_paging_select_limit;

    my $off_set_next = $off_set+$items_per_page;
    if (($off_set_next >= $result_count)){
        $output_lower_paging .= '';#' [次の10件 ]';
        if ($result_count > $off_set){
            $output_paging_nav .= ($result_count)."件を表示しています。";
        }else{
            if ($result_count){
                $output_paging_nav .= ($result_count+1)."件を表示しています。";
            }else{
                $output_paging_nav .= (0)."件を表示しています。";
            }
        }
    }else{
        my $items_per_page_next = $items_per_page;
        if (($result_count - $off_set_next) < $items_per_page){
            #There are less than $items_per_page left.So fix it.
            $items_per_page_next = ($result_count - $off_set_next);
        }
        $output_lower_paging .= " [ <a href=\"".$script_name."?_mode=mode_list&_type=".$q->param("_type")."&_off_set=".$off_set_next."&_sort_by=".$sort_by."&_limit=".$items_per_page."\">次の ".$items_per_page_next."件</a> ] ";

        $output_paging_nav .= ($off_set + $items_per_page) . "件を表示しています。";
    }

    #$output_lower_paging .= $output_paging_nav;

    $output_lower_end .= $q->end_form();

    my $template = $self->load_tmpl(
            $tmpl_file
        );

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_over_data    => $output_over,
        main_loop    => $ref_loop,
        page_lower_delete    => $output_lower_delete,
        page_lower_paging => $output_lower_paging,
        limit => $items_per_page,
        page_nav_paging => $output_paging_nav,
        page_lower_end => $output_lower_end
        );
    return $template->output;
}

sub show_edit {
    my $self = shift;
    my $q = $self->query();
    my $output = "";
    my $ref_hash = ();
    my $err_result;

    my $Realestate;
    my $label_where;

    if ($q->param("_type") eq 'rl') {
        $label_where = '賃貸::住居用';
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '賃貸::事業用';
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '売買::土地';
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '売買::マンション';
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '売買::一戸建て';
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '売買::投資用';
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
    }else{
        return "No type specified.";
    }

    $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;<strong>' . $label_where . '</strong>&nbsp;&gt;&nbsp;編集更新</div><br />';
    my $page_title =  "REPS :: $label_where :編集更新 :: Real Estate Publishing System";


    if ($q->param("_object_id")) {
        #check param value. escape or strip none degit.


        #check & make sure if _apart_id $apart(APART_USER_ID) is own

        if ($q->param("edit_object") or $q->param("delete_pic")){
            $Realestate->set_Query();

            $err_result .= $Realestate->update_Realestate();

            if ($err_result){
                #re-display form with data
                $q->delete_all();
                $output .= $err_result;
                $output .= $Realestate->get_Edit_Realestate_Form();
            }else{
                # updated success
if ($] >= 5.006) {
#XML::Atom::Syndication module does not work under perl 5.00503
                # generate Atom feed here 
                if ((uc($self->cfg('syndicate_rss')) eq 'ON') or (uc($self->cfg('syndicate')) eq 'ON')) {
                    $Realestate->syndicate();
                }
}

#                 # generate static file if specified.
#                 if (uc($self->cfg('recommend_static_write')) eq 'ON'){
#                     require REPS::CMS::Special;
#                     if ( ($q->param("_type") eq 'rl') and ($self->cfg('recommend_static_rl_filename') ne '') ){
# 
#                         my $tmpl_recommend = 'pub_rl_recommend.tmpl';
#                         my $recomend = REPS::CMS::Special->new($self,$self->param('db_r_apart_special_path'));
#                         my $ref_loop = $recomend->get_special();
# 
#                         #set temp template dir
#                         $self->tmpl_path(File::Spec->catdir($RealBin, $self->cfg('tmpl_path')));
# 
#                         my $template = $self->load_tmpl(
#                                 $tmpl_recommend, die_on_bad_params => 0
#                             );
#                         $template->param(
#                             script_name  => $script_name,
#                             page_charset => $self->cfg('charset'),
#                             page_data    => $output,
#                             site_url => $self->cfg('site_url'),
#                             main_loop    => $ref_loop,
#                             );
#                         my $content = $template->output;
#                         my $file = $self->cfg('site_path').$self->cfg('recommend_static_rl_filename');
# 
#                         #convert charset
#                         my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis','Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
#                         require Unicode::Japanese;
#                         my $charset = uc($self->cfg('charset'));
#                         my $encode = $charmap->{$charset};
#                         my $UJ = Unicode::Japanese->new();
#                         $content = $UJ->set($content,'euc')->conv($encode);#->$encode;
# 
#                         #writing a file
#                         open (OUT,">$file") || Carp::croak ("$!");
#                         flock(OUT,2) || Carp::croak ("$file : $! flock");
#                             print OUT $content;
#                         flock(OUT,8) || Carp::croak("$file : $!");
#                         close (OUT) || Carp::croak("$file : $!");
# 
#                         #re-set template dir
#                         $self->tmpl_path(File::Spec->catdir($RealBin, 'system/templates'));
#                     }
#                 }


                $output .= "<div class=\"information\"><p>更新されました。</p></div>";
                $Realestate->get_Realestate($q->param("_object_id"));#do I need this?
                $q->delete_all();
                $output .= $Realestate->get_Edit_Realestate_Form();

            }
        }else{

            #else get a apart data and populate them in form display it 
            if ($Realestate->get_Realestate($q->param("_object_id"))){
                $q->delete_all();
                $output .= $Realestate->get_Edit_Realestate_Form();
            }else{
                $output .= "<div class=\"warning\"><p>エラー：物件情報を取得出来ませんでした。既に削除されている可能性があります。</p></div>";
            }
        }
    }else{
        $output .= "<div class=\"warning\"><p>エラー：物件を選択せずに編集モードに入ろうとしています。</p></div>";
    }

    my $template = $self->load_tmpl(
            'object_edit.tmpl'
        );
    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output
        );
    return $template->output;
}


sub show_search {
    my $self = shift;
    my $q = $self->query();
    my $output = "";
    my $ref_loop;
    my $template;
    my $page_title;

    my $Realestate;
    my $label_where;
    my $tmpl_search;
    my $tmpl_search_result;

    if ($q->param("_type") eq 'rl') {
        $label_where = '賃貸::住居用';
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
        $tmpl_search = 'object_rl_search.tmpl';
        $tmpl_search_result = 'object_rl_search_result.tmpl';
    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '賃貸::事業用';
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
        $tmpl_search = 'object_rb_search.tmpl';
        $tmpl_search_result = 'object_rb_search_result.tmpl';
    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '売買::土地';
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
        $tmpl_search = 'object_bl_search.tmpl';
        $tmpl_search_result = 'object_bl_search_result.tmpl';
    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '売買::マンション';
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
        $tmpl_search = 'object_bm_search.tmpl';
        $tmpl_search_result = 'object_bm_search_result.tmpl';
    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '売買::一戸建て';
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
        $tmpl_search = 'object_bh_search.tmpl';
        $tmpl_search_result = 'object_bh_search_result.tmpl'
    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '売買::投資用';
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
        $tmpl_search = 'object_bb_search.tmpl';
        $tmpl_search_result = 'object_bb_search_result.tmpl'
    }else{
        return "No type specified.";
    }

    #delete checked items
    if ($q->param("delete_object")){
        if ($q->param("_object_id_to_be_deleted")){
            $Realestate->delete_Realestate($q->param("_object_id_to_be_deleted"));
            $q->delete('_object_id_to_be_deleted');
#shoud I ?
$self->recommend_static_write_file();
        }
    }

    #other action for checked items
    if ($q->param("multiple_object")){
        if ($q->param("_object_id_to_be_deleted")){
            #make it public or private
            if ($q->param("_action") eq 'public'){
                $Realestate->toggle_Realestate(1,$q->param("_object_id_to_be_deleted"));
#shoud I ?
$self->recommend_static_write_file();
            }elsif ($q->param("_action") eq 'private'){
                $Realestate->toggle_Realestate(0,$q->param("_object_id_to_be_deleted"));
#shoud I ?
$self->recommend_static_write_file();
            }elsif ($q->param("_action") eq 'duplicate'){
                $Realestate->dup_Realestate($q->param("_object_id_to_be_deleted"));
            }elsif ($q->param("_action") eq 'make_special'){
                $Realestate->special_Realestate(1,$q->param("_object_id_to_be_deleted"));
                $self->recommend_static_write_file();
            }elsif ($q->param("_action") eq 'undo_special'){
                $Realestate->special_Realestate(0,$q->param("_object_id_to_be_deleted"));
                $self->recommend_static_write_file();
            }
            $q->delete('_object_id_to_be_deleted');
        }
        $q->delete('multiple_object');
    }

    if ($q->param("search_object")) {
        # if "_object_id" is is specified, redirect to edit page. eg reps.cgi?_mode=mode_edit&_type=rl&_object_id=000001
        if ($q->param("_object_id")) {
            my $n = $q->param("_object_id");
            $n = REPS::Util->convert_zhk($self->convert_charset($n));
            $n =~ s/\D//gi;
            return $self->redirect($self->param('script_name').'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$n);
        }

        $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;<strong>' . $label_where . '</strong>&nbsp;&gt;&nbsp;検索結果一覧</div><br />';
        $page_title =  "REPS :: $label_where :検索結果一覧 :: Real Estate Publishing System";
        $template = $self->load_tmpl(
                $tmpl_search_result
            );
        my $sort_by = $q->param("sort_by");
        my $off_set;
        if ($q->param("off_set")){
            $off_set = $q->param("off_set");
        }else{$off_set = 0;}


        my $items_per_page = $self->cfg('items_per_page');
        require REPS::CMS::Search;
        my $Search = REPS::CMS::Search->new($sort_by,$off_set,$items_per_page);
        $Search->{'sort_by'} = $sort_by;

        if ($q->param("off_set_next")){
            $Search->{'off_set'} = $q->param("off_set_next");
            $off_set = $q->param("off_set_next");
        }else{
            $Search->{'off_set'} = $off_set;
        }
        $Search->{'items_per_page'} = $items_per_page;

        $Realestate->get_Search_Result($Search);
        my $ref_loop = $Search->{'ref_result_loop'};
        my $result_count = $Search->{'count_result'};

        my $off_set_pre;
        my $items_per_page_pre;
        my $off_set_next;
        my $items_per_page_next;

        #if no javascript next page 
        if ($q->param("off_set_next")){
            $off_set_next = $q->param("off_set_next");
            my $d = $off_set_next+$items_per_page;

            if ($d < $result_count){
                $output .= "<strong>$result_count件</strong>中&nbsp;".($off_set_next+1)."〜$d件を表示しています。";
                if ($items_per_page > ($result_count - $d)){
                    $items_per_page_next = $result_count - $d;
                }else{
                    $items_per_page_next = $items_per_page;
                }
                $off_set_next = $d;
            }else{
                $output .= "<strong>$result_count件</strong>中&nbsp;".($off_set_next+1)."〜$result_count件を表示しています。";
            }
        }else{
            my $d;
            if ($off_set == 0){$d = 1;}else{$d = $off_set+1 ;}
            if ($result_count == 0){$d = 0;};
            my $tmp_count = ($off_set+$items_per_page);
            #if rest is less than items_per_page
            if ($tmp_count >= $result_count){
                $output .= "<strong>$result_count件</strong>中&nbsp;$d〜$result_count件を表示しています。";
                $items_per_page_next = '';
                $off_set_next = $result_count;
            }else{
                $output .= "<strong>$result_count件</strong>中&nbsp;$d〜$tmp_count件を表示しています。";
                $items_per_page_next = $items_per_page;
                $off_set_next = $tmp_count;
                if ($result_count < ($tmp_count+$items_per_page)){
                    $items_per_page_next = ($result_count - $tmp_count);
                }
            }

            #if previous page
            if ($off_set <= 0){
                    $items_per_page_pre = '';
                    $off_set_pre = 0;   
            }else{
                my $tmp_count = ($off_set-$items_per_page);
                if ($tmp_count > 0){
                    $items_per_page_pre = $items_per_page;
                    $off_set_pre = $off_set-$items_per_page;
                }else{
                    if ($tmp_count == 0){
                        $items_per_page_pre = $items_per_page;
                        $off_set_pre = 0;
                    }else{
                        $items_per_page_pre = ($items_per_page+$tmp_count);
                        $off_set_pre = 0;
                    }
                }
            }
        }
        $q->delete('_action');
        $q->delete('multiple_object');
        $q->delete('_object_id');

        my $params;
        foreach my $param ($q->param()){
            my @values = $q->param($param);
            if (scalar(@values) > 1){
                my $tmp_str;
                for (my $i=0;$i < scalar(@values);$i++){
                    $tmp_str .= $values[$i];
                    unless ($i == (scalar(@values)-1)){$tmp_str = $tmp_str.","}
                }
                $params->{$param} = $tmp_str;
            } else {
                $params->{$param} = $self->convert_charset($q->param($param));
            }
        }


        $params->{'script_version'} = $self->param('script_version');
        $params->{'user_id'} = $self->param('user_id');
        $params->{'admin'} = $self->param('user_isAdmin');
        $params->{'script_name'} = $script_name;
        $params->{'static_url'} = $self->cfg('static_url');

        $params->{'r_visible'} = $self->param('r_visible');
        $params->{'rl_visible'} = $self->param('rl_visible');
        $params->{'rb_visible'} = $self->param('rb_visible');
        $params->{'b_visible'} = $self->param('b_visible');
        $params->{'bl_visible'} = $self->param('bl_visible');
        $params->{'bm_visible'} = $self->param('bm_visible');
        $params->{'bh_visible'} = $self->param('bh_visible');
        $params->{'bb_visible'} = $self->param('bb_visible');

        $params->{'page_title'} = $page_title;
        $params->{'page_charset'} = $self->cfg('charset');
        $params->{'page_data'} = $output;
        $params->{'main_loop'} = $ref_loop;
        $params->{'result_count'} = $result_count;
        $params->{'off_set'} = $off_set;
        $params->{'off_set_next'} = $off_set_next;
        $params->{'items_per_page_next'} = $items_per_page_next;
        $params->{'off_set_pre'} = $off_set_pre;
        $params->{'items_per_page_pre'} = $items_per_page_pre;

        $params->{'search_object'} = 'DoSearch';

        $template->param($params);


    }else{
        $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;<strong>' . $label_where . '</strong>&nbsp;&gt;&nbsp;検索</div><br />';
        $page_title =  "REPS :: $label_where :検索 :: Real Estate Publishing System";

        my $Independent_user;
        if (uc($self->cfg('independent_users')) eq 'ON') {$Independent_user = 'on';}else{$Independent_user = '';}

        $template = $self->load_tmpl(
                $tmpl_search
            );
        $template->param(
            script_version  => $self->version,
            user_id => $self->param('user_id'),
            admin => $self->param('user_isAdmin'),
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),
            r_visible    => $self->param('r_visible'),
            rl_visible    => $self->param('rl_visible'),
            rb_visible    => $self->param('rb_visible'),
            b_visible    => $self->param('b_visible'),
            bl_visible    => $self->param('bl_visible'),
            bm_visible    => $self->param('bm_visible'),
            bh_visible    => $self->param('bh_visible'),
            bb_visible    => $self->param('bb_visible'),
            page_title   => $page_title,
            page_charset => $self->cfg('charset'),
            page_data    => $output,
            INDEPENDENT_USER => $Independent_user
            );
    }

    return $template->output;
}




sub show_profile {
    my $self = shift;
    my $q = $self->query();
    my $output = "";
    my $usr = REPS::User->new($self,$self->param('user_id'),'');
    my %hash;

    if (uc($self->cfg('independent_users')) eq 'ON') {
        $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . 'ユーザー会社情報編集</div><br />'; 
    }else{
        $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . 'ユーザー情報編集</div><br />'; 
    }

    if ($q->param("update_usr_profile")) {
        $usr->set_Query();
        my $err_result = $usr->update_profile(
                $q->param("usr_profile_password"),
                $q->param("usr_profile_password_new"),
                $q->param("usr_profile_password_new_check")
                );
        if ($err_result) {
            $output .= $err_result;

            my %hash = (
                'PASSWORD' => '',
                'ADMIN' => 0,
                'USER_EMAIL' => $q->param("usr_profile_company_mail"),
                'USER_WHO' => $q->param("usr_profile_company_who"),
                'COMPANY_NAME' => $q->param("usr_profile_company_name"),
                'COMPANY_ADDRESS' => $q->param("usr_profile_company_address"),
                'COMPANY_TEL' => $q->param("usr_profile_company_tel"),
                'COMPANY_LICENSE' => $q->param("usr_profile_company_license")
            );
            $self->convert_hash_charset(\%hash);
            $usr->{'_ref_hash'} = \%hash;
            $q->delete_all();
        }else{
            if ($q->param("usr_profile_password_new")){
                $output .= "<div class=\"information\"><p>更新されました。</p><p>新しいパスワードでログインし直してください。</p></div>";
            }else{
                $output .= "<div class=\"information\"><p>更新されました。</p></div>";
            }
            $q->delete_all();
            $usr->get_Profile();
        }
    }else{
        $usr->get_Profile();
    }

    $output .= $usr->get_Profile_Form();

    my $page_title =  "REPS :: ユーザー情報 :: Real Estate Publishing System";
    my $template = $self->load_tmpl(
            'user_viewEdit.tmpl'
        );

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output
        );

    return $template->output;
}


sub show_admin_settings {
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }

    my $q = $self->query();
    my $output = "";
    my $Settings = REPS::Settings->new($self,$self->param('user_id'),'');
    my %hash;
    my $page_title;
    
    if (uc($self->cfg('independent_users')) eq 'ON') {
        $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] システム運営会社情報編集</div><br />'; 
        $page_title =  "REPS :: システム運営会社情報 :: Real Estate Publishing System";
    }else{
        $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] 会社情報編集</div><br />'; 
        $page_title =  "REPS :: 会社情報 :: Real Estate Publishing System";
    }

    if ($q->param("update_settings")) {
        $Settings->set_Query();
        my $err_result = $Settings->update_settings();
        if ($err_result) {
            $output .= $err_result;

            $q->delete_all();
        }else{
            $output .= "<div class=\"information\"><p>更新されました。</p></div>";
            $q->delete_all();
            $Settings->get_settings();
        }
        
    }else{
        $Settings->get_settings();
    }

    $output .= $Settings->get_Settings_Form();

    
    my $template = $self->load_tmpl(
            'admin_viewSettings.tmpl'
        );

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output
        );

    return $template->output;

}

sub show_admin_addUser{
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }
    my $usr_id;
    my $q = $self->query();
    my $output = "";
    my $usr = REPS::User->new($self,'','');

    $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] ユーザー追加</div><br />'; 

    if ($q->param("add_usr_profile")) {
        $usr->set_Query();
        my $err_result = $usr->create_profile(
                $q->param("usr_profile_id_new"),
                $q->param("usr_profile_password_new"),
                $q->param("usr_profile_password_new_check")
                );
        $usr_id = $q->param("usr_profile_id_new");
        
        if ($err_result) {
            $output .= $err_result;

            $q->delete_all();
        }else{
            $output .= "<div class=\"information\"><p>新規にユーザーが追加されました。</p></div>";
            $q->delete_all();
            $usr->get_Profile();
        }
    }else{

        $usr_id = '';
    }

    $output .= $usr->get_Admin_Create_Profile_Form($usr_id);
    
    my $page_title =  "REPS :: [管理メニュー] ユーザー追加 :: Real Estate Publishing System";
    my $template = $self->load_tmpl(
            'admin_viewEditUser.tmpl'
        );

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output
        );

    return $template->output;

}

sub show_admin_showUsers_list{
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }

    my $q = $self->query();
    my $output_over = "";
    my $output_lower = "";
    my @loop_data = ();
    my $usr = REPS::User->new($self,$self->param('user_id'),'');

    $output_over .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] ユーザー一覧</div><br />'; 
    $output_over .= $q->start_form(-action => $script_name, -onsubmit=> 'return confirmDelete(document.udelete)', -name=>'udelete');
    
    if ($q->param("delete_usr_profile")) {
        if ($q->param("_object_id_to_be_deleted")){
            $usr->delete_profile($q->param("_object_id_to_be_deleted"));
        }
    }

    my $ref_loop = $usr->get_usr_list();

    $output_lower .= $q->hidden(-name => '_mode', -value => 'mode_admin_showUsers_list');
    $output_lower .= $q->submit(-name => 'delete_usr_profile' , -value =>'削除' , -class=>'submit');
    $output_lower .= $q->end_form();

    my $page_title =  "REPS :: [管理メニュー] ユーザー一覧 :: Real Estate Publishing System";
    my $template = $self->load_tmpl(
            'admin_viewUsers.tmpl'
        );


    foreach (@$ref_loop){
        $$_{'r_visible'} = $self->param('r_visible');
        $$_{'rl_visible'} = $self->param('rl_visible');
        $$_{'rb_visible'} = $self->param('rb_visible');
        $$_{'b_visible'} = $self->param('b_visible');
        $$_{'bl_visible'} = $self->param('bl_visible');
        $$_{'bm_visible'} = $self->param('bm_visible');
        $$_{'bh_visible'} = $self->param('bh_visible');
        $$_{'bb_visible'} = $self->param('bb_visible');
    }

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_over_data    => $output_over,
        main_loop    => $ref_loop,
        page_lower_data    => $output_lower
        );
    return $template->output;

}

sub show_admin_showUser_profile {
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }
    my $output = "";
    my $q = $self->query();
    
    $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] ユーザー情報</div><br />';

    if ($q->param("_usr_id")){

        my $usr = REPS::User->new($self,$q->param("_usr_id"),'');
        my $ref_hash;
        my %hash;

        if ($q->param("update_usr_profile")) {
            $output .= $usr->update_profile(
                    $q->param("usr_profile_password"),
                    $q->param("usr_profile_password_new"),
                    $q->param("usr_profile_password_new_check")
                    );
            $q->delete_all();
        }
        
        $usr->get_Profile();
        $output .= $usr->get_UserProfile_Form();

        my $page_title =  "REPS :: [管理メニュー] 会社情報 :: Real Estate Publishing System";
        my $template = $self->load_tmpl(
                'admin_viewUser_Profile.tmpl'
            );

        $template->param(
            script_version  => $self->version,
            user_id => $self->param('user_id'),
            admin => $self->param('user_isAdmin'),
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),
            r_visible    => $self->param('r_visible'),
            rl_visible    => $self->param('rl_visible'),
            rb_visible    => $self->param('rb_visible'),
            b_visible    => $self->param('b_visible'),
            bl_visible    => $self->param('bl_visible'),
            bm_visible    => $self->param('bm_visible'),
            bh_visible    => $self->param('bh_visible'),
            bb_visible    => $self->param('bb_visible'),
            page_title   => $page_title,
            page_charset => $self->cfg('charset'),
            page_data    => $output
            );

        return $template->output;
    }else{

        my $page_title =  "REPS :: エラー :: Real Estate Publishing System";
        my $template = $self->load_tmpl(
                'err.tmpl'
            );
        $output = 'idが指定されていません。';
        $template->param(
            script_version  => $self->version,
            user_id => $self->param('user_id'),
            admin => $self->param('user_isAdmin'),
            script_name  => $script_name,
            static_url => $self->cfg('static_url'),
            r_visible    => $self->param('r_visible'),
            rl_visible    => $self->param('rl_visible'),
            rb_visible    => $self->param('rb_visible'),
            b_visible    => $self->param('b_visible'),
            bl_visible    => $self->param('bl_visible'),
            bm_visible    => $self->param('bm_visible'),
            bh_visible    => $self->param('bh_visible'),
            bb_visible    => $self->param('bb_visible'),
            page_title   => $page_title,
            page_charset => $self->cfg('charset'),
            page_data    => $output
            );


        return $template->output;
    }

}

sub show_admin_showUser_items {
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }
    my $output_over = "";
    my $output_lower_delete = "";
    my $output_lower_paging = '';
    my $output_paging_nav;
    my $output_paging_select_limit;
    my $output_lower_end ="";
    my $q = $self->query();
    my $page_title;;

    my $Realestate;
    my $label_where;
    my $tmpl_file;


    if ($q->param("_type") eq 'rl') {
        $label_where = '賃貸::住居用';
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
        $tmpl_file = 'admin_view_list_rl.tmpl';

    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '賃貸::事業用';
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
        $tmpl_file = 'admin_view_list_rb.tmpl';

    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '売買::土地';
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
        $tmpl_file = 'admin_view_list_bl.tmpl';

    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '売買::マンション';
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
        $tmpl_file = 'admin_view_list_bm.tmpl';

    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '売買::一戸建て';
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
        $tmpl_file = 'admin_view_list_bh.tmpl';

    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '売買::投資用';
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
        $tmpl_file = 'admin_view_list_bb.tmpl';

    }else{
        return "No type specified.";
    }

    $page_title =  "REPS :: [管理メニュー] ユーザー登録物件一覧 :: Real Estate Publishing System";

    $output_over .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . "[管理メニュー] ユーザー (". REPS::Util->convert2htmlchars($self->convert_charset($q->param("_usr_id"))) .") 登録物件一覧&nbsp;&gt;&nbsp;$label_where</div><br />"; 


    $output_over .= $q->start_form(-action => $script_name, -onsubmit=> 'return confirmDelete(document.udelete)' ,-name=>'udelete');
    
    if ($q->param("delete_object")) {
        if ($q->param("_object_id_to_be_deleted")){
            $Realestate->delete_Realestate($q->param("_object_id_to_be_deleted"));

        }
    }


    my $off_set;
    if ($q->param("_off_set")){
        $off_set = $q->param("_off_set");
    }else{
        $off_set = 0;
    }
    
    if ($off_set < 0){$off_set = 0;}

    my $sort_by;
    if ($q->param("_sort_by")){
        $sort_by = $q->param("_sort_by");
    }else{
        $sort_by = '';
    }

    my $user_id;
    if ($q->param("_usr_id")){
        $user_id = REPS::Util->convert2htmlchars($q->param("_usr_id"));
    }else{
        Carp::croak "No user id is specified.";
    }

    my $items_per_page;
    if ($q->param("_limit")){
        $items_per_page = $q->param("_limit");
    }else{
        $items_per_page = $self->cfg('items_per_page');
    }
    if ($items_per_page > 50){$items_per_page = 50;}
    if ($items_per_page < 5){$items_per_page = 5;}
    #becouse we *are* in the admin mode. The forth parameter is set.
    my ($ref_loop, $result_count) = $Realestate->get_Realestate_List($sort_by,$off_set,$items_per_page,$user_id);

    $output_lower_delete .= $q->hidden(-name => '_mode', -value => 'mode_admin_showUser_items');
    $output_lower_delete .= $q->hidden(-name => '_usr_id', -value => $user_id);
    $output_lower_delete .= $q->hidden(-name => '_type', -value => $q->param("_type"));
    $output_lower_delete .= $q->submit(-name => 'delete_object' , -value =>'削除' , -class => 'submit');

    $output_lower_paging .= $q->hidden(-name => '_off_set', -value => $off_set );
    $output_lower_paging .= $q->hidden(-name => '_sort_by', -value => $sort_by);
    $output_lower_paging .= $q->hidden(-name => '_limit', -value => $items_per_page);

    if ($off_set <= 0 ){
        $output_lower_paging .= '';#'[ 前の0件 ] ';
        if ($result_count > 0){
            $output_paging_nav = $result_count."件中 1〜";#.($items_per_page)."件まで表示しています。";
        }else{
            $output_paging_nav = $result_count."件中 0〜";
        }
    }else{
        if ($off_set >= $result_count){$off_set = $result_count;}
        my $off_set_pre = $off_set - $items_per_page;
        if ($off_set_pre < 0){$off_set_pre = 0;}
        my $items_per_page_pre = $items_per_page;
        if ($off_set < $items_per_page_pre){
            $items_per_page_pre = $items_per_page - ($items_per_page_pre - $off_set);
        }
        $output_lower_paging .= "[ <a href=\"".$script_name."?_mode=mode_admin_showUser_items&_type=".$q->param("_type")."&_off_set=".$off_set_pre."&_sort_by=".$sort_by."&_limit=".$items_per_page."&_usr_id=".$user_id."\">前の ".$items_per_page_pre."件</a> ] ";

        if (($off_set+1) < $result_count){
            $output_paging_nav = $result_count."件中 ".($off_set+1)."〜";
        }else{
            $output_paging_nav = $result_count."件中 ".($off_set+1)."〜";
        }

    }
    $output_paging_select_limit = '
    <select name="_limit" onchange="if(this.options[this.selectedIndex].value){window.location=\''.$script_name.'?_mode=mode_admin_showUser_items&_type='.$q->param("_type").'&_off_set='.$off_set.'&_sort_by='.$sort_by.'&_usr_id='.$user_id.'&_limit='.'\' + this.options[this.selectedIndex].value + \''.'\'}"><option value=""';
        if (!$q->param("_limit")){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>表示件数</option><option value="5"';
        if ($q->param("_limit") == 5){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>5 件</option><option value="10"';
        if ($q->param("_limit") == 10){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>10 件</option><option value="20"';
        if ($q->param("_limit") == 20){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>20 件</option><option value="60"';
        if ($q->param("_limit") == 50){ $output_paging_select_limit .= ' selected="selected"';}
        $output_paging_select_limit .= '>50 件</option></select>';
    
    $output_lower_paging .= $output_paging_select_limit;

    my $off_set_next = $off_set+$items_per_page;
    if (($off_set_next >= $result_count)){
        $output_lower_paging .= '';#' [次の10件 ]';
        if ($result_count > $off_set){
            $output_paging_nav .= ($result_count)."件を表示しています。";
        }else{
            if ($result_count){
                $output_paging_nav .= ($result_count+1)."件を表示しています。";
            }else{
                $output_paging_nav .= (0)."件を表示しています。";
            }
        }
    }else{
        my $items_per_page_next = $items_per_page;
        if (($result_count - $off_set_next) < $items_per_page){
            #There are less than $items_per_page left.So fix it.
            $items_per_page_next = ($result_count - $off_set_next);
        }
        $output_lower_paging .= " [ <a href=\"".$script_name."?_mode=mode_admin_showUser_items&_type=".$q->param("_type")."&_off_set=".$off_set_next."&_sort_by=".$sort_by."&_limit=".$items_per_page."&_usr_id=".$user_id."\">次の ".$items_per_page_next."件</a> ] ";

        $output_paging_nav .= ($off_set + $items_per_page) . "件を表示しています。";
    }


    $output_lower_end .= $q->end_form();

    
    my $template = $self->load_tmpl(
            $tmpl_file
        );

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_over_data    => $output_over,
        main_loop    => $ref_loop,
        page_lower_delete    => $output_lower_delete,
        page_lower_end => $output_lower_end,
        target_user_id => $user_id,
        page_lower_paging => $output_lower_paging,
        limit => $items_per_page,
        page_nav_paging => $output_paging_nav,
        page_lower_end => $output_lower_end
        );
    return $template->output;

}


sub show_admin_inexport{
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }
    my $output = "";
    my $q = $self->query();

    $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] インポート／エクスポート</div><br />';
    my $page_title =  "REPS :: [管理メニュー] インポート／エクスポート :: Real Estate Publishing System";

    my $label;
    my $tmpl_file;
    my $msg;
    my $RL_HEADER;
    my $RB_HEADER;
    my $BL_HEADER;
    my $BM_HEADER;
    my $BH_HEADER;
    my $BB_HEADER;
    my $RL_IMPORT;
    my $RB_IMPORT;
    my $BL_IMPORT;
    my $BM_IMPORT;
    my $BH_IMPORT;
    my $BB_IMPORT;
    my $strDbPath;
    my $qPrmDataType;
    my $strHeaderFileName;
    my $strTargetFileName;
    my $pmExist = 1;
    require REPS::CMS::InExport::CSV;
    my $CSV = REPS::CMS::InExport::CSV->new($self);

    # インポート処理
    if($q->param("_action") eq 'import'){
        my $strImportDirName = 'import';
        my $qPrmTruncateData = $q->param("Truncate");
        my $strUser_ID = $q->param("strUser_ID");
        my $offset = 0;
        if ($q->param("offset")){$offset = $q->param("offset")};

        if ($q->param("_type") eq 'rl') {
            $label = '賃貸::住居用';
            if ($q->param("_result")){
                $msg.= "$label のインポート処理はすべて完了しました。<br />データの内容を確認してください。";
            }else{
                $strDbPath = $self->param('db_r_apart_path');
                $qPrmDataType = 'rl';
                $strHeaderFileName = "./$strImportDirName/rl.header";
                $strTargetFileName = "./$strImportDirName/rl.csv";
                $msg .= $CSV->import_Data($label, $strDbPath, $qPrmTruncateData, $qPrmDataType, $strUser_ID, $strTargetFileName, $strHeaderFileName, $offset);
            }
        }elsif ($q->param("_type") eq 'rb') {
            $label = '賃貸::事業用';
            if ($q->param("_result")){
                $msg.= "$label のインポート処理はすべて完了しました。<br />データの内容を確認してください。";
            }else{
                $strDbPath = $self->param('db_r_business_path');
                $qPrmDataType = 'rb';
                $strHeaderFileName = "./$strImportDirName/rb.header";
                $strTargetFileName = "./$strImportDirName/rb.csv";
                $msg .= $CSV->import_Data($label, $strDbPath, $qPrmTruncateData, $qPrmDataType, $strUser_ID, $strTargetFileName, $strHeaderFileName, $offset);
            }
        }elsif ($q->param("_type") eq 'bl') {
            $label = '売買::土地';
            if ($q->param("_result")){
                $msg.= "$label のインポート処理はすべて完了しました。<br />データの内容を確認してください。";
            }else{
                $strDbPath = $self->param('db_b_land_path');
                $qPrmDataType = 'bl';
                $strHeaderFileName = "./$strImportDirName/bl.header";
                $strTargetFileName = "./$strImportDirName/bl.csv";
                $msg .= $CSV->import_Data($label, $strDbPath, $qPrmTruncateData, $qPrmDataType, $strUser_ID, $strTargetFileName, $strHeaderFileName, $offset);
            }
        }elsif ($q->param("_type") eq 'bm') {
            $label = '売買::マンション';
            if ($q->param("_result")){
                $msg.= "$label のインポート処理はすべて完了しました。<br />データの内容を確認してください。";
            }else{
                $strDbPath = $self->param('db_b_mansion_path');
                $qPrmDataType = 'bm';
                $strHeaderFileName = "./$strImportDirName/bm.header";
                $strTargetFileName = "./$strImportDirName/bm.csv";
                $msg .= $CSV->import_Data($label, $strDbPath, $qPrmTruncateData, $qPrmDataType, $strUser_ID, $strTargetFileName, $strHeaderFileName, $offset);
            }
        }elsif ($q->param("_type") eq 'bh') {
            $label = '売買::一戸建て';
            if ($q->param("_result")){
                $msg.= "$label のインポート処理はすべて完了しました。<br />データの内容を確認してください。";
            }else{
                $strDbPath = $self->param('db_b_house_path');
                $qPrmDataType = 'bh';
                $strHeaderFileName = "./$strImportDirName/bh.header";
                $strTargetFileName = "./$strImportDirName/bh.csv";
                $msg .= $CSV->import_Data($label, $strDbPath, $qPrmTruncateData, $qPrmDataType, $strUser_ID, $strTargetFileName, $strHeaderFileName, $offset);
            }
        }elsif ($q->param("_type") eq 'bb') {
            $label = '売買::投資用';
            if ($q->param("_result")){
                $msg.= "$label のインポート処理はすべて完了しました。<br />データの内容を確認してください。";
            }else{
                $strDbPath = $self->param('db_b_business_path');
                $qPrmDataType = 'bb';
                $strHeaderFileName = "./$strImportDirName/bb.header";
                $strTargetFileName = "./$strImportDirName/bb.csv";
                $msg .= $CSV->import_Data($label, $strDbPath, $qPrmTruncateData, $qPrmDataType, $strUser_ID, $strTargetFileName, $strHeaderFileName, $offset);
            }
        }else{
            $output .= "<div class=\"warning\"><p>インポートする項目が選択されていません。 </p></div>";
        }
    # エクスポート処理
    }elsif($q->param("_action") eq 'export'){
        my $result='';
        if ($q->param("_type") eq 'rl') {
            $label = "賃貸住居用";
            
            $strDbPath = $self->param('db_r_apart_path');
            $strTargetFileName = './export/rl.header';
            $result = $CSV->export_Data($strDbPath, $strTargetFileName, 'rl.csv');
            #$msg .= $CSV->export('rl', $label, $result);
        }elsif ($q->param("_type") eq 'rb') {
            $label = "賃貸事業用";
            
            $strDbPath = $self->param('db_r_business_path');
            $strTargetFileName = './export/rb.header';
            $result = $CSV->export_Data($strDbPath, $strTargetFileName, 'rb.csv');
            #$msg .= $CSV->export('rb', $label, $result);
        }elsif ($q->param("_type") eq 'bl') {
            $label = "売買土地";
            
            $strDbPath = $self->param('db_b_land_path');
            $strTargetFileName = './export/bl.header';
            $result = $CSV->export_Data($strDbPath, $strTargetFileName, 'bl.csv');
            #$msg .= $CSV->export('bl', $label, $result);
        }elsif ($q->param("_type") eq 'bm') {
            $label = "売買マンション";
            
            $strDbPath = $self->param('db_b_mansion_path');
            $strTargetFileName = './export/bm.header';
            $result = $CSV->export_Data($strDbPath, $strTargetFileName, 'bm.csv');
            #$msg .= $CSV->export('bm', $label, $result);
        }elsif ($q->param("_type") eq 'bh') {
            $label = "売買一戸建て";
            
            $strDbPath = $self->param('db_b_house_path');
            $strTargetFileName = './export/bh.header';
            $result = $CSV->export_Data($strDbPath, $strTargetFileName, 'bh.csv');
            #$msg .= $CSV->export('bh', $label, $result);
        }elsif ($q->param("_type") eq 'bb') {
            $label = "売買投資用";
            
            $strDbPath = $self->param('db_b_business_path');
            $strTargetFileName = './export/bb.header';
            $result = $CSV->export_Data($strDbPath, $strTargetFileName, 'bb.csv');
            #$msg .= $CSV->export('bh', $label, $result);
        }else{
            $output .= "<div class=\"warning\"><p>エクスポートする項目が選択されていません。</p></div>";
        }

        if ($result){
            $output .= "<div class=\"warning\"><p>$result</p></div>";
        }

    }



    # ユーザ一覧の取得
    my $usr = REPS::User->new($self,$self->param('user_id'),'');
    my $ref_loop = $usr->get_usr_list();

    my @user_ids;
    foreach (@$ref_loop) {
        push @user_ids,$$_{'ID'};
    }
    my $selectUserID = $q->popup_menu(-name=>'strUser_ID',
                            -default=>$self->param('user_id'),
                            -values=>[@user_ids]);

    # ヘッダファイルの存在チェック
    if (-e './export/rl.header' && -e $self->param('db_r_apart_path') ){
        $RL_HEADER = $pmExist;
    }
    if (-e './export/rb.header' && -e $self->param('db_r_business_path') ){
        $RB_HEADER = $pmExist;
    }
    if (-e './export/bl.header' && -e $self->param('db_b_land_path') ){
        $BL_HEADER = $pmExist;
    }
    if (-e './export/bm.header' && -e $self->param('db_b_mansion_path') ){
        $BM_HEADER = $pmExist;
    }
    if (-e './export/bh.header' && -e $self->param('db_b_house_path') ){
        $BH_HEADER = $pmExist;
    }
    if (-e './export/bb.header' && -e $self->param('db_b_business_path') ){
        $BB_HEADER = $pmExist;
    }

    # インポートファイルの存在チェック
    if ( (-e './import/rl.csv' || -e './import/rl.xml') && -e './import/rl.header') {
        $RL_IMPORT = $pmExist;
    }
    if ( (-e './import/rb.csv' || -e './import/rb.xml') && -e './import/rb.header') {
        $RB_IMPORT = $pmExist;
    }
    if ( (-e './import/bl.csv' || -e './import/bl.xml') && -e './import/bl.header') {
        $BL_IMPORT = $pmExist;
    }
    if ( (-e './import/bm.csv' || -e './import/bm.xml') && -e './import/bm.header') {
        $BM_IMPORT = $pmExist;
    }
    if ( (-e './import/bh.csv' || -e './import/bh.xml') && -e './import/bh.header') {
        $BH_IMPORT = $pmExist;
    }
    if ( (-e './import/bb.csv' || -e './import/bb.xml') && -e './import/bb.header') {
        $BB_IMPORT = $pmExist;
    }

    # $msgが空でない場合に、divタグでスタライズする
    if($msg ne ''){
        $output .= "<div class=\"information\"><p>" . $msg . "</p></div>";
    }

    my $template = $self->load_tmpl('admin_inexport.tmpl');

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output,
        selectUserID => $selectUserID, 
        RL_HEADER => $RL_HEADER,
        RB_HEADER => $RB_HEADER,
        BL_HEADER => $BL_HEADER,
        BM_HEADER => $BM_HEADER,
        BH_HEADER => $BH_HEADER,
        BB_HEADER => $BB_HEADER,
        RL_IMPORT => $RL_IMPORT,
        RB_IMPORT => $RB_IMPORT,
        BL_IMPORT => $BL_IMPORT,
        BM_IMPORT => $BM_IMPORT,
        BH_IMPORT => $BH_IMPORT,
        BB_IMPORT => $BB_IMPORT,
    );

    return $template->output;

}

sub show_admin_backup{
    my $self = shift;
    my $q = $self->query();
    my $db_path;
    my $output = "";
    my $msg = "";
    my $page_title = "";
    my $label = "";
    my $RL;
    my $RB;
    my $BL;
    my $BM;
    my $BH;
    my $BB;
    my $UP;
    my $CS;
    my $pmExist = 1;
    
    #check the privilege
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }

    $output .= "<div id=\"nav\"><a href=\"$script_name\" class=\"nav\">メインメニュー</a>".'&nbsp;&gt;&nbsp;' . '[管理メニュー] バックアップ</div><br />';
    $page_title =  "REPS :: [管理メニュー] バックアップ :: Real Estate Publishing System";

    require REPS::CMS::BackUp;
    my $BackUp = REPS::CMS::BackUp->new($self);;

    if($q->param("_action") eq 'backup'){
        if ($q->param("rl") eq 'on') {
            $label = "賃貸住居用";
            $msg .= $BackUp->backup($self->param('db_r_apart_path'), 'rl', $label);
        }
        if ($q->param("rb") eq 'on') {
            $label = "賃貸事業用";
            $msg .= $BackUp->backup($self->param('db_r_business_path'), 'rb', $label);
        }
        if ($q->param("bl") eq 'on') {
            $label = "売買土地";
            $msg .= $BackUp->backup($self->param('db_b_land_path'), 'bl', $label);
        }
        if ($q->param("bm") eq 'on') {
            $label = "売買マンション";
            $msg .= $BackUp->backup($self->param('db_b_mansion_path'), 'bm', $label);
        }
        if ($q->param("bh") eq 'on') {
            $label = "売買一戸建て";
            $msg .= $BackUp->backup($self->param('db_b_house_path'), 'bh', $label);
        }
        if ($q->param("bb") eq 'on') {
            $label = "売買投資用";
            $msg .= $BackUp->backup($self->param('db_b_business_path'), 'bb', $label);
        }
        if ($q->param("up") eq 'on') {
            $label = "ユーザー";
            $msg .= $BackUp->backup($self->param('db_usr_profile_path'), 'up', $label);
        }
        if ($q->param("cs") eq 'on') {
            $label = "会社情報";
            $msg .= $BackUp->backup($self->param('db_settings_path'), 'cs', $label);
        }
    }elsif($q->param("_action") eq 'restore'){
        if ($q->param("rl") eq 'on') {
            $label = "賃貸住居用";
            $msg .= $BackUp->restore($self->param('db_r_apart_path'), 'rl', $label);
        }
        if ($q->param("rb") eq 'on') {
            $label = "賃貸事業用";
            $msg .= $BackUp->restore($self->param('db_r_business_path'), 'rb', $label);
        }
        if ($q->param("bl") eq 'on') {
            $label = "売買土地";
            $msg .= $BackUp->restore($self->param('db_b_land_path'), 'bl', $label);
        }
        if ($q->param("bm") eq 'on') {
            $label = "売買マンション";
            $msg .= $BackUp->restore($self->param('db_b_mansion_path'), 'bm', $label);
        }
        if ($q->param("bh") eq 'on') {
            $label = "売買一戸建て";
            $msg .= $BackUp->restore($self->param('db_b_house_path'), 'bh', $label);
        }
        if ($q->param("bb") eq 'on') {
            $label = "売買投資用";
            $msg .= $BackUp->restore($self->param('db_b_business_path'), 'bb', $label);
        }
        if ($q->param("up") eq 'on') {
            $label = "ユーザー";
            $msg .= $BackUp->restore($self->param('db_usr_profile_path'), 'up', $label);
        }
        if ($q->param("cs") eq 'on') {
            $label = "会社情報";
            $msg .= $BackUp->restore($self->param('db_settings_path'), 'cs', $label);
        }
    }

    # バックアップファイルの存在チェック
    if (-e './backup/reps-rl-backup.dump'){
        $RL = $pmExist;
    }
    if (-e './backup/reps-rb-backup.dump'){
        $RB = $pmExist;
    }
    if (-e './backup/reps-bl-backup.dump'){
        $BL = $pmExist;
    }
    if (-e './backup/reps-bm-backup.dump'){
        $BM = $pmExist;
    }
    if (-e './backup/reps-bh-backup.dump'){
        $BH = $pmExist;
    }
    if (-e './backup/reps-bb-backup.dump'){
        $BB = $pmExist;
    }
    if (-e './backup/reps-up-backup.dump'){
        $UP = $pmExist;
    }
    if (-e './backup/reps-cs-backup.dump'){
        $CS = $pmExist;
    }

    #$msgが空でない場合に、divタグでスタライズする
    if($msg ne ''){
        $output .= "<div class=\"information\"><p>" . $msg . "</p></div>";
    }

    my $template = $self->load_tmpl(
            'admin_backup.tmpl'
        );

    $template->param(
        script_version  => $self->version,
        user_id => $self->param('user_id'),
        admin => $self->param('user_isAdmin'),
        script_name  => $script_name,
        static_url => $self->cfg('static_url'),
        r_visible    => $self->param('r_visible'),
        rl_visible    => $self->param('rl_visible'),
        rb_visible    => $self->param('rb_visible'),
        b_visible    => $self->param('b_visible'),
        bl_visible    => $self->param('bl_visible'),
        bm_visible    => $self->param('bm_visible'),
        bh_visible    => $self->param('bh_visible'),
        bb_visible    => $self->param('bb_visible'),
        page_title   => $page_title,
        page_charset => $self->cfg('charset'),
        page_data    => $output,
        RL => $RL,
        RB => $RB,
        BL => $BL,
        BM => $BM,
        BH => $BH,
        BB => $BB,
        UP => $UP,
        CS => $CS
        );
    return $template->output;

}

#this should not be used. internal hack only.
sub show_admin_batch {
    my $self = shift;
    if ($self->param('user_isAdmin') != 1){
        Carp::croak "You do not have admin privilege";
    }

    my $q = $self->query();
    my $output = "";
    my $Realestate;

    if ($q->param("_type") eq 'rl') {
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
    }elsif ($q->param("_type") eq 'rb') {
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
    }elsif ($q->param("_type") eq 'bl') {
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
    }elsif ($q->param("_type") eq 'bm') {
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
    }elsif ($q->param("_type") eq 'bh') {
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
    }elsif ($q->param("_type") eq 'bb') {
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
    }else{
        return "No type specified.";
    }

    my $ref_loop = $Realestate->do_batch();

    return "A batch proccess is now done.";


}

sub recommend_static_write_file{
    my $self = shift;

    my $Realestate;
    my @tmp = ();
    my $ref_hash_rl=\@tmp;
    my $ref_hash_rb=\@tmp;
    my $ref_hash_bl=\@tmp;
    my $ref_hash_bm=\@tmp;
    my $ref_hash_bh=\@tmp;
    my $ref_hash_bb=\@tmp;

    if (!$self->cfg('recommend_static_filename')){return 1;}

    if (uc($self->cfg('recommend_static_rl')) eq 'ON'){
        require REPS::CMS::Realestate::R_Apartment;
        $Realestate = REPS::CMS::Realestate::R_Apartment->new($self);
        $ref_hash_rl = $Realestate->get_Specials();
    }
    if (uc($self->cfg('recommend_static_rb')) eq 'ON'){
        require REPS::CMS::Realestate::R_Business;
        $Realestate = REPS::CMS::Realestate::R_Business->new($self);
        $ref_hash_rb = $Realestate->get_Specials();
    }
    if (uc($self->cfg('recommend_static_bl')) eq 'ON'){
        require REPS::CMS::Realestate::B_Land;
        $Realestate = REPS::CMS::Realestate::B_Land->new($self);
        $ref_hash_bl = $Realestate->get_Specials();
    }
    if (uc($self->cfg('recommend_static_bm')) eq 'ON'){
        require REPS::CMS::Realestate::B_Mansion;
        $Realestate = REPS::CMS::Realestate::B_Mansion->new($self);
        $ref_hash_bm = $Realestate->get_Specials();
    }
    if (uc($self->cfg('recommend_static_bh')) eq 'ON'){
        require REPS::CMS::Realestate::B_House;
        $Realestate = REPS::CMS::Realestate::B_House->new($self);
        $ref_hash_bh = $Realestate->get_Specials();
    }
    if (uc($self->cfg('recommend_static_bb')) eq 'ON'){
        require REPS::CMS::Realestate::B_Business;
        $Realestate = REPS::CMS::Realestate::B_Business->new($self);
        $ref_hash_bb = $Realestate->get_Specials();
    }

    $self->tmpl_path(File::Spec->catdir($RealBin, $self->cfg('tmpl_path')));
    #$self->tmpl_path($self->cfg('tmpl_path'));

    my $template = $self->load_tmpl(
            'site_static_recommend.tmpl',die_on_bad_params => 0
        );

    $template->param(
        rl_recommend => $ref_hash_rl,
        rb_recommend => $ref_hash_rb,
        bl_recommend => $ref_hash_bl,
        bm_recommend => $ref_hash_bm,
        bh_recommend => $ref_hash_bh,
        bb_recommend => $ref_hash_bb,
        #script_name  => $script_name,
        page_charset => $self->cfg('charset'),
        #page_data    => $output,
        site_url => $self->cfg('site_url'),
        cgi_url  => $self->cfg('cgi_url'),
        #info_string            => $str
        );

    require REPS::Util;
    my $file = REPS::Util->de_taint($self->cfg('site_path').$self->cfg('recommend_static_filename'));

    if ($file){
        require Unicode::Japanese;
        my $UJ = Unicode::Japanese->new();

        #
        my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
        my $charset = uc($self->cfg('charset'));
        if (defined($charmap->{$charset})){
            #$UJ->set($template->output,'euc');
            my $encode = $charmap->{$charset};
my $umask;
if ($self->cfg('HTMLUmask')){
    $umask = oct $self->cfg('HTMLUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
            open (OUT,">$file") || Carp::croak ("$! $file");
            flock(OUT,2) || Carp::croak ("$file : $! flock");
                #print OUT $UJ->$encode;
                #not good for old perl5
                print OUT $UJ->set($template->output,'euc')->conv($encode);
            flock(OUT,8) || Carp::croak("$file : $!");
            close (OUT) || Carp::croak("$file : $! $file");
umask($old);
        }else{
            Carp::croak "Unknown charset encoding.";
        }
    }

    $self->tmpl_path(File::Spec->catdir($RealBin, 'system/templates'));

    return 1;
}

#takes a string and its charset, then covert the string's charset to euc.
sub convert_charset {
    my $self = shift;
    local($_) = shift;
    #my $charset = uc(shift);

    #does this work?
    #require REPS;
    my $charset = uc($self->cfg('charset'));

    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {
        my $encode = $charmap->{$charset};
        my $UJ = Unicode::Japanese->new();
        return $UJ->set($_,$encode)->euc;

    }else{
        Carp::croak "Unknown charset encoding.";
    }
}

#takes a hash and its charset, then covert its value's charset to euc.
sub convert_hash_charset {
    my $self = shift;
    local($_) = shift;
    #my $charset = uc(shift);

    #does this work?
    #require REPS;
    my $charset = uc($self->cfg('charset'));

    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'Shift_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {
        my $encode = $charmap->{$charset};
        my $UJ = Unicode::Japanese->new();
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

sub mkpath {
    my $self = shift;
    my($path) = @_;
    require File::Path;
    my $umask;

    if ($self->cfg('DirUmask')){
        $umask = oct $self->cfg('DirUmask');
    }else{
        $umask = oct 0000;
    }
    my $old = umask($umask);
    eval { File::Path::mkpath([$path], 0, 0777) };
    #return $self->error($@) if $@;
    Carp::croak "$@" if $@;
    umask($old);

    1;
}


1
