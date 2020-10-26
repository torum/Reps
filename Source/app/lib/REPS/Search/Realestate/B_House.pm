package REPS::Search::Realestate::B_House;

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
            'HOUSE_CHUSYAJYOU' => '',
            'HOUSE_SETUDOUJYOUKYOU' => '',
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
            'HOUSE_TOSIKEIKAKU' => '',#+
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
            'HOUSE_OPTIONS_PARKING_BYKE' => '',
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
            'HOUSE_USER_ID' => $app->param('user_id'),,
            'HOUSE_CREATED' => '',
            'HOUSE_LAST_UPDATED' => '',

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

    my %house;
    my $db_house_path = $self->{_app}->param('db_b_house_path');
    if(-f $db_house_path){
        tie (%house, 'MLDBM', $db_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;
    
        while ( ($key, $value) = each(%house) ) {
            if ((exists $house{$key}) && (defined $house{$key}) && ($value)){
            #if (defined $house{$key}){
                my %tmp = %$value;
                if (exists $tmp{'HOUSE_USER_ID'}){
                    #match?
                    $match = 0;
    
    
                        if ($tmp{'HOUSE_PUBLISHED'}){
                            $match = 1;
                        }else{
                            next;
                        }
    
                    if ($q->param('house_options_sintiku')){
                        if (!$tmp{'HOUSE_OPTIONS_SINTIKU'}){next;}
                    }
    

#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("land_price_l")){
    $q->param("land_price_1"=>$q->param("land_price_l"));
}
                    if ($q->param("house_price_1") || $q->param("house_price_2")){
                        if ($q->param("house_price_1") && $q->param("house_price_2")){
        
                            if (($tmp{'HOUSE_PRICE'} >= ($q->param("house_price_1"))) && ($tmp{'HOUSE_PRICE'} <= ($q->param("house_price_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_price_2")){
                            if ($tmp{'HOUSE_PRICE'} <= ($q->param("house_price_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_price_1")){
                            if ($tmp{'HOUSE_PRICE'} >= ($q->param("house_price_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }
#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("land_price_l")){
    $q->delete('land_price_l');
}
    
                    if ($q->param("house_square_1") || $q->param("house_square_2")){
                        if (($q->param("house_square_1") && $q->param("house_square_2"))){
                            if (($tmp{'HOUSE_BUILDING_SQUARE'} >= ($q->param("house_square_1"))) && ($tmp{'HOUSE_BUILDING_SQUARE'} <= ($q->param("house_square_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_square_2")){
                            if ($tmp{'HOUSE_BUILDING_SQUARE'} <= ($q->param("house_square_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_square_1")){
                            if ($tmp{'HOUSE_BUILDING_SQUARE'} >= ($q->param("house_square_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }
    
    
    
                    #if ($q->param("house_walk_minutes")){
                    #    if (!$tmp{'HOUSE_WALK_MINUTES_1'}){next;}
                    #    if ($tmp{'HOUSE_WALK_MINUTES_1'} <= $q->param("house_walk_minutes")){
                    #        $match = 1;
                    #    }else{next;}
                    #}

                    my $test = 0;
                    if ($q->param("house_walk_minutes")){
                        if ($tmp{'HOUSE_WALK_MINUTES_1'}){
                            if ($tmp{'HOUSE_WALK_MINUTES_1'} <= $q->param("house_walk_minutes")){
                                $test = 1;
                            }
                        }
                        if ($tmp{'HOUSE_WALK_MINUTES_2'}){
                            if ($tmp{'HOUSE_WALK_MINUTES_2'} <= $q->param("house_walk_minutes")){
                                $test = 1;
                            }
                        }
                        next unless ($test);
                    }

    
                    $test = 0;
                    if ($q->param("house_has_")){
                        my @house_has;
                        foreach ($q->param("house_has_")){
                            push (@house_has,split(',',$_));
                        }
                        foreach (@house_has){
                            if ($_ == 1){
                                if ($tmp{'HOUSE_PICS_MADORIZU'}){$test=1;}else{$test=0;last;}
                        
                            }
                            if ($_ == 2){
                                if ($tmp{'HOUSE_PICS_OUTSIDE'} || $tmp{'HOUSE_PICS_INSIDE'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 3){
                                if ($tmp{'HOUSE_MOVIE_FILE_URL'}){$test=1;}else{$test=0;last;}
                        
                            }
                        }
                        next unless ($test);
                    }
    
                    
    
                    if ($q->param("house_age")){
                        if ((exists $tmp{'HOUSE_AGE'})&&(defined $tmp{'HOUSE_AGE'})){
                            if ($tmp{'HOUSE_AGE'} ne ''){
                                if (REPS::Util->get_date_delta($tmp{'HOUSE_AGE'}.'/01') <= ($q->param("house_age")*365)){
                                    $match = 1;
                                }else{next;}
                            }else{next;}
                        }else{
                            next;
                        }
                    }
                    if ($q->param("house_options_sintiku")){
                        if (!$tmp{'HOUSE_OPTIONS_SINTIKU'}){next;}
                    }
    
                    if ($q->param('house_options_parking')){
                        if (!$tmp{'HOUSE_OPTIONS_PARKING'}){next;}
                    }
    
    
                    if ($q->param('house_options_system_kitchin')){
                        if (!$tmp{'HOUSE_OPTIONS_SYSTEM_KITCHIN'}){next;}
                    }
                    if ($q->param('house_options_showertoilete')){
                        if (!$tmp{'HOUSE_OPTIONS_SHOWERTOILETE'}){next;}
                    }
                    if ($q->param('house_options_walkin_closet')){
                        if (!$tmp{'HOUSE_OPTIONS_WALKIN_CLOSET'}){next;}
                    }
                    if ($q->param('house_options_yukasita_syuunou')){
                        if (!$tmp{'HOUSE_OPTIONS_YUKASITA_SYUUNOU'}){next;}
                    }
                    if ($q->param('house_options_yukadanbou')){
                        if (!$tmp{'HOUSE_OPTIONS_YUKADANBOU'}){next;}
                    }
    
    
                    if ($q->param('house_options_bariafuri')){
                        if (!$tmp{'HOUSE_OPTIONS_BARIAFURI'}){next;}
                    }
                    if ($q->param('house_options_tosigasu')){
                        if (!$tmp{'HOUSE_OPTIONS_TOSIGASU'}){next;}
                    }

                    $test = 0;
                    if ($q->param("house_address")){
                        foreach ($q->param("house_address")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'HOUSE_LOCATION'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'HOUSE_LOCATION'},$search_by_key)){
                            #    $test = 1;
                            #    $match = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("house_station")){
                        foreach ($q->param("house_station")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'HOUSE_STATION_1'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }elsif(REPS::Util->str_match($tmp{'HOUSE_STATION_2'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'HOUSE_STATION_1'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}elsif(REPS::Util->str_match($tmp{'HOUSE_STATION_2'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}
                        }
                        next unless ($test);
                    }

                    $test = 0;
                    if ($q->param("house_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("house_school")));
                        if (REPS::Util->str_match($tmp{'HOUSE_SHOUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'HOUSE_CYUUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
    
                        my $tstr =  join(' ',$tmp{'HOUSE_DAIGAKU_LIST'}); 
    
                        if (REPS::Util->str_match($tstr,$search_by_key)){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }



                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location') || ($sort_by eq 'station')){
                            if ($sort_by eq 'station'){
                                $sort_hash{$key} = $tmp{'HOUSE_STATION_1'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'HOUSE_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'HOUSE_LAST_UPDATED'})&&( $tmp{'HOUSE_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'HOUSE_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'HOUSE_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'HOUSE_LOCATION'};
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

    
            my $new_off_set = $off_set + $items_per_page;
    
    
    
            foreach (@sort_keys){
                my $ref_hash = $house{$_};
                my %tmp = %$ref_hash;
    
    
                #if ($tmp{'HOUSE_BUSWALK_MINUTES_1'}){
                #    $tmp{'HOUSE_BUS_MINUTES_1'} = $tmp{'HOUSE_BUS_MINUTES_1'}+$tmp{'HOUSE_BUSWALK_MINUTES_1'};
                #}
                #if ($tmp{'HOUSE_BUSWALK_MINUTES_2'}){
                #    $tmp{'HOUSE_BUS_MINUTES_2'} = $tmp{'HOUSE_BUS_MINUTES_2'}+$tmp{'HOUSE_BUSWALK_MINUTES_2'};
                #}

                my $new = '';
                my $updated = '';
                if ($tmp{'HOUSE_CREATED'}){
                    my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'HOUSE_CREATED'});
                    if ($dd <= 30) {
                        $new = 'ON';
                    }
                    if ((!$new) && ($tmp{'HOUSE_LAST_UPDATED'})){
                        $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'HOUSE_LAST_UPDATED'});
                        if ($dd <= 10) {
                            $updated = 'ON';
                        }
                    }
                }

                if ($tmp{'HOUSE_PICS_OUTSIDE'}){
                    $tmp{'HOUSE_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_OUTSIDE'};
                }
                if ($tmp{'HOUSE_PICS_INSIDE'}){
                    $tmp{'HOUSE_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_INSIDE'};
                }
                if ($tmp{'HOUSE_PICS_MADORIZU'}){
                    $tmp{'HOUSE_PICS_MADORIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_MADORIZU'};
                }
                
                if ($tmp{'HOUSE_PICS_OUTSIDE_THUMB'}){
                    $tmp{'HOUSE_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_OUTSIDE_THUMB'};
                }
                if ($tmp{'HOUSE_PICS_INSIDE_THUMB'}){
                    $tmp{'HOUSE_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_INSIDE_THUMB'};
                }
                if ($tmp{'HOUSE_PICS_MADORIZU_THUMB'}){
                    $tmp{'HOUSE_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_MADORIZU_THUMB'};
                }

                if ($tmp{'HOUSE_PICS_TIZU'}){
                    $tmp{'HOUSE_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_TIZU'};
                }
                if ($tmp{'HOUSE_PICS_TIZU_THUMB'}){
                    $tmp{'HOUSE_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_TIZU_THUMB'};
                }

                my %hash = (
                    'HOUSE_ID' => "$_",
                    'HOUSE_IS_SPECIAL' => $tmp{'HOUSE_IS_SPECIAL'},
                    'HOUSE_STATION_1' => $tmp{'HOUSE_STATION_1'},
                    'HOUSE_STATION_2' => $tmp{'HOUSE_STATION_2'},
                    'HOUSE_LOCATION' => $tmp{'HOUSE_LOCATION'},
                    'HOUSE_PRICE' => REPS::Util->insert_comma($tmp{'HOUSE_PRICE'}),
                    'HOUSE_BUS_MINUTES_1' => $tmp{'HOUSE_BUS_MINUTES_1'},
                    'HOUSE_WALK_MINUTES_1' => $tmp{'HOUSE_WALK_MINUTES_1'},
                    'HOUSE_BUSWALK_MINUTES_1' => $tmp{'HOUSE_BUSWALK_MINUTES_1'},
                    'HOUSE_BUS_MINUTES_2' => $tmp{'HOUSE_BUS_MINUTES_2'},
                    'HOUSE_WALK_MINUTES_2' => $tmp{'HOUSE_WALK_MINUTES_2'},
                    'HOUSE_BUSWALK_MINUTES_2' => $tmp{'HOUSE_BUSWALK_MINUTES_2'},
                    'HOUSE_BUILDING_SQUARE' => $tmp{'HOUSE_BUILDING_SQUARE'},
                    'HOUSE_TOTI_SQUARE' => $tmp{'HOUSE_TOTI_SQUARE'},
                    'HOUSE_MADORI' => $tmp{'HOUSE_MADORI'},
    
                        'HOUSE_PICS_OUTSIDE' => $tmp{'HOUSE_PICS_OUTSIDE'},
                        'HOUSE_PICS_INSIDE' => $tmp{'HOUSE_PICS_INSIDE'},
                        'HOUSE_PICS_MADORIZU' => $tmp{'HOUSE_PICS_MADORIZU'},
                        'HOUSE_PICS_TIZU' => $tmp{'HOUSE_PICS_TIZU'},
           
                        'HOUSE_PICS_OUTSIDE_THUMB' => $tmp{'HOUSE_PICS_OUTSIDE_THUMB'},
                        'HOUSE_PICS_INSIDE_THUMB' => $tmp{'HOUSE_PICS_INSIDE_THUMB'},
                        'HOUSE_PICS_MADORIZU_THUMB' => $tmp{'HOUSE_PICS_MADORIZU_THUMB'},
                        'HOUSE_PICS_TIZU_THUMB' => $tmp{'HOUSE_PICS_TIZU_THUMB'},

                        'HOUSE_BUILDING_STRUCTURE' => $tmp{'HOUSE_BUILDING_STRUCTURE'},
                        'HOUSE_YOUR_ID' => $tmp{'HOUSE_YOUR_ID'},
                        'HOUSE_BUS_1' => $tmp{'HOUSE_BUS_1'},
                        'HOUSE_BUS_2' => $tmp{'HOUSE_BUS_2'},
                        'HOUSE_AGE' => $tmp{'HOUSE_AGE'},
                        'HOUSE_BUSWALK_MINUTES_1' => $tmp{'HOUSE_BUSWALK_MINUTES_1'},
                        'HOUSE_BUSWALK_MINUTES_2' => $tmp{'HOUSE_BUSWALK_MINUTES_2'},
                        'HOUSE_SYAKUTIKIKAN' => $tmp{'HOUSE_SYAKUTIKIKAN'},
                        'HOUSE_ADS_TEXT' => $tmp{'HOUSE_ADS_TEXT'},
                        

                    'HOUSE_NEW' => $new,
                    'HOUSE_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    'HOUSE_CREATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_CREATED'}),
                    'HOUSE_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_LAST_UPDATED'})
    ##                'HOUSE_VIEW_ONLY' => $tmp{'HOUSE_VIEW_ONLY'}
                );
        
                push(@loop_data, \%hash);
            }
    #    }
    
        untie %house;
    }



    $Search->{'ref_result_loop'} = \@loop_data;
    $Search->{'count_result'} = $c;

    return 1;


}

sub get_Simple_List{
    my $self = shift;
    my @ids = @_;
    my @loop_data =();
    my %house;
    my $db_house_path = $self->{_app}->param('db_b_house_path');
    tie (%house, 'MLDBM', $db_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;

        foreach (@ids){
            if ((defined $house{$_}) && ($house{$_})){
                my $ref_hash = $house{$_};
                my %tmp = %$ref_hash;


                #if ($tmp{'HOUSE_BUSWALK_MINUTES_1'}){
                #    $tmp{'HOUSE_BUS_MINUTES_1'} = $tmp{'HOUSE_BUS_MINUTES_1'}+$tmp{'HOUSE_BUSWALK_MINUTES_1'};
                #}
                #if ($tmp{'HOUSE_BUSWALK_MINUTES_2'}){
                #    $tmp{'HOUSE_BUS_MINUTES_2'} = $tmp{'HOUSE_BUS_MINUTES_2'}+$tmp{'HOUSE_BUSWALK_MINUTES_2'};
                #}

                my %hash = (
                    'ID' => "$_",
                    #'HOUSE_PUBLISHED' => $tmp{'HOUSE_PUBLISHED'},
                    'HOUSE_STATION_1' => $tmp{'HOUSE_STATION_1'},
                    'HOUSE_STATION_2' => $tmp{'HOUSE_STATION_2'},
                    'HOUSE_LOCATION' => $tmp{'HOUSE_LOCATION'},
                    'HOUSE_PRICE' => REPS::Util->insert_comma($tmp{'HOUSE_PRICE'}),
                    'HOUSE_BUS_MINUTES_1' => $tmp{'HOUSE_BUS_MINUTES_1'},
                    'HOUSE_WALK_MINUTES_1' => $tmp{'HOUSE_WALK_MINUTES_1'},
                    'HOUSE_BUSWALK_MINUTES_1' => $tmp{'HOUSE_BUSWALK_MINUTES_1'},
                    'HOUSE_BUS_MINUTES_2' => $tmp{'HOUSE_BUS_MINUTES_2'},
                    'HOUSE_WALK_MINUTES_2' => $tmp{'HOUSE_WALK_MINUTES_2'},
                    'HOUSE_BUSWALK_MINUTES_2' => $tmp{'HOUSE_BUSWALK_MINUTES_2'},
                    #'HOUSE_PRICE_KANRIHI' => &_insert_comma($tmp{'HOUSE_PRICE_KANRIHI'}),

                    'HOUSE_BUILDING_SQUARE' => $tmp{'HOUSE_BUILDING_SQUARE'},
                    'HOUSE_TOTI_SQUARE' => $tmp{'HOUSE_TOTI_SQUARE'},
                    'HOUSE_MADORI' => $tmp{'HOUSE_MADORI'},

                    'USER_ID' => $tmp{'HOUSE_USER_ID'},

                    'HOUSE_CREATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_CREATED'}),
                    'HOUSE_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_LAST_UPDATED'})

                );
        
                push(@loop_data, \%hash);
            }
        }
    untie %house;

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

    my %house;
    my $db_house_path = $self->{_app}->param('db_b_house_path');
    if(-f $db_house_path){
        tie (%house, 'MLDBM', $db_house_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;
        #
        my $tmp_company_info;
        my $usr_company_info;
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            #get users company info
            my @usr_ids;
            foreach (@ids){
                if ($house{$_}){
                    push (@usr_ids, $house{$_}{'HOUSE_USER_ID'});
                }
            }
            $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
        }else{
            $tmp_company_info = $Settings->get_settings_to_be_displayed();
        }

        foreach (@ids){
            if (defined $house{$_}){
                
                $value = $house{$_};
                my %tmp = %$value;
                if (exists $tmp{'HOUSE_ID'}){
                    if (($_ eq $tmp{'HOUSE_ID'} ) && ($tmp{'HOUSE_PUBLISHED'})){
                        push (@id_to_be_logged,$_);
    
                        #if ($tmp{'HOUSE_BUSWALK_MINUTES_1'}){
                        #    $tmp{'HOUSE_BUS_MINUTES_1'} = $tmp{'HOUSE_BUS_MINUTES_1'}+$tmp{'HOUSE_BUSWALK_MINUTES_1'};
                        #}
                        #if ($tmp{'HOUSE_BUSWALK_MINUTES_2'}){
                        #    $tmp{'HOUSE_BUS_MINUTES_2'} = $tmp{'HOUSE_BUS_MINUTES_2'}+$tmp{'HOUSE_BUSWALK_MINUTES_2'};
                        #}
                        
                        if ($tmp{'HOUSE_PICS_OUTSIDE'}){
                            $tmp{'HOUSE_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_OUTSIDE'};
                        }
                        if ($tmp{'HOUSE_PICS_INSIDE'}){
                            $tmp{'HOUSE_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_INSIDE'};
                        }
                        if ($tmp{'HOUSE_PICS_MADORIZU'}){
                            $tmp{'HOUSE_PICS_MADORIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_MADORIZU'};
                        }
                        
                        if ($tmp{'HOUSE_PICS_OUTSIDE_THUMB'}){
                            $tmp{'HOUSE_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_OUTSIDE_THUMB'};
                        }
                        if ($tmp{'HOUSE_PICS_INSIDE_THUMB'}){
                            $tmp{'HOUSE_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_INSIDE_THUMB'};
                        }
                        if ($tmp{'HOUSE_PICS_MADORIZU_THUMB'}){
                            $tmp{'HOUSE_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_MADORIZU_THUMB'};
                        }

                        if ($tmp{'HOUSE_PICS_TIZU'}){
                            $tmp{'HOUSE_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_TIZU'};
                        }
                        if ($tmp{'HOUSE_PICS_TIZU_THUMB'}){
                            $tmp{'HOUSE_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'HOUSE_PICS_TIZU_THUMB'};
                        }
                        require Unicode::Japanese;
                        my $UJ = Unicode::Japanese->new;
                        my $str = $UJ->set($tmp{'HOUSE_LOCATION'},'euc')->utf8;
                        $str =~ s/(\W)/sprintf("%%%02X",unpack("C",$1))/eg;
                        #
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            $tmp_company_info = $$usr_company_info{$tmp{'HOUSE_USER_ID'}};
                        }
    
                        my %hash = (
    
                            'HOUSE_ID' => "$_",
                            'HOUSE_IS_SPECIAL' => $tmp{'HOUSE_IS_SPECIAL'},
                            'HOUSE_STATION_1' => $tmp{'HOUSE_STATION_1'},
                            'HOUSE_LOCATION' => $tmp{'HOUSE_LOCATION'},
                            'HOUSE_LOCATION_URLENCODED' => $str,

                            'HOUSE_PRICE' => REPS::Util->insert_comma($tmp{'HOUSE_PRICE'}),
                            'HOUSE_PRICE_TAX_INC' => $tmp{'HOUSE_PRICE_TAX_INC'},

                            'HOUSE_BUS_1' => $tmp{'HOUSE_BUS_1'},
                            'HOUSE_BUS_MINUTES_1' => $tmp{'HOUSE_BUS_MINUTES_1'},
                            'HOUSE_WALK_MINUTES_1' => $tmp{'HOUSE_WALK_MINUTES_1'},
                            'HOUSE_BUSWALK_MINUTES_1' => $tmp{'HOUSE_BUSWALK_MINUTES_1'},
                
                            'HOUSE_BUILDING_SQUARE' => $tmp{'HOUSE_BUILDING_SQUARE'},
                            'HOUSE_TOTI_SQUARE' => $tmp{'HOUSE_TOTI_SQUARE'},
                            'HOUSE_TOTI_SQUARE_TEXT' => $tmp{'HOUSE_TOTI_SQUARE_TEXT'},
                            'HOUSE_TOTI_SQUARE_TUBO' => $tmp{'HOUSE_TOTI_SQUARE_TUBO'},
                
                            'HOUSE_MADORI' => $tmp{'HOUSE_MADORI'},
                            'HOUSE_MADORI_DETAIL' => $tmp{'HOUSE_MADORI_DETAIL'},
            
                            'HOUSE_STATION_2' => $tmp{'HOUSE_STATION_2'},
                            'HOUSE_BUS_2' => $tmp{'HOUSE_BUS_2'},
                            'HOUSE_BUS_MINUTES_2' => $tmp{'HOUSE_BUS_MINUTES_2'},
                            'HOUSE_WALK_MINUTES_2' => $tmp{'HOUSE_WALK_MINUTES_2'},
                            'HOUSE_BUSWALK_MINUTES_2' => $tmp{'HOUSE_BUSWALK_MINUTES_2'},

                            'HOUSE_CHUSYAJYOU' => $tmp{'HOUSE_CHUSYAJYOU'},
                            'HOUSE_TOTIKENRI' => $tmp{'HOUSE_TOTIKENRI'},
            
                            'HOUSE_TIMOKU' => $tmp{'HOUSE_TIMOKU'},
                            'HOUSE_TISEI' => $tmp{'HOUSE_TISEI'},
                            'HOUSE_YOUTOTIIKI' => $tmp{'HOUSE_YOUTOTIIKI'},
                            'HOUSE_GENKYOU' => $tmp{'HOUSE_GENKYOU'},
            
                            'HOUSE_HIKIWATASI' => $tmp{'HOUSE_HIKIWATASI'},
                            'HOUSE_BIKOU' => $tmp{'HOUSE_BIKOU'},
            
                            'HOUSE_SETUDOUJYOUKYOU' => $tmp{'HOUSE_SETUDOUJYOUKYOU'},
                
                            'HOUSE_SYAKUTIRYOU' => $tmp{'HOUSE_SYAKUTIRYOU'},
                            'HOUSE_SYAKUTIKIKAN' => $tmp{'HOUSE_SYAKUTIKIKAN'},
                            'HOUSE_SETBACK' => $tmp{'HOUSE_SETBACK'},
                            'HOUSE_SIDOUFUTAN_SQUARE' => $tmp{'HOUSE_SIDOUFUTAN_SQUARE'},
                
                            'HOUSE_KENPEIRITU' => $tmp{'HOUSE_KENPEIRITU'},
                            'HOUSE_YOUSEKIRITU'=> $tmp{'HOUSE_YOUSEKIRITU'},
                            'HOUSE_TOSIKEIKAKU' => $tmp{'HOUSE_TOSIKEIKAKU'},#+
                            'HOUSE_KOKUDOHOUTODOKEDE' => $tmp{'HOUSE_KOKUDOHOUTODOKEDE'},

                            'HOUSE_BUILDING_STRUCTURE' => $tmp{'HOUSE_BUILDING_STRUCTURE'},
                            #'HOUSE_STORY' => $tmp{'HOUSE_STORY'},
                            #'HOUSE_FLOOR' => $tmp{'HOUSE_FLOOR'},
                            'HOUSE_AGE' => $tmp{'HOUSE_AGE'},
                            'HOUSE_JYOUKEN' => $tmp{'HOUSE_JYOUKEN'},
                
                            'HOUSE_OPTIONS_SINTIKU' => $tmp{'HOUSE_OPTIONS_SINTIKU'},
                            'HOUSE_OPTIONS_TVPHONE' => $tmp{'HOUSE_OPTIONS_TVPHONE'},
                            'HOUSE_OPTIONS_SYSTEM_KITCHIN' => $tmp{'HOUSE_OPTIONS_SYSTEM_KITCHIN'},
                            'HOUSE_OPTIONS_SHOWERTOILETE' => $tmp{'HOUSE_OPTIONS_SHOWERTOILETE'},
                            'HOUSE_OPTIONS_WALKIN_CLOSET' => $tmp{'HOUSE_OPTIONS_WALKIN_CLOSET'},
                            'HOUSE_OPTIONS_YUKASITA_SYUUNOU' => $tmp{'HOUSE_OPTIONS_YUKASITA_SYUUNOU'},
                            'HOUSE_OPTIONS_YUKADANBOU' => $tmp{'HOUSE_OPTIONS_YUKADANBOU'},
                            'HOUSE_OPTIONS_PARKING' => $tmp{'HOUSE_OPTIONS_PARKING'},
                            'HOUSE_OPTIONS_BARIAFURI' => $tmp{'HOUSE_OPTIONS_BARIAFURI'},
                            'HOUSE_OPTIONS_TOSIGASU' => $tmp{'HOUSE_OPTIONS_TOSIGASU'},

                            'HOUSE_TORIHIKITAIYOU' => $tmp{'HOUSE_TORIHIKITAIYOU'},
                            'HOUSE_ADS_TEXT' => $tmp{'HOUSE_ADS_TEXT'},
                            'HOUSE_SETUBI' => $tmp{'HOUSE_SETUBI'},
                    
                            'HOUSE_PICS_OUTSIDE' => $tmp{'HOUSE_PICS_OUTSIDE'},
                            'HOUSE_PICS_INSIDE' => $tmp{'HOUSE_PICS_INSIDE'},
                            'HOUSE_PICS_MADORIZU' => $tmp{'HOUSE_PICS_MADORIZU'},
                            'HOUSE_PICS_TIZU' => $tmp{'HOUSE_PICS_TIZU'},
                
                            'HOUSE_PICS_OUTSIDE_THUMB' => $tmp{'HOUSE_PICS_OUTSIDE_THUMB'},
                            'HOUSE_PICS_INSIDE_THUMB' => $tmp{'HOUSE_PICS_INSIDE_THUMB'},
                            'HOUSE_PICS_MADORIZU_THUMB' => $tmp{'HOUSE_PICS_MADORIZU_THUMB'},
                            'HOUSE_PICS_TIZU_THUMB' => $tmp{'HOUSE_PICS_TIZU_THUMB'},
                    
                            'HOUSE_MOVIE_FILE_URL' => $tmp{'HOUSE_MOVIE_FILE_URL'},

                            'HOUSE_YOUR_ID' => $tmp{'HOUSE_YOUR_ID'},
                
                            'HOUSE_COMPANY_NAME' => $$tmp_company_info{'COMPANY_NAME'},
                            'HOUSE_COMPANY_TEL' => $$tmp_company_info{'COMPANY_TEL'},
                            'HOUSE_COMPANY_ADDRESS' => $$tmp_company_info{'COMPANY_ADDRESS'},
                            'HOUSE_COMPANY_LICENSE' => $$tmp_company_info{'COMPANY_LICENSE'},
                            'HOUSE_COMPANY_HP' => $$tmp_company_info{'COMPANY_HP'},
                
                            'HOUSE_CREATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_CREATED'}),
                            'HOUSE_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_LAST_UPDATED'}),
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
            my $db_access_path = $self->{_app}->param('db_b_house_access_path');
            tie (%access, 'MLDBM', $db_access_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
            foreach (@id_to_be_logged){
                my $ref_access_tmp;
                $ref_access_tmp = $access{$_};
                $$ref_access_tmp{'COUNT'} = $access{$_}{'COUNT'}+1;
                $$ref_access_tmp{'USER_ID'} = $house{$_}{'HOUSE_USER_ID'};
    
                $access{$_} =  $ref_access_tmp;
                #$access{$_}++;
            }
            untie %access;
        }
        untie %house;
    }
    return \@loop_data;

}

sub log_Inquiry{
    my $self = shift;
    my @ids = @_;

    if ($self->{_app}->param('user_logged_in') != 1){
        my %house;
        my $db_house_path = $self->{_app}->param('db_b_house_path');
        tie (%house, 'MLDBM', $db_house_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        my %mansion;
        my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
        tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        my %inquiry;
        my $db_inquiry_path = $self->{_app}->param('db_b_house_inquiry_path');
        tie (%inquiry, 'MLDBM', $db_inquiry_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
        foreach (@ids){
            my $ref_access_tmp;
            $ref_access_tmp = $inquiry{$_};
            $$ref_access_tmp{'COUNT'} = $inquiry{$_}{'COUNT'}+1;
            $$ref_access_tmp{'USER_ID'} = $house{$_}{'HOUSE_USER_ID'};

            $inquiry{$_} =  $ref_access_tmp;
            #$inquiry{$_}++;
        }
        untie %inquiry;

        untie %house;
    }
}


















1
