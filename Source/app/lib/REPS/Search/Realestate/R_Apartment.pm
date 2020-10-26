package REPS::Search::Realestate::R_Apartment;

use base qw(REPS::Search::Realestate);
use strict;
#use Fcntl;
use DB_File::Lock;
use File::Path;

sub new{
    my ($class,$app) = @_;
    my $self = {
        _app => $app,
        _ref_hash => {
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
            'APART_ROOM_NUMBER' => '',
            'APART_YOUR_ID' => '',
            'APART_OPTIONS_IKKAI' => '',
            'APART_OPTIONS_NIKAIIJYOU' => '',
            'APART_OPTIONS_SAIJYOUKAI' => '',
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
            'APART_OPTIONS_BICYCLE' => '',
            'APART_OPTIONS_INTERNET' => '',
            'APART_SHOUGAKKOUKU' => '',
            'APART_CYUUGAKKOUKU' => '',
            'APART_DAIGAKU_LIST' => '',
            'APART_TORIHIKITAIYOU' => '',
            #'APART_HTML_TEXT' => '',
            'APART_ADS_TEXT' => '',
            'APART_BIKOU' => '',
            'APART_NYUUKYOJIKI' =>'',
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
            'APART_USER_ID' => '',
            'APART_CREATED' => '',
            'APART_LAST_UPDATED' => ''
            }
        };
    
    return bless $self,$class;
}

sub get_Search_Result {
    my $self = shift;
    my $Search = $_[0];

    my $sort_by = $Search->{'sort_by'};
    my $off_set = $Search->{'off_set'};
    my $items_per_page = $Search->{'items_per_page'};

    my $q = $self->{_app}->query();
    my %sort_hash = ();
    my %tmp;
    my $key;
    my $value;
    my @loop_data;
    my $c=0;

    my $match = 0;

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    if(-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;

        while ( ($key, $value) = each(%apart) ) {
            if ((exists $apart{$key}) && (defined $apart{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'APART_USER_ID'}){
                    #match?
                    $match = 0;
                        if ($tmp{'APART_PUBLISHED'}){
                            $match = 1;
                        }else{
                            next;
                        }

                    my $test = 0;
                    if ($q->param("apart_kind")){
                        my @apart_kind;
                        foreach ($q->param("apart_kind")){
                            push (@apart_kind,split(',',$_));
                        }
                        foreach (@apart_kind){
                            if ($tmp{'APART_KIND'} == $_){
                                $test = 1;
                            }
                        }
                        next unless ($test);
                    }


#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("apart_price_l")){
    $q->param("apart_price_1"=>$q->param("apart_price_l"));
}

                    if ($q->param("apart_price_1") || $q->param("apart_price_2")){

                        my $tmp_price = $tmp{'APART_PRICE'};
                        if ($q->param("include_k_k")){
                        
                            if ($tmp{'APART_PRICE_KANRIHI'}){
                                $tmp_price = $tmp_price+$tmp{'APART_PRICE_KANRIHI'};
                            }
                        }
                        if ($q->param("apart_price_1") && $q->param("apart_price_2")){
    
                            if (($tmp_price >= ($q->param("apart_price_1") * 10000)) && ($tmp_price <= ($q->param("apart_price_2") * 10000))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("apart_price_2") == 0){
                            if ($tmp_price >= ($q->param("apart_price_1") * 10000)){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("apart_price_1") == 0){
    
                            if ($tmp_price <= ($q->param("apart_price_2") * 10000)){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }
#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("apart_price_l")){
    $q->delete('apart_price_l');
}


                    if ($q->param("apart_no_reikin")){
                        if ($tmp{'APART_PRICE_REIKIN'} > 0){
                            next;
                        }
                    }
                    if ($q->param("apart_no_sikikin")){
                        if ($tmp{'APART_PRICE_SIKIKIN'} > 0){
                            next;
                        }
                    }

                    if ($q->param("apart_square_1") || $q->param("apart_square_2")){
                        if (($q->param("apart_square_1") && $q->param("apart_square_2"))){
                            if (($tmp{'APART_SQUARE'} >= ($q->param("apart_square_1"))) && ($tmp{'APART_SQUARE'} <= ($q->param("apart_square_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("apart_square_2")){
                            if ($tmp{'APART_SQUARE'} <= ($q->param("apart_square_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("apart_square_1")){
                            if ($tmp{'APART_SQUARE'} >= ($q->param("apart_square_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }

    
                    $test = 0;
                    if ($q->param("apart_madori")){
                        my @apart_madori;
                        foreach ($q->param("apart_madori")){
                            push (@apart_madori,split(',',$_));
                        }
                        foreach (@apart_madori){
                            if ($tmp{'APART_MADORI'} eq $_){
                                $test = 1;
                                last;
                            }
                        }
                        next unless ($test);
                    }

                    if ($q->param("apart_age")){
                        if ((exists $tmp{'APART_AGE'})&&(defined $tmp{'APART_AGE'})){
                            if ($tmp{'APART_AGE'} ne ''){
                                if (REPS::Util->get_date_delta($tmp{'APART_AGE'}.'/01') <= ($q->param("apart_age")*365)){
                                    $match = 1;
                                }else{next;}
                            }else{next;}
                        }else{
                            next;
                        }
                    }

                    $test = 0;
                    if ($q->param("apart_walk_minutes")){
                        if ( $tmp{'APART_WALK_MINUTES_1'} ){
                            if ($tmp{'APART_WALK_MINUTES_1'} <= $q->param("apart_walk_minutes")){
                                $test = 1;
                            }
                        }
                        if ( $tmp{'APART_WALK_MINUTES_2'} ){
                            if ($tmp{'APART_WALK_MINUTES_2'} <= $q->param("apart_walk_minutes")){
                                $test = 1;
                            }
                        }

                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("apart_has_")){
                        foreach ($q->param("apart_has_")){
                            if ($_ == 1){
                                if ($tmp{'APART_PICS_MADORIZU'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 2){
                                if ($tmp{'APART_PICS_OUTSIDE'} || $tmp{'APART_PICS_INSIDE'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 3){
                                if ($tmp{'APART_MOVIE_FILE_URL'}){$test=1;}else{$test=0;last;}
                            }
                        }
                        next unless ($test);
                    }

                    if ($q->param('apart_options_ikkai')){
                        if ($tmp{'APART_FLOOR'} != 1){next;}
                    }
                    if ($q->param('apart_options_nikaiijyou')){
                        if ($tmp{'APART_FLOOR'}){
                            unless ($tmp{'APART_FLOOR'} >= 2){next;}
                        }else{
                            next;
                        }
                    }
                    if ($q->param('apart_options_saijyoukai')){
                        if ($tmp{'APART_STORY'} > 2){
                            if ($tmp{'APART_STORY'} && $tmp{'APART_FLOOR'}){
                                if ($tmp{'APART_STORY'} != $tmp{'APART_FLOOR'}){
                                    next;
                                }
                            }else{
                                next;
                            }
                        }else{next;}
                    }

                    if ($q->param('apart_options_kakubeya')){
                        if (!$tmp{'APART_OPTIONS_KAKUBEYA'}){next;}
                    }
                    if ($q->param('apart_options_minami')){
                        if (!$tmp{'APART_OPTIONS_MINAMI'}){next;}
                    }
                    if ($q->param('apart_options_autolock')){
                        if (!$tmp{'APART_OPTIONS_AUTOLOCK'}){next;}
                    }
                    if ($q->param('apart_options_elevator')){
                        if (!$tmp{'APART_OPTIONS_ELEVATOR'}){next;}
                    }
                    if ($q->param('apart_options_tvphone')){
                        if (!$tmp{'APART_OPTIONS_ELEVATOR'}){next;}
                    }
                    if ($q->param('apart_options_bathtoilet')){
                        if (!$tmp{'APART_OPTIONS_BATHTOILET'}){next;}
                    }
                    if ($q->param('apart_options_aircon')){
                        if (!$tmp{'APART_OPTIONS_AIRCON'}){next;}
                    }
                    if ($q->param('apart_options_oitaki')){
                        if (!$tmp{'APART_OPTIONS_OITAKI'}){next;}
                    }
                    if ($q->param('apart_options_gasconro')){
                        if (!$tmp{'APART_OPTIONS_GASCONRO'}){next;}
                    }
                    if ($q->param('apart_options_situnaisentakuki')){
                        if (!$tmp{'APART_OPTIONS_SITUNAISENTAKUKI'}){next;}
                    }
                    if ($q->param('apart_options_loft')){
                        if (!$tmp{'APART_OPTIONS_LOFT'}){next;}
                    }
                    if ($q->param('apart_options_flooring')){
                        if (!$tmp{'APART_OPTIONS_FLOORING'}){next;}
                    }
                    if ($q->param('apart_options_catv')){
                        if (!$tmp{'APART_OPTIONS_CATV'}){next;}
                    }
                    if ($q->param('apart_options_cs')){
                        if (!$tmp{'APART_OPTIONS_CS'}){next;}
                    }
                    if ($q->param('apart_options_bs')){
                        if (!$tmp{'APART_OPTIONS_BS'}){next;}
                    }
                    
                    if ($q->param('apart_options_parking')){
                        if (!$tmp{'APART_OPTIONS_PARKING'}){next;}
                    }
                    if ($q->param('apart_options_pet')){
                        if (!$tmp{'APART_OPTIONS_PET'}){next;}
                    }
                    if ($q->param('apart_options_hosyounin')){
                        if (!$tmp{'APART_OPTIONS_HOSYOUNIN'}){next;}
                    }
                    if ($q->param('apart_options_instrument')){
                        if (!$tmp{'APART_OPTIONS_INSTRUMENT'}){next;}
                    }
                    if ($q->param('apart_options_jimusyoka')){
                        if (!$tmp{'APART_OPTIONS_JIMUSYOKA'}){next;}
                    }
                    if ($q->param('apart_options_internet')){
                        if (!$tmp{'APART_OPTIONS_INTERNET'}){next;}
                    }
                    if ($q->param('apart_options_bicycle')){
                        if (!$tmp{'APART_OPTIONS_BICYCLE'}){next;}
                    }

                    $test = 0;
                    if ($q->param("apart_address")){
                        foreach ($q->param("apart_address")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'APART_LOCATION'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'APART_LOCATION'},$search_by_key)){
                            #    $test = 1;
                            #    $match = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("apart_station")){
                        foreach ($q->param("apart_station")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'APART_STATION_1'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }elsif(REPS::Util->str_match($tmp{'APART_STATION_2'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'APART_STATION_1'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}elsif(REPS::Util->str_match($tmp{'APART_STATION_2'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("apart_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("apart_school")));
                        if (REPS::Util->str_match($tmp{'APART_SHOUGAKKOUKU'},$search_by_key)){
                        #if ($tmp{'APART_SHOUGAKKOUKU'} =~ m/.*$search_by_key.*/i){
    
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'APART_CYUUGAKKOUKU'},$search_by_key)){
                        #if ($tmp{'APART_CYUUGAKKOUKU'} =~ m/.*$search_by_key.*/i){
                            $test = 1;
                        }
                        my $tstr = join (' ',$tmp{'APART_DAIGAKU_LIST'});
                        if (REPS::Util->str_match($tstr,$search_by_key)){
                        #if ($tmp{'APART_DAIGAKU_LIST'} =~ m/.*$search_by_key.*/ig){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }


                    #if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location') || ($sort_by eq 'station')){
                            if ($sort_by eq 'station'){
                                $sort_hash{$key} = $tmp{'APART_STATION_1'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'APART_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'APART_LAST_UPDATED'})&&( $tmp{'APART_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'APART_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'APART_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'APART_LOCATION'};
                            }else{
                                $sort_hash{$key} = $key;
                            }
                        }else{
                            $sort_hash{$key} = $key;
    
                        }
                    #}
                    
                }else{
                    #todo app user id not exists
                }
            }
        }
    
    
    
    #    if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date')|| ($sort_by eq 'location')){
            my @sort_keys;
            #sort
            if (($sort_by eq 'name') || ($sort_by eq 'location') || ($sort_by eq 'station')){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
            }elsif(($sort_by eq 'price')){
                @sort_keys = sort {$sort_hash{$a} <=> $sort_hash{$b} || length($a) <=> length($b) || $a cmp $b} keys %sort_hash;
            }elsif($sort_by eq 'date'){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
                @sort_keys = reverse @sort_keys;
            }else{
                @sort_keys = reverse sort keys %sort_hash;
                
            }

            $c = @sort_keys;

            if (!$off_set){$off_set=0;}
    
            @sort_keys = splice( @sort_keys , $off_set,$items_per_page);

            my $new_off_set = $off_set + $items_per_page;

            foreach (@sort_keys){
                my $ref_hash = $apart{$_};
                my %tmp = %$ref_hash;
    
    
#                if ($tmp{'APART_BUSWALK_MINUTES_1'}){
#                    $tmp{'APART_BUS_MINUTES_1'} = $tmp{'APART_BUS_MINUTES_1'}+$tmp{'APART_BUSWALK_MINUTES_1'};
#                }

#                if ($tmp{'APART_BUSWALK_MINUTES_2'}){
#                    $tmp{'APART_BUS_MINUTES_2'} = $tmp{'APART_BUS_MINUTES_2'}+$tmp{'APART_BUSWALK_MINUTES_2'};
#                }

                if ($tmp{'APART_KIND'}==1){
                    $tmp{'APART_KIND'}='アパート';
                }elsif($tmp{'APART_KIND'}==2){
                    $tmp{'APART_KIND'}='マンション';
                }elsif($tmp{'APART_KIND'}==3){
                    $tmp{'APART_KIND'}='一戸建て';
                }elsif($tmp{'APART_KIND'}==4){
                    $tmp{'APART_KIND'}='テラスハウス';
                }
    
                if ($tmp{'APART_PRICE_SIKIKIN_UNIT'}){
                    if ($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 1){
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }elsif($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 2){
                        $tmp{'APART_PRICE_SIKIKIN'} = REPS::Util->insert_comma($tmp{'APART_PRICE_SIKIKIN'});
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = '円';
                    }elsif($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 3){
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = '万円';
                    }else{
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }
                }else{
                    $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                }

                if ($tmp{'APART_PRICE_REIKIN_UNIT'}){
                    if ($tmp{'APART_PRICE_REIKIN_UNIT'} == 1){
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }elsif($tmp{'APART_PRICE_REIKIN_UNIT'} == 2){
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = '円';
                        $tmp{'APART_PRICE_REIKIN'} = REPS::Util->insert_comma($tmp{'APART_PRICE_REIKIN'});
                    }elsif($tmp{'APART_PRICE_REIKIN_UNIT'} == 3){
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = '万円';
                    }else{
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }
                }else{
                    $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                }

                my $new = '';
                my $updated = '';
                if ($tmp{'APART_CREATED'}){
                    my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'APART_CREATED'});
                    if ($dd <= 30) {
                        $new = 'ON';
                    }
                    if ((!$new) && ($tmp{'APART_LAST_UPDATED'})){
                        $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'APART_LAST_UPDATED'});
                        if ($dd <= 10) {
                            $updated = 'ON';
                        }
                    }
                }

                if ($tmp{'APART_PICS_OUTSIDE'}){
                    $tmp{'APART_PICS_OUTSIDE'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_OUTSIDE'};
                }
                if ($tmp{'APART_PICS_OUTSIDE_THUMB'}){
                    $tmp{'APART_PICS_OUTSIDE_THUMB'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_OUTSIDE_THUMB'};
                }
                if ($tmp{'APART_PICS_INSIDE'}){
                    $tmp{'APART_PICS_INSIDE'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_INSIDE'};
                }
                if ($tmp{'APART_PICS_INSIDE_THUMB'}){
                    $tmp{'APART_PICS_INSIDE_THUMB'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_INSIDE_THUMB'};
                }
                if ($tmp{'APART_PICS_MADORIZU'}){
                    $tmp{'APART_PICS_MADORIZU'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_MADORIZU'};
                }
                if ($tmp{'APART_PICS_MADORIZU_THUMB'}){
                    $tmp{'APART_PICS_MADORIZU_THUMB'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_MADORIZU_THUMB'};
                }
                if ($tmp{'APART_PICS_TIZU'}){
                    $tmp{'APART_PICS_TIZU'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_TIZU'};
                }
                if ($tmp{'APART_PICS_TIZU_THUMB'}){
                    $tmp{'APART_PICS_TIZU_THUMB'} =  $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_TIZU_THUMB'};
                }

                my %hash = (
                    'APART_ID' => "$_",
                    'APART_IS_SPECIAL' => $tmp{'APART_IS_SPECIAL'},
                    'APART_STATION_1' => $tmp{'APART_STATION_1'},
                    'APART_STATION_2' => $tmp{'APART_STATION_2'},
                    'APART_LOCATION' => $tmp{'APART_LOCATION'},
                    'APART_PRICE' => REPS::Util->insert_comma($tmp{'APART_PRICE'}),
                    'APART_BUS_MINUTES_1' => $tmp{'APART_BUS_MINUTES_1'},
                    'APART_WALK_MINUTES_1' => $tmp{'APART_WALK_MINUTES_1'},

                    'APART_BUS_MINUTES_2' => $tmp{'APART_BUS_MINUTES_2'},
                    'APART_WALK_MINUTES_2' => $tmp{'APART_WALK_MINUTES_2'},
    
                    'APART_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'APART_PRICE_KANRIHI'}),
                    'APART_PRICE_SIKIKIN' => $tmp{'APART_PRICE_SIKIKIN'},
                    'APART_PRICE_REIKIN' => $tmp{'APART_PRICE_REIKIN'},
                    'APART_PRICE_SIKIKIN_UNIT' => $tmp{'APART_PRICE_SIKIKIN_UNIT'},
                    'APART_PRICE_REIKIN_UNIT' => $tmp{'APART_PRICE_REIKIN_UNIT'},    

                        'APART_PICS_OUTSIDE' => $tmp{'APART_PICS_OUTSIDE'},
                        'APART_PICS_INSIDE' => $tmp{'APART_PICS_INSIDE'},
                        'APART_PICS_MADORIZU' => $tmp{'APART_PICS_MADORIZU'},
                        'APART_PICS_TIZU' => $tmp{'APART_PICS_TIZU'},
                        'APART_PICS_OUTSIDE_THUMB' => $tmp{'APART_PICS_OUTSIDE_THUMB'},
                        'APART_PICS_INSIDE_THUMB' => $tmp{'APART_PICS_INSIDE_THUMB'},
                        'APART_PICS_MADORIZU_THUMB' => $tmp{'APART_PICS_MADORIZU_THUMB'},
                        'APART_PICS_TIZU_THUMB' => $tmp{'APART_PICS_TIZU_THUMB'},

                        'APART_BUILDING_STRUCTURE' => $tmp{'APART_BUILDING_STRUCTURE'},
                        'APART_YOUR_ID' => $tmp{'APART_YOUR_ID'},
                        'APART_BUS_1' => $tmp{'APART_BUS_1'},
                        'APART_BUS_2' => $tmp{'APART_BUS_2'},
                        'APART_AGE' => $tmp{'APART_AGE'},
                        'APART_BUSWALK_MINUTES_1' => $tmp{'APART_BUSWALK_MINUTES_1'},
                        'APART_BUSWALK_MINUTES_2' => $tmp{'APART_BUSWALK_MINUTES_2'},
                        'APART_STORY' => $tmp{'APART_STORY'},
                        'APART_ADS_TEXT' => $tmp{'APART_ADS_TEXT'},

                    'APART_SQUARE' => $tmp{'APART_SQUARE'},
                    'APART_SQUARE_TUBO' => $tmp{'APART_SQUARE_TUBO'},

                    'APART_MADORI' => $tmp{'APART_MADORI'},
                    'APART_KIND' => $tmp{'APART_KIND'},
                    'APART_NEW' => $new,
                    'APART_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    'APART_CREATED' => REPS::Util->get_date_as_string($tmp{'APART_CREATED'}),
                    'APART_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'APART_LAST_UPDATED'})
                );
        
                push(@loop_data, \%hash);
            }
    #    }
    
        untie %apart;
    }



    #my $search = REPS::Search::Search->new;
    $Search->{'ref_result_loop'} = \@loop_data;
    #$Search->{'off_set'} = $new_off_set;
    $Search->{'count_result'} = $c;
    #$search->{'items_per_page'} = $items_per_page;

    return 1;
    #return \@loop_data;


}

sub get_Simple_List{
    my $self = shift;
    my @ids = @_;
    my @loop_data =();
    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;

        foreach (@ids){
            if ((defined $apart{$_}) && ($apart{$_})){
                my $ref_hash = $apart{$_};
                my %tmp = %$ref_hash;


#                if ($tmp{'APART_BUSWALK_MINUTES_1'}){
#                    $tmp{'APART_BUS_MINUTES_1'} = $tmp{'APART_BUS_MINUTES_1'}+$tmp{'APART_BUSWALK_MINUTES_1'};
#                }
#                if ($tmp{'APART_BUSWALK_MINUTES_2'}){
#                    $tmp{'APART_BUS_MINUTES_2'} = $tmp{'APART_BUS_MINUTES_2'}+$tmp{'APART_BUSWALK_MINUTES_2'};
#                }

                if ($tmp{'APART_PRICE_SIKIKIN_UNIT'}){
                    if ($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 1){
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }elsif($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 2){
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = '円';
                        $tmp{'APART_PRICE_SIKIKIN'} = REPS::Util->insert_comma($tmp{'APART_PRICE_SIKIKIN'});
                    }elsif($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 3){
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = '万円';
                    }else{
                        $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }
                }else{
                    $tmp{'APART_PRICE_SIKIKIN_UNIT'} =  'ヶ月';
                }

                if ($tmp{'APART_PRICE_REIKIN_UNIT'}){
                    if ($tmp{'APART_PRICE_REIKIN_UNIT'} == 1){
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }elsif($tmp{'APART_PRICE_REIKIN_UNIT'} == 2){
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = '円';
                        $tmp{'APART_PRICE_REIKIN'} = REPS::Util->insert_comma($tmp{'APART_PRICE_REIKIN'});
                    }elsif($tmp{'APART_PRICE_REIKIN_UNIT'} == 3){
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = '万円';
                    }else{
                        $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }
                }else{
                    $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                }



                my %hash = (
                    'ID' => "$_",
                    #'APART_PUBLISHED' => $tmp{'APART_PUBLISHED'},
                    'APART_STATION_1' => $tmp{'APART_STATION_1'},
                    'APART_STATION_2' => $tmp{'APART_STATION_2'},
                    'APART_LOCATION' => $tmp{'APART_LOCATION'},
                    'APART_PRICE' => REPS::Util->insert_comma($tmp{'APART_PRICE'}),
                    'APART_BUS_MINUTES_1' => $tmp{'APART_BUS_MINUTES_1'},
                    'APART_WALK_MINUTES_1' => $tmp{'APART_WALK_MINUTES_1'},
                    'APART_BUSWALK_MINUTES_1' => $tmp{'APART_BUSWALK_MINUTES_1'},

                    'APART_BUS_MINUTES_2' => $tmp{'APART_BUS_MINUTES_2'},
                    'APART_WALK_MINUTES_2' => $tmp{'APART_WALK_MINUTES_2'},
                    'APART_BUSWALK_MINUTES_2' => $tmp{'APART_BUSWALK_MINUTES_2'},

                    'APART_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'APART_PRICE_KANRIHI'}),
                    'APART_PRICE_SIKIKIN' => $tmp{'APART_PRICE_SIKIKIN'},
                    'APART_PRICE_REIKIN' => $tmp{'APART_PRICE_REIKIN'},
                    'APART_PRICE_SIKIKIN_UNIT' => $tmp{'APART_PRICE_SIKIKIN_UNIT'},
                    'APART_PRICE_REIKIN_UNIT' => $tmp{'APART_PRICE_REIKIN_UNIT'},

                    'APART_SQUARE' => $tmp{'APART_SQUARE'},
                    'APART_MADORI' => $tmp{'APART_MADORI'},

                    'USER_ID' => $tmp{'APART_USER_ID'},

                    'APART_CREATED' => REPS::Util->get_date_as_string($tmp{'APART_CREATED'}),
                    'APART_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'APART_LAST_UPDATED'})
                );

                push(@loop_data, \%hash);
            }
        }
    untie %apart;

    return \@loop_data;

}

sub get_Detail_List{
    my $self = shift;
    my @ids = @_;
    #my $sort_by = $_[0];

    my %sort_hash = ();
    my %tmp;
    my $key;
    my $value;
    my @loop_data;

    my @id_to_be_logged;

    my $usr = REPS::User->new($self->{_app},'','');
    my $Settings = REPS::Settings->new($self->{_app});

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    if(-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        #
        my $tmp_company_info;
        my $usr_company_info;
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            #get users company info
            my @usr_ids;
            foreach (@ids){
                if ($apart{$_}){
                    push (@usr_ids, $apart{$_}{'APART_USER_ID'});
                }
            }
            $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
        }else{
            $tmp_company_info = $Settings->get_settings_to_be_displayed();
        }

    
        foreach (@ids){
            if ((exists $apart{$_}) && (defined $apart{$_}) && ($apart{$_})){
                $value = $apart{$_};
                my %tmp = %$value;
                if (exists $tmp{'APART_ID'}){
                    if (($_ eq $tmp{'APART_ID'} ) && ($tmp{'APART_PUBLISHED'})){
                        push (@id_to_be_logged,$_);
                        if ($tmp{'APART_KIND'}==1){
                            $tmp{'APART_KIND'}='アパート';
                        }elsif($tmp{'APART_KIND'}==2){
                            $tmp{'APART_KIND'}='マンション';
                        }elsif($tmp{'APART_KIND'}==3){
                            $tmp{'APART_KIND'}='一戸建て';
                        }elsif($tmp{'APART_KIND'}==4){
                            $tmp{'APART_KIND'}='テラスハウス';
                        }

                        $tmp{'APART_DAIGAKU_LIST'} =~s/[\n]/、/g;

#                        if ($tmp{'APART_BUSWALK_MINUTES_1'}){
#                            $tmp{'APART_BUS_MINUTES_1'} = $tmp{'APART_BUS_MINUTES_1'}+$tmp{'APART_BUSWALK_MINUTES_1'};
#                        }
#                        if ($tmp{'APART_BUSWALK_MINUTES_2'}){
#                            $tmp{'APART_BUS_MINUTES_2'} = $tmp{'APART_BUS_MINUTES_2'}+$tmp{'APART_BUSWALK_MINUTES_2'};
#                        }
                        
                        if ($tmp{'APART_PICS_OUTSIDE'}){
                            $tmp{'APART_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_OUTSIDE'};
                        }
                        if ($tmp{'APART_PICS_INSIDE'}){
                            $tmp{'APART_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_INSIDE'};
                        }
                        if ($tmp{'APART_PICS_MADORIZU'}){
                            $tmp{'APART_PICS_MADORIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_MADORIZU'};
                        }
                        if ($tmp{'APART_PICS_TIZU'}){
                            $tmp{'APART_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_TIZU'};
                        }

                        if ($tmp{'APART_PICS_OUTSIDE_THUMB'}){
                            $tmp{'APART_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_OUTSIDE_THUMB'};
                        }
                        if ($tmp{'APART_PICS_INSIDE_THUMB'}){
                            $tmp{'APART_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_INSIDE_THUMB'};
                        }
                        if ($tmp{'APART_PICS_MADORIZU_THUMB'}) {
                            $tmp{'APART_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_MADORIZU_THUMB'};
                        }
                        if ($tmp{'APART_PICS_TIZU_THUMB'}) {
                            $tmp{'APART_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'APART_PICS_TIZU_THUMB'};
                        }

                        if ($tmp{'APART_PRICE_SIKIKIN_UNIT'}){
                            if ($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 1){
                                $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                            }elsif($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 2){
                                $tmp{'APART_PRICE_SIKIKIN_UNIT'} = '円';
                                $tmp{'APART_PRICE_SIKIKIN'} = REPS::Util->insert_comma($tmp{'APART_PRICE_SIKIKIN'});
                            }elsif($tmp{'APART_PRICE_SIKIKIN_UNIT'} == 3){
                                $tmp{'APART_PRICE_SIKIKIN_UNIT'} = '万円';
                            }else{
                                $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                            }
                        }else{
                            $tmp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                        }
                        if ($tmp{'APART_PRICE_REIKIN_UNIT'}){
                            if ($tmp{'APART_PRICE_REIKIN_UNIT'} == 1){
                                $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                            }elsif($tmp{'APART_PRICE_REIKIN_UNIT'} == 2){
                                $tmp{'APART_PRICE_REIKIN_UNIT'} = '円';
                                $tmp{'APART_PRICE_REIKIN'} = REPS::Util->insert_comma($tmp{'APART_PRICE_REIKIN'});
                            }elsif($tmp{'APART_PRICE_REIKIN_UNIT'} == 3){
                                $tmp{'APART_PRICE_REIKIN_UNIT'} = '万円';
                            }else{
                                $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                            }
                        }else{
                            $tmp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
                        }

                        #単位はヶ月となっているが、円でも入れられるように、とりあえず...
                        if ($tmp{'APART_PRICE_OTHER'} =~ m/^([1-9]([0-9]{3,20}))$/){
                            $tmp{'APART_PRICE_OTHER'} = REPS::Util->insert_comma($tmp{'APART_PRICE_OTHER'});
                        }

                        require Unicode::Japanese;
                        my $UJ = Unicode::Japanese->new;
                        my $str = $UJ->set($tmp{'APART_LOCATION'},'euc')->utf8;
                        $str =~ s/(\W)/sprintf("%%%02X",unpack("C",$1))/eg;

                        #TODO
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            $tmp_company_info = $$usr_company_info{$tmp{'APART_USER_ID'}};
                        }

                        my %hash = (
                            'APART_ID' => "$_",
                            'APART_IS_SPECIAL' => $tmp{'APART_IS_SPECIAL'},
                            'APART_STATION_1' => $tmp{'APART_STATION_1'},
                            'APART_LOCATION' => $tmp{'APART_LOCATION'},
                            'APART_LOCATION_URLENCODED' => $str,
            
                            'APART_PRICE' => REPS::Util->insert_comma($tmp{'APART_PRICE'}),
            
                            'APART_BUS_1' => $tmp{'APART_BUS_1'},
                            'APART_BUS_MINUTES_1' => $tmp{'APART_BUS_MINUTES_1'},
                            'APART_WALK_MINUTES_1' => $tmp{'APART_WALK_MINUTES_1'},
                            'APART_BUSWALK_MINUTES_1' => $tmp{'APART_BUSWALK_MINUTES_1'},
            
                            'APART_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'APART_PRICE_KANRIHI'}),
                            'APART_PRICE_SIKIKIN' => $tmp{'APART_PRICE_SIKIKIN'},
                            'APART_PRICE_REIKIN' => $tmp{'APART_PRICE_REIKIN'},
                            'APART_PRICE_SIKIKIN_UNIT' => $tmp{'APART_PRICE_SIKIKIN_UNIT'},
                            'APART_PRICE_REIKIN_UNIT' => $tmp{'APART_PRICE_REIKIN_UNIT'},    
                            'APART_SQUARE' => $tmp{'APART_SQUARE'},
                            'APART_MADORI' => $tmp{'APART_MADORI'},
            
            
                            'APART_STATION_2' => $tmp{'APART_STATION_2'},
                            'APART_BUS_2' => $tmp{'APART_BUS_2'},
                            'APART_BUS_MINUTES_2' => $tmp{'APART_BUS_MINUTES_2'},
                            'APART_WALK_MINUTES_2' => $tmp{'APART_WALK_MINUTES_2'},
                            'APART_BUSWALK_MINUTES_2' => $tmp{'APART_BUSWALK_MINUTES_2'},
        
                            'APART_PRICE_HOSYOUKIN' => REPS::Util->insert_comma($tmp{'APART_PRICE_HOSYOUKIN'}),
                            'APART_PRICE_SIKIBIKI' => REPS::Util->insert_comma($tmp{'APART_PRICE_SIKIBIKI'}),
                            'APART_PRICE_OTHER' => $tmp{'APART_PRICE_OTHER'},
                            'APART_INSURANCE' => $tmp{'APART_INSURANCE'},
                            'APART_MADORI_DETAIL' => $tmp{'APART_MADORI_DETAIL'},
                            'APART_SQUARE' => $tmp{'APART_SQUARE'},
                            'APART_SQUARE_TUBO' => $tmp{'APART_SQUARE_TUBO'},

                            'APART_KIND' => $tmp{'APART_KIND'},
                            'APART_BUILDING_STRUCTURE' => $tmp{'APART_BUILDING_STRUCTURE'},
                            'APART_STORY' => $tmp{'APART_STORY'},
                            'APART_FLOOR' => $tmp{'APART_FLOOR'},
                            'APART_AGE' => $tmp{'APART_AGE'},
                            'APART_CONDITION' => $tmp{'APART_CONDITION'},
            
                            'APART_OPTIONS_KAKUBEYA' => $tmp{'APART_OPTIONS_KAKUBEYA'},
                            'APART_OPTIONS_MINAMI' => $tmp{'APART_OPTIONS_MINAMI'},
                            'APART_OPTIONS_AUTOLOCK' => $tmp{'APART_OPTIONS_AUTOLOCK'},
                            'APART_OPTIONS_ELEVATOR' => $tmp{'APART_OPTIONS_ELEVATOR'},
                            'APART_OPTIONS_TVPHONE' => $tmp{'APART_OPTIONS_TVPHONE'},
                            'APART_OPTIONS_BATHTOILET' => $tmp{'APART_OPTIONS_BATHTOILET'},
                            'APART_OPTIONS_AIRCON' => $tmp{'APART_OPTIONS_AIRCON'},
                            'APART_OPTIONS_OITAKI' => $tmp{'APART_OPTIONS_OITAKI'},
                            'APART_OPTIONS_GASCONRO' => $tmp{'APART_OPTIONS_GASCONRO'},
                            'APART_OPTIONS_SITUNAISENTAKUKI' => $tmp{'APART_OPTIONS_SITUNAISENTAKUKI'},
                            'APART_OPTIONS_LOFT' => $tmp{'APART_OPTIONS_LOFT'},
                            'APART_OPTIONS_FLOORING' => $tmp{'APART_OPTIONS_FLOORING'},
                            'APART_OPTIONS_CATV' => $tmp{'APART_OPTIONS_CATV'},
                            'APART_OPTIONS_CS' => $tmp{'APART_OPTIONS_CS'},
                            'APART_OPTIONS_BS' => $tmp{'APART_OPTIONS_BS'},
                            'APART_OPTIONS_JIMUSYOKA' => $tmp{'APART_OPTIONS_JIMUSYOKA'},

                            'APART_OPTIONS_INTERNET' => $tmp{'APART_OPTIONS_INTERNET'},
                            'APART_OPTIONS_BICYCLE' => $tmp{'APART_OPTIONS_BICYCLE'},
                
                            'APART_OPTIONS_PARKING' => $tmp{'APART_OPTIONS_PARKING'},
                            'APART_OPTIONS_PET' => $tmp{'APART_OPTIONS_PET'},
                            'APART_OPTIONS_HOSYOUNIN' => $tmp{'APART_OPTIONS_HOSYOUNIN'},
            
                            'APART_OPTIONS_INSTRUMENT' => $tmp{'APART_OPTIONS_INSTRUMENT'},
                
                            'APART_SHOUGAKKOUKU' => $tmp{'APART_SHOUGAKKOUKU'},
                            'APART_CYUUGAKKOUKU' => $tmp{'APART_CYUUGAKKOUKU'},
                            'APART_DAIGAKU_LIST' => $tmp{'APART_DAIGAKU_LIST'},
                
                
                            'APART_TORIHIKITAIYOU' => $tmp{'APART_TORIHIKITAIYOU'},
                            'APART_ADS_TEXT' => $tmp{'APART_ADS_TEXT'},
                            #'APART_HTML_TEXT' => $tmp{'APART_HTML_TEXT'},
                            'APART_BIKOU' => $tmp{'APART_BIKOU'},
                            'APART_NYUUKYOJIKI' => $tmp{'APART_NYUUKYOJIKI'},
                            'APART_SETUBI' => $tmp{'APART_SETUBI'},
                    
                            'APART_YOUR_ID' => $tmp{'APART_YOUR_ID'},

                            'APART_PICS_OUTSIDE' => $tmp{'APART_PICS_OUTSIDE'},
                            'APART_PICS_INSIDE' => $tmp{'APART_PICS_INSIDE'},
                            'APART_PICS_MADORIZU' => $tmp{'APART_PICS_MADORIZU'},
                            'APART_PICS_TIZU' => $tmp{'APART_PICS_TIZU'},

                            'APART_PICS_OUTSIDE_THUMB' => $tmp{'APART_PICS_OUTSIDE_THUMB'},
                            'APART_PICS_INSIDE_THUMB' => $tmp{'APART_PICS_INSIDE_THUMB'},
                            'APART_PICS_MADORIZU_THUMB' => $tmp{'APART_PICS_MADORIZU_THUMB'},
                            'APART_PICS_TIZU_THUMB' => $tmp{'APART_PICS_TIZU_THUMB'},

                            'APART_MOVIE_FILE_URL' => $tmp{'APART_MOVIE_FILE_URL'},

                            'APART_COMPANY_NAME' => $$tmp_company_info{'COMPANY_NAME'},
                            'APART_COMPANY_TEL' => $$tmp_company_info{'COMPANY_TEL'},
                            'APART_COMPANY_ADDRESS' => $$tmp_company_info{'COMPANY_ADDRESS'},
                            'APART_COMPANY_LICENSE' => $$tmp_company_info{'COMPANY_LICENSE'},
                            'APART_COMPANY_HP' => $$tmp_company_info{'COMPANY_HP'},
            
                            'APART_CREATED' => REPS::Util->get_date_as_string($tmp{'APART_CREATED'}),
                            'APART_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'APART_LAST_UPDATED'}),
                            'site_url' => $self->{_app}->cfg('site_url'),
                            'cgi_url' => $self->{_app}->cfg('cgi_url')
                        );
                        push(@loop_data, \%hash);
                    }
                }
            }
        }
    
    
        if ((scalar @loop_data) == 1){
            $loop_data[0]{'ONLY_ONE'} = 1;
        }
    
        if ($self->{_app}->param('user_logged_in') != 1){
            my %access;
            my $db_access_path = $self->{_app}->param('db_r_apart_access_path');
            tie (%access, 'MLDBM', $db_access_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
            foreach (@id_to_be_logged){
                my $ref_access_tmp;
                $ref_access_tmp = $access{$_};
                $$ref_access_tmp{'COUNT'} = $access{$_}{'COUNT'}+1;
                $$ref_access_tmp{'USER_ID'} = $apart{$_}{'APART_USER_ID'};
    
                $access{$_} =  $ref_access_tmp;
            }
            untie %access;
        }
        untie %apart;
    }
    return \@loop_data;
}

sub log_Inquiry{
    my $self = shift;
    my @ids = @_;

    if ($self->{_app}->param('user_logged_in') != 1){

        my %apart;
        my $db_apart_path = $self->{_app}->param('db_r_apart_path');
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        my %inquiry;
        my $db_inquiry_path = $self->{_app}->param('db_r_apart_inquiry_path');
        tie (%inquiry, 'MLDBM', $db_inquiry_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
        foreach (@ids){

            my $ref_access_tmp;
            $ref_access_tmp = $inquiry{$_};
            $$ref_access_tmp{'COUNT'}++;# = $inquiry{$_}{'COUNT'}+1;
            $$ref_access_tmp{'USER_ID'} = $apart{$_}{'APART_USER_ID'};

            $inquiry{$_} =  $ref_access_tmp;

            #$inquiry{$_}{'COUNT'}++;
            #$inquiry{$_}{'USER_ID'} = $apart{'APART_USER_ID'};
            
            #$inquiry{$_}++;
        }
        untie %inquiry;

        untie %apart;
    }
}



















1
