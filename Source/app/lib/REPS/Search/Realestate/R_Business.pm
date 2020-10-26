package REPS::Search::Realestate::R_Business;

use base qw(REPS::Search::Realestate);
use strict;
use DB_File::Lock;
use File::Path;

sub new{
    my ($class,$app) = @_;
    my $self = {
        _app => $app,
        _ref_hash => {
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
            'BUSINESS_TUBOTANKA' => '',
            'BUSINESS_PRICE_KANRIHI' => '',
            'BUSINESS_PRICE_SIKIKIN' => '',
            'BUSINESS_PRICE_REIKIN' => '',
            'BUSINESS_PRICE_SIKIKIN_UNIT' => '',
            'BUSINESS_PRICE_REIKIN_UNIT' => '',
            'BUSINESS_PRICE_HOSYOUKIN' => '',
            'BUSINESS_PRICE_SYOUKYAKU' => '',
            'BUSINESS_PRICE_SIKIBIKI' => '',
            'BUSINESS_PRICE_OTHER' => '',
            'BUSINESS_INSURANCE' => '',
            'BUSINESS_TOTI_SQUARE' => '',
            'BUSINESS_SENYUU_SQUARE' => '',
            'BUSINESS_KIND' => '',
            'BUSINESS_BUILDING_NAME' => '',
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
            'BUSINESS_BIKOU' =>'',
            'BUSINESS_USER_ID' => $app->param('user_id'),,
            'BUSINESS_CREATED' => '',
            'BUSINESS_LAST_UPDATED' => '',

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

    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if(-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        while ( ($key, $value) = each(%business) ) {
            if ((exists $business{$key}) && (defined $business{$key}) && ($value)){

                my %tmp = %$value;
                if (exists $tmp{'BUSINESS_USER_ID'}){
                    #match?
                    $match = 0;

                        if ($tmp{'BUSINESS_PUBLISHED'}){
                            $match = 1;
                        }else{
                            next;
                        }

                   my $test = 0;
                   my $tk;
                   if ($q->param("business_kind")){
                        my @business_kind;
                        foreach ($q->param("business_kind")){
                            push (@business_kind,split(',',$_));
                        }
                       foreach $tk (@business_kind){
                           foreach (split(',',$tmp{'BUSINESS_KIND'})){
                               if ($tk == $_){
                                   $test = 1;
                               }
                           }
                       }
                       next unless ($test);
                   }

#bad code
#                     my $test = 0;
#                     if ($q->param("business_kind")){
#                         my @business_kind;
#                         foreach ($q->param("business_kind")){
#                             push (@business_kind,split(',',$_));
#                         }
#                         foreach (@business_kind){
#                             if ($tmp{'BUSINESS_KIND'} == $_){
#                                 $test = 1;
#                             }
#                         }
#                         next unless ($test);
#                     }





#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("business_price_l")){
    $q->param("business_price_1"=>$q->param("business_price_l"));
}
                    if ($q->param("business_price_1") || $q->param("business_price_2")){
    
                        my $tmp_price = $tmp{'BUSINESS_PRICE'};
                        if ($q->param("include_k_k")){
                            #TODO
                            if ($tmp{'BUSINESS_PRICE_KANRIHI'}){
                                $tmp_price = $tmp_price+$tmp{'BUSINESS_PRICE_KANRIHI'};
                            }
                        }
                        if ($q->param("business_price_1") && $q->param("business_price_2")){
    
                            if (($tmp_price >= ($q->param("business_price_1") * 10000)) && ($tmp_price <= ($q->param("business_price_2") * 10000))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("business_price_2") == 0){
                            if ($tmp_price >= ($q->param("business_price_1") * 10000)){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("business_price_1") == 0){
    
                            if ($tmp_price <= ($q->param("business_price_2") * 10000)){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }
#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("business_price_l")){
    $q->delete('business_price_l');
}
    
                    if ($q->param("business_no_reikin")){
                        if ($tmp{'BUSINESS_PRICE_REIKIN'} > 0){
                            next;
                        }
                    }
                    if ($q->param("business_no_sikikin")){
                        if ($tmp{'BUSINESS_PRICE_SIKIKIN'} > 0){
                            next;
                        }
                    }
    
    #                if ($q->param("business_square_1") || $q->param("business_square_2")){
    #                    if (($tmp{'BUSINESS_SQUARE'} >= ($q->param("business_square_1"))) && ($tmp{'BUSINESS_SQUARE'} <= ($q->param("business_square_2")))){
    #                        $match = 1;
    #                    }else{
    #                        next;
    #                    }
    #                }
                    if ($q->param("business_square_1") || $q->param("business_square_2")){
                        if (($q->param("business_square_1") && $q->param("business_square_2"))){
                            if (($tmp{'BUSINESS_SENYUU_SQUARE'} >= ($q->param("business_square_1"))) && ($tmp{'BUSINESS_SENYUU_SQUARE'} <= ($q->param("business_square_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("business_square_2")){
                            if ($tmp{'BUSINESS_SENYUU_SQUARE'} <= ($q->param("business_square_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("business_square_1")){
                            if ($tmp{'BUSINESS_SENYUU_SQUARE'} >= ($q->param("business_square_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
    
                        }
                    }

                    if ($q->param("business_age")){
    #                    if ($q->param("business_age") = ){
                        if ((exists $tmp{'BUSINESS_AGE'})&&(defined $tmp{'BUSINESS_AGE'})){
                            if ($tmp{'BUSINESS_AGE'} ne ''){

                                if (REPS::Util->get_date_delta($tmp{'BUSINESS_AGE'}.'/01') <= ($q->param("business_age")*365)){
                                    $match = 1;

                                }else{next;}
                            }else{next;}
                        }else{
                            next;
                        }
                    }

                    $test = 0;
                    if ($q->param("business_walk_minutes")){
                        if ($tmp{'BUSINESS_WALK_MINUTES_1'}){
                            if ($tmp{'BUSINESS_WALK_MINUTES_1'} <= $q->param("business_walk_minutes")){
                                $test = 1;
                            }
                        }
                        if ($tmp{'BUSINESS_WALK_MINUTES_2'}){
                            if ($tmp{'BUSINESS_WALK_MINUTES_2'} <= $q->param("business_walk_minutes")){
                                $test = 1;
                            }
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("business_has_")){
                        my @business_has;
                        foreach ($q->param("business_has_")){
                            push (@business_has,split(',',$_));
                        }
                        foreach (@business_has){
                            if ($_ == 1){
                                if ($tmp{'BUSINESS_PICS_MADORIZU'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 2){
                                if ($tmp{'BUSINESS_PICS_OUTSIDE'} || $tmp{'BUSINESS_PICS_INSIDE'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 3){
                                if ($tmp{'BUSINESS_MOVIE_FILE_URL'}){$test=1;}else{$test=0;last;}
                            }
                        }
                        next unless ($test);
                    }

                    if ($q->param('business_options_ikkai')){
                        if ($tmp{'BUSINESS_FLOOR'} != 1){next;}
                    }
                    if ($q->param('business_options_nikaiijyou')){
                        if ($tmp{'BUSINESS_FLOOR'}){
                            unless ($tmp{'BUSINESS_FLOOR'} >= 2){next;}
                        }else{
                            next;
                        }
                    }
                    if ($q->param('business_options_saijyoukai')){
                        if ($tmp{'BUSINESS_STORY'} > 2){
                            if ($tmp{'BUSINESS_STORY'} && $tmp{'BUSINESS_FLOOR'}){
                                if ($tmp{'BUSINESS_STORY'} != $tmp{'BUSINESS_FLOOR'}){
                                    next;
                                }
                            }else{
                                next;
                            }
                        }else{next;}
                    }

                    if ($q->param('business_options_parking')){
                        if (!$tmp{'BUSINESS_OPTIONS_PARKING'}){next;}
                    }

                    $test = 0;
                    if ($q->param("business_address")){
                        foreach ($q->param("business_address")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'BUSINESS_LOCATION'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'BUSINESS_LOCATION'},$search_by_key)){
                            #    $test = 1;
                            #    $match = 1;
                            #}else{
                            #    next;
                            #}
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("business_station")){
                        foreach ($q->param("business_station")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'BUSINESS_STATION_1'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }elsif(REPS::Util->str_match($tmp{'BUSINESS_STATION_2'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'BUSINESS_STATION_1'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}elsif(REPS::Util->str_match($tmp{'BUSINESS_STATION_2'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    if ($q->param("business_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("business_school")));
                        if (REPS::Util->str_match($tmp{'BUSINESS_SHOUGAKKOUKU'},$search_by_key)){
                        #if ($tmp{'BUSINESS_SHOUGAKKOUKU'} =~ m/.*$search_by_key.*/i){
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'BUSINESS_CYUUGAKKOUKU'},$search_by_key)){
                        #if ($tmp{'BUSINESS_CYUUGAKKOUKU'} =~ m/.*$search_by_key.*/i){
                            $test = 1;
                        }
    
                        my $tstr =  join(' ',$tmp{'BUSINESS_DAIGAKU_LIST'}); 
    
                        if (REPS::Util->str_match($tstr,$search_by_key)){
                        #if ($tmp{'BUSINESS_DAIGAKU_LIST'} =~ m/.*$search_by_key.*/ig){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }


                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'station') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'station'){
                                $sort_hash{$key} = $tmp{'BUSINESS_STATION_1'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'BUSINESS_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'BUSINESS_LAST_UPDATED'}&&($tmp{'BUSINESS_LAST_UPDATED'}))){
                                    $sort_hash{$key} = $tmp{'BUSINESS_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'BUSINESS_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'BUSINESS_LOCATION'};
                            }else{
                                $sort_hash{$key} = $key;
                            }
                        }else{
                            $sort_hash{$key} = $key;
    
                        }
                    }

                }else{
                    #todo app user id not exists
                }
            }
        }
    
    
    
    #    if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date')|| ($sort_by eq 'location')){
            my @sort_keys;
            #sort
            if (($sort_by eq 'station') || ($sort_by eq 'location')){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
            }elsif(($sort_by eq 'price')){
                @sort_keys = sort {$sort_hash{$a} <=> $sort_hash{$b} || length($a) <=> length($b) || $a cmp $b} keys %sort_hash;
            }elsif($sort_by eq 'date'){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
                @sort_keys = reverse @sort_keys;
            }else{
                @sort_keys = reverse sort keys %sort_hash;
                
            }
            #check if it is over max listing num
    
            $c = @sort_keys;
    
            #my $items_per_page = $self->{_app}->cfg('items_per_page');
            
            #my $of = $q->param("off_set");
            if ($off_set){
                splice( @sort_keys , 0,$off_set); # $of items delete. start with 0
                splice( @sort_keys , $items_per_page,$c-$off_set); # delete rest of items. start with offset
            }else{
                if ($c > $items_per_page){
                            splice( @sort_keys , $items_per_page); #show $of items. delete rest.
                }
            }

            my $new_off_set = $off_set + $items_per_page;

    
            foreach (@sort_keys){
                my $ref_hash = $business{$_};
                my %tmp = %$ref_hash;

#                if ($tmp{'BUSINESS_BUSWALK_MINUTES_1'}){
#                    $tmp{'BUSINESS_BUS_MINUTES_1'} = $tmp{'BUSINESS_BUS_MINUTES_1'}+$tmp{'BUSINESS_BUSWALK_MINUTES_1'};
#                }
#                if ($tmp{'BUSINESS_BUSWALK_MINUTES_2'}){
#                    $tmp{'BUSINESS_BUS_MINUTES_2'} = $tmp{'BUSINESS_BUS_MINUTES_2'}+$tmp{'BUSINESS_BUSWALK_MINUTES_2'};
#                }
    
                if ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'}){
                    if ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 1){
                        $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }elsif ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 2){
                        $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = '円';
                        $tmp{'BUSINESS_PRICE_SIKIKIN'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_SIKIKIN'});
                    }elsif ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 3){
                        $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = '万円';
                    }else{
                        $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }
                }else{
                    $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                }

                if ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'}){
                    if ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 1){
                        $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }elsif ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 2){
                        $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = '円';
                        $tmp{'BUSINESS_PRICE_REIKIN'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_REIKIN'});
                    }elsif ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 3){
                        $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = '万円';
                    }else{
                        $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }
                }else{
                    $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                }

                my $kind;
                foreach (split(',',$tmp{'BUSINESS_KIND'})){
                    if ($kind){$kind.='・'}
                    if ($_ == 1){$kind .= '店舗'}
                    elsif($_ == 2){$kind .= '事務所'}
                    elsif($_ == 3){$kind .= '他'}
                }

                my $new = '';
                my $updated = '';
                if ($tmp{'BUSINESS_CREATED'}){
                    my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'BUSINESS_CREATED'});
                    if ($dd <= 30) {
                        $new = 'ON';
                    }
                    if ((!$new) && ($tmp{'BUSINESS_LAST_UPDATED'})){
                        $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'BUSINESS_LAST_UPDATED'});
                        if ($dd <= 10) {
                            $updated = 'ON';
                        }
                    }
                }
#TODO:


                if ($tmp{'BUSINESS_PICS_OUTSIDE'}){
                    $tmp{'BUSINESS_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_OUTSIDE'};
                }
                if ($tmp{'BUSINESS_PICS_INSIDE'}){
                    $tmp{'BUSINESS_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_INSIDE'};
                }
                if ($tmp{'BUSINESS_PICS_MADORIZU'}) {
                    $tmp{'BUSINESS_PICS_MADORIZU'} = $self->{_app}->cfg('site_url'). $self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_MADORIZU'};
                }
                if ($tmp{'BUSINESS_PICS_TIZU'}) {
                    $tmp{'BUSINESS_PICS_TIZU'} = $self->{_app}->cfg('site_url'). $self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_TIZU'};
                }
                if ($tmp{'BUSINESS_PICS_OUTSIDE_THUMB'}){
                    $tmp{'BUSINESS_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_OUTSIDE_THUMB'};
                }
                if ($tmp{'BUSINESS_PICS_INSIDE_THUMB'}){
                    $tmp{'BUSINESS_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_INSIDE_THUMB'};
                }
                if ($tmp{'BUSINESS_PICS_MADORIZU_THUMB'}){
                    $tmp{'BUSINESS_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_MADORIZU_THUMB'};
                }
                if ($tmp{'BUSINESS_PICS_TIZU_THUMB'}){
                    $tmp{'BUSINESS_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_TIZU_THUMB'};
                }


                my %hash = (
                    'BUSINESS_ID' => "$_",
                    'BUSINESS_IS_SPECIAL' => $tmp{'BUSINESS_IS_SPECIAL'},
                    'BUSINESS_STATION_1' => $tmp{'BUSINESS_STATION_1'},
                    'BUSINESS_STATION_2' => $tmp{'BUSINESS_STATION_2'},
                    'BUSINESS_BUS_MINUTES_1' => $tmp{'BUSINESS_BUS_MINUTES_1'},
                    'BUSINESS_WALK_MINUTES_1' => $tmp{'BUSINESS_WALK_MINUTES_1'},
                    'BUSINESS_BUS_MINUTES_2' => $tmp{'BUSINESS_BUS_MINUTES_2'},
                    'BUSINESS_WALK_MINUTES_2' => $tmp{'BUSINESS_WALK_MINUTES_2'},
                    'BUSINESS_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_KANRIHI'}),
                    'BUSINESS_PRICE_SIKIKIN' => $tmp{'BUSINESS_PRICE_SIKIKIN'},
                    'BUSINESS_PRICE_REIKIN' => $tmp{'BUSINESS_PRICE_REIKIN'},
                    'BUSINESS_PRICE_SIKIKIN_UNIT' => $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'},
                    'BUSINESS_PRICE_REIKIN_UNIT' => $tmp{'BUSINESS_PRICE_REIKIN_UNIT'},
                    'BUSINESS_TOTI_SQUARE' => $tmp{'BUSINESS_TOTI_SQUARE'},
                    'BUSINESS_SENYUU_SQUARE' => $tmp{'BUSINESS_SENYUU_SQUARE'},
                    'BUSINESS_LOCATION' => $tmp{'BUSINESS_LOCATION'},
                    'BUSINESS_PRICE' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE'}),
                    'BUSINESS_KIND' => $kind,

                        'BUSINESS_PICS_OUTSIDE' => $tmp{'BUSINESS_PICS_OUTSIDE'},
                        'BUSINESS_PICS_OUTSIDE_THUMB' => $tmp{'BUSINESS_PICS_OUTSIDE_THUMB'},
                        'BUSINESS_PICS_INSIDE' => $tmp{'BUSINESS_PICS_INSIDE'},
                        'BUSINESS_PICS_INSIDE_THUMB' => $tmp{'BUSINESS_PICS_INSIDE_THUMB'},
                        'BUSINESS_PICS_MADORIZU' => $tmp{'BUSINESS_PICS_MADORIZU'},
                        'BUSINESS_PICS_MADORIZU_THUMB' => $tmp{'BUSINESS_PICS_MADORIZU_THUMB'},
                        'BUSINESS_PICS_TIZU' => $tmp{'BUSINESS_PICS_TIZU'},
                        'BUSINESS_PICS_TIZU_THUMB' => $tmp{'BUSINESS_PICS_TIZU_THUMB'},

                        'BUSINESS_BUILDING_STRUCTURE' => $tmp{'BUSINESS_BUILDING_STRUCTURE'},
                        'BUSINESS_YOUR_ID' => $tmp{'BUSINESS_YOUR_ID'},
                        'BUSINESS_BUS_1' => $tmp{'BUSINESS_BUS_1'},
                        'BUSINESS_BUS_2' => $tmp{'BUSINESS_BUS_2'},
                        'BUSINESS_AGE' => $tmp{'BUSINESS_AGE'},
                        'BUSINESS_BUSWALK_MINUTES_1' => $tmp{'BUSINESS_BUSWALK_MINUTES_1'},
                        'BUSINESS_BUSWALK_MINUTES_2' => $tmp{'BUSINESS_BUSWALK_MINUTES_2'},
                        'BUSINESS_STORY' => $tmp{'BUSINESS_STORY'},

                    'BUSINESS_NEW' => $new,
                    'BUSINESS_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    'BUSINESS_CREATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_CREATED'}),
                    'BUSINESS_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_LAST_UPDATED'}),
                    '_type' => 'rb'
                );
        
                push(@loop_data, \%hash);
            }

    
        untie %business;
    }

    #my $search = REPS::Search::Search->new;
    $Search->{'ref_result_loop'} = \@loop_data;
    #$Search->{'off_set'} = $new_off_set;
    $Search->{'count_result'} = $c;
    #$search->{'items_per_page'} = $items_per_page;

    return 1;


}

sub get_Simple_List{
    my $self = shift;
    my @ids = @_;
    my @loop_data =();
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if(-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;
    
            foreach (@ids){
                if ((defined $business{$_}) && ($business{$_})){
                    my $ref_hash = $business{$_};
                    my %tmp = %$ref_hash;
    
    
                    #if ($tmp{'BUSINESS_BUSWALK_MINUTES_1'}){
                    #    $tmp{'BUSINESS_BUS_MINUTES_1'} = $tmp{'BUSINESS_BUS_MINUTES_1'}+$tmp{'BUSINESS_BUSWALK_MINUTES_1'};
                    #}
                    #if ($tmp{'BUSINESS_BUSWALK_MINUTES_2'}){
                    #    $tmp{'BUSINESS_BUS_MINUTES_2'} = $tmp{'BUSINESS_BUS_MINUTES_2'}+$tmp{'BUSINESS_BUSWALK_MINUTES_2'};
                    #}

                    if ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'}){
                        if ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 1){
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                        }elsif ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 2){
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = '円';
                            $tmp{'BUSINESS_PRICE_SIKIKIN'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_SIKIKIN'});
                        }elsif ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 3){
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = '万円';
                        }else{
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                        }
                    }else{
                        $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                    }

                    if ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'}){
                        if ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 1){
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                        }elsif ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 2){
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = '円';
                            $tmp{'BUSINESS_PRICE_REIKIN'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_REIKIN'});
                        }elsif ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 3){
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = '万円';
                        }else{
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                        }
                    }else{
                        $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                    }

                    my %hash = (
                        'ID' => "$_",
                        #'BUSINESS_PUBLISHED' => $tmp{'BUSINESS_PUBLISHED'},
                        'BUSINESS_STATION_1' => $tmp{'BUSINESS_STATION_1'},
                        'BUSINESS_STATION_2' => $tmp{'BUSINESS_STATION_2'},
                        'BUSINESS_LOCATION' => $tmp{'BUSINESS_LOCATION'},
                        'BUSINESS_PRICE' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE'}),
                        'BUSINESS_BUS_MINUTES_1' => $tmp{'BUSINESS_BUS_MINUTES_1'},
                        'BUSINESS_WALK_MINUTES_1' => $tmp{'BUSINESS_WALK_MINUTES_1'},
                        'BUSINESS_BUSWALK_MINUTES_1' => $tmp{'BUSINESS_BUSWALK_MINUTES_1'},
                        'BUSINESS_BUS_MINUTES_2' => $tmp{'BUSINESS_BUS_MINUTES_2'},
                        'BUSINESS_WALK_MINUTES_2' => $tmp{'BUSINESS_WALK_MINUTES_2'},
                        'BUSINESS_BUSWALK_MINUTES_2' => $tmp{'BUSINESS_BUSWALK_MINUTES_2'},
                        'BUSINESS_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_KANRIHI'}),
                        'BUSINESS_PRICE_SIKIKIN' => $tmp{'BUSINESS_PRICE_SIKIKIN'},
                        'BUSINESS_PRICE_REIKIN' => $tmp{'BUSINESS_PRICE_REIKIN'},
                        'BUSINESS_PRICE_SIKIKIN_UNIT' => $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'},
                        'BUSINESS_PRICE_REIKIN_UNIT' => $tmp{'BUSINESS_PRICE_REIKIN_UNIT'},    
                        'BUSINESS_SENYUU_SQUARE' => $tmp{'BUSINESS_SENYUU_SQUARE'},
                        'BUSINESS_TOTI_SQUARE' => $tmp{'BUSINESS_TOTI_SQUARE'},
    
                        'USER_ID' => $tmp{'BUSINESS_USER_ID'},
    
                        'BUSINESS_CREATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_CREATED'}),
                        'BUSINESS_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_LAST_UPDATED'})

                    );
            
                    push(@loop_data, \%hash);
                }
            }
        untie %business;
    }
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

#    my $tmp_company_info = $Settings->get_settings_to_be_displayed();

    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if(-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;
        #
        my $tmp_company_info;
        my $usr_company_info;
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            #get users company info
            my @usr_ids;
            foreach (@ids){
                if ($business{$_}){
                    push (@usr_ids, $business{$_}{'BUSINESS_USER_ID'});
                }
            }
            $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
        }else{
            $tmp_company_info = $Settings->get_settings_to_be_displayed();
        }

        foreach (@ids){
            if (defined $business{$_}){
    
                $value = $business{$_};
                my %tmp = %$value;
                if (exists $tmp{'BUSINESS_ID'}){
                    if (($_ eq $tmp{'BUSINESS_ID'} ) && ($tmp{'BUSINESS_PUBLISHED'})){
                        push (@id_to_be_logged,$_);
                        my $kind;
                        foreach (split(',',$tmp{'BUSINESS_KIND'})){
                            if ($kind){$kind.='・'}
                            if ($_ == 1){$kind .= '店舗'}
                            elsif($_ == 2){$kind .= '事務所'}
                            elsif($_ == 3){$kind .= '他'}
                            
                        }
                        #if ($tmp{'BUSINESS_BUSWALK_MINUTES_1'}){
                        #    $tmp{'BUSINESS_BUS_MINUTES_1'} = $tmp{'BUSINESS_BUS_MINUTES_1'}+$tmp{'BUSINESS_BUSWALK_MINUTES_1'};
                        #}
                        #if ($tmp{'BUSINESS_BUSWALK_MINUTES_2'}){
                        #    $tmp{'BUSINESS_BUS_MINUTES_2'} = $tmp{'BUSINESS_BUS_MINUTES_2'}+$tmp{'BUSINESS_BUSWALK_MINUTES_2'};
                        #}
                        
                        if ($tmp{'BUSINESS_PICS_OUTSIDE'}){
                            $tmp{'BUSINESS_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_OUTSIDE'};
                        }
                        if ($tmp{'BUSINESS_PICS_INSIDE'}){
                            $tmp{'BUSINESS_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_INSIDE'};
                        }
                        if ($tmp{'BUSINESS_PICS_MADORIZU'}) {
                            $tmp{'BUSINESS_PICS_MADORIZU'} = $self->{_app}->cfg('site_url'). $self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_MADORIZU'};
                        }
                        if ($tmp{'BUSINESS_PICS_TIZU'}) {
                            $tmp{'BUSINESS_PICS_TIZU'} = $self->{_app}->cfg('site_url'). $self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_TIZU'};
                        }
                        if ($tmp{'BUSINESS_PICS_OUTSIDE_THUMB'}){
                            $tmp{'BUSINESS_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_OUTSIDE_THUMB'};
                        }
                        if ($tmp{'BUSINESS_PICS_INSIDE_THUMB'}){
                            $tmp{'BUSINESS_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_INSIDE_THUMB'};
                        }
                        if ($tmp{'BUSINESS_PICS_MADORIZU_THUMB'}){
                            $tmp{'BUSINESS_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_MADORIZU_THUMB'};
                        }
                        if ($tmp{'BUSINESS_PICS_TIZU_THUMB'}){
                            $tmp{'BUSINESS_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'BUSINESS_PICS_TIZU_THUMB'};
                        }

                        #単位はヶ月となっているが、円でも入れられるように、とりあえず...
                        if ($tmp{'BUSINESS_PRICE_OTHER'} =~ m/^([1-9]([0-9]{3,20}))$/){
                            $tmp{'BUSINESS_PRICE_OTHER'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_OTHER'});
                        }

                        require Unicode::Japanese;
                        my $UJ = Unicode::Japanese->new;
                        my $str = $UJ->set($tmp{'BUSINESS_LOCATION'},'euc')->utf8;
                        $str =~ s/(\W)/sprintf("%%%02X",unpack("C",$1))/eg;
    
                        #
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            $tmp_company_info = $$usr_company_info{$tmp{'BUSINESS_USER_ID'}};
                        }
    
                        if ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 1){
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                        }elsif ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 2){
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = '円';
                            $tmp{'BUSINESS_PRICE_SIKIKIN'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_SIKIKIN'});
                        }elsif ($tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} == 3){
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = '万円';
                        }else{
                            $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
                        }
                        if ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 1){
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                        }elsif ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 2){
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = '円';
                            $tmp{'BUSINESS_PRICE_REIKIN'} = REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_REIKIN'});
                        }elsif ($tmp{'BUSINESS_PRICE_REIKIN_UNIT'} == 3){
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = '万円';
                        }else{
                            $tmp{'BUSINESS_PRICE_REIKIN_UNIT'} = 'ヶ月';
                        }

                        my %hash = (
    
                            'BUSINESS_ID' => "$_",
                            'BUSINESS_IS_SPECIAL' => $tmp{'BUSINESS_IS_SPECIAL'},
                            'BUSINESS_STATION_1' => $tmp{'BUSINESS_STATION_1'},
                            'BUSINESS_STATION_2' => $tmp{'BUSINESS_STATION_2'},
                            'BUSINESS_LOCATION' => $tmp{'BUSINESS_LOCATION'},
                            'BUSINESS_LOCATION_URLENCODED' => $str,
                            'BUSINESS_KIND' => $kind,
                            'BUSINESS_PRICE' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE'}),
                            'BUSINESS_TUBOTANKA' => REPS::Util->insert_comma($tmp{'BUSINESS_TUBOTANKA'}),
                            'BUSINESS_BUS_MINUTES_1' => $tmp{'BUSINESS_BUS_MINUTES_1'},
                            'BUSINESS_WALK_MINUTES_1' => $tmp{'BUSINESS_WALK_MINUTES_1'},
                            'BUSINESS_BUSWALK_MINUTES_1' => $tmp{'BUSINESS_BUSWALK_MINUTES_1'},
                            'BUSINESS_BUS_1' => $tmp{'BUSINESS_BUS_1'},
                            'BUSINESS_BUS_2' => $tmp{'BUSINESS_BUS_2'},
                            'BUSINESS_BUS_MINUTES_2' => $tmp{'BUSINESS_BUS_MINUTES_2'},
                            'BUSINESS_WALK_MINUTES_2' => $tmp{'BUSINESS_WALK_MINUTES_2'},
                            'BUSINESS_BUSWALK_MINUTES_2' => $tmp{'BUSINESS_BUSWALK_MINUTES_2'},
        
                            'BUSINESS_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_KANRIHI'}),
                            'BUSINESS_PRICE_SIKIKIN' => $tmp{'BUSINESS_PRICE_SIKIKIN'},
                            'BUSINESS_PRICE_REIKIN' => $tmp{'BUSINESS_PRICE_REIKIN'},
                            'BUSINESS_PRICE_SIKIKIN_UNIT' => $tmp{'BUSINESS_PRICE_SIKIKIN_UNIT'},
                            'BUSINESS_PRICE_REIKIN_UNIT' => $tmp{'BUSINESS_PRICE_REIKIN_UNIT'},
            
                            'BUSINESS_SENYUU_SQUARE' => $tmp{'BUSINESS_SENYUU_SQUARE'},
            
                            'BUSINESS_PRICE_HOSYOUKIN' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_HOSYOUKIN'}),
                            'BUSINESS_PRICE_SYOUKYAKU' => $tmp{'BUSINESS_PRICE_SYOUKYAKU'},
                            'BUSINESS_PRICE_SIKIBIKI' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE_SIKIBIKI'}),
                            'BUSINESS_PRICE_OTHER' => $tmp{'BUSINESS_PRICE_OTHER'},
                            'BUSINESS_INSURANCE' => $tmp{'BUSINESS_INSURANCE'},
                            #'BUSINESS_CHUUTOKAIYAKU' => $tmp{'BUSINESS_CHUUTOKAIYAKU'},
                
                            'BUSINESS_TOTI_SQUARE' => $tmp{'BUSINESS_TOTI_SQUARE'},
                
                            'BUSINESS_BUILDING_STRUCTURE' => $tmp{'BUSINESS_BUILDING_STRUCTURE'},
                            'BUSINESS_STORY' => $tmp{'BUSINESS_STORY'},
                            'BUSINESS_FLOOR' => $tmp{'BUSINESS_FLOOR'},
                            'BUSINESS_AGE' => $tmp{'BUSINESS_AGE'},
                            'BUSINESS_CONDITION' => $tmp{'BUSINESS_CONDITION'},
                
                            'BUSINESS_OPTIONS_PARKING' => $tmp{'BUSINESS_OPTIONS_PARKING'},

                            'BUSINESS_TORIHIKITAIYOU' => $tmp{'BUSINESS_TORIHIKITAIYOU'},
                            'BUSINESS_ADS_TEXT' => $tmp{'BUSINESS_ADS_TEXT'},
                            'BUSINESS_SETUBI' => $tmp{'BUSINESS_SETUBI'},

                            'BUSINESS_BIKOU' => $tmp{'BUSINESS_BIKOU'},
                    
                            'BUSINESS_PICS_OUTSIDE' => $tmp{'BUSINESS_PICS_OUTSIDE'},
                            'BUSINESS_PICS_INSIDE' => $tmp{'BUSINESS_PICS_INSIDE'},
                            'BUSINESS_PICS_MADORIZU' => $tmp{'BUSINESS_PICS_MADORIZU'},
                            'BUSINESS_PICS_TIZU' => $tmp{'BUSINESS_PICS_TIZU'},
                    
                            'BUSINESS_PICS_OUTSIDE_THUMB' => $tmp{'BUSINESS_PICS_OUTSIDE_THUMB'},
                            'BUSINESS_PICS_INSIDE_THUMB' => $tmp{'BUSINESS_PICS_INSIDE_THUMB'},
                            'BUSINESS_PICS_MADORIZU_THUMB' => $tmp{'BUSINESS_PICS_MADORIZU_THUMB'},
                            'BUSINESS_PICS_TIZU_THUMB' => $tmp{'BUSINESS_PICS_TIZU_THUMB'},
                
                            'BUSINESS_MOVIE_FILE_URL' => $tmp{'BUSINESS_MOVIE_FILE_URL'},
                
                            'BUSINESS_YOUR_ID' => $tmp{'BUSINESS_YOUR_ID'},

                            'BUSINESS_COMPANY_NAME' => $$tmp_company_info{'COMPANY_NAME'},
                            'BUSINESS_COMPANY_TEL' => $$tmp_company_info{'COMPANY_TEL'},
                            'BUSINESS_COMPANY_ADDRESS' => $$tmp_company_info{'COMPANY_ADDRESS'},
                            'BUSINESS_COMPANY_LICENSE' => $$tmp_company_info{'COMPANY_LICENSE'},
                            'BUSINESS_COMPANY_HP' => $$tmp_company_info{'COMPANY_HP'},
                
                            'BUSINESS_CREATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_CREATED'}),
                            'BUSINESS_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_LAST_UPDATED'}),
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
            my $db_access_path = $self->{_app}->param('db_r_business_access_path');
            tie (%access, 'MLDBM', $db_access_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
            foreach (@id_to_be_logged){
    
                my $ref_access_tmp;
                $ref_access_tmp = $access{$_};
                $$ref_access_tmp{'COUNT'} = $access{$_}{'COUNT'}+1;
                $$ref_access_tmp{'USER_ID'} = $business{$_}{'BUSINESS_USER_ID'};
    
                $access{$_} =  $ref_access_tmp;
    
    #            $access{$_}++;
            }
            untie %access;
        }
        untie %business;
    }
    return \@loop_data;

}

sub log_Inquiry{
    my $self = shift;
    my @ids = @_;

    if ($self->{_app}->param('user_logged_in') != 1){

        my %business;
        my $db_business_path = $self->{_app}->param('db_r_business_path');
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        my %inquiry;
        my $db_inquiry_path = $self->{_app}->param('db_r_business_inquiry_path');
        tie (%inquiry, 'MLDBM', $db_inquiry_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
        foreach (@ids){
#            $inquiry{$_}++;
            my $ref_access_tmp;
            $ref_access_tmp = $inquiry{$_};
            $$ref_access_tmp{'COUNT'} = $inquiry{$_}{'COUNT'}+1;
            $$ref_access_tmp{'USER_ID'} = $business{$_}{'BUSINESS_USER_ID'};

            $inquiry{$_} =  $ref_access_tmp;
        }
        untie %inquiry;

        untie %business;
    }
}




1

