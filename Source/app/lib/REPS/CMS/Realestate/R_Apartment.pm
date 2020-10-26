package REPS::CMS::Realestate::R_Apartment;

use strict;
use base qw( REPS::CMS::Realestate );

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
            'APART_PRICE_SIKIKIN_UNIT' => $app->param('user_pref_price_sikikin_unit'),
            'APART_PRICE_REIKIN' => '',
            'APART_PRICE_REIKIN_UNIT' => $app->param('user_pref_price_reikin_unit'),
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
            'APART_TORIHIKITAIYOU' => '',


            'APART_ROOM_NUMBER' => '',
            'APART_YOUR_ID' => '',

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
            

            'APART_OPTIONS_BICYCLE' => '',
            'APART_OPTIONS_INTERNET' => '',
            'APART_OPTIONS_PARKING' => '',
            'APART_OPTIONS_PET' => '',
            'APART_OPTIONS_HOSYOUNIN' => '',
            'APART_OPTIONS_INSTRUMENT' => '',

            'APART_SHOUGAKKOUKU' => '',
            'APART_CYUUGAKKOUKU' => '',
            'APART_DAIGAKU_LIST' => '',

            'APART_HTML_TEXT' => '',
            'APART_ADS_TEXT' => '',
            'APART_BIKOU' => '',
            'APART_NYUUKYOJIKI' => '',
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
            'APART_KANRIKAISYA_CONTACT' => '',

            'APART_USER_ID' => $app->param('user_id'),
            'APART_CREATED' => '',
            'APART_LAST_UPDATED' => '',

            },
#        _bln_need_rebuild_special => 0,
        };

    return bless $self,$class;
}

sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();

    if ($q->param('_object_id')){
        $self->{_ref_hash}{'APART_ID'} = $q->param('_object_id') if $q->param('_object_id');
    }
    $self->{_ref_hash}{'APART_PUBLISHED'} = $q->param('apart_publish') if $q->param('apart_publish');
    $self->{_ref_hash}{'APART_IS_SPECIAL'} = $q->param('add_to_special') if $q->param('add_to_special');

    $self->{_ref_hash}{'APART_NAME'} = REPS::Util->trim($q->param('apart_name')) if $q->param('apart_name');
    $self->{_ref_hash}{'APART_LOCATION'} = $q->param('apart_location') if $q->param('apart_location');
    $self->{_ref_hash}{'APART_STATION_1'} = $q->param('apart_station1') if $q->param('apart_station1');

    $self->{_ref_hash}{'APART_BUS_1'} = $q->param('apart_bus') if $q->param('apart_bus');
    $self->{_ref_hash}{'APART_WALK_MINUTES_1'} = $q->param('apart_walk_minutes') if $q->param('apart_walk_minutes');
    $self->{_ref_hash}{'APART_BUS_MINUTES_1'} = $q->param('apart_bus_minutes') if $q->param('apart_bus_minutes');
    $self->{_ref_hash}{'APART_BUSWALK_MINUTES_1'} = $q->param('apart_buswalk_minutes') if $q->param('apart_buswalk_minutes');

    $self->{_ref_hash}{'APART_STATION_2'} = $q->param('apart_station2') if $q->param('apart_station2');
    $self->{_ref_hash}{'APART_BUS_2'} = $q->param('apart_bus2') if $q->param('apart_bus2');
    $self->{_ref_hash}{'APART_WALK_MINUTES_2'} = $q->param('apart_walk_minutes2') if $q->param('apart_walk_minutes2');
    $self->{_ref_hash}{'APART_BUS_MINUTES_2'} = $q->param('apart_bus_minutes2') if $q->param('apart_bus_minutes2');
    $self->{_ref_hash}{'APART_BUSWALK_MINUTES_2'} = $q->param('apart_buswalk_minutes2') if $q->param('apart_buswalk_minutes2');

    $self->{_ref_hash}{'APART_PRICE'} = $q->param('apart_price') if $q->param('apart_price');
    $self->{_ref_hash}{'APART_PRICE_KANRIHI'} = $q->param('apart_price_kanrihi') if $q->param('apart_price_kanrihi');
    $self->{_ref_hash}{'APART_PRICE_SIKIKIN'} = $q->param('apart_price_sikikin') if $q->param('apart_price_sikikin');
    $self->{_ref_hash}{'APART_PRICE_SIKIKIN_UNIT'} = $q->param('apart_price_sikikin_unit') if $q->param('apart_price_sikikin_unit');

    $self->{_ref_hash}{'APART_PRICE_REIKIN'} = $q->param('apart_price_reikin') if $q->param('apart_price_reikin');
    $self->{_ref_hash}{'APART_PRICE_REIKIN_UNIT'} = $q->param('apart_price_reikin_unit') if $q->param('apart_price_reikin_unit');

    $self->{_ref_hash}{'APART_PRICE_HOSYOUKIN'} = $q->param('apart_price_hosyoukin') if $q->param('apart_price_hosyoukin');
    $self->{_ref_hash}{'APART_PRICE_SIKIBIKI'} = $q->param('apart_price_sikibiki') if $q->param('apart_price_sikibiki');
    $self->{_ref_hash}{'APART_PRICE_OTHER'} = $q->param('apart_price_other') if $q->param('apart_price_other');
    $self->{_ref_hash}{'APART_INSURANCE'} = $q->param('apart_price_insurance') if $q->param('apart_price_insurance');
    $self->{_ref_hash}{'APART_MADORI' } = $q->param('apart_madori') if $q->param('apart_madori');
    $self->{_ref_hash}{'APART_MADORI_DETAIL'} = $q->param('apart_madori_detail') if $q->param('apart_madori_detail');
    $self->{_ref_hash}{'APART_SQUARE'} = $q->param('apart_square') if $q->param('apart_square');
    $self->{_ref_hash}{'APART_SQUARE_TUBO'} = $q->param('apart_square_tubo') if $q->param('apart_square_tubo');
    $self->{_ref_hash}{'APART_KIND'} = $q->param('apart_kind') if $q->param('apart_kind');
    $self->{_ref_hash}{'APART_BUILDING_STRUCTURE'} = $q->param('apart_building_structure') if $q->param('apart_building_structure');
    $self->{_ref_hash}{'APART_STORY'} = $q->param('apart_story') if $q->param('apart_story');
    $self->{_ref_hash}{'APART_FLOOR'} = $q->param('apart_floor') if $q->param('apart_floor');


    $self->{_ref_hash}{'APART_AGE'} = $q->param('apart_age') if $q->param('apart_age');
    $self->{_ref_hash}{'APART_CONDITION'} = $q->param('apart_condition') if $q->param('apart_condition');
    $self->{_ref_hash}{'APART_TORIHIKITAIYOU'} = $q->param('apart_torihikitaiyou') if $q->param('apart_torihikitaiyou');


    $self->{_ref_hash}{'APART_ROOM_NUMBER'} = $q->param('apart_room_number') if $q->param('apart_room_number');
    $self->{_ref_hash}{'APART_YOUR_ID'} = $q->param('apart_your_id') if $q->param('apart_your_id');


    $self->{_ref_hash}{'APART_OPTIONS_KAKUBEYA'} = $q->param('apart_options_kakubeya') if $q->param('apart_options_kakubeya');
    $self->{_ref_hash}{'APART_OPTIONS_MINAMI'} = $q->param('apart_options_minami') if $q->param('apart_options_minami');
    $self->{_ref_hash}{'APART_OPTIONS_AUTOLOCK'} = $q->param('apart_options_autolock') if $q->param('apart_options_autolock');
    $self->{_ref_hash}{'APART_OPTIONS_ELEVATOR'} = $q->param('apart_options_elevator') if $q->param('apart_options_elevator');
    $self->{_ref_hash}{'APART_OPTIONS_TVPHONE'} = $q->param('apart_options_tvphone') if $q->param('apart_options_tvphone');
    $self->{_ref_hash}{'APART_OPTIONS_BATHTOILET'} = $q->param('apart_options_bathtoilet') if $q->param('apart_options_bathtoilet');
    $self->{_ref_hash}{'APART_OPTIONS_AIRCON'} = $q->param('apart_options_aircon') if $q->param('apart_options_aircon');
    $self->{_ref_hash}{'APART_OPTIONS_OITAKI'} = $q->param('apart_options_oitaki') if $q->param('apart_options_oitaki');
    $self->{_ref_hash}{'APART_OPTIONS_GASCONRO'} = $q->param('apart_options_gasconro') if $q->param('apart_options_gasconro');
    $self->{_ref_hash}{'APART_OPTIONS_SITUNAISENTAKUKI'} = $q->param('apart_options_situnaisentakuki') if $q->param('apart_options_situnaisentakuki');
    $self->{_ref_hash}{'APART_OPTIONS_LOFT'} = $q->param('apart_options_loft') if $q->param('apart_options_loft');
    $self->{_ref_hash}{'APART_OPTIONS_FLOORING'} = $q->param('apart_options_flooring') if $q->param('apart_options_flooring');
    $self->{_ref_hash}{'APART_OPTIONS_CATV'} = $q->param('apart_options_catv') if $q->param('apart_options_catv');
    $self->{_ref_hash}{'APART_OPTIONS_CS'} = $q->param('apart_options_cs') if  $q->param('apart_options_cs');
    $self->{_ref_hash}{'APART_OPTIONS_BS'} = $q->param('apart_options_bs') if $q->param('apart_options_bs');

    $self->{_ref_hash}{'APART_OPTIONS_PARKING'} = $q->param('apart_options_parking') if $q->param('apart_options_parking');
    $self->{_ref_hash}{'APART_OPTIONS_PET'} = $q->param('apart_options_pet') if $q->param('apart_options_pet');
    $self->{_ref_hash}{'APART_OPTIONS_HOSYOUNIN'} = $q->param('apart_options_hosyounin') if $q->param('apart_options_hosyounin');
    $self->{_ref_hash}{'APART_OPTIONS_INSTRUMENT'} = $q->param('apart_options_instrument') if $q->param('apart_options_instrument');

    $self->{_ref_hash}{'APART_OPTIONS_JIMUSYOKA'} = $q->param('apart_options_jimusyoka') if $q->param('apart_options_jimusyoka');
    $self->{_ref_hash}{'APART_OPTIONS_BICYCLE'} = $q->param('apart_options_bicycle') if $q->param('apart_options_bicycle');
    $self->{_ref_hash}{'APART_OPTIONS_INTERNET'} = $q->param('apart_options_internet') if $q->param('apart_options_internet');


    $self->{_ref_hash}{'APART_SHOUGAKKOUKU'} = $q->param('apart_shougakkouku') if $q->param('apart_shougakkouku');
    $self->{_ref_hash}{'APART_CYUUGAKKOUKU'} = $q->param('apart_cyuugakkouku') if $q->param('apart_cyuugakkouku');
    $self->{_ref_hash}{'APART_DAIGAKU_LIST'} = $q->param('apart_daigaku_list') if $q->param('apart_daigaku_list');


    $self->{_ref_hash}{'APART_HTML_TEXT'} = $q->param('apart_html_text') if $q->param('apart_html_text');
    $self->{_ref_hash}{'APART_ADS_TEXT'} = $q->param('apart_ads_text') if $q->param('apart_ads_text');
    $self->{_ref_hash}{'APART_BIKOU'} = $q->param('apart_bikou') if $q->param('apart_bikou');
    $self->{_ref_hash}{'APART_NYUUKYOJIKI'} = $q->param('apart_nyuukyojiki') if $q->param('apart_nyuukyojiki');

    $self->{_ref_hash}{'APART_SETUBI'} = $q->param('apart_setubi') if $q->param('apart_setubi');



    $self->{_ref_hash}{'APART_PICS_OUTSIDE'} = $q->param('_apart_pics_outside') if $q->param('_apart_pics_outside');
    $self->{_ref_hash}{'APART_PICS_INSIDE'} = $q->param('_apart_pics_inside') if $q->param('_apart_pics_inside');
    $self->{_ref_hash}{'APART_PICS_MADORIZU'} = $q->param('_apart_pics_madorizu') if $q->param('_apart_pics_madorizu');
    $self->{_ref_hash}{'APART_PICS_TIZU'} = $q->param('_apart_pics_tizu') if $q->param('_apart_pics_tizu');

    $self->{_ref_hash}{'APART_PICS_OUTSIDE_THUMB'} = $q->param('_apart_pics_outside_thumb') if $q->param('_apart_pics_outside_thumb');
    $self->{_ref_hash}{'APART_PICS_INSIDE_THUMB'} = $q->param('_apart_pics_inside_thumb') if $q->param('_apart_pics_inside_thumb');
    $self->{_ref_hash}{'APART_PICS_MADORIZU_THUMB'} = $q->param('_apart_pics_madorizu_thumb') if $q->param('_apart_pics_madorizu_thumb');
    $self->{_ref_hash}{'APART_PICS_TIZU_THUMB'} = $q->param('_apart_pics_tizu_thumb') if $q->param('_apart_pics_tizu_thumb');

    $self->{_ref_hash}{'APART_MOVIE_FILE_URL'} = $q->param('apart_movie_file_url') if $q->param('apart_movie_file_url');

    $self->{_ref_hash}{'APART_TASYAKANRI'} = $q->param('apart_tasyakanri') if $q->param('apart_tasyakanri');
    $self->{_ref_hash}{'APART_RYUUTUU'} = $q->param('apart_ryuutuu') if $q->param('apart_ryuutuu');
    $self->{_ref_hash}{'APART_KANRIKAISYA'} = $q->param('apart_kanrikaisya') if $q->param('apart_kanrikaisya');
    $self->{_ref_hash}{'APART_KANRIKAISYA_CONTACT'} = $q->param('apart_kanrikaisya_contact') if $q->param('apart_kanrikaisya_contact');


    if ($q->param('apart_created')){
        $self->{_ref_hash}{'APART_CREATED'} = $q->param('apart_created') if $q->param('apart_created');
    }

    $self->{_app}->convert_hash_charset($self->{_ref_hash});
    REPS::Util->convert_hash_zhk($self->{_ref_hash});
}

sub get_Create_Realestate_Form{
    my $self = shift;

    #my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    $q->delete('apart_kind');

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'apart');
    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_name'},"物件名: ")), 
                $q->td($q->textfield(-id=>'apart_name', -name=>'apart_name', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_NAME'}"))
            ), 

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_room_number'},"部屋番号: ")), 
                $q->td($q->textfield(-id=>'apart_room_number',-name=>'apart_room_number', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_ROOM_NUMBER'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_location'},"物件所在地: ")), 
                $q->td($q->textfield(-id=>'apart_location', -name=>'apart_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_LOCATION'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_station1'},"最寄駅 1: ")),
                $q->td($q->textfield(-id=>'apart_station1',-name=>'apart_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_STATION_1'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_walk_minutes'},"駅徒歩 1: ")),
                $q->td($q->textfield(-id=>'apart_walk_minutes', -name=>'apart_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_WALK_MINUTES_1'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus'},"バス停名 1: ")),
                $q->td($q->textfield(-id=>'apart_bus',-name=>'apart_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUS_1'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus_minutes'},"バス分 1: ")),
                $q->td($q->textfield(-id=>'apart_bus_minutes',-name=>'apart_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUS_MINUTES_1'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_buswalk_minutes'},"停歩 1: ")), 
                $q->td($q->textfield(-id=>'apart_buswalk_minutes',-name=>'apart_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUSWALK_MINUTES_1'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_station2'},"最寄駅 2: ")), 
                $q->td($q->textfield(-id=>'apart_station2', -name=>'apart_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_STATION_2'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_walk_minutes2'},"駅徒歩 2: ")), 
                $q->td($q->textfield(-id=>'apart_walk_minutes2', -name=>'apart_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_WALK_MINUTES_2'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus2'},"バス停名 2: ")), 
                $q->td($q->textfield(-id=>'apart_bus2', -name=>'apart_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUS_2'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus_minutes2'},"バス分 2: ")), 
                $q->td($q->textfield(-id=>'apart_bus_minutes2',-name=>'apart_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUS_MINUTES_2'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_buswalk_minutes2'},"停歩 2: ")), 
                $q->td($q->textfield(-id=>'apart_buswalk_minutes2', -name=>'apart_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUSWALK_MINUTES_2'}"),'分'),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_price'},"賃料: ")), 
                $q->td($q->textfield(-id=>'apart_price', -name=>'apart_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE'}"),'円')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_kanrihi'},"共益費／管理費: ")), 
                $q->td($q->textfield(-id=>'apart_price_kanrihi', -name=>'apart_price_kanrihi', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE_KANRIHI'}"),'円'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_sikikin'},"敷金: ")), 
                $q->td($q->textfield(-id=>'apart_price_sikikin', -name=>'apart_price_sikikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE_SIKIKIN'}"),
                        $q->popup_menu(-name=>'apart_price_sikikin_unit', 
                            -default=>$self->{_ref_hash}{'APART_PRICE_SIKIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                    ),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_reikin'},"礼金: ")), 
                $q->td($q->textfield(-id=>'apart_price_reikin', -name=>'apart_price_reikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE_REIKIN'}"),
                        $q->popup_menu(-name=>'apart_price_reikin_unit', 
                            -default=>$self->{_ref_hash}{'APART_PRICE_REIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                    ),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_hosyoukin'},"保証金: ")), 
                $q->td($q->textfield(-id=>'apart_price_hosyoukin', -name=>'apart_price_hosyoukin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE_HOSYOUKIN'}"),'円&nbsp;<small>(関西地域)</small>'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_sikibiki'},"敷引: ")), 
                $q->td($q->textfield(-id=>'apart_price_sikibiki', -name=>'apart_price_sikibiki', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE_SIKIBIKI'}"),'円&nbsp;<small>(関西地域)</small>'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_other'},"その他一時金: ")), 
                $q->td($q->textfield(-id=>'apart_price_other', -name=>'apart_price_other', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PRICE_OTHER'}"),'(ヶ月)'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_insurance'},"保険等: ")), 
                $q->td($q->textfield(-id=>'apart_price_insurance', -name=>'apart_price_insurance', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_INSURANCE'}"),''),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"間取り: "), 
                $q->td($q->popup_menu(-name=>'apart_madori', -default=>$self->{_ref_hash}{'APART_MADORI'},  
                    -values=>['','1R','1K','1DK','1LDK','2K','2DK','2LDK','3K','3DK','3LDK','4K','4DK','4LDK+'],
                    -labels=>{''=>'指定なし','1R'=>'ワンルーム','1K'=>'1K','1DK'=>'1DK','1LDK'=>'1LDK','2K'=>'2K','2DK'=>'2DK','2LDK'=>'2LDK','3K'=>'3K','3DK'=>'3DK','3LDK'=>'3LDK','4K'=>'4K','4DK'=>'4DK','4LDK+'=>'4LDK以上'})),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り内訳: "), 
                $q->td($q->textfield(-name=>'apart_madori_detail', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_MADORI_DETAIL'}"),'例：洋室２、和室１'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_square'},"面積(平米): ")), 
                $q->td($q->textfield(-id=>'apart_square', -name=>'apart_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_square_tubo'},"面積(坪): ")), 
                $q->td($q->textfield(-id=>'apart_square_tubo', -name=>'apart_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_SQUARE_TUBO'}"),'坪')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-class=>'required'},"物件種目: "), 
                $q->td(
                    $q->popup_menu(-name=>'apart_kind', -default=>$self->{_ref_hash}{'APART_KIND'},-values=>['','1','2','3','4'],-labels=>{''=>'指定なし','1'=>'アパート','2'=>'マンション','3'=>'一戸建て','4'=>'テラスハウス'}),
                ),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_building_structure'},"建物構造: ")), 
                $q->td($q->textfield(-id=>'apart_building_structure', -name=>'apart_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_BUILDING_STRUCTURE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_story'},"階建: ")), 
                $q->td($q->textfield(-id=>'apart_story', -name=>'apart_story', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_STORY'}"),'階建')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_floor'},"階: ")), 
                $q->td($q->textfield(-id=>'apart_floor', -name=>'apart_floor', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_FLOOR'}"),'階')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_age'},"築年月: ")), 
                $q->td($q->textfield(-id=>'apart_age', -name=>'apart_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_AGE'}"),'例： 2000/01'),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_condition'},"条件等: ")), 
                $q->td($q->textfield(-id=>'apart_condition', -name=>'apart_condition', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_CONDITION'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_torihikitaiyou'},"取引態様: ")), 
                $q->td($q->textfield(-id=>'apart_torihikitaiyou', -name=>'apart_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_TORIHIKITAIYOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_your_id'},"管理番号: ")), 
                $q->td($q->textfield(-id=>'apart_your_id', -name=>'apart_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_YOUR_ID'}"),'（既にあれば）'),
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(    
                            $q->th('位置'),
                            $q->td(
                                $q->checkbox(-id=>'apart_options_minami', -name=>'apart_options_minami', -label=>'南向き', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_MINAMI'}")
                            ),
                            $q->td($q->checkbox(-name=>'apart_options_kakubeya', -label=>'角部屋', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_KAKUBEYA'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        ),
                    
                        $q->Tr(
                            $q->th('設備'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_autolock', -label=>'オートロック', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_AUTOLOCK'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_elevator', -label=>'エレベータ', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_ELEVATOR'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_tvphone', -label=>'TVドアフォン', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_TVPHONE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_bathtoilet', -label=>'バス・トイレ別', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_BATHTOILET'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_aircon', -label=>'エアコン', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_AIRCON'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_oitaki', -label=>'追い焚き', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_OITAKI'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_gasconro', -label=>'ガスコンロ', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_GASCONRO'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_situnaisentakuki', -label=>'室内洗濯機置場', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_SITUNAISENTAKUKI'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_loft', -label=>'ロフト付き', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_LOFT'}")),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_flooring', -label=>'フローリング', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_FLOORING'}")),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_bs', -label=>'BSアンテナ', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_BS'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_cs', -label=>'CSアンテナ', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_CS'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_catv', -label=>'CATV', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_CATV'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_internet', -label=>'インターネット利用可', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_INTERNET'}"))
                        ),
                        $q->Tr(
                            $q->th('他'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_parking', -label=>'駐車場有', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_PARKING'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_bicycle', -label=>'駐輪場有', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_BICYCLE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_pet', -label=>'ペット相談', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_PET'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_instrument', -label=>'楽器相談', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_INSTRUMENT'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_jimusyoka', -label=>'事務所可', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_JIMUSYOKA'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_hosyounin', -label=>'保証人不要有', -checked=>"$self->{_ref_hash}{'APART_OPTIONS_HOSYOUNIN'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                            
                        )
                    )
                ),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_setubi'},"その他設備:")), 
                $q->td($q->textarea(-id=>'apart_setubi', -name=>'apart_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'APART_SETUBI'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_shougakkouku'},"小学校区: ")), 
                $q->td($q->textfield(-id=>'apart_shougakkouku', -name=>'apart_shougakkouku', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_SHOUGAKKOUKU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_cyuugakkouku'},"中学校区: ")), 
                $q->td($q->textfield(-id=>'apart_cyuugakkouku', -name=>'apart_cyuugakkouku', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_CYUUGAKKOUKU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_daigaku_list'},"近隣大学一覧:<br />(改行区切り)")), 
                $q->td($q->textarea(-id=>'apart_daigaku_list', -name=>'apart_daigaku_list', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'APART_DAIGAKU_LIST'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_ads_text'},"宣伝文句: ")),
                $q->td($q->textfield(-id=>'apart_ads_text', -name=>'apart_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$self->{_ref_hash}{'APART_ADS_TEXT'}")),
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},$q->label({for=>'apart_html_text'},"自由記入欄: <br />(HTML可) ")),
            #    $q->td($q->textarea(-id=>'apart_html_text', -name=>'apart_html_text', -default=>'', -rows=>7, -columns=>41, -value=>"$self->{_ref_hash}{'APART_HTML_TEXT'}")),
            #),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_outside'},"外観写真: ")), 
                $q->td($q->filefield(-id=>'apart_pics_outside', -name=>'apart_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>"$self->{_ref_hash}{'APART_PICS_OUTSIDE'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_inside'},"内観写真: ")), 
                $q->td($q->filefield(-id=>'apart_pics_inside', -name=>'apart_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PICS_INSIDE'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_madorizu'},"間取り図: ")), 
                $q->td($q->filefield(-id=>'apart_pics_madorizu', -name=>'apart_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PICS_MADORIZU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_tizu'},"地図: ")), 
                $q->td($q->filefield(-id=>'apart_pics_tizu', -name=>'apart_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_PICS_TIZU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_movie_file_url'},"動画URL:")), 
                $q->td($q->textfield(-id=>'apart_movie_file_url', -name=>'apart_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_MOVIE_FILE_URL'}"),'(http://＊＊＊)'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bikou'},"備考: ")), 
                $q->td($q->textarea(-id=>'apart_bikou', -name=>'apart_bikou', -default=>'', -rows=>3, -columns=>41, -value=>"$self->{_ref_hash}{'APART_BIKOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_nyuukyojiki'},"入居可能時期: ")), 
                $q->td($q->textfield(-id=>'apart_nyuukyojiki', -name=>'apart_nyuukyojiki', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_NYUUKYOJIKI'}"),''),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"他社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'apart_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'APART_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td($q->label({for=>'apart_kanrikaisya'},'会社名:')),
                            $q->td(
                    $q->textfield(-id=>'apart_kanrikaisya', -name=>'apart_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td($q->label({for=>'apart_kanrikaisya_contact'},'電話番号:')),
                            $q->td(
                    $q->textfield(-id=>'apart_kanrikaisya_contact', -name=>'apart_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'apart_ryuutuu',-label=>'流通可', -checked=>"$self->{_ref_hash}{'APART_RYUUTUU'}")
            #    )
            #),

            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_add'),
                    $q->hidden(-name => '_type', -value => 'rl'),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件', -checked=>""),
                    #'&nbsp;',
                    $q->checkbox(-name=>'apart_publish', -label=>'公開する', -checked=>"$self->{_ref_hash}{'APART_PUBLISHED'}"),
                    $q->submit(-name => 'add_new_object' ,-value => '新規追加', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.apart.apart_name.focus(); \n// --></script>";
    return $output;
}

sub create_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();

    #todo check each item
    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        if ($$ref_hash{'APART_USER_ID'} ne $self->{_app}->param('user_id')){
            $result .= '異なるユーザーIDでは登録できません。<br />';
        }
    }
    #
    $$ref_hash{'APART_USER_ID'} = $self->{_app}->param('user_id');

    if (!$$ref_hash{'APART_KIND'}) {$result .= '物件種目が入力されていません。<br />';}
    if (!$$ref_hash{'APART_NAME'}) {$result .= '物件名が入力されていません。<br />';}
    if (!$$ref_hash{'APART_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'APART_PRICE'}) {$result .= '賃料が入力されていません。<br />';}
    #if (!$$ref_hash{'APART_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}
    if (!$$ref_hash{'APART_MADORI'}) {$result .= '間取りが選択されていません。<br />';}
    if (!$$ref_hash{'APART_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'APART_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'APART_PRICE_KANRIHI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '管理費(円)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }


    if (!($$ref_hash{'APART_PRICE_SIKIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_REIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '礼金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_HOSYOUKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '保証金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_SIKIBIKI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷引の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_OTHER'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'その他一時金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_STORY'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階建ての数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_FLOOR'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'APART_PRICE'}) {
        my $str = $$ref_hash{'APART_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{3,6}))$/){

        }else{
            $result .= '賃料の値が不自然です。4桁から7桁以内の半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'APART_AGE'}){
        my $str = $$ref_hash{'APART_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />'; #/31
        }
    }
    if ($$ref_hash{'APART_SQUARE'}){
        unless($$ref_hash{'APART_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
            $result .= '面積は半角英数とピリオド（.）だけで入力してください。<br />'; #/31
        }
    }

    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'rl' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('apart_pics_outside')){
        my $fh = $q->upload('apart_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'APART_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('apart_pics_inside')){
        my $fh = $q->upload('apart_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'APART_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('apart_pics_madorizu')){
        my $fh = $q->upload('apart_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'APART_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('apart_pics_tizu')){
        my $fh = $q->upload('apart_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'APART_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
    }else{
        $$ref_hash{'APART_CREATED'} = REPS::Util->get_datetime_now();
        my %apart;
        my $db_apart_path = $self->{_app}->param('db_r_apart_path');
        my $num_keys = 1;
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%apart, 'MLDBM', $db_apart_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

        $num_keys = scalar keys (%apart);
        $num_keys = sprintf('%06d', $num_keys++);
        if (exists $apart{$num_keys}){
            #count up and add again. This could happen when export and import data.
            #$result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
            while (exists $apart{$num_keys}) {
                $num_keys++;
                if ($num_keys >= 999999) {die "Reached lmit.";};
            }
        }
        if (!defined $apart{$num_keys}){
            $$ref_hash{'APART_ID'} = $num_keys;
            eval {
                if ($q->param('apart_pics_outside')){
                    my $tmp = $$ref_hash{'APART_PICS_OUTSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_OUTSIDE'},$dir.$tmp);
                    $$ref_hash{'APART_PICS_OUTSIDE'} =  'rl' . '/'.$tmp;
                    if ($$ref_hash{'APART_PICS_OUTSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'APART_PICS_OUTSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'APART_PICS_OUTSIDE_THUMB'} = 'rl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('apart_pics_inside')){
                    my $tmp = $$ref_hash{'APART_PICS_INSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_INSIDE'},$dir.$tmp);
                    $$ref_hash{'APART_PICS_INSIDE'} = 'rl' . '/'.$tmp;
                    if ($$ref_hash{'APART_PICS_INSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'APART_PICS_INSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_INSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'APART_PICS_INSIDE_THUMB'} = 'rl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('apart_pics_madorizu')){
                    my $tmp = $$ref_hash{'APART_PICS_MADORIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_MADORIZU'},$dir.$tmp);
                    $$ref_hash{'APART_PICS_MADORIZU'} = 'rl' . '/'.$tmp;
                    if ($$ref_hash{'APART_PICS_MADORIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'APART_PICS_MADORIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'APART_PICS_MADORIZU_THUMB'} = 'rl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            eval {
                if ($q->param('apart_pics_tizu')){
                    my $tmp = $$ref_hash{'APART_PICS_TIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_TIZU'},$dir.$tmp);
                    $$ref_hash{'APART_PICS_TIZU'} = 'rl' . '/'.$tmp;
                    if ($$ref_hash{'APART_PICS_TIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'APART_PICS_TIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_TIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'APART_PICS_TIZU_THUMB'} = 'rl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            $apart{$num_keys} = $ref_hash;
            $self->{_ref_hash} = $ref_hash;

        }else{
            $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。(ID が存在していますが、データが空です。既に削除されている可能性があります)</p></div>";
        }

        untie %apart;
umask($old);
#if recommend
#         my %hash_sp=(
#                 'APART_ID' => $$ref_hash{'APART_ID'},
#                 'APART_NAME' => $$ref_hash{'APART_NAME'},
#                 'APART_STATION_1' => $$ref_hash{'APART_STATION_1'},
#                 'APART_STATION_2' => $$ref_hash{'APART_STATION_2'},
#                 'APART_LOCATION' =>$$ref_hash{'APART_LOCATION'},
#                 'APART_PRICE' => REPS::Util->insert_comma($$ref_hash{'APART_PRICE'}),
#                 'APART_BUS_MINUTES_1' => $$ref_hash{'APART_BUS_MINUTES_1'},
#                 'APART_WALK_MINUTES_1' => $$ref_hash{'APART_WALK_MINUTES_1'},
#                 'APART_PRICE_KANRIHI' => REPS::Util->insert_comma($$ref_hash{'APART_PRICE_KANRIHI'}),
#                 'APART_PRICE_SIKIKIN' => $$ref_hash{'APART_PRICE_SIKIKIN'},
#                 'APART_PRICE_SIKIKIN_UNIT' => $$ref_hash{'APART_PRICE_SIKIKIN_UNIT'},
#                 'APART_PRICE_REIKIN' => $$ref_hash{'APART_PRICE_REIKIN'},
#                 'APART_PRICE_REIKIN_UNIT' => $$ref_hash{'APART_PRICE_REIKIN_UNIT'},
#                 'APART_MADORI' => $$ref_hash{'APART_MADORI'},
#                 'APART_KIND' => $$ref_hash{'APART_KIND'},
#                 'APART_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_OUTSIDE_THUMB'},
#                 'APART_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_MADORIZU_THUMB'},
#                 'APART_ADS_TEXT' => $$ref_hash{'APART_ADS_TEXT'}
#             );
#         if ($hash_sp{'APART_KIND'}==1){
#             $hash_sp{'APART_KIND'}='アパート';
#         }elsif($hash_sp{'APART_KIND'}==2){
#             $hash_sp{'APART_KIND'}='マンション';
#         }elsif($hash_sp{'APART_KIND'}==3){
#             $hash_sp{'APART_KIND'}='一戸建て';
#         }elsif($hash_sp{'APART_KIND'}==4){
#             $hash_sp{'APART_KIND'}='テラスハウス';
#         }
# 
#         if ($hash_sp{'APART_PRICE_SIKIKIN_UNIT'}){
#             if ($hash_sp{'APART_PRICE_SIKIKIN_UNIT'} == 1){
#                 $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#             }elsif($hash_sp{'APART_PRICE_SIKIKIN_UNIT'} == 2){
#                 $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = '円';
#             }elsif($hash_sp{'APART_PRICE_SIKIKIN_UNIT'} == 3){
#                 $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = '万円';
#             }else{
#                 $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#             }
#         }else{
#             $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#         }
#         if ($hash_sp{'APART_PRICE_REIKIN_UNIT'}){
#             if ($hash_sp{'APART_PRICE_REIKIN_UNIT'} == 1){
#                 $hash_sp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#             }elsif($hash_sp{'APART_PRICE_REIKIN_UNIT'} == 2){
#                 $hash_sp{'APART_PRICE_REIKIN_UNIT'} = '円';
#             }elsif($hash_sp{'APART_PRICE_REIKIN_UNIT'} == 3){
#                 $hash_sp{'APART_PRICE_REIKIN_UNIT'} = '万円';
#             }else{
#                 $hash_sp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#             }
#         }else{
#             $hash_sp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#         }
# 
#         #add to specail
#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'APART_PUBLISHED'}){
#                 #Special
#                 require REPS::CMS::Special;
#                 my $special = REPS::CMS::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_r_apart_special_path'),
#                                 $$ref_hash{'APART_ID'},
#                                 \%hash_sp
#                             );
# 
#                 $special->add_special();
#             }else{
#                 $result .="<div class=\"information\"><p>更新されましたが、非公開ですので、お勧め物件には登録できません。</p></div>";
#             }
#         }
#end recommend


    }
    return $result;
}

sub get_Realestate_List{
    my ($self,$sort_by,$off_set,$items_per_page,$only_this_user) = @_;

    my %sort_hash = ();
    my %tmp;
    my @loop_data;
    my $count = 0;

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    if (-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;#

        my @sort_keys;
        while ( my ($key, $value) = each(%apart) ) {
            if ((exists $apart{$key}) && (defined $apart{$key}) && ($value)){

                my %tmp = %$value;
                if (exists $tmp{'APART_USER_ID'}){
                    if ($only_this_user){
                        if ($only_this_user ne $tmp{'APART_USER_ID'}){
                            next;
                        }
                    }

                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($tmp{'APART_USER_ID'} ne $self->{_app}->param('user_id')) {
                                next;
                            }
                        }
                    }else{
                        if (!$only_this_user){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($tmp{'APART_USER_ID'} ne $self->{_app}->param('user_id')) {
                                    next;
                                }
                            }
                        }
                    }
    #                if ($tmp{'APART_USER_ID'} eq $self->{_app}->param('user_id')){
                        #sort
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'name'){
                                $sort_hash{$key} = $tmp{'APART_NAME'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'APART_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'APART_LAST_UPDATED'})&&($tmp{'APART_LAST_UPDATED'})){

                                    $sort_hash{$key} = $tmp{'APART_LAST_UPDATED'};
                                    
                                }else{
    
                                    $sort_hash{$key} = $tmp{'APART_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'APART_LOCATION'};
                            }
                        }else{
#                            my %hash = (
#                                'APART_ID' => "$key",
#                                'APART_PUBLISHED' => $tmp{'APART_PUBLISHED'},
#                                'APART_NAME' => $tmp{'APART_NAME'},
#                                'APART_LOCATION' => $tmp{'APART_LOCATION'},
#                                'APART_PRICE' => REPS::Util->insert_comma($tmp{'APART_PRICE'}),
#                                'APART_ROOM_NUMBER' => $tmp{'APART_ROOM_NUMBER'},
#                                'APART_CREATED' => REPS::Util->get_date_as_string($tmp{'APART_CREATED'}),
#                                'APART_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'APART_LAST_UPDATED'}),
#                            );
#                            push(@loop_data, \%hash);
                            push(@sort_keys, $key);
                        }
    #                }
                }else{
                    #todo app user id not exists
                }
            }
        }

        
        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date')|| ($sort_by eq 'location')){
            
            if (($sort_by eq 'name') || ($sort_by eq 'location')){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
            }elsif($sort_by eq 'date'){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
                @sort_keys = reverse @sort_keys;
            }else{
                @sort_keys = sort {$sort_hash{$a} <=> $sort_hash{$b} || length($a) <=> length($b) || $a cmp $b} keys %sort_hash;
            }
        }else{

        }
        $count = @sort_keys;
        #paging
        if (!$off_set){$off_set=0;}
        @sort_keys = splice( @sort_keys , $off_set,$items_per_page);
        #@sort_keys = splice( @sort_keys , 4,10);

        foreach (@sort_keys){

            my %tmp = %{$apart{$_}};

            my $new = '';
            my $updated = '';
            if ($tmp{'APART_CREATED'}){
                my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'APART_CREATED'});
                if ($dd <= 30) {
                    $new = 'on';
                }
                if ((!$new) && ($tmp{'APART_LAST_UPDATED'})){
                    $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'APART_LAST_UPDATED'});
                    if ($dd <= 10) {
                        $updated = 'on';
                    }
                }
            }

            my %hash = (
                'APART_ID' => "$_",
                'APART_PUBLISHED' => $tmp{'APART_PUBLISHED'},
                'APART_IS_SPECIAL' => $tmp{'APART_IS_SPECIAL'},
                'APART_NAME' => $tmp{'APART_NAME'},
                'APART_LOCATION' => $tmp{'APART_LOCATION'},
                'APART_PRICE' => REPS::Util->insert_comma($tmp{'APART_PRICE'}),
                'APART_ROOM_NUMBER' => $tmp{'APART_ROOM_NUMBER'},
                'APART_CREATED' => REPS::Util->get_date_as_string($tmp{'APART_CREATED'}),
                'APART_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'APART_LAST_UPDATED'}),
                    'APART_NEW' => $new,
                    'APART_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
            );
    
            push(@loop_data, \%hash);
        }

        untie %apart;
    }


    return \@loop_data,$count;
}

sub get_Realestate {
    my $self = shift;
    my $apart_id = $_[0];

    my $ref_hash;
    my %hash;
    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');

    unless ($apart_id =~ /[0-9]{6,10}/g){Carp::croak "IDの形式が不正です。";}

    if (-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        if (exists $apart{$apart_id} ) {
            if ((defined $apart{$apart_id}) && ($apart{$apart_id})){
                if ($self->{_app}->param('user_isAdmin') != 1){
                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($apart{$apart_id}{'APART_USER_ID'} ne $self->{_app}->param('user_id')) {
                            untie %apart;
                            Carp::croak "The ID does not belong to you.";
                        }
                    }
                }
                $ref_hash = $apart{$apart_id};
                
                #%hash = %$ref_hash;
    #            if ($self->{_app}->param('user_id') eq $$ref_hash{'APART_USER_ID'}){
    
                    $self->{_ref_hash} = $apart{$apart_id};
                    
    #            }else{
    #                untie %apart;
    #                die 'the ID does not belong to you.';
    #            }
            }else{
                untie %apart;
                return 0;
                #die "The ID [$apart_id] has no value. Possibly deleted.";
            }
        }else{
            untie %apart;
            return 0;
            #die "The ID [$apart_id] does not exists.";
        }
        untie %apart;
    }

    return 1;
}

sub get_Edit_Realestate_Form{
    my $self = shift;
    my $ref_hash = $self->{_ref_hash};
    my $output = '';
    my $q = $self->{_app}->query();

    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'APART_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $output = "<div class=\"warning\"><p>他のユーザーの物件はアクセス出来ません。 </p></div>";
                return $output;
            }
        }
    }
    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'apart');

    $q->delete('apart_kind');

    my $ifView = '';
    if ($$ref_hash{'APART_IS_SPECIAL'}){
        $ifView .= '<img src="'.$self->{_app}->cfg('static_url').'icons/16-heart-gold-m.png" width="16" height="16" />';
    }
    if ($$ref_hash{'APART_PUBLISHED'}){
        $ifView .= "&nbsp;<a href=\"./search.cgi?_mode=mode_detail&_type=rl&_object_id=$$ref_hash{'APART_ID'}\" target=\"_blank\">公開ページ閲覧</a>";
    }


    #dummy var for delete pics
    $output .= $q->hidden(-name => 'delete_pic', -value => '');

    my $ifPicsOutside = '';
    if ($$ref_hash{'APART_PICS_OUTSIDE'}){
        if ($$ref_hash{'APART_PICS_OUTSIDE_THUMB'}){
            $ifPicsOutside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_OUTSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_OUTSIDE\');" />';

        }else{
            $ifPicsOutside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_OUTSIDE'}."\">外観画像</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_OUTSIDE\');" />';
        }
    }
    my $ifPicsInside = '';
    if ($$ref_hash{'APART_PICS_INSIDE'}){
        if ($$ref_hash{'APART_PICS_INSIDE_THUMB'}){
            $ifPicsInside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_INSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_INSIDE\');" />';
        }else{
            $ifPicsInside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_INSIDE'}."\">内観画像</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_INSIDE\');" />';
        }
    }
    my $ifMadorizu = '';
    if ($$ref_hash{'APART_PICS_MADORIZU'}){
        if ($$ref_hash{'APART_PICS_MADORIZU_THUMB'}){
            $ifMadorizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_MADORIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_MADORIZU\');" />';
        }else{
            $ifMadorizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_MADORIZU'}."\">間取り図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_MADORIZU\');" />';
        }
    }

    my $ifTizu = '';
    if ($$ref_hash{'APART_PICS_TIZU'}){
        if ($$ref_hash{'APART_PICS_TIZU_THUMB'}){
            $ifTizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_TIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_TIZU\');" />';
        }else{
            $ifTizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_TIZU'}."\">地図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'APART_PICS_TIZU\');" />';
        }
    }

    $output .= $q-> table( {-border => 1,-class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"物件番号："), 
                $q->th('[RL'.$$ref_hash{'APART_ID'}.']'.$ifView), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_name'},"物件名: ")), 
                $q->td($q->textfield(-id=>'apart_name', -name=>'apart_name', -default=>'',-size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_NAME'}")), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_room_number'},"部屋番号: ")), 
                $q->td($q->textfield(-id=>'apart_room_number', -name=>'apart_room_number', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_ROOM_NUMBER'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_location'},"物件所在地: ")), 
                $q->td($q->textfield(-id=>'apart_location', -name=>'apart_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_LOCATION'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_station1'},"最寄駅 1: ")), 
                $q->td($q->textfield(-id=>'apart_station1', -name=>'apart_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_STATION_1'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_walk_minutes'},"駅徒歩 1: ")), 
                $q->td($q->textfield(-id=>'apart_walk_minutes', -name=>'apart_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'APART_WALK_MINUTES_1'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus'},"バス停名 1: ")), 
                $q->td($q->textfield(-id=>'apart_bus', -name=>'apart_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_BUS_1'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus_minutes'},"バス分 1: ")), 
                $q->td($q->textfield(-name=>'apart_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'APART_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_buswalk_minutes'},"停歩 1: ")), 
                $q->td($q->textfield(-id=>'apart_buswalk_minutes', -name=>'apart_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'APART_BUSWALK_MINUTES_1'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_station2'},"最寄駅 2: ")), 
                $q->td($q->textfield(-id=>'apart_station2', -name=>'apart_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_STATION_2'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_walk_minutes2'},"駅徒歩 2: ")), 
                $q->td($q->textfield(-id=>'apart_walk_minutes2', -name=>'apart_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'APART_WALK_MINUTES_2'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus2'},"バス停名 2: ")), 
                $q->td($q->textfield(-id=>'apart_bus2', -name=>'apart_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_BUS_2'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bus_minutes2'},"バス分 2: ")), 
                $q->td($q->textfield(-id=>'apart_bus_minutes2', -name=>'apart_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'APART_BUS_MINUTES_2'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_buswalk_minutes2'},"停歩 2: ")), 
                $q->td($q->textfield(-id=>'apart_buswalk_minutes2', -name=>'apart_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'APART_BUSWALK_MINUTES_2'}"),'分'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_price'},"賃料: ")), 
                $q->td($q->textfield(-id=>'apart_price', -name=>'apart_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE'}"),'円'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_kanrihi'},"管理費等: ")), 
                $q->td($q->textfield(-id=>'apart_price_kanrihi', -name=>'apart_price_kanrihi', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE_KANRIHI'}"),'円'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_sikikin'},"敷金: ")), 
                $q->td($q->textfield(-id=>'apart_price_sikikin', -name=>'apart_price_sikikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE_SIKIKIN'}"),
                        $q->popup_menu(-name=>'apart_price_sikikin_unit', 
                            -default=>$$ref_hash{'APART_PRICE_SIKIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                    ),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_reikin'},"礼金: ")), 
                $q->td($q->textfield(-id=>'apart_price_reikin', -name=>'apart_price_reikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE_REIKIN'}"),
                        $q->popup_menu(-name=>'apart_price_reikin_unit', 
                            -default=>$$ref_hash{'APART_PRICE_REIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})
                ),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_hosyoukin'},"保証金: ")), 
                $q->td($q->textfield(-id=>'apart_price_hosyoukin', -name=>'apart_price_hosyoukin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE_HOSYOUKIN'}"),'円&nbsp;<small>(関西地域)</small>'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_sikibiki'},"敷引: ")), 
                $q->td($q->textfield(-id=>'apart_price_sikibiki', -name=>'apart_price_sikibiki', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE_SIKIBIKI'}"),'円&nbsp;<small>(関西地域)</small>'),
            ),
            $q->Tr( {-align=>'left'},
                $q->td({-align=>'right'},$q->label({for=>'apart_price_other'},"その他一時金: ")), 
                $q->td($q->textfield(-id=>'apart_price_other', -name=>'apart_price_other', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_PRICE_OTHER'}"),'(ヶ月)'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_price_insurance'},"保険等: ")), 
                $q->td($q->textfield(-id=>'apart_price_insurance', -name=>'apart_price_insurance', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_INSURANCE'}"),''),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"間取り: "), 
                $q->td($q->popup_menu(-name=>'apart_madori', -default=>"$$ref_hash{'APART_MADORI'}",  
                -values=>['','1R','1K','1DK','1LDK','2K','2DK','2LDK','3K','3DK','3LDK','4K','4DK','4LDK+'],
                -labels=>{''=>'指定なし','1R'=>'ワンルーム','1K'=>'1K','1DK'=>'1DK','1LDK'=>'1LDK','2K'=>'2K','2DK'=>'2DK','2LDK'=>'2LDK','3K'=>'3K','3DK'=>'3DK','3LDK'=>'3LDK','4K'=>'4K','4DK'=>'4DK','4LDK+'=>'4LDK以上'}))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_madori_detail'},"間取り内訳: ")), 
                $q->td($q->textfield(-id=>'apart_madori_detail', -name=>'apart_madori_detail', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_MADORI_DETAIL'}"),'例：洋室２、和室１'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_square'},"面積(平米): ")), 
                $q->td($q->textfield(-id=>'apart_square', -name=>'apart_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_SQUARE'}"),'m&sup2'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_square_tubo'},"面積(坪): ")), 
                $q->td($q->textfield(-id=>'apart_square_tubo', -name=>'apart_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_SQUARE_TUBO'}"),'坪')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-class=>'required'},"物件種目: "), 
                $q->td(
                    $q->popup_menu(-name=>'apart_kind', -default=>"$$ref_hash{'APART_KIND'}",-values=>['',1,2,3,4],-labels=>{''=>'指定なし','1'=>'アパート','2'=>'マンション','3'=>'一戸建て','4'=>'テラスハウス'}),
                ),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_building_structure'},"建物構造: ")), 
                $q->td($q->textfield(-id=>'apart_building_structure', -name=>'apart_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_BUILDING_STRUCTURE'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_story'},"階建: ")), 
                $q->td($q->textfield(-id=>'apart_story', -name=>'apart_story', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_STORY'}"),'階建')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_floor'},"階: ")), 
                $q->td($q->textfield(-id=>'apart_floor', -name=>'apart_floor', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_FLOOR'}"),'階')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_age'},"築年月: ")), 
                $q->td($q->textfield(-id=>'apart_age', -name=>'apart_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$$ref_hash{'APART_AGE'}"),'例： 2000/01'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_condition'},"条件等: ")), 
                $q->td($q->textfield(-id=>'apart_condition', -name=>'apart_condition', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_CONDITION'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},$q->label({for=>'apart_torihikitaiyou'},"取引態様: ")), 
                $q->td($q->textfield(-id=>'apart_torihikitaiyou', -name=>'apart_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'APART_TORIHIKITAIYOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_your_id'},"管理番号: ")), 
                $q->td($q->textfield(-id=>'apart_your_id', -name=>'apart_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_YOUR_ID'}"),'(既にあれば)'),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},

                        $q->Tr(    
                            $q->th('位置'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_minami', -label=>'南向き', -checked=>"$$ref_hash{'APART_OPTIONS_MINAMI'}")
                            ),
                            $q->td($q->checkbox(-name=>'apart_options_kakubeya', -label=>'角部屋', -checked=>"$$ref_hash{'APART_OPTIONS_KAKUBEYA'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_autolock', -label=>'オートロック', -checked=>"$$ref_hash{'APART_OPTIONS_AUTOLOCK'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_elevator', -label=>'エレベータ', -checked=>"$$ref_hash{'APART_OPTIONS_ELEVATOR'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_tvphone', -label=>'TVドアフォン', -checked=>"$$ref_hash{'APART_OPTIONS_TVPHONE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_bathtoilet', -label=>'バス・トイレ別', -checked=>"$$ref_hash{'APART_OPTIONS_BATHTOILET'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_aircon', -label=>'エアコン', -checked=>"$$ref_hash{'APART_OPTIONS_AIRCON'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_oitaki', -label=>'追い焚き', -checked=>"$$ref_hash{'APART_OPTIONS_OITAKI'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_gasconro', -label=>'ガスコンロ', -checked=>"$$ref_hash{'APART_OPTIONS_GASCONRO'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_situnaisentakuki', -label=>'室内洗濯機置場', -checked=>"$$ref_hash{'APART_OPTIONS_SITUNAISENTAKUKI'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_loft', -label=>'ロフト付き', -checked=>"$$ref_hash{'APART_OPTIONS_LOFT'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_flooring', -label=>'フローリング', -checked=>"$$ref_hash{'APART_OPTIONS_FLOORING'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_bs', -label=>'BSアンテナ', -checked=>"$$ref_hash{'APART_OPTIONS_BS'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_cs', -label=>'CSアンテナ', -checked=>"$$ref_hash{'APART_OPTIONS_CS'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_catv', -label=>'CATV', -checked=>"$$ref_hash{'APART_OPTIONS_CATV'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_internet', -label=>'インターネット利用可', -checked=>"$$ref_hash{'APART_OPTIONS_INTERNET'}"))
                        ),
                        $q->Tr(
                            $q->th('他'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_parking', -label=>'駐車場有', -checked=>"$$ref_hash{'APART_OPTIONS_PARKING'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_bicycle', -label=>'駐輪場有', -checked=>"$$ref_hash{'APART_OPTIONS_BICYCLE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_pet', -label=>'ペット相談', -checked=>"$$ref_hash{'APART_OPTIONS_PET'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_instrument', -label=>'楽器相談', -checked=>"$$ref_hash{'APART_OPTIONS_INSTRUMENT'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_jimusyoka', -label=>'事務所可', -checked=>"$$ref_hash{'APART_OPTIONS_JIMUSYOKA'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'apart_options_hosyounin', -label=>'保証人不要有', -checked=>"$$ref_hash{'APART_OPTIONS_HOSYOUNIN'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        )
                    )
                ),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_shougakkouku'},"小学校区: ")), 
                $q->td($q->textfield(-id=>'apart_shougakkouku', -name=>'apart_shougakkouku', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_SHOUGAKKOUKU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_cyuugakkouku'},"中学校区: ")), 
                $q->td($q->textfield(-id=>'apart_cyuugakkouku', -name=>'apart_cyuugakkouku', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_CYUUGAKKOUKU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_daigaku_list'},"近隣大学一覧:<br />(改行区切り)")), 
                $q->td($q->textarea(-id=>'apart_daigaku_list', -name=>'apart_daigaku_list', -default=>'', -rows=>2, -columns=>41,  -value=>"$$ref_hash{'APART_DAIGAKU_LIST'}")),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_setubi'},"その他設備: ")), 
                $q->td($q->textarea(-id=>'apart_setubi', -name=>'apart_setubi', -default=>'', -rows=>2, -columns=>41,  -value=>"$$ref_hash{'APART_SETUBI'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_ads_text'},"宣伝文句: ")), 
                $q->td($q->textfield(-id=>'apart_ads_text', -name=>'apart_ads_text', -default=>'', -size=>50,-maxlength=>250, -value=>"$$ref_hash{'APART_ADS_TEXT'}")),
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},$q->label({for=>'apart_html_text'},"自由記入欄: <br />(HTML可) ")),
            #    $q->td($q->textarea(-id=>'apart_html_text', -name=>'apart_html_text', -default=>'', -rows=>7, -columns=>41, -value=>"$$ref_hash{'APART_HTML_TEXT'}")),
            #),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_outside'},"外観写真: ")), 
                $q->td($q->filefield(-id=>'apart_pics_outside', -name=>'apart_pics_outside', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifPicsOutside",
                    $q->hidden(-name => '_apart_pics_outside', -value => "$$ref_hash{'APART_PICS_OUTSIDE'}"),
                    $q->hidden(-name => '_apart_pics_outside_thumb', -value => "$$ref_hash{'APART_PICS_OUTSIDE_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_inside'},"内観写真: ")), 
                $q->td($q->filefield(-id=>'apart_pics_inside', -name=>'apart_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifPicsInside",
                    $q->hidden(-name => '_apart_pics_inside', -value => "$$ref_hash{'APART_PICS_INSIDE'}"),
                    $q->hidden(-name => '_apart_pics_inside_thumb', -value => "$$ref_hash{'APART_PICS_INSIDE_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_madorizu'},"間取り図: ")), 
                $q->td($q->filefield(-id=>'apart_pics_madorizu', -name=>'apart_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifMadorizu",
                    $q->hidden(-name => '_apart_pics_madorizu', -value => "$$ref_hash{'APART_PICS_MADORIZU'}"),
                    $q->hidden(-name => '_apart_pics_madorizu_thumb', -value => "$$ref_hash{'APART_PICS_MADORIZU_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_pics_tizu'},"地図: ")), 
                $q->td($q->filefield(-id=>'apart_pics_tizu', -name=>'apart_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifTizu",
                    $q->hidden(-name => '_apart_pics_tizu', -value => "$$ref_hash{'APART_PICS_TIZU'}"),
                    $q->hidden(-name => '_apart_pics_tizu_thumb', -value => "$$ref_hash{'APART_PICS_TIZU_THUMB'}")),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL:"), 
                $q->td($q->textfield(-name=>'apart_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'APART_MOVIE_FILE_URL'}"),'(http://＊＊＊)'),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_bikou'},"備考: ")), 
                $q->td($q->textarea(-id=>'apart_bikou', -name=>'apart_bikou', -default=>'', -rows=>3, -columns=>41,  -value=>"$$ref_hash{'APART_BIKOU'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},$q->label({for=>'apart_nyuukyojiki'},"入居可能時期: ")), 
                $q->td($q->textfield(-id=>'apart_nyuukyojiki', -name=>'apart_nyuukyojiki', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'APART_NYUUKYOJIKI'}"),''),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"他社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'apart_tasyakanri',-label=>'他社管理物件', -checked=>"$$ref_hash{'APART_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td($q->label({for=>'apart_kanrikaisya'},'会社名:')),
                            $q->td(
                    $q->textfield(-id=>'apart_kanrikaisya', -name=>'apart_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'APART_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td($q->label({for=>'apart_kanrikaisya_contact'},'電話番号:')),
                            $q->td(
                    $q->textfield(-id=>'apart_kanrikaisya_contact', -name=>'apart_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'APART_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'apart_ryuutuu',-label=>'流通可', -checked=>"$$ref_hash{'APART_RYUUTUU'}"),
            #    ),
            #),


            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_edit'),
                    $q->hidden(-name => '_type', -value => 'rl'),
                    $q->hidden(-name => '_object_id', -value => "$$ref_hash{'APART_ID'}"),
                    $q->hidden(-name => 'apart_created', -value => "$$ref_hash{'APART_CREATED'}"),
                    $q->hidden(-name => 'add_to_special', -value => "$$ref_hash{'APART_IS_SPECIAL'}"),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件', -checked=>"$self->{_ref_hash}{'APART_IS_SPECIAL'}"),
                    #'&nbsp;',
                    $q->checkbox(-name=>'apart_publish', -label=>'公開する', -checked=>"$$ref_hash{'APART_PUBLISHED'}"),
                    $q->submit(-name => 'edit_object' ,-value => '編集更新', -class=>'submit')
                )
            )
        );

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.apart.apart_name.focus(); \n// --></script>";

    return $output;
}

sub update_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();

    #todo check each item
    unless ($$ref_hash{'APART_ID'}=~ /[0-9]{6,10}/){$result .= 'IDの形式が不正です。<br />';}
#    if ($$ref_hash{'APART_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'APART_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $result = "<div class=\"warning\"><p>他のユーザーの物件は更新できません。更新されませんでした。</p></div>";
                return $result;
            }
        }
    }
    if (!$$ref_hash{'APART_KIND'}) {$result .= '物件種目が入力されていません。<br />';}
    if (!$$ref_hash{'APART_NAME'}) {$result .= '物件名が入力されていません。<br />';}
    if (!$$ref_hash{'APART_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'APART_PRICE'}) {$result .= '賃料が入力されていません。<br />';}
    #if (!$$ref_hash{'APART_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}
    if (!$$ref_hash{'APART_MADORI'}) {$result .= '間取りが選択されていません。<br />';}
    if (!$$ref_hash{'APART_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'APART_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'APART_PRICE_KANRIHI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '管理費(円)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'APART_PRICE_SIKIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_REIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '礼金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_HOSYOUKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '保証金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_SIKIBIKI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷引の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_PRICE_OTHER'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'その他一時金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_STORY'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階建ての数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'APART_FLOOR'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }



    if ($$ref_hash{'APART_PRICE'}) {
        my $str = $$ref_hash{'APART_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{3,6}))$/){

        }else{
            $result .= '賃料の値が不自然です。4桁から7桁以内の半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'APART_AGE'}){
        my $str = $$ref_hash{'APART_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />';
        }
    }
    if ($$ref_hash{'APART_SQUARE'}){
        unless($$ref_hash{'APART_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
            $result .= '面積は半角英数とピリオド（.）だけで入力してください。<br />'; #/31
        }
    }

    if ($q->param('delete_pic')){
        if ($q->param('delete_pic') =~ /^(\w)+$/) {
            #check if value does not contain "." and "/"
            if (-e $self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory').$$ref_hash{$q->param('delete_pic')}) {
                if (unlink($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory').$$ref_hash{$q->param('delete_pic')})){
                 #or die "Can't delete $FILENAME: $!\n";
                    $$ref_hash{$q->param('delete_pic')} = '';
                }
            }else{
                $$ref_hash{$q->param('delete_pic')} = '';
            }
            if (-e $self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory').$$ref_hash{$q->param('delete_pic').'_THUMB'}) {
                if (unlink($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory').$$ref_hash{$q->param('delete_pic').'_THUMB'})){
                    $$ref_hash{$q->param('delete_pic').'_THUMB'} = '';
                }
            }else{
                $$ref_hash{$q->param('delete_pic')} = '';
            }
        }
    }


    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'rl' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('apart_pics_outside')){
        my $fh = $q->upload('apart_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'APART_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_OUTSIDE'} = $saved->{'_image'};
    }
   if ($q->param('apart_pics_inside')){
        my $fh = $q->upload('apart_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'APART_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('apart_pics_madorizu')){
        my $fh = $q->upload('apart_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'APART_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('apart_pics_tizu')){
        my $fh = $q->upload('apart_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'APART_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'APART_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />更新されませんでした。</p></div>";
    }else{
        $$ref_hash{'APART_LAST_UPDATED'} = REPS::Util->get_datetime_now();
        my %apart;
        my $db_apart_path = $self->{_app}->param('db_r_apart_path');

        tie (%apart, 'MLDBM', $db_apart_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

        if (!$apart{$$ref_hash{'APART_ID'}}){
            $result = "<div class=\"warning\"><p>別のユーザー又は別の画面で削除された可能性があります。<br />更新されませんでした。</p></div>";
            untie %apart;
            return $result;
        }

        if ($self->{_app}->param('user_isAdmin') != 1){
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($apart{$$ref_hash{'APART_ID'}}{'APART_USER_ID'} ne $self->{_app}->param('user_id')){
                    $result = "<div class=\"warning\"><p>他のユーザーの物件は更新出来ません。 </p></div>";
                    untie %apart;
                    return $result;
                }
            }
        }
#        if ($apart{$$ref_hash{'APART_ID'}}{'APART_USER_ID'} eq $self->{_app}->param('user_id')){
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
        my $num_keys = REPS::Util->de_taint($$ref_hash{'APART_ID'});

        eval {
            if ($q->param('apart_pics_outside')){
                my $tmp = $$ref_hash{'APART_PICS_OUTSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g;
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_OUTSIDE'},$dir.$tmp);
                $$ref_hash{'APART_PICS_OUTSIDE'} = 'rl' . '/'.$tmp;

                my $tmp2 = $$ref_hash{'APART_PICS_OUTSIDE_THUMB'};
                $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                $$ref_hash{'APART_PICS_OUTSIDE_THUMB'} = 'rl' . '/'.$tmp2;
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('apart_pics_inside')){
                my $tmp = $$ref_hash{'APART_PICS_INSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_INSIDE'},$dir.$tmp);
                $$ref_hash{'APART_PICS_INSIDE'} = 'rl' . '/'.$tmp;
                if ($$ref_hash{'APART_PICS_INSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'APART_PICS_INSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_INSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'APART_PICS_INSIDE_THUMB'} = 'rl' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('apart_pics_madorizu')){
                my $tmp = $$ref_hash{'APART_PICS_MADORIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_MADORIZU'},$dir.$tmp);
                $$ref_hash{'APART_PICS_MADORIZU'} = 'rl' . '/'.$tmp;
                if ($$ref_hash{'APART_PICS_MADORIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'APART_PICS_MADORIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'APART_PICS_MADORIZU_THUMB'} = 'rl' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('apart_pics_tizu')){
                my $tmp = $$ref_hash{'APART_PICS_TIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_TIZU'},$dir.$tmp);
                $$ref_hash{'APART_PICS_TIZU'} = 'rl' . '/'.$tmp;
                if ($$ref_hash{'APART_PICS_TIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'APART_PICS_TIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'APART_PICS_TIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'APART_PICS_TIZU_THUMB'} = 'rl' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        if (!$apart{$$ref_hash{'APART_ID'}}{'APART_USER_ID'}){
            $$ref_hash{'APART_USER_ID'} = $self->{_app}->param('user_id');
        }else{
            $$ref_hash{'APART_USER_ID'} = $apart{$$ref_hash{'APART_ID'}}{'APART_USER_ID'};
        }

        $apart{$$ref_hash{'APART_ID'}} = $ref_hash;

        untie %apart;


        #update recommend
        if ($$ref_hash{'APART_IS_SPECIAL'}) {
            $self->{_app}->recommend_static_write_file();
        }


#if recomend
# 
#          my %hash_sp=(
#                  'APART_ID' => $$ref_hash{'APART_ID'},
#                  'APART_NAME' => $$ref_hash{'APART_NAME'},
#                  'APART_STATION_1' => $$ref_hash{'APART_STATION_1'},
#                  'APART_STATION_2' => $$ref_hash{'APART_STATION_2'},
#                  'APART_LOCATION' =>$$ref_hash{'APART_LOCATION'},
#                  'APART_PRICE' => REPS::Util->insert_comma($$ref_hash{'APART_PRICE'}),
#                  'APART_BUS_MINUTES_1' => $$ref_hash{'APART_BUS_MINUTES_1'},
#                  'APART_WALK_MINUTES_1' => $$ref_hash{'APART_WALK_MINUTES_1'},
#                  'APART_PRICE_KANRIHI' => REPS::Util->insert_comma($$ref_hash{'APART_PRICE_KANRIHI'}),
#                  'APART_PRICE_SIKIKIN' => $$ref_hash{'APART_PRICE_SIKIKIN'},
#                  'APART_PRICE_SIKIKIN_UNIT' => $$ref_hash{'APART_PRICE_SIKIKIN_UNIT'},
#                  'APART_PRICE_REIKIN' => $$ref_hash{'APART_PRICE_REIKIN'},
#                  'APART_PRICE_REIKIN_UNIT' => $$ref_hash{'APART_PRICE_REIKIN_UNIT'},
#                  'APART_MADORI' => $$ref_hash{'APART_MADORI'},
#                  'APART_KIND' => $$ref_hash{'APART_KIND'},
#                  'APART_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_OUTSIDE_THUMB'},
#                  'APART_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'APART_PICS_MADORIZU_THUMB'},
#                  'APART_ADS_TEXT' => $$ref_hash{'APART_ADS_TEXT'}
#          );
#          if ($hash_sp{'APART_KIND'}==1){
#              $hash_sp{'APART_KIND'}='アパート';
#          }elsif($hash_sp{'APART_KIND'}==2){
#              $hash_sp{'APART_KIND'}='マンション';
#          }elsif($hash_sp{'APART_KIND'}==3){
#              $hash_sp{'APART_KIND'}='一戸建て';
#          }elsif($hash_sp{'APART_KIND'}==4){
#              $hash_sp{'APART_KIND'}='テラスハウス';
#          }
#  
#          if ($hash_sp{'APART_PRICE_SIKIKIN_UNIT'}){
#              if ($hash_sp{'APART_PRICE_SIKIKIN_UNIT'} == 1){
#                  $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#              }elsif($hash_sp{'APART_PRICE_SIKIKIN_UNIT'} == 2){
#                  $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = '円';
#              }elsif($hash_sp{'APART_PRICE_SIKIKIN_UNIT'} == 3){
#                  $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = '万円';
#              }else{
#                  $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#              }
#          }else{
#              $hash_sp{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#          }
#          if ($hash_sp{'APART_PRICE_REIKIN_UNIT'}){
#              if ($hash_sp{'APART_PRICE_REIKIN_UNIT'} == 1){
#                  $hash_sp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#              }elsif($hash_sp{'APART_PRICE_REIKIN_UNIT'} == 2){
#                  $hash_sp{'APART_PRICE_REIKIN_UNIT'} = '円';
#              }elsif($hash_sp{'APART_PRICE_REIKIN_UNIT'} == 3){
#                  $hash_sp{'APART_PRICE_REIKIN_UNIT'} = '万円';
#              }else{
#                  $hash_sp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#              }
#          }else{
#              $hash_sp{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#          }
# 
#         require REPS::CMS::Special;
#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'APART_PUBLISHED'}){
#                 #Special
#                 my $special = REPS::CMS::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_r_apart_special_path'),
#                                 $$ref_hash{'APART_ID'},
#                                 \%hash_sp
#                             );
#         
#                 $special->add_special();
#     
#                 #$$ref_hash{'APART_IS_SPECIAL'} = '1';
#             }else{
#                 $result .="<div class=\"information\"><p>更新されましたが、非公開ですので、お勧め物件には登録できません。</p></div>";
#             }
#         }else{
#                 my $special = REPS::CMS::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_r_apart_special_path'),
#                                 $$ref_hash{'APART_ID'}
#                             );
#                 $special->delete_Realestate($$ref_hash{'APART_ID'});
#         }
#end recommend

        #add to updates
        #if ($$ref_hash{'APART_PUBLISHED'}){
        #    if (!$$ref_hash{'APART_LAST_UPDATED'}){
        #        $hash_sp{'LAST_UPDATED'} = $$ref_hash{'APART_CREATED'};
        #    }else{
        #        $hash_sp{'LAST_UPDATED'} = $$ref_hash{'APART_LAST_UPDATED'};
        #    }
        #    my $updates = REPS::Updates::Updates->new(
        #                    $self->{_app},
        #                    $self->{_app}->param('db_rl_updates_path'),
        #                    $$ref_hash{'APART_ID'},
        #                    \%hash_sp
        #                );
    
        #    $updates->add_updates();
        #}

    }


    return $result;

}

sub delete_Realestate{
    my $self = shift;
    my @to_be_deleted = @_;
    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    my @not_to_be_deleted;

    tie (%apart, 'MLDBM', $db_apart_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    
    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $apart{$_}){
                if (defined $apart{$_} && ($apart{$_})){
                #    my %hash = ();
                #    $apart{$_} = \%hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($apart{$_}{'APART_USER_ID'} eq $self->{_app}->param('user_id')) {
                                undef $apart{$_};
                            } else {
                                #delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            undef $apart{$_};
                        }
                    }else{
                        undef $apart{$_};
                    }
                }
            }
        }
    }
    untie %apart;

#     #delete dupe here
#     if ($self->{_app}->param('user_isAdmin') != 1){
#         if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
#             my %delete_dupelicate;
#             @to_be_deleted = grep(!$delete_dupelicate{$_}++, @to_be_deleted);
#         }
#     }
    #
#     my $special = REPS::Special::Special->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_rl_special_path')
#                 );
#     $special->delete_Realestate(@to_be_deleted);
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_rl_updates_path')
#                 );
# 
#     $updates->delete_Realestate(@to_be_deleted);
    
    return 1;
}

sub dup_Realestate{
    my $self = shift;
    my @to_be_duped = @_;
    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');

    require REPS::Util;
    use File::Copy;
    use File::Basename;
    my $res_dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory'));

    tie (%apart, 'MLDBM', $db_apart_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_duped){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $apart{$_}){
                if (defined $apart{$_} && ($apart{$_})){
                #    
                #    $apart{$_} = \%hash;
                    my $num_keys = scalar keys (%apart);
                    $num_keys = sprintf('%06d', $num_keys++);
                    if (exists $apart{$num_keys}){
                        #count up and add again. This could happen when export and import data.
                        while (exists $apart{$num_keys}) {
                            $num_keys++;
                            if ($num_keys >= 999999) {die "Reached lmit.";}
                        }
                    }
                    my %hash = %{$apart{$_}};
                    #物件IDをつける
                    $hash{'APART_ID'} = $num_keys;
                    #部屋番号を空にする。
                    $hash{'APART_ROOM_NUMBER'} = '';

                    $hash{'APART_CREATED'} = REPS::Util->get_datetime_now();
                    $hash{'APART_LAST_UPDATED'} = '';


                    if ($hash{'APART_PICS_OUTSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_OUTSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_OUTSIDE'}, $res_dir.'rl/'.$num_keys.'_a'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_OUTSIDE'} = 'rl/'.$num_keys.'_a'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'APART_PICS_INSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_INSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_INSIDE'}, $res_dir.'rl/'.$num_keys.'_b'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_INSIDE'} = 'rl/'.$num_keys.'_b'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'APART_PICS_MADORIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_MADORIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_MADORIZU'}, $res_dir.'rl/'.$num_keys.'_c'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_MADORIZU'} = 'rl/'.$num_keys.'_c'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'APART_PICS_TIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_TIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_TIZU'}, $res_dir.'rl/'.$num_keys.'_d'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_TIZU'} = 'rl/'.$num_keys.'_d'.$ext;
                        };
                        if ($@){die $@;}
                    }

                    if ($hash{'APART_PICS_OUTSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_OUTSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_OUTSIDE_THUMB'}, $res_dir.'rl/'.$num_keys.'_a_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_OUTSIDE_THUMB'} = 'rl/'.$num_keys.'_a_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'APART_PICS_INSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_INSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_INSIDE_THUMB'}, $res_dir.'rl/'.$num_keys.'_b_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_INSIDE_THUMB'} = 'rl/'.$num_keys.'_b_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'APART_PICS_MADORIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_MADORIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_MADORIZU_THUMB'}, $res_dir.'rl/'.$num_keys.'_c_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_MADORIZU_THUMB'} = 'rl/'.$num_keys.'_c_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'APART_PICS_TIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'APART_PICS_TIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'APART_PICS_TIZU_THUMB'}, $res_dir.'rl/'.$num_keys.'_d_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'APART_PICS_TIZU_THUMB'} = 'rl/'.$num_keys.'_d_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }


                    #$apart{$num_keys} = $apart{$_};
                    $apart{$num_keys} = \%hash;
                }
            }
        }
    }
    untie %apart;

    return 1;
}

sub toggle_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    my @not_to_be_deleted;

    tie (%apart, 'MLDBM', $db_apart_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $apart{$_}){
                if (defined $apart{$_} && ($apart{$_})){
                #    my %hash = ();
                #    $apart{$_} = \%hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($apart{$_}{'APART_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$apart{$_}};
                                if ($boolean){
                                    $hash{'APART_PUBLISHED'}='On';
                                    $hash{'APART_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                                }else{
                                    $hash{'APART_PUBLISHED'}='';
                                }
                                $apart{$_} = \%hash;
                            } else {
                                #delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$apart{$_}};
                            if ($boolean){
                                $hash{'APART_PUBLISHED'}='On';
                                $hash{'APART_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                            }else{
                                $hash{'APART_PUBLISHED'}='';
                            }
                            $apart{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$apart{$_}};
                        if ($boolean){
                            $hash{'APART_PUBLISHED'}='On';
                            $hash{'APART_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                        }else{
                            $hash{'APART_PUBLISHED'}='';
                        }
                        $apart{$_} = \%hash;
                    }
                }
            }
        }
    }
    untie %apart;

#     #delete dupe here
#     if ($self->{_app}->param('user_isAdmin') != 1){
#         if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
#             my %delete_dupelicate;
#             @to_be_deleted = grep(!$delete_dupelicate{$_}++, @to_be_deleted);
#         }
#     }
    #
#     my $special = REPS::Special::Special->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_rl_special_path')
#                 );
#     $special->delete_Realestate(@to_be_deleted);
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_rl_updates_path')
#                 );
# 
#     $updates->delete_Realestate(@to_be_deleted);
    
    return 1;
}

sub special_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    my @not_to_be_deleted;

    tie (%apart, 'MLDBM', $db_apart_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $apart{$_}){
                if (defined $apart{$_} && ($apart{$_})){
                #    my %hash = ();
                #    $apart{$_} = \%hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($apart{$_}{'APART_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$apart{$_}};
                                if ($boolean){
                                    $hash{'APART_IS_SPECIAL'}='On';
                                }else{
                                    $hash{'APART_IS_SPECIAL'}='';
                                }
                                $apart{$_} = \%hash;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$apart{$_}};
                            if ($boolean){
                                $hash{'APART_IS_SPECIAL'}='On';
                            }else{
                                $hash{'APART_IS_SPECIAL'}='';
                            }
                            $apart{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$apart{$_}};
                        if ($boolean){
                            $hash{'APART_IS_SPECIAL'}='On';
                        }else{
                            $hash{'APART_IS_SPECIAL'}='';
                        }
                        $apart{$_} = \%hash;
                    }
                }
            }
        }
    }
    untie %apart;
    return 1;
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
    my $c;
    my $match = 0;

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    if (-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        while ( ($key, $value) = each(%apart) ) {

            if ((defined $apart{$key}) && (exists $apart{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'APART_USER_ID'}){
                    #match?
                    $match = 0;

                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($tmp{'APART_USER_ID'} ne $self->{_app}->param('user_id')) {
                            next;
                        }
                    }

                    if ($q->param("apart_jisyakannri") > 0){ #自社管理指定
                        if ($q->param("apart_jisyakannri") == 1) {
                            if ($tmp{'APART_TASYAKANRI'}){
                                #他社管理物件
                                next;
                            }else{
                                $match = 1;
                            }
                        }elsif($q->param("apart_jisyakannri") == 2){
                            if ($tmp{'APART_TASYAKANRI'}){
                                    $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("apart_jisyatouroku") > 0){
                        if ($q->param("apart_jisyatouroku") == 1) {
                            if ($tmp{'APART_USER_ID'} ne $self->{_app}->param('user_id')){
                                next;
                            }else{$match = 1;}
                        }elsif ($q->param("apart_jisyatouroku") == 2) {
                            if ($tmp{'APART_USER_ID'} eq $self->{_app}->param('user_id')){
                                next;
                            }else{$match = 1;}
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("apart_public") > 0){
                        if ($q->param("apart_public") == 1) {
                            if ($tmp{'APART_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("apart_public") == 2){
                            if (!$tmp{'APART_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("apart_recommend") > 0){
                        if ($q->param("apart_recommend") == 1) {
                            if ($tmp{'APART_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("apart_recommend") == 2){
                            if (!$tmp{'APART_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
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

                    if ($q->param("apart_price_1") || $q->param("apart_price_2")){
                        my $tmp_price = $tmp{'APART_PRICE'};
                        if ($q->param("include_k_k")){
                            #TODO
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
                        my @apart_has;
                        foreach ($q->param("apart_has_")){
                            push (@apart_has,split(',',$_));
                        }
                        foreach (@apart_has){
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

                    if ($q->param("apart_address")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("apart_address")));
                        if (REPS::Util->str_match($tmp{'APART_LOCATION'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
                    }

                    if ($q->param("apart_name")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("apart_name")));
                        if (REPS::Util->str_match($tmp{'APART_NAME'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
                    }

                    $test = 0;

                    if ($q->param("apart_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("apart_school")));
                        if (REPS::Util->str_match($tmp{'APART_SHOUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'APART_CYUUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }

                        my $tstr =  join(' ',$tmp{'APART_DAIGAKU_LIST'}); 

                        if (REPS::Util->str_match($tstr,$search_by_key)){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }

                    if ($q->param("apart_station")){
                        my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("apart_station")));
                        if (REPS::Util->str_match($tmp{'APART_STATION_1'},$search_by_key)){
                            $match = 1;
                        }elsif(REPS::Util->str_match($tmp{'APART_STATION_2'},$search_by_key)){
                            $match = 1;
                        }else{next;}
                    }

                    if ($match){

                        #add to sort_hash
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'name'){
                                $sort_hash{$key} = $tmp{'APART_NAME'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'APART_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'APART_LAST_UPDATED'}&&($tmp{'APART_LAST_UPDATED'}))){
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
                    }

                }else{
                    #todo app user id not exists
                }
            }
        }


        my @sort_keys;
        #sort
        if (($sort_by eq 'name') || ($sort_by eq 'location')){
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

        if (!$off_set){$off_set=0;}

        @sort_keys = splice( @sort_keys, $off_set, $items_per_page);

        my $new_off_set = $off_set + $items_per_page;

        foreach (@sort_keys){
            my $ref_hash = $apart{$_};
            my %tmp = %$ref_hash;

            my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'APART_CREATED'});
            my $new = '';
            if ($dd <= 30) {
                $new = 'ON';
            }
            my $updated = '';
            if ((!$new) && ($tmp{'APART_LAST_UPDATED'})){
                $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'APART_LAST_UPDATED'});
                if ($dd <= 10) {
                    $updated = 'ON';
                }
            }

            my %hash = (
                'APART_ID' => "$_",
                'APART_PUBLISHED' => $tmp{'APART_PUBLISHED'},
                'APART_IS_SPECIAL' => $tmp{'APART_IS_SPECIAL'},
                'APART_NAME' => $tmp{'APART_NAME'},
                'APART_LOCATION' => $tmp{'APART_LOCATION'},
                'APART_PRICE' => REPS::Util->insert_comma($tmp{'APART_PRICE'}),
                'APART_ROOM_NUMBER' => $tmp{'APART_ROOM_NUMBER'},
                'APART_CREATED' => REPS::Util->get_date_as_string($tmp{'APART_CREATED'}),
                'APART_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'APART_LAST_UPDATED'}),
                    'APART_NEW' => $new,
                    'APART_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                '_type' => 'rl'
            );

            push(@loop_data, \%hash);
        }

        untie %apart;
        $Search->{'ref_result_loop'} = \@loop_data;
        $Search->{'count_result'} = $c;
    }else{
        $Search->{'ref_result_loop'} = \@loop_data;
        $Search->{'count_result'} = 0;
    }

    return 1;

}

sub do_batch {
    my $self = shift;

    #my $only_this_user = $_[1];

    my %tmp;
    my $key;
    my $value;
    #my @loop_data;


    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    if (-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;#
        #my $image = Image::Magick->new;
        while ( ($key, $value) = each(%apart) ) {
            if ((defined $apart{$key}) && ($value)){
                my %tmp = %$value;


                            #$image->Read($tmp{'APART_PICS_OUTSIDE'});
                            #$image->Scale(geometry => '210x230');
                            #$image->Write($tmp{'APART_PICS_OUTSIDE_THUMB'});
                            #@$image = ();

                            #$image->Read($tmp{'APART_PICS_INSIDE'});
                            #$image->Scale(geometry => '210x230');
                            #$image->Write($tmp{'APART_PICS_INSIDE_THUMB'});
                            #@$image = ();

                            #$image->Read($tmp{'APART_PICS_MADORIZU'});
                            #$image->Scale(geometry => '210x230');
                            #$image->Write($tmp{'APART_PICS_MADORIZU_THUMB'});
                            #@$image = ();


                #$tmp{'APART_KIND'}=1;

#                if (exists $tmp{'APART_USER_ID'}){
#                    if ($only_this_user){
#                        if ($only_this_user ne $tmp{'APART_USER_ID'}){
#                            next;
#                        }
#                    }

#                }else{
                    #todo app user id not exists
    
#                }
                #$apart{$key}=\%tmp;
            }
        }
        untie %apart;

    }


    return 1;


}

sub get_Specials{
    my $self = shift;
    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    my ($key, $value);
    my @loop_data=();
    #my %hash;
my $limit =  $self->{_app}->cfg('recommend_static_display_limit');

    if (-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;


        while ( ($key, $value) = each(%apart) ) {
            if ((exists $apart{$key}) && (defined $apart{$key}) && ($value)){

                 #if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                 #    if ($$value{'APART_USER_ID'} ne $self->{_app}->param('user_id')) {
                 #        next;
                 #    }
                 #}
                 if (($$value{'APART_PUBLISHED'}) && ($$value{'APART_IS_SPECIAL'})){
# 
#                     my %hash=(
#                             'APART_ID' => $$value{'APART_ID'},
#                             #'APART_NAME' => $$value{'APART_NAME'},
#                             'APART_STATION_1' => $$value{'APART_STATION_1'},
#                             'APART_STATION_2' => $$value{'APART_STATION_2'},
#                             'APART_LOCATION' =>$$value{'APART_LOCATION'},
#                             'APART_PRICE' => REPS::Util->insert_comma($$value{'APART_PRICE'}),
#                             'APART_BUS_MINUTES_1' => $$value{'APART_BUS_MINUTES_1'},
#                             'APART_WALK_MINUTES_1' => $$value{'APART_WALK_MINUTES_1'},
#                             'APART_BUS_MINUTES_2' => $$value{'APART_BUS_MINUTES_2'},
#                             'APART_WALK_MINUTES_2' => $$value{'APART_WALK_MINUTES_2'},
#                             'APART_PRICE_KANRIHI' => REPS::Util->insert_comma($$value{'APART_PRICE_KANRIHI'}),
#                             'APART_PRICE_SIKIKIN' => $$value{'APART_PRICE_SIKIKIN'},
#                             'APART_PRICE_SIKIKIN_UNIT' => $$value{'APART_PRICE_SIKIKIN_UNIT'},
#                             'APART_PRICE_REIKIN' => $$value{'APART_PRICE_REIKIN'},
#                             'APART_PRICE_REIKIN_UNIT' => $$value{'APART_PRICE_REIKIN_UNIT'},
#                             'APART_MADORI' => $$value{'APART_MADORI'},
#                             'APART_KIND' => $$value{'APART_KIND'},
#                             'APART_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$value{'APART_PICS_OUTSIDE_THUMB'},
#                             'APART_PICS_INSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$value{'APART_PICS_INSIDE_THUMB'},
#                             'APART_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$value{'APART_PICS_MADORIZU_THUMB'},
#                             'APART_ADS_TEXT' => $$value{'APART_ADS_TEXT'}
#                     );
#                     if ($hash{'APART_KIND'}==1){
#                         $hash{'APART_KIND'}='アパート';
#                     }elsif($hash{'APART_KIND'}==2){
#                         $hash{'APART_KIND'}='マンション';
#                     }elsif($hash{'APART_KIND'}==3){
#                         $hash{'APART_KIND'}='一戸建て';
#                     }elsif($hash{'APART_KIND'}==4){
#                         $hash{'APART_KIND'}='テラスハウス';
#                     }
#             
#                     if ($hash{'APART_PRICE_SIKIKIN_UNIT'}){
#                         if ($hash{'APART_PRICE_SIKIKIN_UNIT'} == 1){
#                             $hash{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#                         }elsif($hash{'APART_PRICE_SIKIKIN_UNIT'} == 2){
#                             $hash{'APART_PRICE_SIKIKIN_UNIT'} = '円';
#                         }elsif($hash{'APART_PRICE_SIKIKIN_UNIT'} == 3){
#                             $hash{'APART_PRICE_SIKIKIN_UNIT'} = '万円';
#                         }else{
#                             $hash{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#                         }
#                     }else{
#                         $hash{'APART_PRICE_SIKIKIN_UNIT'} = 'ヶ月';
#                     }
#                     if ($hash{'APART_PRICE_REIKIN_UNIT'}){
#                         if ($hash{'APART_PRICE_REIKIN_UNIT'} == 1){
#                             $hash{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#                         }elsif($hash{'APART_PRICE_REIKIN_UNIT'} == 2){
#                             $hash{'APART_PRICE_REIKIN_UNIT'} = '円';
#                         }elsif($hash{'APART_PRICE_REIKIN_UNIT'} == 3){
#                             $hash{'APART_PRICE_REIKIN_UNIT'} = '万円';
#                         }else{
#                             $hash{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#                         }
#                     }else{
#                         $hash{'APART_PRICE_REIKIN_UNIT'} = 'ヶ月';
#                     }
# 
#                     push(@loop_data, \%hash);
# 
push(@loop_data, $key);
if ($limit < scalar(@loop_data)){last;}
                 }

            }

        }
        untie %apart;

    }
my $limit =  $self->{_app}->cfg('recommend_static_display_limit');
if (($limit) && ($limit>0)){
    @loop_data = @loop_data[0..$limit-1];
}
require REPS::Search::Realestate::R_Apartment;
my $Realestate = REPS::Search::Realestate::R_Apartment->new($self->{_app});
my $ref_loop = $Realestate->get_Detail_List(@loop_data);

return $ref_loop;

#    return \@loop_data;
}

sub get_Count{
    my $self = shift;
    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    my ($key, $value);
    my %hash;
    if (-f $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        my $n=0;
        my $p=0;
        my $l=0;
        my $t;

        while ( ($key, $value) = each(%apart) ) {
            if ((exists $apart{$key}) && (defined $apart{$key}) && ($value)){

                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($$value{'APART_USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }
                if (exists $$value{'APART_PUBLISHED'}){
                    if ($$value{'APART_PUBLISHED'}){
                        $p++;
                    }else{
                        $n++;
                    }
                }
        
                if ((defined $$value{'APART_LAST_UPDATED'}&&($$value{'APART_LAST_UPDATED'}))){
                    $t=$$value{'APART_LAST_UPDATED'};
                    $t =~ s/\D//gi;
                    #$t =~ s/T?:?-?//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'APART_LAST_UPDATED'};
                    }
        
                }else{
                    $t=$$value{'APART_CREATED'};
                    $t =~ s/\D//gi;
                    #$t =~ s/T?:?-?//i;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'APART_CREATED'};
                    }
                }
            }
            
        }
        untie %apart;
        %hash = ('count_all'=>$n+$p,'count_published'=>$p,'last_updated'=>REPS::Util->get_date_as_string($l));
    }
    return \%hash;
}

sub get_AccessLog{
    my $self = shift;
    my ($key, $value);
    my @loop_data = ();
    my $n = 0;
    my %access;
    my $db_access_path = $self->{_app}->param('db_r_apart_access_path');
    my %hash;
    if (-f $db_access_path){
        tie (%access, 'MLDBM', $db_access_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        while ( ($key, $value) = each(%access) ) {
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($$value{'USER_ID'} ne $self->{_app}->param('user_id')) {
                    next;
                }
            }
            #$n = $n+$value;
            $n = $n+$$value{'COUNT'};
        }
        if (uc($self->{_app}->cfg('detailed_stat')) eq 'ON') {
            #my @sort_keys = keys %access;
            my @sort_keys = sort {$access{$b}{'COUNT'} <=> $access{$a}{'COUNT'}} keys %access;
            @sort_keys = splice( @sort_keys , 0,5);
            foreach (@sort_keys){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($access{$_}{'USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }
                my %tmp = (
                    'OBJECT_ID' => "$_",
                    'ACCESS_COUNT' => $access{$_}{'COUNT'},
                );
        
                push(@loop_data, \%tmp);
            }
        }
        %hash = ('access_count_all'=>$n,'access_loop'=>\@loop_data);
        untie %access;
    }else{
        %hash = ('access_count_all'=>'','access_loop'=>\@loop_data);
    }
    return \%hash;

}


sub get_InquiryLog{
    my $self = shift;
    my ($key, $value);
    my @loop_data = ();
    my $n;
    my %inquiry;
    my $db_inquiry_path = $self->{_app}->param('db_r_apart_inquiry_path');
    my %hash;
    if (-f $db_inquiry_path){

        tie (%inquiry, 'MLDBM', $db_inquiry_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        while ( ($key, $value) = each(%inquiry) ) {
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($$value{'USER_ID'} ne $self->{_app}->param('user_id')) {
                    next;
                }
            }

            $n = $n+$$value{'COUNT'};
            #$n = $n+$value;
        }
        if (uc($self->{_app}->cfg('detailed_stat')) eq 'ON') {
            my @sort_keys = sort {$inquiry{$b}{'COUNT'} <=> $inquiry{$a}{'COUNT'}} keys %inquiry;
            @sort_keys = splice( @sort_keys , 0,5);
    
            foreach (@sort_keys){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($inquiry{$_}{'USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }

                my %tmp = (
                    'OBJECT_ID' => "$_",
                    'INQUIRY_COUNT' => $inquiry{$_}{'COUNT'},
                );
        
                push(@loop_data, \%tmp);
            }
        }
        %hash = ('inquiry_count_all'=>$n,'inquiry_loop'=>\@loop_data);
        untie %inquiry;
    }else{
        %hash = ('inquiry_count_all'=>'','inquiry_loop'=>\@loop_data);
    }
    return \%hash;

}

#sub require_rebuild_special {
#    my $self = shift;
#    return $self->{_bln_need_rebuild_special};
#}

sub syndicate {
    my $self = shift;
    require XML::Atom::Syndication::Feed;
    require XML::Atom::Syndication::Link;
    require XML::Atom::Syndication::Generator;
    require XML::Atom::Syndication::Entry;
    require XML::Atom::Syndication::Text;
    require XML::Atom::Syndication::Person;
    require XML::Atom::Syndication::Content;
    require XML::Atom::Syndication::Category;
    require Unicode::Japanese;
    my $UJ = Unicode::Japanese->new();

    require REPS::Settings;
    my $Settings = REPS::Settings->new($self->{_app});
    my $settings_info = $Settings->get_settings_to_be_displayed();

    # create a feed
    my $feed = XML::Atom::Syndication::Feed->new;
    # set feed title
    my $feed_title = '賃貸住居用物件情報';
    $feed->title($UJ->set($feed_title,'euc')->utf8);
    # subtitle
    my $feed_subtitle = $$settings_info{'COMPANY_NAME'} . 'が配信する最新の賃貸住居用物件情報です';
    $feed->subtitle($UJ->set($feed_subtitle,'euc')->utf8);

    #TODO: how do I set multiple link?
    #create self link
    my $feed_link = XML::Atom::Syndication::Link->new();
    $feed_link->href($self->{_app}->cfg('site_url').'rl-atom.xml');
    $feed_link->rel('self');
    $feed_link->type('application/atom+xml');
    #set a feed link
    $feed->link($feed_link);

    #create alt link
    my $feed_link = XML::Atom::Syndication::Link->new();
    $feed_link->href($self->{_app}->cfg('site_url'));
    $feed_link->rel('alternate');
    $feed_link->type('text/html');
    #set a feed link
    $feed->link($feed_link);

    #set a copyrights
    $feed->rights('Copyright (c) reserved by '. $UJ->set($$settings_info{'COMPANY_NAME'},'euc')->utf8);
#TODO: create better id for feeds
    $feed->id($self->{_app}->cfg('cgi_url').'rl');

    my $feed_gen = XML::Atom::Syndication::Generator->new();
    $feed_gen->uri('http://www.witha.jp/reps');
    $feed_gen->version($self->{_app}->version);
#TODO: missing agent string. This is a bug in the atom lib
    #$feed_gen->agent('REPS');
    $feed->generator($feed_gen);

    my $feed_author = XML::Atom::Syndication::Person->new(Name=>'author');
    $feed_author->name($$settings_info{'COMPANY_NAME'});
    $feed_author->uri($self->{_app}->cfg('site_url'));

    my $key='';
    my $value='';
    my $i=0;
    my %sort_hash = ();

    my %apart;
    my $db_apart_path = $self->{_app}->param('db_r_apart_path');
    if (-e $db_apart_path){
        tie (%apart, 'MLDBM', $db_apart_path, O_RDONLY, 0660, $DB_BTREE, 'write') or Carp::croak ("$! $db_apart_path");#
        while ( ($key, $value) = each(%apart) ) {
            if ($i > 15){last;}
            if ((defined $apart{$key}) && ($value)){
                if ($$value{'APART_PUBLISHED'}){
                    $i++;
                    if ((defined $$value{'APART_LAST_UPDATED'}&&($$value{'APART_LAST_UPDATED'}))){
                        $sort_hash{$key} = $$value{'APART_LAST_UPDATED'};
                    }else{
                        $sort_hash{$key} = $$value{'APART_CREATED'};
                    }
                }
            }
        }

        #sort by update
        my @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
        @sort_keys = reverse @sort_keys;
        if (@sort_keys > 0){
            if ($apart{$sort_keys[0]}{'APART_LAST_UPDATED'}. '+09:00'){
                $feed->updated($apart{$sort_keys[0]}{'APART_LAST_UPDATED'}. '+09:00');
            }else{
                $feed->updated($apart{$sort_keys[0]}{'APART_CREATED'}. '+09:00');
            }
        }else{
            $feed->updated(REPS::Util->get_datetime_now . '+09:00');
        }
        #for each
        foreach (@sort_keys){
            my $entry = XML::Atom::Syndication::Entry->new;
#TODO: create better id for entry.
            $entry->id($self->{_app}->cfg('cgi_url').'rl/'.$apart{$_}{'APART_ID'});

            #title
            my $apart_kind='';
            if ($apart{$_}{'APART_KIND'}==1){
                $apart_kind='アパート';
            }elsif($apart{$_}{'APART_KIND'}==2){
                $apart_kind='マンション';
            }elsif($apart{'APART_KIND'}==3){
                $apart_kind='一戸建て';
            }elsif($apart{'APART_KIND'}==4){
                $apart_kind='テラスハウス';
            }else {$apart_kind='賃貸物件';}
            my $apart_price = REPS::Util->insert_comma($apart{$_}{'APART_PRICE'});
            my $entry_title = "[$apart_kind][$apart{$_}{'APART_MADORI'}][$apart_price]";
            $entry->title($UJ->set($entry_title,'euc')->utf8);

            #create a link
            my $entry_link = XML::Atom::Syndication::Link->new();
            $entry_link->href($self->{_app}->cfg('cgi_url').'search.cgi?_mode=mode_detail&_type=rl&_object_id='.$apart{$_}{'APART_ID'});
            $entry_link->rel('alternate');
            $entry_link->type('text/html');
            #set a feed link
            $entry->link($entry_link);
            #updated
            if ($apart{$_}{'APART_LAST_UPDATED'}){
                $entry->updated($apart{$_}{'APART_LAST_UPDATED'} . '+09:00');
                $entry->published($apart{$_}{'APART_CREATED'}. '+09:00');
            }else{
                $entry->updated($apart{$_}{'APART_CREATED'}. '+09:00');
            }
            #author
            my $entry_author = XML::Atom::Syndication::Person->new(Name=>'author');
            $entry_author->name($apart{$_}{'APART_USER_ID'});
            $entry->author($entry_author);

            my $apart_picture_outside='';
            if ($apart{$_}{'APART_PICS_OUTSIDE'}){
                $apart_picture_outside = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$apart{$_}{'APART_PICS_OUTSIDE_THUMB'};
                $apart_picture_outside = '<img src="'.$apart_picture_outside.'" class="outside" />';
            }
            my $apart_picture_madorizu='';
            if ($apart{$_}{'APART_PICS_MADORIZU'}){
                $apart_picture_madorizu = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$apart{$_}{'APART_PICS_MADORIZU_THUMB'};
                $apart_picture_madorizu = '<img src="'.$apart_picture_madorizu.'" class="madorizu" />';
            }

            my $entry_category = XML::Atom::Syndication::Category->new();
            $entry_category->term($UJ->set($apart_kind,'euc')->utf8);
            $entry->category($entry_category);
#TODO: How to add more than one category?
            #my $entry_category = XML::Atom::Syndication::Category->new();
            #$entry_category->term($apart{$_}{APART_MADORI});
            #$entry->category($entry_category);

my $entry_content = <<"_HTML_";
<div class="rl">
    <h4><span="tagline">$apart{$_}{APART_ADS_TEXT}</span></h4>
    <ul>
        <li>種別：<span class="type">$apart_kind</span></li>
        <li>間取り：<span class="madori">$apart{$_}{APART_MADORI}</span></li>
        <li>価格：<span class="price">$apart_price<span class="unit">円</span></span></li>
        <li>所在地：<span class="location">$apart{$_}{APART_LOCATION}</span></li>
        <li>最寄駅：<span class="station">$apart{$_}{APART_STATION_1}</span></li>
    </ul>
    <div class="picture">
        <span class="outside">$apart_picture_outside</span>
        <span class="madorizu">$apart_picture_madorizu</span>
    </div>
</div>
_HTML_

            my $content = XML::Atom::Syndication::Content->new($UJ->set($entry_content,'euc')->utf8);
            $content->type('html');
            $entry->content($content);
            $feed->add_entry($entry);

        }
        untie %apart;

        my $output = $feed->as_xml;
        my $file = $self->{_app}->cfg('site_path').'rl-atom.xml';

my $umask;
if ($self->{_app}->cfg('HTMLUmask')){
    $umask = oct $self->{_app}->cfg('HTMLUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);

        open (OUT,">$file") || Carp::croak ("$! $file");
        flock(OUT,2) || Carp::croak ("$file : $! flock");
            print OUT $output;
        flock(OUT,8) || Carp::croak("$file : $!");
        close (OUT) || Carp::croak("$file : $! $file");

umask($old);

        return 1
    }
}

1
