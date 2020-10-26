package REPS::Search;

use strict;
use base qw( REPS CGI::Application );

use FindBin qw( $Bin );

#use REPS::Util;
use REPS::User;
use REPS::Settings;


use vars qw(
    $script_name
    $charset
);

sub setup {
    my $self = shift;
    $self->run_modes(
               'mode_search'                 => 'show_search',
               'mode_search,mode_search'     => 'show_search', #work around for mobile au bug
               'mode_result'                 => 'show_result',
               'mode_detail'                 => 'show_detail',
               'mode_inquiry'                => 'show_inquiry',
               #'mode_recommend'              => 'show_recommend',
    );

    my $q = $self->query();

    #workaround for Cobalt (BlueQuartz)
    if (my $path_info = $ENV{PATH_INFO}) {
        if ($path_info =~ m/\.cgi$/) {
            delete $ENV{PATH_INFO};
        }
    }
    $script_name = $q->url;#$ENV{'SCRIPT_NAME'};

    $self->start_mode('mode_search');

    $self->mode_param('_mode');

    $self->param('user_id'=>'');
    $self->param('user_logged_in'=>0);
    $self->param('user_isAdmin'=>0);

    require REPS; #for older version of perl.

    if (uc($self->cfg('this_is_demo')) eq 'ON'){
        $self->param('this_is_demo'=>1);
    }else{
        $self->param('this_is_demo'=>0);
    }

    $self->param('script_name'=>$script_name);

    $self->tmpl_path($self->cfg('tmpl_path'));

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

    if ($self->param('mobile')){
        $charset = $self->cfg('charset_mobile');
    }else{
        $charset = $self->cfg('charset');
    }
    
    $self->header_props(
        -charset=>$charset,
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
            $self->param('user_logged_in'=>1);
        }
    }
}

sub cgiapp_postrun {
    my $self = shift;
    my $bodyref = shift;

    $charset = uc($charset);
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

# sub show_recommend {
#     my $self = shift;
#     my $q = $self->query();
# 
#     if ($q->param("_type")){
#         require REPS::CMS::Special;
#         my $recomend;
#         my $tmpl_recommend;
#         my $template;
#         my $output;
#         if ($q->param("_type") eq 'rl') {
#             $tmpl_recommend = 'pub_rl_recommend.tmpl';
#             $recomend = REPS::CMS::Special->new($self,$self->param('db_r_apart_special_path'));
#         }elsif ($q->param("_type") eq 'rb') {
#             $tmpl_recommend = 'pub_rb_recommend.tmpl';
#             $recomend = REPS::CMS::Special->new($self,$self->param('db_r_business_special_path'));
#         }elsif ($q->param("_type") eq 'bl') {
#             $tmpl_recommend = 'pub_bl_recommend.tmpl';
#             $recomend = REPS::CMS::Special->new($self,$self->param('db_b_land_special_path'));
#         }elsif ($q->param("_type") eq 'bm') {
#             $tmpl_recommend = 'pub_bm_recommend.tmpl';
#             $recomend = REPS::CMS::Special->new($self,$self->param('db_b_mansion_special_path'));
#         }elsif ($q->param("_type") eq 'bh') {
#             $tmpl_recommend = 'pub_bh_recommend.tmpl';
#             $recomend = REPS::CMS::Special->new($self,$self->param('db_b_house_special_path'));
#         }else{
#             return "ʪ��μ��ब�����Ǥ���(The type is not defined.)";
#         }
# 
#         my $ref_loop = $recomend->get_special();
# 
#         $template = $self->load_tmpl(
#                 $tmpl_recommend, die_on_bad_params => 0
#             );
#         $template->param(
#             script_name  => $script_name,
#             page_charset => $charset,
#             page_data    => $output,
#             site_url => $self->cfg('site_url'),
#             cgi_url => $self->cfg('cgi_url'),
#             main_loop    => $ref_loop,
#             );
# 
#         return $template->output;
# 
#     }else{
#         return "ʪ��μ��ब���ꤵ��Ƥ��ޤ���(No type specified.)";
#     }
# 
# }

sub show_search {
    my $self = shift;
    my $q = $self->query();
    my $output = "";
    my $ref_loop;
    my $template;

    my $Realestate;
    my $label_where;
    my $tmpl_search;
    my $tmpl_search_result;

    if ($q->param("_type")){
        if (($q->param("_type") eq 'rl') or ($q->param("_type") eq 'rl,rl')) {
            $label_where = '����::����';
            require REPS::Search::Realestate::R_Apartment;
            $Realestate = REPS::Search::Realestate::R_Apartment->new($self);
            if ($self->param('mobile')){
                $tmpl_search = 'mob_rl_search.tmpl';
                $tmpl_search_result = 'mob_rl_search_result.tmpl';
            }else{
                $tmpl_search = 'pub_rl_search.tmpl';
                $tmpl_search_result = 'pub_rl_search_result.tmpl';
            }
        }elsif (($q->param("_type") eq 'rb') or ($q->param("_type") eq 'rb,rb')) {
            $label_where = '����::������';
            require REPS::Search::Realestate::R_Business;
            $Realestate = REPS::Search::Realestate::R_Business->new($self);
            if ($self->param('mobile')){
                $tmpl_search = 'mob_rb_search.tmpl';
                $tmpl_search_result = 'mob_rb_search_result.tmpl';
            }else{
                $tmpl_search = 'pub_rb_search.tmpl';
                $tmpl_search_result = 'pub_rb_search_result.tmpl';
            }
        }elsif (($q->param("_type") eq 'bl') or ($q->param("_type") eq 'bl,bl')) {
            $label_where = '����::����';
            require REPS::Search::Realestate::B_Land;
            $Realestate = REPS::Search::Realestate::B_Land->new($self);
            if ($self->param('mobile')){
                $tmpl_search = 'mob_bl_search.tmpl';
                $tmpl_search_result = 'mob_bl_search_result.tmpl';
            }else{
                $tmpl_search = 'pub_bl_search.tmpl';
                $tmpl_search_result = 'pub_bl_search_result.tmpl';
            }
        }elsif (($q->param("_type") eq 'bm') or ($q->param("_type") eq 'bm,bm')) {
            $label_where = '����::�ޥ󥷥��';
            require REPS::Search::Realestate::B_Mansion;
            $Realestate = REPS::Search::Realestate::B_Mansion->new($self);
            if ($self->param('mobile')){
                $tmpl_search = 'mob_bm_search.tmpl';
                $tmpl_search_result = 'mob_bm_search_result.tmpl';
            }else{
                $tmpl_search = 'pub_bm_search.tmpl';
                $tmpl_search_result = 'pub_bm_search_result.tmpl';
            }
        }elsif (($q->param("_type") eq 'bh') or ($q->param("_type") eq 'bh,bh')) {
            $label_where = '����::��ͷ���';
            require REPS::Search::Realestate::B_House;
            $Realestate = REPS::Search::Realestate::B_House->new($self);
            if ($self->param('mobile')){
                $tmpl_search = 'mob_bh_search.tmpl';
                $tmpl_search_result = 'mob_bh_search_result.tmpl';
            }else{
                $tmpl_search = 'pub_bh_search.tmpl';
                $tmpl_search_result = 'pub_bh_search_result.tmpl';
            }
        }elsif (($q->param("_type") eq 'bb') or ($q->param("_type") eq 'bb,bb')) {
            $label_where = '����::�����';
            require REPS::Search::Realestate::B_Business;
            $Realestate = REPS::Search::Realestate::B_Business->new($self);
            if ($self->param('mobile')){
                $tmpl_search = 'mob_bb_search.tmpl';
                $tmpl_search_result = 'mob_bb_search_result.tmpl';
            }else{
                $tmpl_search = 'pub_bb_search.tmpl';
                $tmpl_search_result = 'pub_bb_search_result.tmpl';
            }
        }else{
            return "ʪ��μ��ब�����Ǥ���(The type is not defined.)";

        }
    }else{
        if ($self->param('mobile')){
            #TODO:
            #get settings info and display company info.if independent_user=off 

            $template = $self->load_tmpl(
                    'mob_menu.tmpl',die_on_bad_params => 0
                );
            $template->param(
                script_name  => $script_name,
                page_charset => $charset,
                site_url => $self->cfg('site_url'),
                cgi_url => $self->cfg('cgi_url'),
                );
    
            return $template->output;
        }else{
            return "ʪ��μ��ब���ꤵ��Ƥ��ޤ���(No type specified.)";
        }
    }

    if ($q->param("search_object")) {
        $template = $self->load_tmpl(
                $tmpl_search_result,die_on_bad_params => 0,
            );
        my $sort_by = '';
        $sort_by = $q->param("sort_by") if $q->param("sort_by");
        my $off_set = 0;
        $off_set = $q->param("off_set") if $q->param("off_set");

        my $items_per_page = 10;
        if ($self->param('mobile')){
            $items_per_page = $self->cfg('items_per_page_mobile');
        }else{
            $items_per_page = $self->cfg('items_per_page');
        }
        require REPS::Search::Search;
        my $Search = REPS::Search::Search->new();
        $Search->{'sort_by'} = $sort_by;
        if ($q->param("off_set_next")){
            $Search->{'off_set'} = $q->param("off_set_next");
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
                $output .= "<strong>$result_count��</strong>��&nbsp;".($off_set_next+1)."��$d���ɽ�����Ƥ��ޤ���";
                if ($items_per_page > ($result_count - $d)){
                    $items_per_page_next = $result_count - $d;
                }else{
                    $items_per_page_next = $items_per_page;
                }
                $off_set_next = $d;
            }else{
                $output .= "<strong>$result_count��</strong>��&nbsp;".($off_set_next+1)."��$result_count���ɽ�����Ƥ��ޤ���";
            }

#            $off_set_next = $q->param("off_set_next");
#            $output .= "<strong>$result_count��</strong>��&nbsp;$off_set_next��$result_count���ɽ�����Ƥ��ޤ���";
        }else{
            #if next page 
            my $tmp_count = ($off_set+$items_per_page);
            #if rest is less than items_per_page
            my $d;
            if ($off_set == 0){$d = 1;}else{$d = $off_set+1;}
            if ($result_count == 0){$d = 0;};
            if ($tmp_count >= $result_count){
                $output .= "<strong>$result_count��</strong>��&nbsp;$d��$result_count���ɽ�����Ƥ��ޤ���";
                $items_per_page_next = '';
                $off_set_next = $result_count;
            }else{
                $output .= "<strong>$result_count��</strong>��&nbsp;$d��$tmp_count���ɽ�����Ƥ��ޤ���";
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

        foreach (@$ref_loop){
            $$_{'script_name'} = $script_name;
        }

        $q->delete('_object_id');
        require REPS::Util;
        my $params;
        foreach my $param ($q->param()){
            my @values = $q->param($param);
            if (scalar(@values) > 1){
                my $tmp_str;
                for (my $i=0;$i < scalar(@values);$i++){
                    $tmp_str .= $values[$i];
                    unless ($i == (scalar(@values)-1)){$tmp_str = $tmp_str.","}
                }
                $params->{$param} = REPS::Util->stripHtmlChars(
                                            REPS::Util->stripMetachars(
                                                $self->convert_charset($tmp_str)
                                            )
                                    );
                if ($self->param('mobile')){$params->{$param} = REPS::Util->stripEmoji($params->{$param});}
            } else {
                $params->{$param} = REPS::Util->stripHtmlChars(
                                            REPS::Util->stripMetachars(
                                                $self->convert_charset($q->param($param))
                                            )
                                    );
                if ($self->param('mobile')){$params->{$param} = REPS::Util->stripEmoji($params->{$param});}
            }
        }

        $params->{'script_name'} = $script_name;
        $params->{'page_charset'} = $charset;
        $params->{'page_data'} = $output;
        $params->{'main_loop'} = $ref_loop;
        $params->{'result_count'} = $result_count;
        $params->{'off_set'} = $off_set;
        $params->{'off_set_next'} = $off_set_next;
        $params->{'items_per_page_next'} = $items_per_page_next;
        $params->{'off_set_pre'} = $off_set_pre;
        $params->{'items_per_page_pre'} = $items_per_page_pre;

        $params->{'search_object'} = 'Search';

        $params->{'site_url'} = $self->cfg('site_url');
        $params->{'cgi_url'} = $self->cfg('cgi_url');

        $template->param($params);

    }else{

        $template = $self->load_tmpl(
                $tmpl_search,die_on_bad_params => 0
            );
        $template->param(
            script_name  => $script_name,
            page_charset => $charset,
            page_data    => $output,
            site_url => $self->cfg('site_url'),
            cgi_url  => $self->cfg('cgi_url'),
            );

    }

    return $template->output;
}

sub show_detail{
    my $self = shift;
    my $q = $self->query();
    my $output = "";

    my $template;
    my $ref_loop = ();
    my $result_count;

    my $Realestate;
    my $label_where;
    my $tmpl_detail;

    if ($q->param("_type") eq 'rl') {
        $label_where = '����::����';
        require REPS::Search::Realestate::R_Apartment;
        $Realestate = REPS::Search::Realestate::R_Apartment->new($self);
        if ($self->param('mobile')){
            $tmpl_detail = 'mob_rl_detail.tmpl';
        }else{
            $tmpl_detail = 'pub_rl_detail.tmpl';
        }
    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '����::������';
        require REPS::Search::Realestate::R_Business;
        $Realestate = REPS::Search::Realestate::R_Business->new($self);
        if ($self->param('mobile')){
            $tmpl_detail = 'mob_rb_detail.tmpl';
        }else{
            $tmpl_detail = 'pub_rb_detail.tmpl';
        }
    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '����::����';
        require REPS::Search::Realestate::B_Land;
        $Realestate = REPS::Search::Realestate::B_Land->new($self);
        if ($self->param('mobile')){
            $tmpl_detail = 'mob_bl_detail.tmpl';
        }else{
            $tmpl_detail = 'pub_bl_detail.tmpl';
        }
    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '����::�ޥ󥷥��';
        require REPS::Search::Realestate::B_Mansion;
        $Realestate = REPS::Search::Realestate::B_Mansion->new($self);
        if ($self->param('mobile')){
            $tmpl_detail = 'mob_bm_detail.tmpl';
        }else{
            $tmpl_detail = 'pub_bm_detail.tmpl';
        }
    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '����::��ͷ���';
        require REPS::Search::Realestate::B_House;
        $Realestate = REPS::Search::Realestate::B_House->new($self);
        if ($self->param('mobile')){
            $tmpl_detail = 'mob_bh_detail.tmpl';
        }else{
            $tmpl_detail = 'pub_bh_detail.tmpl';
        }
    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '����::�����';
        require REPS::Search::Realestate::B_Business;
        $Realestate = REPS::Search::Realestate::B_Business->new($self);
        if ($self->param('mobile')){
            $tmpl_detail = 'mob_bb_detail.tmpl';
        }else{
            $tmpl_detail = 'pub_bb_detail.tmpl';
        }
    }else{
        return "No type specified.";
    }

    if ($q->param("_object_id")) {
        $ref_loop = $Realestate->get_Detail_List($q->param("_object_id"));
        #$q->delete_all;
        $template = $self->load_tmpl(
                $tmpl_detail,die_on_bad_params => 0
            );
        my $result_one = '';
        my $aid = '';
        $result_count = (scalar @$ref_loop);
        if (1 == $result_count){
            $result_one = 1;
            #my @tmp = @$ref_loop;
            $aid = $q->param("_object_id");
        }elsif(0 == $result_count){
            #return 404 status code header
            $self->header_props(
                -status=>'404 Not Found'
            );
        }
        if ($result_one){
            $template->param(
                script_name  => $script_name,
                page_charset => $charset,
                page_data    => $output,
                main_loop => $ref_loop,
                result_count =>$result_count,
                result_one => $result_one,
                aid => $aid,
                site_url => $self->cfg('site_url'),
                cgi_url => $self->cfg('cgi_url'),
                _type => $q->param("_type")
                );
        }else{
            $template->param(
                script_name  => $script_name,
                #page_title   => $page_title,
                page_charset => $charset,
                page_data    => $output,
                main_loop => $ref_loop,
                result_count => $result_count,
                site_url => $self->cfg('site_url'),
                cgi_url => $self->cfg('cgi_url'),
                _type => $q->param("_type")
                );
        }

    }else{
        $q->delete_all;
        $output .= '<div class="warning">ʪ�郎���򤵤�Ƥ��ޤ���</div>';
        $template = $self->load_tmpl(
                $tmpl_detail,die_on_bad_params => 0
            );
        $template->param(
            script_name  => $script_name,
            page_charset => $charset,
            page_data    => $output,
            site_url => $self->cfg('site_url'),
            cgi_url => $self->cfg('cgi_url'),
            );
    }

    return $template->output;
}

sub show_inquiry{
    my $self = shift;
    my $q = $self->query();
    my $output = "";

    my $mailHTML;
    my $template;
    my $ref_loop = ();
    my $result_count;

    my $Realestate;
    my $label_where;
    my $tmpl_inquiry;
    if ($q->param("_type") eq 'rl') {
        $label_where = '����::����';
        require REPS::Search::Realestate::R_Apartment;
        $Realestate = REPS::Search::Realestate::R_Apartment->new($self);
        if ($self->param('mobile')){
            $tmpl_inquiry = 'mob_rl_Inquiry.tmpl';
        }else{
            $tmpl_inquiry = 'pub_rl_Inquiry.tmpl';
        }
    }elsif ($q->param("_type") eq 'rb') {
        $label_where = '����::������';
        require REPS::Search::Realestate::R_Business;
        $Realestate = REPS::Search::Realestate::R_Business->new($self);
        if ($self->param('mobile')){
            $tmpl_inquiry = 'mob_rb_Inquiry.tmpl';
        }else{
            $tmpl_inquiry = 'pub_rb_Inquiry.tmpl';
        }
    }elsif ($q->param("_type") eq 'bl') {
        $label_where = '����::����';
        require REPS::Search::Realestate::B_Land;
        $Realestate = REPS::Search::Realestate::B_Land->new($self);
        if ($self->param('mobile')){
            $tmpl_inquiry = 'mob_bl_Inquiry.tmpl';
        }else{
            $tmpl_inquiry = 'pub_bl_Inquiry.tmpl';
        }
    }elsif ($q->param("_type") eq 'bm') {
        $label_where = '����::�ޥ󥷥��';
        require REPS::Search::Realestate::B_Mansion;
        $Realestate = REPS::Search::Realestate::B_Mansion->new($self);
        if ($self->param('mobile')){
            $tmpl_inquiry = 'mob_bm_Inquiry.tmpl';
        }else{
            $tmpl_inquiry = 'pub_bm_Inquiry.tmpl';
        }
    }elsif ($q->param("_type") eq 'bh') {
        $label_where = '����::��ͷ���';
        require REPS::Search::Realestate::B_House;
        $Realestate = REPS::Search::Realestate::B_House->new($self);
        if ($self->param('mobile')){
            $tmpl_inquiry = 'mob_bh_Inquiry.tmpl';
        }else{
            $tmpl_inquiry = 'pub_bh_Inquiry.tmpl';
        }
    }elsif ($q->param("_type") eq 'bb') {
        $label_where = '����::�����';
        require REPS::Search::Realestate::B_Business;
        $Realestate = REPS::Search::Realestate::B_Business->new($self);
        if ($self->param('mobile')){
            $tmpl_inquiry = 'mob_bb_Inquiry.tmpl';
        }else{
            $tmpl_inquiry = 'pub_bb_Inquiry.tmpl';
        }
    }else{
        return "No type specified.";
    }

    if ($q->param("submit_Inquiry")){
        if ($q->param("_object_id")) {
            if (($q->param("_type") eq 'rl') || ($q->param("_type") eq 'rb')) {
                #��ǳ�ǧ�᡼���Ф����
                my $email_address;

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
                    if ($self->param('mobile')){
                        $output = "<div class=\"warning\">$output</div>";
                    }else{
                        $output = "<div class=\"warning\">$output<a href=\"javascript:history.back()\">���</a></div>";
                    }
                }else{
                    if ($self->param('mobile')){
                        $mailHTML .= '���Ӥ�����䤤��碌�Ǥ���'."\n";
                    }
                    $mailHTML .= '�����п�̾:' . $self->convert_charset($q->param("c_name"))."\n";
                    $mailHTML .= '�������ֹ�:' . $self->convert_charset($q->param("c_phone"))."\n";
                    if ($q->param("c_email")){
                        $mailHTML .= '��FAX:' . $self->convert_charset($q->param("c_fax"))."\n";
                    }
                    $mailHTML .= '���᡼�륢�ɥ쥹:' . $self->convert_charset($q->param("c_email"))."\n";
                    $email_address = $self->convert_charset($q->param("c_email"));
                    if ($q->param("contact_pref") == 1){
                        $mailHTML .= "��Ϣ��ϡ��᡼��ǡ�\n";    
                    }elsif($q->param("contact_pref") == 2){
                        $mailHTML .= "��Ϣ��ϡ����äǡ�\n";    
                    }elsif($q->param("contact_pref") == 3){
                        $mailHTML .= "��Ϣ����ˡ�ϥ᡼�롢���äɤ���Ǥ⡣\n";
                    }else{
                        $mailHTML .= "��Ϣ����ˡ������\n";
                    }
                    $mailHTML .= '���䤤��碌����:'."\n--------------------\n" . $self->convert_charset($q->param("c_text"),$charset)."\n\n--------------------\n";    
                
                    #$send
##
                    $ref_loop = $Realestate->get_Simple_List($q->param("_object_id"));
                    require REPS::Search::Inquiry;
                    my $mail = REPS::Search::Inquiry->new($self);
                    my $usr = REPS::User->new($self,'','','');
                    my $Settings = REPS::Settings->new($self);
    
                    my $tmp_company_info;
                    my $usr_company_info;

                    if (uc($self->cfg('independent_users')) eq 'ON') {

                        #get users company info
                        my @usr_ids;
                        foreach (@$ref_loop){
                            push (@usr_ids, $$_{'USER_ID'});
                        }
    
                        $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
                        $tmp_company_info = $Settings->get_settings_contact_info();

                        my $admin_mailaddress = $usr->get_admin_mailaddress;
                        foreach (@$ref_loop){
                            my $tmp = $_;
                            $mail->{'MAIL_TO'} = '';
                            $mail->{'MAIL_BCC'} = '';
                            $mail->{'MAIL_TEXT'} = '';

                            #my $tmp_usr = $usr->get_usr_to_be_displayed($$tmp{'USER_ID'});
                            if (uc($self->cfg('independent_users')) eq 'ON') {
                                $mail->{'MAIL_TO'} = $$usr_company_info{$$tmp{'USER_ID'}}{'USER_EMAIL'};
        
                                if ($$tmp_company_info{'COMPANY_SEND_BBC_ADMIN_EMAIL'}){
                                    if ($$tmp_company_info{'COMPANY_EMAIL'} ne $mail->{'MAIL_TO'}){
                                        $mail->{'MAIL_BCC'} = $$tmp_company_info{'COMPANY_EMAIL'};
                                    }
                                }
                            }
                            $mail->{'MAIL_SUBJECT'} = '[REPS][����]ʪ��˴ؤ��뤪�䤤��碌�Ǥ��� ';
                    
                            if (!$mail->{'MAIL_TO'}){die "No email adress is provided.";}
                        
                            $mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
                            $mail->{'MAIL_TEXT'} .= "���Υ᡼��ϡ��ۡ���ڡ���������ʪ���䤤��碌�ե������������Ƥ��ޤ���\n������ʪ��ˤĤ��ơ����䤤��碌�Ǥ���\n";
        
                            $mail->{'MAIL_TEXT'} .= '�䤤��碌ʪ��ڡ���URL(������󥯤򥯥�å����뤫�����ԡ����ƥ֥饦�����ǳ����Ƥ�������)��'."\n";
                            #if ($self->param('mobile')){
                                #mode
                            #    $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            #}else{
                                #_mode
                                $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            #}

                            $mail->{'MAIL_TEXT'} .= "$mailHTML\n";

                            $mail->{'MAIL_TEXT'} .= "\n\n";
                            #Send it
                            my $result = $mail->send;
                            if ($result != 1){
                                $output .= $result;
                            }
                        }
                        $Realestate->log_Inquiry($q->param("_object_id"));

#do not send it here.
#                        #Send it
#                        my $result = $mail->send;
#                        if ($result != 1){
#                            $output .= $result;
#                        }

                    }else{

                        $tmp_company_info = $Settings->get_settings_contact_info();

                        my $admin_mailaddress = $usr->get_admin_mailaddress;
                        foreach (@$ref_loop){
                            my $tmp = $_;
                            $mail->{'MAIL_TO'} = '';
                            $mail->{'MAIL_BCC'} = '';

                            if ($$tmp_company_info{'COMPANY_RENT_EMAIL'}){
                                $mail->{'MAIL_TO'} = $$tmp_company_info{'COMPANY_RENT_EMAIL'};
                            }else{
                                $mail->{'MAIL_TO'} = $$tmp_company_info{'COMPANY_EMAIL'};
                            }
                            if ($$tmp_company_info{'COMPANY_SEND_BBC_ADMIN_EMAIL'}){
                                if ($admin_mailaddress ne $mail->{'MAIL_TO'}){
                                    $mail->{'MAIL_BCC'} = $admin_mailaddress;
                                }
                            }

                            $mail->{'MAIL_SUBJECT'} = '[REPS][����]ʪ��˴ؤ��뤪�䤤��碌�Ǥ��� ';

                            if (!$mail->{'MAIL_TO'}){die "No email adress is provided.";}

                            $mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
                            $mail->{'MAIL_TEXT'} .= "���Υ᡼��ϡ��ۡ���ڡ���������ʪ���䤤��碌�ե������������Ƥ��ޤ���\n������ʪ��ˤĤ��ơ����䤤��碌�Ǥ���\n";

                            $mail->{'MAIL_TEXT'} .= '�䤤��碌ʪ��ڡ���URL(������󥯤򥯥�å����뤫�����ԡ����ƥ֥饦�����ǳ����Ƥ�������)��'."\n";
                            #if ($self->param('mobile')){
                                #mode
                            #    $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            #}else{
                                #_mode
                                $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            #}

                            $mail->{'MAIL_TEXT'} .= "$mailHTML\n";

                            $mail->{'MAIL_TEXT'} .= "\n\n";

                        }
                        $Realestate->log_Inquiry($q->param("_object_id"));

                        #Send it
                        my $result = $mail->send;
                        if ($result != 1){
                            $output .= $result;
                        }

                    }

##

                    #��ǧ�᡼����䤤��碌��������
                    if (uc($self->cfg('send_confirmation')) eq 'ON') {
                        if ($email_address){
                            if ($email_address =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                                my $mail_comfirm = REPS::Search::Inquiry->new($self);
                                $mail_comfirm->{'MAIL_FROM'} = $$tmp_company_info{'COMPANY_EMAIL'};
                                $mail_comfirm->{'MAIL_TO'} = $email_address;
                                $mail_comfirm->{'MAIL_SUBJECT'} = '[���䤤��碌�γ�ǧ] ʪ��˴ؤ��뤪�䤤��碌������դ��ޤ�����';

                                $mail_comfirm->{'MAIL_TEXT'} = '���䤤��碌ĺ���ޤ��Ƥ��꤬�Ȥ��������ޤ����ܥ᡼��ϡ�'."\n";
                                $mail_comfirm->{'MAIL_TEXT'} .= $self->cfg('site_url')."\n";
                                $mail_comfirm->{'MAIL_TEXT'} .= '���䤤��碌�ե������ꡢ��ư�������Ƥ��ޤ���'."\n";

                                $mail_comfirm->{'MAIL_TEXT'} .= 'ô���Ԥ����ֿ�������ޤǺ����Ф餯���Ԥ�����������'."\n\n";
                                #$mail_comfirm->{'MAIL_TEXT'} .= $texts;

                                my $result_comfirm = $mail_comfirm->send;
                                if ($result_comfirm != 1){
                                    $output .= $result_comfirm;
                                }
                            }
                        }
                    }

                    if ($output){
                        if ($self->param('mobile')){
                            $output .= "<div class=\"warning\">$output</div>";
                        }else{
                            $output .= "<div class=\"warning\">$output<a href=\"javascript:history.back()\">���</a></div>";
                        }
                    }

                    $output = "<div class=\"information\">������λ���ޤ��������꤬�Ȥ��������ޤ���";
                        if (uc($self->cfg('send_confirmation')) eq 'ON') {
                            if ($email_address){
                                if ($email_address =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                                    $output .= '<br /><br />�ʤ�����ǧ�Υ᡼����������ޤ����Τǡ�Ⱦ�����ٷФäƤ��ǧ�᡼�뤬�Ϥ��ʤ��ä����ϡ��᡼�륢�ɥ쥹�γ�ǧ�򤷤���ǡ������٤��䤤��碌ĺ�������פ��ޤ���';
                                }
                            }
                        }
                    $output .= "</div>";
                    #$output .= "<div class=\"information\">������λ��<br />���꤬�Ȥ��������ޤ�����</div>";
                    $output .= '<br /><br />';    
                }

            }else{
                #����


                my $texts;
                #��ǡ��䤤��碌���˳�ǧ�᡼�������,���ɥ쥹�򤳤��ǽ������
                my $email_address;
################################
                if ($self->param('mobile')){

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

                    #��ǡ��䤤��碌���˳�ǧ�᡼������٤����ǳ��ݡ�
                    $email_address = $self->convert_charset($q->param("c_email"));

                    $texts .= '�����Ǥ�����䤤��碌�Ǥ���'."\n";
                        $texts .= '�����п�̾:' . $self->convert_charset($q->param("c_name"))."\n";
                        $texts .= '�������ֹ�:' . $self->convert_charset($q->param("c_phone"))."\n";
                        $texts .= '���᡼�륢�ɥ쥹:' . $self->convert_charset($q->param("c_email"))."\n";    
                        if ($q->param("contact_pref") == 1){
                            $texts .= "��Ϣ��ϡ��᡼��ǡ�\n";    
                        }elsif($q->param("contact_pref") == 2){
                            $texts .= "��Ϣ��ϡ����äǡ�\n";    
                        }elsif($q->param("contact_pref") == 3){
                            $texts .= "��Ϣ����ˡ�ϥ᡼�롢���äɤ���Ǥ⡣\n";
                        }else{
                            $texts .= "��Ϣ����ˡ������\n";
                        }
                        $texts .= '���䤤��碌����:'."\n--------------------\n" . $self->convert_charset($q->param("c_text"))."\n\n--------------------\n";    
    

                } else {
                #not mobile

                    my $BUKKEN_SYUBETSU = $self->convert_charset($q->param("BUKKEN_SYUBETSU")) if $q->param("BUKKEN_SYUBETSU");
                    my $BUKKEN_AREA = $self->convert_charset($q->param("BUKKEN_AREA")) if $q->param("BUKKEN_AREA");
                    my $BUKKEN_EKI = $self->convert_charset(join(',', $q->param("BUKKEN_EKI"))) if $q->param("BUKKEN_EKI");
                    my $BUKKEN_AREA_SECOND = $self->convert_charset($q->param("BUKKEN_AREA_SECOND")) if $q->param("BUKKEN_AREA_SECOND");
                    my $BUKKEN_EKI_SECOND = $self->convert_charset(join(',', $q->param("BUKKEN_EKI_SECOND"))) if $q->param("BUKKEN_EKI_SECOND");
                
                    my $BUKKEN_YOSAN = $self->convert_charset($q->param("BUKKEN_YOSAN")) if $q->param("BUKKEN_YOSAN");
                    my $MENSEKI_MANSION = $self->convert_charset( $q->param("MENSEKI_MANSION")) if $q->param("MENSEKI_MANSION");
                    my $MENSEKI_TATEMONO = $self->convert_charset($q->param("MENSEKI_TATEMONO")) if $q->param("MENSEKI_TATEMONO");
                    my $MENSEKI_TOCHI = $self->convert_charset($q->param("MENSEKI_TOCHI")) if $q->param("MENSEKI_TOCHI");
                    my $MADORI = $self->convert_charset($q->param("MADORI")) if $q->param("MADORI");
                    my $MADORI_TYPE = $self->convert_charset($q->param("MADORI_TYPE")) if $q->param("MADORI_TYPE");
                    my $YOTEI = $self->convert_charset($q->param("YOTEI")) if $q->param("YOTEI");

                
                    my $NAME = $self->convert_charset($q->param("NAME")) if $q->param("NAME");
                    my $NAME_KANA = $self->convert_charset($q->param("NAME_KANA")) if $q->param("NAME_KANA");

                    #dont "my" here 
                    $email_address = $self->convert_charset($q->param("EMAIL")) if $q->param("EMAIL");
                    my $EMAIL = $self->convert_charset($q->param("EMAIL")) if $q->param("EMAIL");

                    my $FAX = $self->convert_charset($q->param("FAX")) if $q->param("FAX");
                    #my $FAX1 = $self->convert_charset($q->param("FAX1")) if $q->param("FAX1");
                    my $FAX2 = $self->convert_charset($q->param("FAX2")) if $q->param("FAX2");
                    my $FAX3 = $self->convert_charset($q->param("FAX3")) if $q->param("FAX3");

                    my $TEL = $self->convert_charset($q->param("TEL")) if $q->param("TEL");
                    #my $TEL1 = $self->convert_charset($q->param("TEL1")) if $q->param("TEL1");
                    my $TEL2 = $self->convert_charset($q->param("TEL2")) if $q->param("TEL2");
                    my $TEL3 = $self->convert_charset($q->param("TEL3")) if $q->param("TEL3");
                    my $YUBIN = $self->convert_charset($q->param("YUBIN")) if $q->param("YUBIN");
                    my $YUBIN2 = $self->convert_charset($q->param("YUBIN2")) if $q->param("YUBIN2");
                
                    my $ADDRESS_TODOUFUKEN = $self->convert_charset($q->param("ADDRESS_TODOUFUKEN")) if $q->param("ADDRESS_TODOUFUKEN");
                    my $ADDRESS_SIKUCYOUSON = $self->convert_charset($q->param("ADDRESS_SIKUCYOUSON")) if $q->param("ADDRESS_SIKUCYOUSON");
                    my $ADDRESS_CHYOUME = $self->convert_charset($q->param("ADDRESS_CHYOUME")) if $q->param("ADDRESS_CHYOUME");
                    my $ADDRESS_BANCHI = $self->convert_charset($q->param("ADDRESS_BANCHI")) if $q->param("ADDRESS_BANCHI");
                    my $ADDRESS_MANSYON = $self->convert_charset($q->param("ADDRESS_MANSYON")) if $q->param("ADDRESS_MANSYON");
                
                    my $BIRTHDAY_Y = $self->convert_charset($q->param("BIRTHDAY_Y")) if $q->param("BIRTHDAY_Y");
                    my $BIRTHDAY_M = $self->convert_charset($q->param("BIRTHDAY_M")) if $q->param("BIRTHDAY_M");
                    my $BIRTHDAY_D = $self->convert_charset($q->param("BIRTHDAY_D")) if $q->param("BIRTHDAY_D");
                
                    my $SHUDAN_EMAIL = $self->convert_charset($q->param("SHUDAN_EMAIL")) if $q->param("SHUDAN_EMAIL");
                    if ($SHUDAN_EMAIL == 1){$SHUDAN_EMAIL="OK";}else{$SHUDAN_EMAIL="";}
                    my $SHUDAN_FAX = $self->convert_charset($q->param("SHUDAN_FAX")) if $q->param("SHUDAN_FAX");
                    if ($SHUDAN_FAX == 1){$SHUDAN_FAX="OK";}else{$SHUDAN_FAX="";}

                    my $SHUDAN_TEL = $self->convert_charset($q->param("SHUDAN_TEL")) if $q->param("SHUDAN_TEL");
                    if ($SHUDAN_TEL == 1){$SHUDAN_TEL="OK";}else{$SHUDAN_TEL="";}
                    my $RENRAKU_TIME = $self->convert_charset($q->param("RENRAKU_TIME")) if $q->param("RENRAKU_TIME");
                
                    my $SHUDAN_FAX = $self->convert_charset($q->param("SHUDAN_FAX")) if $q->param("SHUDAN_FAX");
                    if ($SHUDAN_FAX == 1){$SHUDAN_FAX="OK";}else{$SHUDAN_FAX="";}
                    my $SHUDAN_YUBIN = $self->convert_charset($q->param("SHUDAN_YUBIN")) if $q->param("SHUDAN_YUBIN");
                    if ($SHUDAN_YUBIN == 1){$SHUDAN_YUBIN="OK";}else{$SHUDAN_YUBIN="";}
                
                    my $NINTI =$self->convert_charset( join(',', $q->param("NINTI"))) if $q->param("NINTI");
                    my $OPINION = $self->convert_charset($q->param("OPINION")) if $q->param("OPINION");
                
                    if ($BUKKEN_SYUBETSU eq ""){
                        $output .= ('ʪ����̤����򤵤�Ƥ��ޤ���<br />');
                    }
                    if ((!$BUKKEN_AREA) && (!$BUKKEN_EKI)){
                        $output .= ('ʪ�泌�ꥢ���ޤ��ϺǴ�ؤ����Ϥ���Ƥ��ޤ���<br />');
                    }
                    if ($BUKKEN_YOSAN eq ""){
                        $output .= ('����˾��ͽ�������Ϥ���Ƥ��ޤ���<br />');
                    }
                    #if ($MADORI eq ""){
                    #    $output .= ('����˾�δּ褬���Ϥ���Ƥ��ޤ���<br />');
                    #}
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
                        $output .= ('������ʻԶ�Į¼�ˤΤ����򤵤�Ƥ��ޤ���<br />');
                    }
                    if ($ADDRESS_CHYOUME eq ""){
                        $output .= ('����������ܡˤ����򤵤�Ƥ��ޤ���<br />');
                    }
                    if ($ADDRESS_BANCHI eq ""){
                        $output .= ('����������ϡˤ����򤵤�Ƥ��ޤ���<br />');
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

                    if ($SHUDAN_FAX){
                        if (($FAX eq "")||($FAX2 eq "")||($FAX3 eq "")){
                            $output .= (' FAX�Ǥθ�Ϣ������򤵤�ޤ�������FAX�ֹ椬���Ϥ���Ƥ��ޤ���<br />');
                        }
                    }

                    if ($EMAIL ne ''){
                        if ($EMAIL =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/) {
                        }else{
                            $output .= '�᡼�륢�ɥ쥹�η����������Ǥ���'."<br />";
                        }
                    }

                
                    if ($q->param("buy_ID") && $q->param("buy_address")){
                
                        $texts .= "�������ʪ��˴ؤ����䤤��碌�� "."\n";
                        $texts .= "ʪ�ｻ��: " . $q->param("buy_address")."\n";
                        $texts .= "���۳�ǧ�ֹ�: " . $q->param("buy_ID")."\n\n------------------------------------------\n\n";
                
                    }
                
                    $texts .= "ʪ�����: " . $BUKKEN_SYUBETSU."\n";
                    $texts .= "ʪ�泌�ꥢ: " . $BUKKEN_AREA."\n";
                    $texts .= "ʪ���: " . $BUKKEN_EKI."\n";
                    $texts .= "ʪ�泌�ꥢ��: " . $BUKKEN_AREA_SECOND."\n";
                    $texts .= "ʪ��أ�: " . $BUKKEN_EKI_SECOND."\n";

                
                    $texts .= "ͽ��: " . $BUKKEN_YOSAN ."����\n";
                    $texts .= "�ޥ󥷥��ξ�������: " . $MENSEKI_MANSION ."\n";
                    $texts .= "���ϡ��ͷ��ξ��η�ʪ����: " . $MENSEKI_TATEMONO ."\n";
                    $texts .= "���ϡ��ͷ��ξ�����������: " . $MENSEKI_TOCHI ."\n";
                    $texts .= "�ּ�: " . $MADORI . $MADORI_TYPE ."\n";
                    $texts .= "ͽ��: " . $YOTEI ."\n";
                    $texts .= "Ϣ���衧\n";
                    $texts .= "̾��: " . $NAME ."\n";
                    $texts .= "̾���ʥ��ʡ�: " . $NAME_KANA ."\n";
                    $texts .= "�᡼�륢�ɥ쥹: " . $EMAIL ."\n";
                    $texts .= "�����ֹ�: " . $TEL ."-".$TEL2."-".$TEL3."\n";
                    $texts .= "FAX�ֹ�: " . $FAX ."-".$FAX2."-".$FAX3."\n";
                    $texts .= "͹���ֹ�: " . $YUBIN ."-". $YUBIN2."\n";
                    $texts .= "����: " . $ADDRESS_TODOUFUKEN ." ". $ADDRESS_SIKUCYOUSON . " " .$ADDRESS_CHYOUME." ".$ADDRESS_BANCHI. " " . $ADDRESS_MANSYON ."\n";
                    $texts .= "������: " . $BIRTHDAY_Y ."ǯ". $BIRTHDAY_M . "��" . $BIRTHDAY_D . "��". "\n";
                    $texts .= "Ϣ�����-\n";
                    $texts .= "   �᡼��: " . $SHUDAN_EMAIL ."\n";
                    $texts .= "   ����: " . $SHUDAN_TEL;
                    $texts .= " - ������: " . $RENRAKU_TIME ."\n";
                    $texts .= "   FAX: " . $SHUDAN_FAX ."\n";
                    $texts .= "   ͹��: " . $SHUDAN_YUBIN ."\n";
                    $texts .= "\n";
                    $texts .= "�ɤΤ褦�ˤ����Τ�ޤ�����: " . $NINTI ."\n";
                    $texts .= "���ո�: " . $OPINION ."\n";

                }
    
                if ($output){
                        if ($self->param('mobile')){
                            $output = "<div class=\"warning\">$output</div>";
                        }else{
                            $output = "<div class=\"warning\">$output<a href=\"javascript:history.back()\">���</a></div>";
                        }
                }else{
                    #$send
##
                    $ref_loop = $Realestate->get_Simple_List($q->param("_object_id"));

                    require REPS::Search::Inquiry;
                    my $mail = REPS::Search::Inquiry->new($self);
                    my $usr = REPS::User->new($self);
                    my $Settings = REPS::Settings->new($self);

                    my $tmp_company_info;
                    my $usr_company_info;
                    #my $tmp_company_mail = $Settings->get_settings_mail_address();
                    #my $tmp_company_info = $Settings->get_settings_contact_info();

                    if (uc($self->cfg('independent_users')) eq 'ON') {

                        my @usr_ids;
                        foreach (@$ref_loop){
                            push (@usr_ids, $$_{'USER_ID'});
                        }
                        $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
                        $tmp_company_info = $Settings->get_settings_contact_info();

                        my $admin_mailaddress = $usr->get_admin_mailaddress;
        
                        $mail->{'MAIL_TO'} = $$tmp_company_info{'COMPANY_EMAIL'};
        
                        foreach (@$ref_loop){
                            my $tmp = $_;
        
                            #$usr->get_User_info_to_be_displayed($$tmp{'APART_USER_ID'});
                            #my $tmp_usr = $usr->get_usr_to_be_displayed($$tmp{'USER_ID'});
        
                            $mail->{'MAIL_TO'} = '';
                            $mail->{'MAIL_BCC'} = '';
                            $mail->{'MAIL_TEXT'} = '';
        

                            #$mail->{'MAIL_TO'} = $$usr_company_info{'COMPANY_EMAIL'};
                            $mail->{'MAIL_TO'} = $$usr_company_info{$$tmp{'USER_ID'}}{'USER_EMAIL'};
    
                            if ($$tmp_company_info{'COMPANY_SEND_BBC_ADMIN_EMAIL'}){
                                if ($$tmp_company_info{'COMPANY_EMAIL'} ne $mail->{'MAIL_TO'}){
                                    $mail->{'MAIL_BCC'} = $$tmp_company_info{'COMPANY_EMAIL'};#$admin_mailaddress;
                                }
                            }

        
        
                            $mail->{'MAIL_SUBJECT'} = '[REPS][����]ʪ��˴ؤ��뤪�䤤��碌�Ǥ��� ';
                    
                            if (!$mail->{'MAIL_TO'}){die "no email adress is provided.";}
                        
                            $mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
        
        
        
                            $mail->{'MAIL_TEXT'} .= "���Υ᡼��ϡ��ۡ���ڡ���������ʪ���䤤��碌�ե������������Ƥ��ޤ���\n������ʪ��ˤĤ��ơ����䤤��碌�Ǥ���\n";
        
                            $mail->{'MAIL_TEXT'} .= '�䤤��碌ʪ��ڡ���URL(������󥯤򥯥�å����뤫�����ԡ����ƥ֥饦�����ǳ����Ƥ�������)��'."\n";
        
                            if ($self->param('mobile')){
                                #mode
                                $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            }else{
                                #_mode
                                $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            }
        
                            $mail->{'MAIL_TEXT'} .= "$texts\n";
                        
                            $mail->{'MAIL_TEXT'} .= "\n\n";
                            my $tmp_site_url = $self->cfg('site_url');
                            if ((chop $tmp_site_url) ne '/'){
                                $tmp_site_url = $self->cfg('site_url')
                            }

                            #send
                            if (!$mail->{'MAIL_TO'}){die "No E-mail adress is provided.";}
                            
                            my $result = $mail->send;
                            if ($result != 1){
                                $output .= $result;
                            }
        
                        }
                        $Realestate->log_Inquiry($q->param("_object_id"));



                    }else{


                        $tmp_company_info = $Settings->get_settings_contact_info();

        
        
                        my $admin_mailaddress = $usr->get_admin_mailaddress;
        
                        $mail->{'MAIL_TO'} = $$tmp_company_info{'COMPANY_EMAIL'};
        
                        foreach (@$ref_loop){
                            my $tmp = $_;
        
                            #$usr->get_User_info_to_be_displayed($$tmp{'APART_USER_ID'});
                            #my $tmp_usr = $usr->get_usr_to_be_displayed($$tmp{'USER_ID'});
        
                            $mail->{'MAIL_TO'} = '';
                            $mail->{'MAIL_BCC'} = '';
        
        

                            if ($$tmp_company_info{'COMPANY_SALE_EMAIL'}){
    
                                $mail->{'MAIL_TO'} = $$tmp_company_info{'COMPANY_SALE_EMAIL'};
                            }else{
    
                                $mail->{'MAIL_TO'} = $$tmp_company_info{'COMPANY_EMAIL'};
                            }
    
                            if ($$tmp_company_info{'COMPANY_SEND_BBC_ADMIN_EMAIL'}){
                                if ($admin_mailaddress ne $mail->{'MAIL_TO'}){
                                    $mail->{'MAIL_BCC'} = $admin_mailaddress;
                                }
                            }

        
        
                            $mail->{'MAIL_SUBJECT'} = '[REPS][����]ʪ��˴ؤ��뤪�䤤��碌�Ǥ��� ';
                    
                            if (!$mail->{'MAIL_TO'}){die "no email adress is provided.";}
                        
                            $mail->{'MAIL_FROM'} = $mail->{'MAIL_TO'};
        
        
        
                            $mail->{'MAIL_TEXT'} .= "���Υ᡼��ϡ��ۡ���ڡ���������ʪ���䤤��碌�ե������������Ƥ��ޤ���\n������ʪ��ˤĤ��ơ����䤤��碌�Ǥ���\n";
        
                            $mail->{'MAIL_TEXT'} .= '�䤤��碌ʪ��ڡ���URL(������󥯤򥯥�å����뤫�����ԡ����ƥ֥饦�����ǳ����Ƥ�������)��'."\n";
        
                            if ($self->param('mobile')){
                                #mode
                                $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            }else{
                                #_mode
                                $mail->{'MAIL_TEXT'} .= $self->cfg('cgi_url').'reps.cgi'.'?_mode=mode_edit&_type='.$q->param("_type").'&_object_id='.$$tmp{'ID'}."\n\n";
                            }
        
                            $mail->{'MAIL_TEXT'} .= "$texts\n";
                        
                            $mail->{'MAIL_TEXT'} .= "\n\n";
                            my $tmp_site_url = $self->cfg('site_url');
                            if ((chop $tmp_site_url) ne '/'){
                                $tmp_site_url = $self->cfg('site_url')
                            }
        
        
                        }
        
                        if (!$mail->{'MAIL_TO'}){die "No E-mail adress is provided.";}
                        
                        my $result = $mail->send;
                        if ($result != 1){
                            $output .= $result;
                        }

                        $Realestate->log_Inquiry($q->param("_object_id"));
                    }
##

                    #��ǧ�᡼����䤤��碌��������
                    if (uc($self->cfg('send_confirmation')) eq 'ON') {
                        if ($email_address){
                            if ($email_address =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                                my $mail_comfirm = REPS::Search::Inquiry->new($self);
                                $mail_comfirm->{'MAIL_FROM'} = $$tmp_company_info{'COMPANY_EMAIL'};
                                $mail_comfirm->{'MAIL_TO'} = $email_address;
                                $mail_comfirm->{'MAIL_SUBJECT'} = '[���䤤��碌�γ�ǧ] ʪ��˴ؤ��뤪�䤤��碌������դ��ޤ�����';

                                $mail_comfirm->{'MAIL_TEXT'} = '���䤤��碌ĺ���ޤ��Ƥ��꤬�Ȥ��������ޤ����ܥ᡼��ϡ�'."\n";
                                $mail_comfirm->{'MAIL_TEXT'} .= $self->cfg('site_url')."\n";
                                $mail_comfirm->{'MAIL_TEXT'} .= '���䤤��碌�ե������ꡢ��ư�������Ƥ��ޤ���'."\n";
                                $mail_comfirm->{'MAIL_TEXT'} .= 'ô���Ԥ����ֿ�������ޤǺ����Ф餯���Ԥ�����������'."\n\n";
                                #$mail_comfirm->{'MAIL_TEXT'} .= $texts;

                                my $result_comfirm = $mail_comfirm->send;
                                if ($result_comfirm != 1){
                                    $output .= $result_comfirm;
                                }
                            }
                        }
                    }

                    if ($output){
                        if ($self->param('mobile')){
                            $output = "<div class=\"warning\">$output</div>";
                        }else{
                            $output = "<div class=\"warning\">$output<a href=\"javascript:history.back()\">���</a></div>";
                        }
                    }else{
                        $output = "<div class=\"information\">������λ���ޤ��������꤬�Ȥ��������ޤ���";
                            if (uc($self->cfg('send_confirmation')) eq 'ON') {
                                if ($email_address){
                                    if ($email_address =~ /^[-\w.]+@[-\w.]+\.[-\w]+$/){
                                        $output .= '<br /><br />�ʤ�����ǧ�Υ᡼����������ޤ����Τǡ�Ⱦ�����ٷФäƤ��ǧ�᡼�뤬�Ϥ��ʤ��ä����ϡ��᡼�륢�ɥ쥹�γ�ǧ�򤷤���ǡ������٤��䤤��碌ĺ�������פ��ޤ���';
                                    }
                                }
                            }
                        $output .= "</div>";
                    }
                    $output .= '<br /><br />';
    
                }
    

################################
            }

            $template = $self->load_tmpl(
                    $tmpl_inquiry,die_on_bad_params => 0
                );
            $template->param(
                script_name  => $script_name,
                page_charset => $charset,
                #main_loop => $ref_loop,
                page_data    => $output,
                site_url => $self->cfg('site_url'),
                cgi_url => $self->cfg('cgi_url'),
                );

        }else{
            die "No id specified.";
        }
    }else{
        if ($q->param("_object_id")) {
            $ref_loop = $Realestate->get_Simple_List($q->param("_object_id"));
            foreach (@$ref_loop){
                delete $$_{'USER_ID'};
            }
        }else{
            $output .= '<div class="warning">ʪ�郎���򤵤�Ƥ��ޤ���</div>';
        }
        $template = $self->load_tmpl(
                $tmpl_inquiry,die_on_bad_params => 0
            );
        if ($ref_loop) {
            $result_count = scalar @$ref_loop;
        }else{
            $result_count = 0;
        }
        if ($result_count <= 0){
            $self->header_props(
                -status=>'404 Not Found'
            );
        }

        if ($ref_loop){
            $template->param(
                script_name  => $script_name,
                page_charset => $charset,
                main_loop => $ref_loop,
                page_data    => $output,
                result_count => $result_count,
                site_url => $self->cfg('site_url'),
                cgi_url => $self->cfg('cgi_url'),
                aid=> ''
                );
        }else{
            $template->param(
                script_name  => $script_name,
                page_charset => $charset,
                #main_loop => $ref_loop,
                page_data    => $output,
                result_count => $result_count,
                site_url => $self->cfg('site_url'),
                cgi_url => $self->cfg('cgi_url'),
                );
        }

    }

    return $template->output;
}


sub convert_charset {
    my $self = shift;
    local($_) = shift;
    my $charset;
    if ($self->param('mobile')){
        $charset = uc($self->cfg('charset_mobile'));
    }else{
        $charset = uc($self->cfg('charset'));
    }
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

sub convert_hash_charset {
    my $self = shift;
    local($_) = shift;
    my $charset;
    if ($self->param('mobile')){
        $charset = uc($self->cfg('charset_mobile'));
    }else{
        $charset = uc($self->cfg('charset'));
    }

    my $charmap = { 'ISO-2022-JP' => 'jis', 'SHIFT_JIS' => 'sjis', 'EUC-JP' => 'euc', 'UTF-8' => 'utf8' };
    if (defined($charset) and defined($charmap->{$charset})) {

        my $UJ = Unicode::Japanese->new();
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
    #    return 1;
    }else{
        die "I don\'t understand your encoding ";
    }
}



1
