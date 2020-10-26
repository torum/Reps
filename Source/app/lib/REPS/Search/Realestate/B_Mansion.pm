package REPS::Search::Realestate::B_Mansion;

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


            'MANSION_SQUARE' => '',
            'MANSION_SQUARE_TEXT' => '',
            'MANSION_SQUARE_TUBO' => '',



            'MANSION_SOUKOSUU' => '',
            'MANSION_SYUYOUSAIKOUMEN' => '',
            'MANSION_BARUKONI_SQUARE' => '',
            'MANSION_BARUKONI_SQUARE_TUBO' => '',

            'MANSION_CHUSYAJYOU' => '',
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

            'MANSION_TASYAKANRI' => '',
            'MANSION_RYUUTUU' => '',
            'MANSION_KANRIKAISYA' => '',
            'MANSION_KANRIKAISYA_CONTACT' => '',


            'MANSION_USER_ID' => $app->param('user_id'),,
            'MANSION_CREATED' => '',
            'MANSION_LAST_UPDATED' => '',

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

    my %mansion;
    my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
    if(-f $db_mansion_path){
        tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;
    
        while ( ($key, $value) = each(%mansion) ) {
            if ((exists $mansion{$key}) && (defined $mansion{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'MANSION_USER_ID'}){
                    #match?
                    $match = 0;
    #
    
                        if ($tmp{'MANSION_PUBLISHED'}){
                            $match = 1;
                        }else{
                            next;
                        }
    
#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("mansion_price_l")){
    $q->param("mansion_price_1"=>$q->param("mansion_price_l"));
}
                    if ($q->param("mansion_price_1") || $q->param("mansion_price_2")){
                        if ($q->param("mansion_price_1") && $q->param("mansion_price_2")){
        
                            if (($tmp{'MANSION_PRICE'} >= ($q->param("mansion_price_1"))) && ($tmp{'MANSION_PRICE'} <= ($q->param("mansion_price_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("mansion_price_2")){
                            if ($tmp{'MANSION_PRICE'} <= ($q->param("mansion_price_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
    
                        }elsif($q->param("mansion_price_1")){
                            if ($tmp{'MANSION_PRICE'} >= ($q->param("mansion_price_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }
#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("mansion_price_l")){
    $q->delete('mansion_price_l');
}
    
                    if ($q->param("mansion_square_1") || $q->param("mansion_square_2")){
                        if (($q->param("mansion_square_1") && $q->param("mansion_square_2"))){
                            if (($tmp{'MANSION_SQUARE'} >= ($q->param("mansion_square_1"))) && ($tmp{'MANSION_SQUARE'} <= ($q->param("mansion_square_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("mansion_square_2")){
                            if ($tmp{'MANSION_SQUARE'} <= ($q->param("mansion_square_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("mansion_square_1")){
                            if ($tmp{'MANSION_SQUARE'} >= ($q->param("mansion_square_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }
    
                    my $test = 0;
                    if ($q->param("mansion_madori")){
                        my @mansion_madori;
                        foreach ($q->param("mansion_madori")){
                            push (@mansion_madori,split(',',$_));
                        }
                        foreach (@mansion_madori){
    
                            if ($tmp{'MANSION_MADORI'} eq $_){
                                $test = 1;
                                last;
                            }
                        }
                        next unless ($test);
                    }
    
                    if ($q->param("mansion_age")){
                        if ((exists $tmp{'MANSION_AGE'})&&(defined $tmp{'MANSION_AGE'})){
                            if ($tmp{'MANSION_AGE'} ne ''){
                                if (REPS::Util->get_date_delta($tmp{'MANSION_AGE'}.'/01') <= ($q->param("mansion_age")*365)){
                                    $match = 1;
                                }else{next;}
                            }else{next;}
                        }else{
                            next;
                        }
                    }

    
    
                    #if ($q->param("mansion_walk_minutes")){
                    #    if (!$tmp{'MANSION_WALK_MINUTES_1'}){next;}
                    #    if ($tmp{'MANSION_WALK_MINUTES_1'} <= $q->param("mansion_walk_minutes")){
                    #        $match = 1;
                    #    }else{next;}
                    #}

                    $test = 0;
                    if ($q->param("mansion_walk_minutes")){
                        if ($tmp{'MANSION_WALK_MINUTES_1'}){
                            if ($tmp{'MANSION_WALK_MINUTES_1'} <= $q->param("mansion_walk_minutes")){
                                $test = 1;
                            }
                        }
                        if ($tmp{'BUSINESS_WALK_MINUTES_2'}){
                            if ($tmp{'BUSINESS_WALK_MINUTES_2'} <= $q->param("mansion_walk_minutes")){
                                $test = 1;
                            }
                        }
                        next unless ($test);
                    }

    
                    $test = 0;
                    if ($q->param("mansion_has_")){
                        my @mansion_has;
                        foreach ($q->param("mansion_has_")){
                            push (@mansion_has,split(',',$_));
                        }
                        foreach (@mansion_has){
                            if ($_ == 1){
                                if ($tmp{'MANSION_PICS_MADORIZU'}){$test=1;}else{$test=0;last;}
                        
                            }
                            if ($_ == 2){
                                if ($tmp{'MANSION_PICS_OUTSIDE'} || $tmp{'MANSION_PICS_INSIDE'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 3){
                                if ($tmp{'MANSION_MOVIE_FILE_URL'}){$test=1;}else{$test=0;last;}
                        
                            }
                        }
                        next unless ($test);
                    }

                    if ($q->param('mansion_options_nikaiijyou')){
                        if ($tmp{'MANSION_FLOOR'}){
                            unless ($tmp{'MANSION_FLOOR'} >= 2){next;}
                        }else{
                            next;
                        }
                    }
                    if ($q->param('mansion_options_saijyoukai')){
                        if ($tmp{'MANSION_STORY'} > 2){
                            if ($tmp{'MANSION_STORY'} && $tmp{'MANSION_FLOOR'}){
                                if ($tmp{'MANSION_STORY'} != $tmp{'MANSION_FLOOR'}){
                                    next;
                                }
                            }else{
                                next;
                            }
                        }else{
                            if ($q->param('mansion_options_ikkai')){
                                if ($tmp{'MANSION_FLOOR'} != 1){next;}
                            }else{next;}
                        }
                    }
                    
                    if ($q->param('mansion_options_ikkai')){
                        if ($tmp{'MANSION_FLOOR'} != 1){next;}
                    }
    
                    if ($q->param('mansion_options_autolock')){
                        if (!$tmp{'MANSION_OPTIONS_AUTOLOCK'}){next;}
                    }
                    if ($q->param('mansion_options_elevator')){
                        if (!$tmp{'MANSION_OPTIONS_ELEVATOR'}){next;}
                    }
                    if ($q->param('mansion_options_tvphone')){
                        if (!$tmp{'MANSION_OPTIONS_ELEVATOR'}){next;}
                    }
                    if ($q->param('mansion_options_parking')){
                        if (!$tmp{'MANSION_OPTIONS_PARKING'}){next;}
                    }
                    if ($q->param('mansion_options_pet')){
                        if (!$tmp{'MANSION_OPTIONS_PET'}){next;}
                    }
                    if ($q->param('mansion_options_kakubeya')){
                        if (!$tmp{'MANSION_OPTIONS_KAKUBEYA'}){next;}
                    }
                    if ($q->param('mansion_options_system_kitchin')){
                        if (!$tmp{'MANSION_OPTIONS_SYSTEM_KITCHIN'}){next;}
                    }
                    if ($q->param('mansion_options_showertoilete')){
                        if (!$tmp{'MANSION_OPTIONS_SHOWERTOILETE'}){next;}
                    }
                    if ($q->param('mansion_options_walkin_closet')){
                        if (!$tmp{'MANSION_OPTIONS_WALKIN_CLOSET'}){next;}
                    }
                    if ($q->param('mansion_options_yukasita_syuunou')){
                        if (!$tmp{'MANSION_OPTIONS_YUKASITA_SYUUNOU'}){next;}
                    }
                    if ($q->param('mansion_options_yukadanbou')){
                        if (!$tmp{'MANSION_OPTIONS_YUKADANBOU'}){next;}
                    }
    
                    if ($q->param('mansion_options_parking_byke')){
                        if (!$tmp{'MANSION_OPTIONS_PARKING_BYKE'}){next;}
                    }
                    if ($q->param('mansion_options_parking_jitensya')){
                        if (!$tmp{'MANSION_OPTIONS_PARKING_JITENSYA'}){next;}
                    }
                    if ($q->param('mansion_options_barukoni')){
                        if (!$tmp{'MANSION_OPTIONS_BARUKONI'}){next;}
                    }
                    if ($q->param('mansion_options_bariafuri')){
                        if (!$tmp{'MANSION_OPTIONS_BARIAFURI'}){next;}
                    }
                    if ($q->param('mansion_options_tosigasu')){
                        if (!$tmp{'MANSION_OPTIONS_TOSIGASU'}){next;}
                    }
                    if ($q->param('mansion_options_senyouniwa')){
                        if (!$tmp{'MANSION_OPTIONS_SENYOUNIWA'}){next;}
                    }

                    #if ($q->param("mansion_address")){
                    #    my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("mansion_address")));
                    #    if (REPS::Util->str_match($tmp{'MANSION_LOCATION'},$search_by_key)){
                    #        $match = 1;
                    #    }else{
                    #        next;
                    #    }
                    #}
                    $test = 0;
                    if ($q->param("mansion_address")){
                        foreach ($q->param("mansion_address")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'MANSION_LOCATION'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'MANSION_LOCATION'},$search_by_key)){
                            #    $test = 1;
                            #    $match = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("mansion_station")){
                        foreach ($q->param("mansion_station")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'MANSION_STATION_1'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }elsif(REPS::Util->str_match($tmp{'MANSION_STATION_2'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'MANSION_STATION_1'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}elsif(REPS::Util->str_match($tmp{'MANSION_STATION_2'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    #if ($q->param("mansion_name")){
                    #    my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("mansion_name")));
                    #    if (REPS::Util->str_match($tmp{'MANSION_NAME'},$search_by_key)){
                    #        $match = 1;
                    #    }else{
                    #        next;
                    #    }
                    #}

                    $test = 0;
                    if ($q->param("mansion_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("mansion_school")));
                        if (REPS::Util->str_match($tmp{'MANSION_SHOUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'MANSION_CYUUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }

                        my $tstr =  join(' ',$tmp{'MANSION_DAIGAKU_LIST'}); 

                        if (REPS::Util->str_match($tstr,$search_by_key)){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }


                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location') || ($sort_by eq 'station')){
                            if ($sort_by eq 'station'){
                                $sort_hash{$key} = $tmp{'MANSION_STATION_1'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'MANSION_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'MANSION_LAST_UPDATED'})&&( $tmp{'MANSION_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'MANSION_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'MANSION_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'MANSION_LOCATION'};
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
            #check if it is over max listing num
    
            $c = @sort_keys;
    
            #my $items_per_page = $self->{_app}->cfg('items_per_page');
            
            #my $of = $q->param("off_set");
    
            if (!$off_set){$off_set=0;}
    
            @sort_keys = splice( @sort_keys , $off_set,$items_per_page);
    
    
    
    #        if ($off_set){
    #            splice( @sort_keys , 0,$off_set); # $of items delete. start with 0
    #            splice( @sort_keys , $items_per_page,$c-$off_set); # delete rest of items. start with offset
    #        }else{
    #if ($c > $items_per_page){
    #            splice( @sort_keys , $items_per_page); #show $of items. delete rest.
    #}
    #        }
    #-->
    
            my $new_off_set = $off_set + $items_per_page;

            foreach (@sort_keys){
                my $ref_hash = $mansion{$_};
                my %tmp = %$ref_hash;
    
                #if ($tmp{'MANSION_BUSWALK_MINUTES_1'}){
                #    $tmp{'MANSION_BUS_MINUTES_1'} = $tmp{'MANSION_BUS_MINUTES_1'}+$tmp{'MANSION_BUSWALK_MINUTES_1'};
                #}
                #if ($tmp{'MANSION_BUSWALK_MINUTES_2'}){
                #    $tmp{'MANSION_BUS_MINUTES_2'} = $tmp{'MANSION_BUS_MINUTES_2'}+$tmp{'MANSION_BUSWALK_MINUTES_2'};
                #}

                my $new = '';
                my $updated = '';
                if ($tmp{'MANSION_CREATED'}){
                    my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'MANSION_CREATED'});
                    if ($dd <= 30) {
                        $new = 'ON';
                    }
                    if ((!$new) && ($tmp{'MANSION_LAST_UPDATED'})){
                        $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'MANSION_LAST_UPDATED'});
                        if ($dd <= 10) {
                            $updated = 'ON';
                        }
                    }
                }


                if ($tmp{'MANSION_BUSWALK_MINUTES_1'}){
                    $tmp{'MANSION_BUS_MINUTES_1'} = $tmp{'MANSION_BUS_MINUTES_1'}+$tmp{'MANSION_BUSWALK_MINUTES_1'};
                }
                if ($tmp{'MANSION_BUSWALK_MINUTES_2'}){
                    $tmp{'MANSION_BUS_MINUTES_2'} = $tmp{'MANSION_BUS_MINUTES_2'}+$tmp{'MANSION_BUSWALK_MINUTES_2'};
                }
                
                if ($tmp{'MANSION_PICS_OUTSIDE'}){
                    $tmp{'MANSION_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_OUTSIDE'};
                }
                if ($tmp{'MANSION_PICS_INSIDE'}){
                    $tmp{'MANSION_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_INSIDE'};
                }
                if ($tmp{'MANSION_PICS_MADORIZU'}){
                    $tmp{'MANSION_PICS_MADORIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_MADORIZU'};
                }
                if ($tmp{'MANSION_PICS_TIZU'}){
                    $tmp{'MANSION_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_TIZU'};
                }
                if ($tmp{'MANSION_PICS_OUTSIDE_THUMB'}){
                    $tmp{'MANSION_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_OUTSIDE_THUMB'};
                }
                if ($tmp{'MANSION_PICS_INSIDE_THUMB'}){
                    $tmp{'MANSION_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_INSIDE_THUMB'};
                }
                if ($tmp{'MANSION_PICS_MADORIZU_THUMB'}){
                    $tmp{'MANSION_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_MADORIZU_THUMB'};
                }
                if ($tmp{'MANSION_PICS_TIZU_THUMB'}){
                    $tmp{'MANSION_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_TIZU_THUMB'};
                }

                my %hash = (
                    'MANSION_ID' => "$_",
                    'MANSION_IS_SPECIAL' => $tmp{'MANSION_IS_SPECIAL'},
                    'MANSION_STATION_1' => $tmp{'MANSION_STATION_1'},
                    'MANSION_STATION_2' => $tmp{'MANSION_STATION_2'},
                    'MANSION_LOCATION' => $tmp{'MANSION_LOCATION'},
                    'MANSION_PRICE' => REPS::Util->insert_comma($tmp{'MANSION_PRICE'}),
                    'MANSION_BUS_MINUTES_1' => $tmp{'MANSION_BUS_MINUTES_1'},
                    'MANSION_WALK_MINUTES_1' => $tmp{'MANSION_WALK_MINUTES_1'},
                    'MANSION_BUSWALK_MINUTES_1' => $tmp{'MANSION_BUSWALK_MINUTES_1'},
                    'MANSION_BUS_MINUTES_2' => $tmp{'MANSION_BUS_MINUTES_2'},
                    'MANSION_WALK_MINUTES_2' => $tmp{'MANSION_WALK_MINUTES_2'},
                    'MANSION_BUSWALK_MINUTES_2' => $tmp{'MANSION_BUSWALK_MINUTES_2'},
                    'MANSION_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'MANSION_PRICE_KANRIHI'}),
    
                        'MANSION_PICS_OUTSIDE' => $tmp{'MANSION_PICS_OUTSIDE'},
                        'MANSION_PICS_INSIDE' => $tmp{'MANSION_PICS_INSIDE'},
                        'MANSION_PICS_MADORIZU' => $tmp{'MANSION_PICS_MADORIZU'},
                        'MANSION_PICS_TIZU' => $tmp{'MANSION_PICS_TIZU'},
            
                        'MANSION_PICS_OUTSIDE_THUMB' => $tmp{'MANSION_PICS_OUTSIDE_THUMB'},
                        'MANSION_PICS_INSIDE_THUMB' => $tmp{'MANSION_PICS_INSIDE_THUMB'},
                        'MANSION_PICS_MADORIZU_THUMB' => $tmp{'MANSION_PICS_MADORIZU_THUMB'},
                        'MANSION_PICS_TIZU_THUMB' => $tmp{'MANSION_PICS_TIZU_THUMB'},

                        'MANSION_BUILDING_STRUCTURE' => $tmp{'MANSION_BUILDING_STRUCTURE'},
                        'MANSION_YOUR_ID' => $tmp{'MANSION_YOUR_ID'},
                        'MANSION_BUS_1' => $tmp{'MANSION_BUS_1'},
                        'MANSION_BUS_2' => $tmp{'MANSION_BUS_2'},
                        'MANSION_AGE' => $tmp{'MANSION_AGE'},
                        'MANSION_BUSWALK_MINUTES_1' => $tmp{'MANSION_BUSWALK_MINUTES_1'},
                        'MANSION_BUSWALK_MINUTES_2' => $tmp{'MANSION_BUSWALK_MINUTES_2'},
                        'MANSION_STORY' => $tmp{'MANSION_STORY'},
                        'MANSION_ADS_TEXT' => $tmp{'MANSION_ADS_TEXT'},

    
                    'MANSION_SQUARE' => $tmp{'MANSION_SQUARE'},
                    'MANSION_MADORI' => $tmp{'MANSION_MADORI'},

                    'MANSION_NEW' => $new,
                    'MANSION_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    'MANSION_CREATED' => REPS::Util->get_date_as_string($tmp{'MANSION_CREATED'}),
                    'MANSION_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'MANSION_LAST_UPDATED'})
                );
        
                push(@loop_data, \%hash);
            }
    #    }
    
        untie %mansion;
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
    my %mansion;
    my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
    tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;

        foreach (@ids){
            if ((defined $mansion{$_}) && ($mansion{$_})){
                my $ref_hash = $mansion{$_};
                my %tmp = %$ref_hash;


                #if ($tmp{'MANSION_BUSWALK_MINUTES_1'}){
                #    $tmp{'MANSION_BUS_MINUTES_1'} = $tmp{'MANSION_BUS_MINUTES_1'}+$tmp{'MANSION_BUSWALK_MINUTES_1'};
                #}
                #if ($tmp{'MANSION_BUSWALK_MINUTES_2'}){
                #    $tmp{'MANSION_BUS_MINUTES_2'} = $tmp{'MANSION_BUS_MINUTES_2'}+$tmp{'MANSION_BUSWALK_MINUTES_2'};
                #}

                my %hash = (
                    'ID' => "$_",
                    #'MANSION_PUBLISHED' => $tmp{'MANSION_PUBLISHED'},
                    'MANSION_STATION_1' => $tmp{'MANSION_STATION_1'},
                    'MANSION_STATION_2' => $tmp{'MANSION_STATION_2'},
                    'MANSION_LOCATION' => $tmp{'MANSION_LOCATION'},
                    'MANSION_PRICE' => REPS::Util->insert_comma($tmp{'MANSION_PRICE'}),
                    'MANSION_BUS_MINUTES_1' => $tmp{'MANSION_BUS_MINUTES_1'},
                    'MANSION_WALK_MINUTES_1' => $tmp{'MANSION_WALK_MINUTES_1'},
                    'MANSION_BUSWALK_MINUTES_1' => $tmp{'MANSION_BUSWALK_MINUTES_1'},
                    'MANSION_BUS_MINUTES_2' => $tmp{'MANSION_BUS_MINUTES_2'},
                    'MANSION_WALK_MINUTES_2' => $tmp{'MANSION_WALK_MINUTES_2'},
                    'MANSION_BUSWALK_MINUTES_2' => $tmp{'MANSION_BUSWALK_MINUTES_2'},

                    'MANSION_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'MANSION_PRICE_KANRIHI'}),

                    'MANSION_SQUARE' => $tmp{'MANSION_SQUARE'},
                    'MANSION_MADORI' => $tmp{'MANSION_MADORI'},

                    'USER_ID' => $tmp{'MANSION_USER_ID'},

                    'MANSION_CREATED' => REPS::Util->get_date_as_string($tmp{'MANSION_CREATED'}),
                    'MANSION_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'MANSION_LAST_UPDATED'})
    ##                'MANSION_VIEW_ONLY' => $tmp{'MANSION_VIEW_ONLY'}
                );
        
                push(@loop_data, \%hash);
            }
        }
    untie %mansion;

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
    #my $tmp_company_info = $Settings->get_settings_to_be_displayed();

    my %mansion;
    my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
    if(-f $db_mansion_path){
        tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;
        #
        my $tmp_company_info;
        my $usr_company_info;
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            #get users company info
            my @usr_ids;
            foreach (@ids){
                if ($mansion{$_}){
                    push (@usr_ids, $mansion{$_}{'MANSION_USER_ID'});
                }
            }
            $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
        }else{
            $tmp_company_info = $Settings->get_settings_to_be_displayed();
        }

        foreach (@ids){
            if (defined $mansion{$_}){
                
                $value = $mansion{$_};
                my %tmp = %$value;
                if (exists $tmp{'MANSION_ID'}){
                    if (($_ eq $tmp{'MANSION_ID'} ) && ($tmp{'MANSION_PUBLISHED'})){
                        push (@id_to_be_logged,$_);
    
                        #if ($tmp{'MANSION_BUSWALK_MINUTES_1'}){
                        #    $tmp{'MANSION_BUS_MINUTES_1'} = $tmp{'MANSION_BUS_MINUTES_1'}+$tmp{'MANSION_BUSWALK_MINUTES_1'};
                        #}
                        #if ($tmp{'MANSION_BUSWALK_MINUTES_2'}){
                        #    $tmp{'MANSION_BUS_MINUTES_2'} = $tmp{'MANSION_BUS_MINUTES_2'}+$tmp{'MANSION_BUSWALK_MINUTES_2'};
                        #}
                        
                        if ($tmp{'MANSION_PICS_OUTSIDE'}){
                            $tmp{'MANSION_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_OUTSIDE'};
                        }
                        if ($tmp{'MANSION_PICS_INSIDE'}){
                            $tmp{'MANSION_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_INSIDE'};
                        }
                        if ($tmp{'MANSION_PICS_MADORIZU'}){
                            $tmp{'MANSION_PICS_MADORIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_MADORIZU'};
                        }
                        if ($tmp{'MANSION_PICS_TIZU'}){
                            $tmp{'MANSION_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_TIZU'};
                        }
                        if ($tmp{'MANSION_PICS_OUTSIDE_THUMB'}){
                            $tmp{'MANSION_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_OUTSIDE_THUMB'};
                        }
                        if ($tmp{'MANSION_PICS_INSIDE_THUMB'}){
                            $tmp{'MANSION_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_INSIDE_THUMB'};
                        }
                        if ($tmp{'MANSION_PICS_MADORIZU_THUMB'}){
                            $tmp{'MANSION_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_MADORIZU_THUMB'};
                        }
                        if ($tmp{'MANSION_PICS_TIZU_THUMB'}){
                            $tmp{'MANSION_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'MANSION_PICS_TIZU_THUMB'};
                        }
                        require Unicode::Japanese;
                        my $UJ = Unicode::Japanese->new;
                        my $str = $UJ->set($tmp{'MANSION_LOCATION'},'euc')->utf8;
                        $str =~ s/(\W)/sprintf("%%%02X",unpack("C",$1))/eg;
                        #
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            $tmp_company_info = $$usr_company_info{$tmp{'MANSION_USER_ID'}};
                        }    

                        my %hash = (
    
                            'MANSION_ID' => "$_",
                            'MANSION_IS_SPECIAL' => $tmp{'MANSION_IS_SPECIAL'},
                            'MANSION_STATION_1' => $tmp{'MANSION_STATION_1'},
                            'MANSION_LOCATION' => $tmp{'MANSION_LOCATION'},
                            'MANSION_LOCATION_URLENCODED' => $str,
            
                            'MANSION_PRICE' => REPS::Util->insert_comma($tmp{'MANSION_PRICE'}),
                            'MANSION_PRICE_TAX_INC' => $tmp{'MANSION_PRICE_TAX_INC'},

                            'MANSION_BUS_1' => $tmp{'MANSION_BUS_1'},
                            'MANSION_BUS_MINUTES_1' => $tmp{'MANSION_BUS_MINUTES_1'},
                            'MANSION_WALK_MINUTES_1' => $tmp{'MANSION_WALK_MINUTES_1'},
                            'MANSION_BUSWALK_MINUTES_1' => $tmp{'MANSION_BUSWALK_MINUTES_1'},
            
                            'MANSION_PRICE_KANRIHI' => REPS::Util->insert_comma($tmp{'MANSION_PRICE_KANRIHI'}),
            
                            'MANSION_SQUARE' => $tmp{'MANSION_SQUARE'},
                            'MANSION_SQUARE_TEXT' => $tmp{'MANSION_SQUARE_TEXT'},
                            'MANSION_SQUARE_TUBO' => $tmp{'MANSION_SQUARE_TUBO'},
            
                            'MANSION_MADORI' => $tmp{'MANSION_MADORI'},
                            'MANSION_MADORI_DETAIL' => $tmp{'MANSION_MADORI_DETAIL'},
            
                            'MANSION_STATION_2' => $tmp{'MANSION_STATION_2'},
                            'MANSION_BUS_2' => $tmp{'MANSION_BUS_2'},
                            'MANSION_BUS_MINUTES_2' => $tmp{'MANSION_BUS_MINUTES_2'},
                            'MANSION_WALK_MINUTES_2' => $tmp{'MANSION_WALK_MINUTES_2'},
                            'MANSION_BUSWALK_MINUTES_2' => $tmp{'MANSION_BUSWALK_MINUTES_2'},

                            'MANSION_SOUKOSUU' => $tmp{'MANSION_SOUKOSUU'},
                            'MANSION_SYUYOUSAIKOUMEN' => $tmp{'MANSION_SYUYOUSAIKOUMEN'},
                            'MANSION_BARUKONI_SQUARE' => $tmp{'MANSION_BARUKONI_SQUARE'},
                            'MANSION_BARUKONI_SQUARE_TUBO' => $tmp{'MANSION_BARUKONI_SQUARE_TUBO'},
                            'MANSION_CHUSYAJYOU' => $tmp{'MANSION_CHUSYAJYOU'},
                            'MANSION_GAISOU_AGE' => $tmp{'MANSION_GAISOU_AGE'},
                            'MANSION_KENRI' => $tmp{'MANSION_KENRI'},
                            'MANSION_SYUUZENTUMITATEKIN' => REPS::Util->insert_comma($tmp{'MANSION_SYUUZENTUMITATEKIN'}),
            
                            #'MANSION_TIMOKU' => $tmp{'MANSION_TIMOKU'},
                            'MANSION_TISEI' => $tmp{'MANSION_TISEI'},
                            'MANSION_YOUTOTIIKI' => $tmp{'MANSION_YOUTOTIIKI'},
                            'MANSION_GENKYOU' => $tmp{'MANSION_GENKYOU'},
            
                            'MANSION_HIKIWATASI' => $tmp{'MANSION_HIKIWATASI'},
                            'MANSION_BIKOU' => $tmp{'MANSION_BIKOU'},
            
                            'MANSION_BUILDING_STRUCTURE' => $tmp{'MANSION_BUILDING_STRUCTURE'},
                            'MANSION_STORY' => $tmp{'MANSION_STORY'},
                            'MANSION_FLOOR' => $tmp{'MANSION_FLOOR'},
                                                    'MANSION_AGE' => $tmp{'MANSION_AGE'},
                            'MANSION_JYOUKEN' => $tmp{'MANSION_JYOUKEN'},
                    
                            'MANSION_OPTIONS_KAKUBEYA' => $tmp{'MANSION_OPTIONS_KAKUBEYA'},
                            'MANSION_OPTIONS_AUTOLOCK' => $tmp{'MANSION_OPTIONS_AUTOLOCK'},
                            'MANSION_OPTIONS_ELEVATOR' => $tmp{'MANSION_OPTIONS_ELEVATOR'},
                            'MANSION_OPTIONS_TVPHONE' => $tmp{'MANSION_OPTIONS_TVPHONE'},
                                                    'MANSION_OPTIONS_SYSTEM_KITCHIN' => $tmp{'MANSION_OPTIONS_SYSTEM_KITCHIN'},
                            'MANSION_OPTIONS_SHOWERTOILETE' => $tmp{'MANSION_OPTIONS_SHOWERTOILETE'},
                            'MANSION_OPTIONS_WALKIN_CLOSET' => $tmp{'MANSION_OPTIONS_WALKIN_CLOSET'},
                            'MANSION_OPTIONS_YUKASITA_SYUUNOU' => $tmp{'MANSION_OPTIONS_YUKASITA_SYUUNOU'},
                            'MANSION_OPTIONS_YUKADANBOU' => $tmp{'MANSION_OPTIONS_YUKADANBOU'},
                            'MANSION_OPTIONS_SENYOUNIWA' => $tmp{'MANSION_OPTIONS_SENYOUNIWA'},
                            'MANSION_OPTIONS_PARKING' => $tmp{'MANSION_OPTIONS_PARKING'},
                            'MANSION_OPTIONS_PARKING_BYKE' => $tmp{'MANSION_OPTIONS_PARKING_BYKE'},
                            'MANSION_OPTIONS_PARKING_JITENSYA' => $tmp{'MANSION_OPTIONS_PARKING_JITENSYA'},
                            'MANSION_OPTIONS_BARUKONI' => $tmp{'MANSION_OPTIONS_BARUKONI'},
                            'MANSION_OPTIONS_BARIAFURI' => $tmp{'MANSION_OPTIONS_BARIAFURI'},
                            'MANSION_OPTIONS_TOSIGASU' => $tmp{'MANSION_OPTIONS_TOSIGASU'},
                            'MANSION_OPTIONS_PET' => $tmp{'MANSION_OPTIONS_PET'},

                            'MANSION_TORIHIKITAIYOU' => $tmp{'MANSION_TORIHIKITAIYOU'},
                            'MANSION_ADS_TEXT' => $tmp{'MANSION_ADS_TEXT'},
                            'MANSION_SETUBI' => $tmp{'MANSION_SETUBI'},
                    
                            'MANSION_PICS_OUTSIDE' => $tmp{'MANSION_PICS_OUTSIDE'},
                            'MANSION_PICS_INSIDE' => $tmp{'MANSION_PICS_INSIDE'},
                            'MANSION_PICS_MADORIZU' => $tmp{'MANSION_PICS_MADORIZU'},
                            'MANSION_PICS_TIZU' => $tmp{'MANSION_PICS_TIZU'},
                
                            'MANSION_PICS_OUTSIDE_THUMB' => $tmp{'MANSION_PICS_OUTSIDE_THUMB'},
                            'MANSION_PICS_INSIDE_THUMB' => $tmp{'MANSION_PICS_INSIDE_THUMB'},
                            'MANSION_PICS_MADORIZU_THUMB' => $tmp{'MANSION_PICS_MADORIZU_THUMB'},
                            'MANSION_PICS_TIZU_THUMB' => $tmp{'MANSION_PICS_TIZU_THUMB'},
                    
                            'MANSION_MOVIE_FILE_URL' => $tmp{'MANSION_MOVIE_FILE_URL'},

                            'MANSION_YOUR_ID' => $tmp{'MANSION_YOUR_ID'},

                            'MANSION_COMPANY_NAME' => $$tmp_company_info{'COMPANY_NAME'},
                            'MANSION_COMPANY_TEL' => $$tmp_company_info{'COMPANY_TEL'},
                            'MANSION_COMPANY_ADDRESS' => $$tmp_company_info{'COMPANY_ADDRESS'},
                            'MANSION_COMPANY_LICENSE' => $$tmp_company_info{'COMPANY_LICENSE'},
                            'MANSION_COMPANY_HP' => $$tmp_company_info{'COMPANY_HP'},
                
                            'MANSION_CREATED' => REPS::Util->get_date_as_string($tmp{'MANSION_CREATED'}),
                            'MANSION_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'MANSION_LAST_UPDATED'}),
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
            my $db_access_path = $self->{_app}->param('db_b_mansion_access_path');
            tie (%access, 'MLDBM', $db_access_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
            foreach (@id_to_be_logged){
                my $ref_access_tmp;
                $ref_access_tmp = $access{$_};
                $$ref_access_tmp{'COUNT'} = $access{$_}{'COUNT'}+1;
                $$ref_access_tmp{'USER_ID'} = $mansion{$_}{'MANSION_USER_ID'};
    
                $access{$_} =  $ref_access_tmp;
                #$access{$_}++;
            }
            untie %access;
    
        }
        untie %mansion;
    }
    return \@loop_data;

}

sub log_Inquiry{
    my $self = shift;
    my @ids = @_;

    if ($self->{_app}->param('user_logged_in') != 1){
        my %mansion;
        my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
        tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        my %inquiry;
        my $db_inquiry_path = $self->{_app}->param('db_b_mansion_inquiry_path');
        tie (%inquiry, 'MLDBM', $db_inquiry_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
        foreach (@ids){
            my $ref_access_tmp;
            $ref_access_tmp = $inquiry{$_};
            $$ref_access_tmp{'COUNT'} = $inquiry{$_}{'COUNT'}+1;
            $$ref_access_tmp{'USER_ID'} = $mansion{$_}{'LAND_USER_ID'};

            $inquiry{$_} =  $ref_access_tmp;
            #$inquiry{$_}++;
        }
        untie %inquiry;

        untie %mansion;
    }
}



















1
