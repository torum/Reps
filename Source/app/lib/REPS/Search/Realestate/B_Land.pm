package REPS::Search::Realestate::B_Land;

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
            'LAND_ID' => '',
            'LAND_PUBLISHED' => '',
            'LAND_LOCATION' => '',
            'LAND_IS_SPECIAL' => '',
            'LAND_STATION_1' => '',
            'LAND_BUS_1' => '',
            'LAND_WALK_MINUTES_1' => '',
            'LAND_BUS_MINUTES_1' => '',
            'LAND_BUSWALK_MINUTES_1' => '',

            'LAND_STATION_2' => '',
            'LAND_BUS_2' => '',
            'LAND_WALK_MINUTES_2' => '',
            'LAND_BUS_MINUTES_2' => '',
            'LAND_BUSWALK_MINUTES_2' => '',

            'LAND_PRICE' => '',

            'LAND_TUBOTANKA' => '',
            'LAND_SQUARE_M' => '',
            'LAND_SQUARE_TEXT' => '',
            'LAND_SQUARE_T' => '',
            'LAND_SETUDOU' => '',
            'LAND_KENRI' => '',
            'LAND_SETBACK' => '',
            'LAND_SIDOUFUTAN_SQUARE' => '',
            'LAND_TIMOKU' => '',
            'LAND_TISEI' => '',
            'LAND_KENPEIRITU' => '',
            'LAND_YOUSEKIRITU' => '',
            'LAND_YOUTOTIIKI' => '',
            'LAND_TOSIKEIKAKU' => '',
            'LAND_KOKUDOHOUTODOKEDE' => '',
            'LAND_JYOUKEN' => '',

            'LAND_OPTIONS_KAKUTI' => '',

            'LAND_OPTIONS_GUS' => '',
            'LAND_OPTIONS_SUIDOU' => '',
            'LAND_OPTIONS_HAISUI' => '',
            'LAND_OPTIONS_OSUI' => '',



            'LAND_SETUBI' => '',
            'LAND_BIKOU' => '',
            'LAND_HIKIWATASI' => '',
            'LAND_GENKYOU' => '',
            'LAND_TORIHIKITAIYOU' => '',


            'LAND_YOUR_ID' => '',


            'LAND_ADS_TEXT' => '',
    
            'LAND_PICS_OUTSIDE' => '',
            'LAND_PICS_INSIDE' => '',
            'LAND_PICS_TIZU' => '',

            'LAND_PICS_OUTSIDE_THUMB' => '',
            'LAND_PICS_INSIDE_THUMB' => '',
            'LAND_PICS_TIZU_THUMB' => '',
    
            'LAND_MOVIE_FILE_URL' => '',

            'LAND_TASYAKANRI' => '',
            'LAND_RYUUTUU' => '',
            'LAND_KANRIKAISYA' => '',
            'LAND_KANRIKAISYA_CONTACT' => '',


            'LAND_USER_ID' => $app->param('user_id'),,
            'LAND_CREATED' => '',
            'LAND_LAST_UPDATED' => '',

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
    my %sort_hash;
    my %tmp;

    my @loop_data;
    my $c=0;
    my $match = 0;

    my %land;
    my $db_land_path = $self->{_app}->param('db_b_land_path');
    if(-f $db_land_path){
        tie (%land, 'MLDBM', $db_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;
    
        while ( my ($key, $value) = each(%land) ) {
            if ((exists $land{$key}) && (defined $land{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'LAND_USER_ID'}){
                    #match?
                    $match = 0;

                    #TODO
    
                        if ($tmp{'LAND_PUBLISHED'}){
                            $match = 1;
                        }else{
                            next;
                        }
    
    
#temporarly fix that reps1.5.1 or earlier wrongly used price_L
if ($q->param("land_price_l")){
    $q->param("land_price_1"=>$q->param("land_price_l"));
}
                    if ($q->param("land_price_1") || $q->param("land_price_2")){
                        if ($q->param("land_price_1") && $q->param("land_price_2")){
        
                            if (($tmp{'LAND_PRICE'} >= ($q->param("land_price_1"))) && ($tmp{'LAND_PRICE'} <= ($q->param("land_price_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_price_2")){
                            if ($tmp{'LAND_PRICE'} <= ($q->param("land_price_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_price_1")){
                            if ($tmp{'LAND_PRICE'} >= ($q->param("land_price_1"))){
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
    
                    if ($q->param("land_square_1") || $q->param("land_square_2")){
                        if (($q->param("land_square_1") && $q->param("land_square_2"))){
                            if (($tmp{'LAND_SQUARE_M'} >= ($q->param("land_square_1"))) && ($tmp{'LAND_SQUARE_M'} <= ($q->param("land_square_2")))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_square_2")){
                            if ($tmp{'LAND_SQUARE_M'} <= ($q->param("land_square_2"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_square_1")){
                            if ($tmp{'LAND_SQUARE_M'} >= ($q->param("land_square_1"))){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }

                    #if ($q->param("land_walk_minutes")){
                    #    if (!$tmp{'LAND_WALK_MINUTES_1'}){next;}
                    #    if ($tmp{'LAND_WALK_MINUTES_1'} <= $q->param("land_walk_minutes")){
                    #        $match = 1;
                    #    }else{next;}
                    #}


                    my $test = 0;
                    if ($q->param("land_walk_minutes")){
                        if ($tmp{'LAND_WALK_MINUTES_1'}){
                            if ($tmp{'LAND_WALK_MINUTES_1'} <= $q->param("land_walk_minutes")){
                                $test = 1;
                            }
                        }
                        if ($tmp{'LAND_WALK_MINUTES_2'}){
                            if ($tmp{'LAND_WALK_MINUTES_2'} <= $q->param("land_walk_minutes")){
                                $test = 1;
                            }
                        }
                        next unless ($test);
                    }


    
                    my $test = 0;
                    if ($q->param("land_has_")){
                        my @land_has;
                        foreach ($q->param("land_has_")){
                            push (@land_has,split(',',$_));
                        }
                        foreach (@land_has){
    
                            if ($_ == 2){
                                if ($tmp{'LAND_PICS_OUTSIDE'} || $tmp{'LAND_PICS_INSIDE'}){$test=1;}else{$test=0;last;}
                            }
                            if ($_ == 3){
                                if ($tmp{'LAND_MOVIE_FILE_URL'}){$test=1;}else{$test=0;last;}
                        
                            }
                        }
                        next unless ($test);
                    }
    
    
    
    
                    
                    if ($q->param('land_options_kakuti')){
                        if (!$tmp{'LAND_OPTIONS_KAKUTI'}){next;}
                    }
    
    
                    if ($q->param('land_options_gus')){
                        if ($tmp{'LAND_OPTIONS_GUS'} != $q->param('land_options_gus')){next;}
                    }
                    if ($q->param('land_options_suidou')){
                        if ($tmp{'LAND_OPTIONS_SUIDOU'} != $q->param('land_options_suidou')){next;}
                    }
                    if ($q->param('land_options_haisui')){
                        if ($tmp{'LAND_OPTIONS_HAISUI'} != $q->param('land_options_haisui')){next;}
                    }
                    if ($q->param('land_options_osui')){
                        if ($tmp{'LAND_OPTIONS_OSUI'} != $q->param('land_options_osui')){next;}
                    }

                    $test = 0;
                    if ($q->param("land_address")){
                        foreach ($q->param("land_address")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'LAND_LOCATION'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'LAND_LOCATION'},$search_by_key)){
                            #    $test = 1;
                            #    $match = 1;
                            #}
                        }
                        next unless ($test);
                    }
    
                    $test = 0;
                    if ($q->param("land_station")){
                        foreach ($q->param("land_station")){

                            #複数選択されていた場合、カンマで区切って複数文字列が返ってくるから、splitしてLoop処理。
                            my @values = split(',', $_);

                            foreach my $val (@values) {
                                my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($val));
                                if (REPS::Util->str_match($tmp{'LAND_STATION_1'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }elsif(REPS::Util->str_match($tmp{'LAND_STATION_2'},$search_by_key)){
                                    $test = 1;
                                    $match = 1;
                                    last;
                                }

                            }
                            if ($test){last;}

                            #my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($_));
                            #if (REPS::Util->str_match($tmp{'LAND_STATION_1'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}elsif(REPS::Util->str_match($tmp{'LAND_STATION_2'},$search_by_key)){
                            #    $match = 1;
                            #    $test = 1;
                            #}
                        }
                        next unless ($test);
                    }
    
                    $test = 0;
                    if ($q->param("land_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("land_school")));
                        if (REPS::Util->str_match($tmp{'LAND_SHOUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'LAND_CYUUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
    
                        my $tstr =  join(' ',$tmp{'LAND_DAIGAKU_LIST'}); 
    
                        if (REPS::Util->str_match($tstr,$search_by_key)){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }

                    if ($match){
                        #if ($sort_by){
                            #add to sort_hash
                            if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location') || ($sort_by eq 'station')){
                                if ($sort_by eq 'station'){
                                    $sort_hash{$key} = $tmp{'LAND_STATION_1'};
                                }elsif (($sort_by eq 'price')){
                                    $sort_hash{$key} = $tmp{'LAND_PRICE'};
                                }elsif (($sort_by eq 'date')){
                                    if ((defined $tmp{'LAND_LAST_UPDATED'})&&( $tmp{'LAND_LAST_UPDATED'})){
                                        $sort_hash{$key} = $tmp{'LAND_LAST_UPDATED'};
                                    }else{
                                        $sort_hash{$key} = $tmp{'LAND_CREATED'};
                                    }
                                }elsif(($sort_by eq 'location')){
                                    $sort_hash{$key} = $tmp{'LAND_LOCATION'};
                                }else{
                                    $sort_hash{$key} = $key;
                                }
                            }else{
                                $sort_hash{$key} = $key;
                            }
                        #}
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
            my $ref_hash = $land{$_};
            my %tmp = %$ref_hash;

            #if ($tmp{'LAND_BUSWALK_MINUTES_1'}){
            #    $tmp{'LAND_BUS_MINUTES_1'} = $tmp{'LAND_BUS_MINUTES_1'}+$tmp{'LAND_BUSWALK_MINUTES_1'};
            #}
            #if ($tmp{'LAND_BUSWALK_MINUTES_2'}){
            #    $tmp{'LAND_BUS_MINUTES_2'} = $tmp{'LAND_BUS_MINUTES_2'}+$tmp{'LAND_BUSWALK_MINUTES_2'};
            #}


            my $new = '';
            my $updated = '';
            if ($tmp{'LAND_CREATED'}){
                my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'LAND_CREATED'});
                if ($dd <= 30) {
                    $new = 'ON';
                }
                if ((!$new) && ($tmp{'LAND_LAST_UPDATED'})){
                    $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'LAND_LAST_UPDATED'});
                    if ($dd <= 10) {
                        $updated = 'ON';
                    }
                }
            }

            if ($tmp{'LAND_PICS_OUTSIDE'}){
                $tmp{'LAND_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_OUTSIDE'};
            }
            if ($tmp{'LAND_PICS_INSIDE'}){
                $tmp{'LAND_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_INSIDE'};
            }
            if ($tmp{'LAND_PICS_MADORIZU'}){
                $tmp{'LAND_PICS_MADORIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_MADORIZU'};
            }
            if ($tmp{'LAND_PICS_TIZU'}){
                $tmp{'LAND_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_TIZU'};
            }
        
            if ($tmp{'LAND_PICS_OUTSIDE_THUMB'}){
                $tmp{'LAND_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_OUTSIDE_THUMB'};
            }
            if ($tmp{'LAND_PICS_INSIDE_THUMB'}){
                $tmp{'LAND_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_INSIDE_THUMB'};
            }
            if ($tmp{'LAND_PICS_MADORIZU_THUMB'}){
                $tmp{'LAND_PICS_MADORIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_MADORIZU_THUMB'};
            }
            if ($tmp{'LAND_PICS_TIZU_THUMB'}){
                $tmp{'LAND_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_TIZU_THUMB'};
            }


            my %hash = (
                'LAND_ID' => "$_",
                'LAND_IS_SPECIAL' => $tmp{'LAND_IS_SPECIAL'},
                'LAND_STATION_1' => $tmp{'LAND_STATION_1'},
                'LAND_STATION_2' => $tmp{'LAND_STATION_2'},
                'LAND_LOCATION' => $tmp{'LAND_LOCATION'},
                'LAND_PRICE' => REPS::Util->insert_comma($tmp{'LAND_PRICE'}),
                'LAND_BUS_MINUTES_1' => $tmp{'LAND_BUS_MINUTES_1'},
                'LAND_WALK_MINUTES_1' => $tmp{'LAND_WALK_MINUTES_1'},
                'LAND_BUS_MINUTES_2' => $tmp{'LAND_BUS_MINUTES_2'},
                'LAND_WALK_MINUTES_2' => $tmp{'LAND_WALK_MINUTES_2'},
                'LAND_SQUARE' => $tmp{'LAND_SQUARE_M'},
                    
                    'LAND_SQUARE_T' => $tmp{'LAND_SQUARE_T'},
                    'LAND_TIMOKU' => $tmp{'LAND_TIMOKU'},
                    'LAND_KENPEIRITU' => $tmp{'LAND_KENPEIRITU'},
                    'LAND_YOUSEKIRITU' => $tmp{'LAND_YOUSEKIRITU'},
                    'LAND_YOUTOTIIKI' => $tmp{'LAND_YOUTOTIIKI'},

                    'LAND_ADS_TEXT' => $tmp{'LAND_ADS_TEXT'},

                    'LAND_PICS_OUTSIDE' => $tmp{'LAND_PICS_OUTSIDE'},
                    'LAND_PICS_INSIDE' => $tmp{'LAND_PICS_INSIDE'},

                    'LAND_PICS_TIZU' => $tmp{'LAND_PICS_TIZU'},
        
                    'LAND_PICS_OUTSIDE_THUMB' => $tmp{'LAND_PICS_OUTSIDE_THUMB'},
                    'LAND_PICS_INSIDE_THUMB' => $tmp{'LAND_PICS_INSIDE_THUMB'},
                    'LAND_PICS_MADORIZU_THUMB' => $tmp{'LAND_PICS_MADORIZU_THUMB'},
                    'LAND_PICS_TIZU_THUMB' => $tmp{'LAND_PICS_TIZU_THUMB'},

                    'LAND_YOUR_ID' => $tmp{'LAND_YOUR_ID'},
                    'LAND_BUS_1' => $tmp{'LAND_BUS_1'},
                    'LAND_BUS_2' => $tmp{'LAND_BUS_2'},

                    'LAND_BUSWALK_MINUTES_1' => $tmp{'LAND_BUSWALK_MINUTES_1'},
                    'LAND_BUSWALK_MINUTES_2' => $tmp{'LAND_BUSWALK_MINUTES_2'},


                'LAND_NEW' => $new,
                'LAND_UPDATED' => $updated,
                'static_url' => $self->{_app}->cfg('static_url'),
                'LAND_CREATED' => REPS::Util->get_date_as_string($tmp{'LAND_CREATED'}),
                'LAND_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'LAND_LAST_UPDATED'})
            );
            push(@loop_data, \%hash);
        }

        untie %land;
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
    my %land;
    my $db_land_path = $self->{_app}->param('db_b_land_path');
    tie (%land, 'MLDBM', $db_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or die $!;

        foreach (@ids){
            if ((defined $land{$_}) && ($land{$_})) {
                my $ref_hash = $land{$_};
                my %tmp = %$ref_hash;


                #if ($tmp{'LAND_BUSWALK_MINUTES_1'}){
                #    $tmp{'LAND_BUS_MINUTES_1'} = $tmp{'LAND_BUS_MINUTES_1'}+$tmp{'LAND_BUSWALK_MINUTES_1'};
                #}
                #if ($tmp{'LAND_BUSWALK_MINUTES_2'}){
                #    $tmp{'LAND_BUS_MINUTES_2'} = $tmp{'LAND_BUS_MINUTES_2'}+$tmp{'LAND_BUSWALK_MINUTES_2'};
                #}



                my %hash = (
                    'ID' => "$_",
                    #'LAND_PUBLISHED' => $tmp{'LAND_PUBLISHED'},
                    'LAND_STATION_1' => $tmp{'LAND_STATION_1'},
                    'LAND_STATION_2' => $tmp{'LAND_STATION_2'},
                    'LAND_LOCATION' => $tmp{'LAND_LOCATION'},
                    'LAND_PRICE' => REPS::Util->insert_comma($tmp{'LAND_PRICE'}),
                    'LAND_BUS_MINUTES_1' => $tmp{'LAND_BUS_MINUTES_1'},
                    'LAND_WALK_MINUTES_1' => $tmp{'LAND_WALK_MINUTES_1'},
                    'LAND_BUSWALK_MINUTES_1' => $tmp{'LAND_BUSWALK_MINUTES_1'},
                    'LAND_BUS_MINUTES_2' => $tmp{'LAND_BUS_MINUTES_2'},
                    'LAND_WALK_MINUTES_2' => $tmp{'LAND_WALK_MINUTES_2'},
                    'LAND_BUSWALK_MINUTES_2' => $tmp{'LAND_BUSWALK_MINUTES_2'},
                    'LAND_SQUARE_M' => $tmp{'LAND_SQUARE_M'},

                    'USER_ID' => $tmp{'LAND_USER_ID'},

                    'LAND_CREATED' => REPS::Util->get_date_as_string($tmp{'LAND_CREATED'}),
                    'LAND_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'LAND_LAST_UPDATED'})
                );
        
                push(@loop_data, \%hash);
            }
        }
    untie %land;

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

    my %land;
    my $db_land_path = $self->{_app}->param('db_b_land_path');
    if(-f $db_land_path){
        tie (%land, 'MLDBM', $db_land_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;
        #
        my $tmp_company_info;
        my $usr_company_info;
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            #get users company info
            my @usr_ids;
            foreach (@ids){
                if ($land{$_}){
                    push (@usr_ids, $land{$_}{'LAND_USER_ID'});
                }
            }
            $usr_company_info = $usr->get_settings_to_be_displayed(@usr_ids);
        }else{
            $tmp_company_info = $Settings->get_settings_to_be_displayed();
        }
    
        foreach (@ids){
            if (defined $land{$_}){
    
                $value = $land{$_};
                my %tmp = %$value;
                if (exists $tmp{'LAND_ID'}){
                    if (($_ eq $tmp{'LAND_ID'} ) && ($tmp{'LAND_PUBLISHED'})){
                        push (@id_to_be_logged,$_);

                        #if ($tmp{'LAND_BUSWALK_MINUTES_1'}){
                        #    $tmp{'LAND_BUS_MINUTES_1'} = $tmp{'LAND_BUS_MINUTES_1'}+$tmp{'LAND_BUSWALK_MINUTES_1'};
                        #}
                        #if ($tmp{'LAND_BUSWALK_MINUTES_2'}){
                        #    $tmp{'LAND_BUS_MINUTES_2'} = $tmp{'LAND_BUS_MINUTES_2'}+$tmp{'LAND_BUSWALK_MINUTES_2'};
                        #}

                        require Unicode::Japanese;
                        my $UJ = Unicode::Japanese->new;
                        my $str = $UJ->set($tmp{'LAND_LOCATION'},'euc')->utf8;
                        $str =~ s/(\W)/sprintf("%%%02X",unpack("C",$1))/eg;
                        #
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            $tmp_company_info = $$usr_company_info{$tmp{'LAND_USER_ID'}};
                        }

                        if ($tmp{'LAND_OPTIONS_GUS'}){
                            if ($tmp{'LAND_OPTIONS_GUS'} == 1){
                                $tmp{'LAND_OPTIONS_GUS'}='都市ガス';
                            }elsif($tmp{'LAND_OPTIONS_GUS'} == 2){
                                $tmp{'LAND_OPTIONS_GUS'}='個別プロパンガス';
                            }elsif($tmp{'LAND_OPTIONS_GUS'} == 3){
                                $tmp{'LAND_OPTIONS_GUS'}='集中プロパンガス';
                            }elsif($tmp{'LAND_OPTIONS_GUS'} == 4){
                                $tmp{'LAND_OPTIONS_GUS'}='その他';
                            }elsif($tmp{'LAND_OPTIONS_GUS'} == 5){
                                $tmp{'LAND_OPTIONS_GUS'}='無し';
                            }
                        }
                        if ($tmp{'LAND_OPTIONS_SUIDOU'}){
                            if ($tmp{'LAND_OPTIONS_SUIDOU'} == 1){
                                $tmp{'LAND_OPTIONS_SUIDOU'}='公営水道';
                            }elsif($tmp{'LAND_OPTIONS_SUIDOU'} == 2){
                                $tmp{'LAND_OPTIONS_SUIDOU'}='私営水道';
                            }elsif($tmp{'LAND_OPTIONS_SUIDOU'} == 3){
                                $tmp{'LAND_OPTIONS_SUIDOU'}='その他';
                            }elsif($tmp{'LAND_OPTIONS_SUIDOU'} == 4){
                                $tmp{'LAND_OPTIONS_SUIDOU'}='無し';
                            }
                        }
                        if ($tmp{'LAND_OPTIONS_HAISUI'}){
                            if ($tmp{'LAND_OPTIONS_HAISUI'} == 1){
                                $tmp{'LAND_OPTIONS_HAISUI'}='本下水';
                            }elsif($tmp{'LAND_OPTIONS_HAISUI'} == 2){
                                $tmp{'LAND_OPTIONS_HAISUI'}='側溝等';
                            }elsif($tmp{'LAND_OPTIONS_HAISUI'} == 3){
                                $tmp{'LAND_OPTIONS_HAISUI'}='浸透';
                            }elsif($tmp{'LAND_OPTIONS_HAISUI'} == 4){
                                $tmp{'LAND_OPTIONS_HAISUI'}='その他';
                            }elsif($tmp{'LAND_OPTIONS_HAISUI'} == 5){
                                $tmp{'LAND_OPTIONS_HAISUI'}='無し';
                            }
                        }
                        if ($tmp{'LAND_OPTIONS_OSUI'}){
                            if ($tmp{'LAND_OPTIONS_OSUI'} == 1){
                                $tmp{'LAND_OPTIONS_OSUI'}='本下水';
                            }elsif($tmp{'LAND_OPTIONS_OSUI'} == 2){
                                $tmp{'LAND_OPTIONS_OSUI'}='集中浄化槽';
                            }elsif($tmp{'LAND_OPTIONS_OSUI'} == 3){
                                $tmp{'LAND_OPTIONS_OSUI'}='個別浄化槽';
                            }elsif($tmp{'LAND_OPTIONS_OSUI'} == 4){
                                $tmp{'LAND_OPTIONS_OSUI'}='その他';
                            }elsif($tmp{'LAND_OPTIONS_OSUI'} == 5){
                                $tmp{'LAND_OPTIONS_OSUI'}='無し';
                            }
                        }
                        if ($tmp{'LAND_PICS_OUTSIDE'}){
                            $tmp{'LAND_PICS_OUTSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_OUTSIDE'};
                        }
                        if ($tmp{'LAND_PICS_INSIDE'}){
                            $tmp{'LAND_PICS_INSIDE'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_INSIDE'};
                        }

                        if ($tmp{'LAND_PICS_TIZU'}){
                            $tmp{'LAND_PICS_TIZU'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_TIZU'};
                        }
                    
                        if ($tmp{'LAND_PICS_OUTSIDE_THUMB'}){
                            $tmp{'LAND_PICS_OUTSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_OUTSIDE_THUMB'};
                        }
                        if ($tmp{'LAND_PICS_INSIDE_THUMB'}){
                            $tmp{'LAND_PICS_INSIDE_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_INSIDE_THUMB'};
                        }

                        if ($tmp{'LAND_PICS_TIZU_THUMB'}){
                            $tmp{'LAND_PICS_TIZU_THUMB'} = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$tmp{'LAND_PICS_TIZU_THUMB'};
                        }

                        my %hash = (
    
                            'LAND_ID' => "$_",
                            'LAND_IS_SPECIAL' => $tmp{'LAND_IS_SPECIAL'},

                            'LAND_LOCATION' => $tmp{'LAND_LOCATION'},
                            'LAND_LOCATION_URLENCODED' => $str,

                            'LAND_STATION_1' => $tmp{'LAND_STATION_1'},
                            'LAND_BUS_1' => $tmp{'LAND_BUS_1'},
                            'LAND_BUS_MINUTES_1' => $tmp{'LAND_BUS_MINUTES_1'},
                            'LAND_WALK_MINUTES_1' => $tmp{'LAND_WALK_MINUTES_1'},
                            'LAND_BUSWALK_MINUTES_1' => $tmp{'LAND_BUSWALK_MINUTES_1'},

                            'LAND_STATION_2' => $tmp{'LAND_STATION_2'},
                            'LAND_BUS_2' => $tmp{'LAND_BUS_2'},
                            'LAND_BUS_MINUTES_2' => $tmp{'LAND_BUS_MINUTES_2'},
                            'LAND_WALK_MINUTES_2' => $tmp{'LAND_WALK_MINUTES_2'},
                            'LAND_BUSWALK_MINUTES_2' => $tmp{'LAND_BUSWALK_MINUTES_2'},

                            'LAND_PRICE' => REPS::Util->insert_comma($tmp{'LAND_PRICE'}),
                            'LAND_TUBOTANKA' => REPS::Util->insert_comma($tmp{'LAND_TUBOTANKA'}),

                            'LAND_SQUARE_M' => $tmp{'LAND_SQUARE_M'},
                            'LAND_SQUARE_TEXT' => $tmp{'LAND_SQUARE_TEXT'},
                            'LAND_SQUARE_T' => $tmp{'LAND_SQUARE_T'},
                            'LAND_SETUDOU' => $tmp{'LAND_SETUDOU'},
                            'LAND_KENRI' => $tmp{'LAND_KENRI'},
                            'LAND_SETBACK' => $tmp{'LAND_SETBACK'},
                            'LAND_SIDOUFUTAN_SQUARE' => $tmp{'LAND_SIDOUFUTAN_SQUARE'},
                            'LAND_TIMOKU' => $tmp{'LAND_TIMOKU'},
                            'LAND_TISEI' => $tmp{'LAND_TISEI'},
                            'LAND_KENPEIRITU' => $tmp{'LAND_KENPEIRITU'},
                            'LAND_YOUSEKIRITU' => $tmp{'LAND_YOUSEKIRITU'},
                            'LAND_YOUTOTIIKI' => $tmp{'LAND_YOUTOTIIKI'},
                            'LAND_TOSIKEIKAKU' => $tmp{'LAND_TOSIKEIKAKU'},
                            'LAND_KOKUDOHOUTODOKEDE' => $tmp{'LAND_KOKUDOHOUTODOKEDE'},
                            'LAND_JYOUKEN' => $tmp{'LAND_JYOUKEN'},
                            'LAND_OPTIONS_KAKUTI' => $tmp{'LAND_OPTIONS_KAKUTI'},
                            'LAND_OPTIONS_GUS' => $tmp{'LAND_OPTIONS_GUS'},
                            'LAND_OPTIONS_SUIDOU' => $tmp{'LAND_OPTIONS_SUIDOU'},
                            'LAND_OPTIONS_HAISUI' => $tmp{'LAND_OPTIONS_HAISUI'},
                            'LAND_OPTIONS_OSUI' => $tmp{'LAND_OPTIONS_OSUI'},
            
                            'LAND_BIKOU' => $tmp{'LAND_BIKOU'},
                            'LAND_HIKIWATASI' => $tmp{'LAND_HIKIWATASI'},
                            'LAND_GENKYOU' => $tmp{'LAND_GENKYOU'},

                            'LAND_TORIHIKITAIYOU' => $tmp{'LAND_TORIHIKITAIYOU'},
                            'LAND_ADS_TEXT' => $tmp{'LAND_ADS_TEXT'},
                            'LAND_SETUBI' => $tmp{'LAND_SETUBI'},


                            'LAND_PICS_OUTSIDE' => $tmp{'LAND_PICS_OUTSIDE'},
                            'LAND_PICS_INSIDE' => $tmp{'LAND_PICS_INSIDE'},
                            'LAND_PICS_TIZU' => $tmp{'LAND_PICS_TIZU'},
                
                            'LAND_PICS_OUTSIDE_THUMB' => $tmp{'LAND_PICS_OUTSIDE_THUMB'},
                            'LAND_PICS_INSIDE_THUMB' => $tmp{'LAND_PICS_INSIDE_THUMB'},
                            'LAND_PICS_TIZU_THUMB' => $tmp{'LAND_PICS_TIZU_THUMB'},
                    
                            'LAND_MOVIE_FILE_URL' => $tmp{'LAND_MOVIE_FILE_URL'},

                            'LAND_YOUR_ID' => $tmp{'LAND_YOUR_ID'},

                            'LAND_COMPANY_NAME' => $$tmp_company_info{'COMPANY_NAME'},
                            'LAND_COMPANY_TEL' => $$tmp_company_info{'COMPANY_TEL'},
                            'LAND_COMPANY_ADDRESS' => $$tmp_company_info{'COMPANY_ADDRESS'},
                            'LAND_COMPANY_LICENSE' => $$tmp_company_info{'COMPANY_LICENSE'},
                            'LAND_COMPANY_HP' => $$tmp_company_info{'COMPANY_HP'},
                
                            'LAND_CREATED' => REPS::Util->get_date_as_string($tmp{'LAND_CREATED'}),
                            'LAND_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'LAND_LAST_UPDATED'}),
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
            my $db_access_path = $self->{_app}->param('db_b_land_access_path');
            tie (%access, 'MLDBM', $db_access_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
            foreach (@id_to_be_logged){
                my $ref_access_tmp;
                $ref_access_tmp = $access{$_};
                $$ref_access_tmp{'COUNT'} = $access{$_}{'COUNT'}+1;
                $$ref_access_tmp{'USER_ID'} = $land{$_}{'LAND_USER_ID'};
    
                $access{$_} =  $ref_access_tmp;
                #$access{$_}++;
            }
            untie %access;
    
        }
        untie %land;
    }
    return \@loop_data;

}

sub log_Inquiry{
    my $self = shift;
    my @ids = @_;

    if ($self->{_app}->param('user_logged_in') != 1){
        my %land;
        my $db_land_path = $self->{_app}->param('db_b_land_path');
        tie (%land, 'MLDBM', $db_land_path, O_RDONLY, 0666, $DB_BTREE, 'read') or die $!;

        my %inquiry;
        my $db_inquiry_path = $self->{_app}->param('db_b_land_inquiry_path');
        tie (%inquiry, 'MLDBM', $db_inquiry_path, O_CREAT|O_RDWR, 0666, $DB_BTREE, 'write') or die $!;
        foreach (@ids){
            my $ref_access_tmp;
            $ref_access_tmp = $inquiry{$_};
            $$ref_access_tmp{'COUNT'} = $inquiry{$_}{'COUNT'}+1;
            $$ref_access_tmp{'USER_ID'} = $land{$_}{'LAND_USER_ID'};

            $inquiry{$_} =  $ref_access_tmp;
            #$inquiry{$_}++;
        }
        untie %inquiry;

        untie %land;
    }
}



















1
