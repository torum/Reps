package REPS::CMS::Realestate::B_Mansion;

use strict;
use base qw( REPS::CMS::Realestate );

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

            'MANSION_SOUKOSUU' => '',
            'MANSION_SYUYOUSAIKOUMEN' => '',
            'MANSION_BARUKONI_SQUARE' => '',
            'MANSION_BARUKONI_SQUARE_TUBO' => '',

            'MANSION_CHUSYAJYOU' => '',

            'MANSION_SQUARE' => '',
            'MANSION_SQUARE_TEXT' => '',
            'MANSION_SQUARE_TUBO' => '',

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

            #'MANSION_TASYAKANRI' => '',
            'MANSION_RYUUTUU' => '',


            'MANSION_BUNJYOU_KAISYA' => '',
            'MANSION_SEKOU_KAISYA' => '',

            'MANSION_KANRIKAISYA' => '',
            'MANSION_KANRIKAISYA_CONTACT' => '',
            'MANSION_KANRI_JININ' => '',
            'MANSION_KANRI_KEITAI' => '',


            'MANSION_USER_ID' => $app->param('user_id'),
            'MANSION_CREATED' => '',
            'MANSION_LAST_UPDATED' => '',


            }
        };    

    return bless $self,$class;
}

sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();
    
    $self->{_ref_hash}{'MANSION_ID'} = $q->param('_object_id') if $q->param('_object_id');
    $self->{_ref_hash}{'MANSION_PUBLISHED'} = $q->param('mansion_publish') if $q->param('mansion_publish');
    $self->{_ref_hash}{'MANSION_IS_SPECIAL'} = $q->param('add_to_special') if $q->param('add_to_special');

    $self->{_ref_hash}{'MANSION_NAME'} = REPS::Util->trim($q->param('mansion_name')) if $q->param('mansion_name');
    $self->{_ref_hash}{'MANSION_LOCATION'} = $q->param('mansion_location') if $q->param('mansion_location');
    $self->{_ref_hash}{'MANSION_STATION_1'} = $q->param('mansion_station1') if $q->param('mansion_station1');

    $self->{_ref_hash}{'MANSION_BUS_1'} = $q->param('mansion_bus') if $q->param('mansion_bus');
    $self->{_ref_hash}{'MANSION_WALK_MINUTES_1'} = $q->param('mansion_walk_minutes') if $q->param('mansion_walk_minutes');
    $self->{_ref_hash}{'MANSION_BUS_MINUTES_1'} = $q->param('mansion_bus_minutes') if $q->param('mansion_bus_minutes');
    $self->{_ref_hash}{'MANSION_BUSWALK_MINUTES_1'} = $q->param('mansion_buswalk_minutes') if $q->param('mansion_buswalk_minutes');

    $self->{_ref_hash}{'MANSION_STATION_2'} = $q->param('mansion_station2') if $q->param('mansion_station2');
    $self->{_ref_hash}{'MANSION_BUS_2'} = $q->param('mansion_bus2') if $q->param('mansion_bus2');
    $self->{_ref_hash}{'MANSION_WALK_MINUTES_2'} = $q->param('mansion_walk_minutes2') if $q->param('mansion_walk_minutes2');
    $self->{_ref_hash}{'MANSION_BUS_MINUTES_2'} = $q->param('mansion_bus_minutes2') if $q->param('mansion_bus_minutes2');
    $self->{_ref_hash}{'MANSION_BUSWALK_MINUTES_2'} = $q->param('mansion_buswalk_minutes2') if $q->param('mansion_buswalk_minutes2');

    $self->{_ref_hash}{'MANSION_PRICE'} = $q->param('mansion_price') if $q->param('mansion_price');
    $self->{_ref_hash}{'MANSION_PRICE_TAX_INC'} = $q->param('mansion_price_tax_inc') if $q->param('mansion_price_tax_inc');
    $self->{_ref_hash}{'MANSION_PRICE_KANRIHI'} = $q->param('mansion_price_kanrihi') if $q->param('mansion_price_kanrihi');
    $self->{_ref_hash}{'MANSION_MADORI' } = $q->param('mansion_madori') if $q->param('mansion_madori');
    $self->{_ref_hash}{'MANSION_MADORI_DETAIL'} = $q->param('mansion_madori_detail') if $q->param('mansion_madori_detail');
    $self->{_ref_hash}{'MANSION_SQUARE'} = $q->param('mansion_square') if $q->param('mansion_square');
    $self->{_ref_hash}{'MANSION_SQUARE_TEXT'} = $q->param('mansion_square_text') if $q->param('mansion_square_text');
    $self->{_ref_hash}{'MANSION_SQUARE_TUBO'} = $q->param('mansion_square_tubo') if $q->param('mansion_square_tubo');

    $self->{_ref_hash}{'MANSION_GAISOU_AGE'} = $q->param('mansion_gaisou_age') if $q->param('mansion_gaisou_age');

    $self->{_ref_hash}{'MANSION_BUILDING_STRUCTURE'} = $q->param('mansion_building_structure') if $q->param('mansion_building_structure');
    $self->{_ref_hash}{'MANSION_STORY'} = $q->param('mansion_story') if $q->param('mansion_story');
    $self->{_ref_hash}{'MANSION_FLOOR'} = $q->param('mansion_floor') if $q->param('mansion_floor');
    $self->{_ref_hash}{'MANSION_AGE'} = $q->param('mansion_age') if $q->param('mansion_age');
    $self->{_ref_hash}{'MANSION_ROOM_NUMBER'} = $q->param('mansion_room_number') if $q->param('mansion_room_number');

    $self->{_ref_hash}{'MANSION_SOUKOSUU'} = $q->param('mansion_soukosuu') if $q->param('mansion_soukosuu');
    $self->{_ref_hash}{'MANSION_SYUYOUSAIKOUMEN'} = $q->param('mansion_syuyousaikoumen') if $q->param('mansion_syuyousaikoumen');
    $self->{_ref_hash}{'MANSION_BARUKONI_SQUARE'} = $q->param('mansion_barukoni_square') if $q->param('mansion_barukoni_square');

    $self->{_ref_hash}{'MANSION_BARUKONI_SQUARE_TUBO'} = $q->param('mansion_barukoni_square_tubo') if $q->param('mansion_barukoni_square_tubo');

    $self->{_ref_hash}{'MANSION_CHUSYAJYOU'} = $q->param('mansion_chusyajyou') if $q->param('mansion_chusyajyou');

    $self->{_ref_hash}{'MANSION_SETUBI'} = $q->param('mansion_setubi') if $q->param('mansion_setubi');
    $self->{_ref_hash}{'MANSION_JYOUKEN'} = $q->param('mansion_jyouken') if $q->param('mansion_jyouken');


    $self->{_ref_hash}{'MANSION_OPTIONS_KAKUBEYA'} = $q->param('mansion_options_kakubeya') if $q->param('mansion_options_kakubeya');
    $self->{_ref_hash}{'MANSION_OPTIONS_AUTOLOCK'} = $q->param('mansion_options_autolock') if $q->param('mansion_options_autolock');
    $self->{_ref_hash}{'MANSION_OPTIONS_ELEVATOR'} = $q->param('mansion_options_elevator') if $q->param('mansion_options_elevator');
    $self->{_ref_hash}{'MANSION_OPTIONS_TVPHONE'} = $q->param('mansion_options_tvphone') if $q->param('mansion_options_tvphone');
    $self->{_ref_hash}{'MANSION_OPTIONS_SYSTEM_KITCHIN'} = $q->param('mansion_options_system_kitchin') if $q->param('mansion_options_system_kitchin');
    $self->{_ref_hash}{'MANSION_OPTIONS_SHOWERTOILETE'} = $q->param('mansion_options_showertoilete') if $q->param('mansion_options_showertoilete');
    $self->{_ref_hash}{'MANSION_OPTIONS_WALKIN_CLOSET'} = $q->param('mansion_options_walkin_closet') if $q->param('mansion_options_walkin_closet');
    $self->{_ref_hash}{'MANSION_OPTIONS_YUKASITA_SYUUNOU'} = $q->param('mansion_options_yukasita_syuunou') if $q->param('mansion_options_yukasita_syuunou');
    $self->{_ref_hash}{'MANSION_OPTIONS_YUKADANBOU'} = $q->param('mansion_options_yukadanbou') if $q->param('mansion_options_yukadanbou');
    $self->{_ref_hash}{'MANSION_OPTIONS_SENYOUNIWA'} = $q->param('mansion_options_senyouniwa') if $q->param('mansion_options_senyouniwa');
    $self->{_ref_hash}{'MANSION_OPTIONS_PARKING'} = $q->param('mansion_options_parking') if $q->param('mansion_options_parking');
    $self->{_ref_hash}{'MANSION_OPTIONS_PARKING_BYKE'} = $q->param('mansion_options_parking_byke') if $q->param('mansion_options_parking_byke');
    $self->{_ref_hash}{'MANSION_OPTIONS_PARKING_JITENSYA'} = $q->param('mansion_options_parking_jitensya') if $q->param('mansion_options_parking_jitensya');
    $self->{_ref_hash}{'MANSION_OPTIONS_BARUKONI'} = $q->param('mansion_options_barukoni') if $q->param('mansion_options_barukoni');
    $self->{_ref_hash}{'MANSION_OPTIONS_BARIAFURI'} = $q->param('mansion_options_bariafuri') if $q->param('mansion_options_bariafuri');
    $self->{_ref_hash}{'MANSION_OPTIONS_TOSIGASU'} = $q->param('mansion_options_tosigasu') if $q->param('mansion_options_tosigasu');
    $self->{_ref_hash}{'MANSION_OPTIONS_PET'} = $q->param('mansion_options_pet') if $q->param('mansion_options_pet');

    $self->{_ref_hash}{'MANSION_KENRI'} = $q->param('mansion_kenri') if $q->param('mansion_kenri');
    $self->{_ref_hash}{'MANSION_SYUUZENTUMITATEKIN'} = $q->param('mansion_syuuzentumitatekin') if $q->param('mansion_syuuzentumitatekin');
    $self->{_ref_hash}{'MANSION_TISEI'} = $q->param('mansion_tisei') if $q->param('mansion_tisei');

    $self->{_ref_hash}{'MANSION_YOUTOTIIKI'} = $q->param('mansion_youtotiiki') if $q->param('mansion_youtotiiki');

    $self->{_ref_hash}{'MANSION_BIKOU'} = $q->param('mansion_bikou') if $q->param('mansion_bikou');
    $self->{_ref_hash}{'MANSION_HIKIWATASI'} = $q->param('mansion_hikiwatasi') if $q->param('mansion_hikiwatasi');
    $self->{_ref_hash}{'MANSION_GENKYOU'} = $q->param('mansion_genkyou') if $q->param('mansion_genkyou');
    $self->{_ref_hash}{'MANSION_TORIHIKITAIYOU'} = $q->param('mansion_torihikitaiyou') if $q->param('mansion_torihikitaiyou');

    $self->{_ref_hash}{'MANSION_YOUR_ID'} = $q->param('mansion_your_id') if $q->param('mansion_your_id');

    $self->{_ref_hash}{'MANSION_ADS_TEXT'} = $q->param('mansion_ads_text') if $q->param('mansion_ads_text');

    $self->{_ref_hash}{'MANSION_PICS_OUTSIDE'} = $q->param('_mansion_pics_outside') if $q->param('_mansion_pics_outside');
    $self->{_ref_hash}{'MANSION_PICS_INSIDE'} = $q->param('_mansion_pics_inside') if $q->param('_mansion_pics_inside');
    $self->{_ref_hash}{'MANSION_PICS_MADORIZU'} = $q->param('_mansion_pics_madorizu') if $q->param('_mansion_pics_madorizu');
    $self->{_ref_hash}{'MANSION_PICS_TIZU'} = $q->param('_mansion_pics_tizu') if $q->param('_mansion_pics_tizu');

    $self->{_ref_hash}{'MANSION_PICS_OUTSIDE_THUMB'} = $q->param('_mansion_pics_outside_thumb') if $q->param('_mansion_pics_outside_thumb');
    $self->{_ref_hash}{'MANSION_PICS_INSIDE_THUMB'} = $q->param('_mansion_pics_inside_thumb') if $q->param('_mansion_pics_inside_thumb');
    $self->{_ref_hash}{'MANSION_PICS_MADORIZU_THUMB'} = $q->param('_mansion_pics_madorizu_thumb') if $q->param('_mansion_pics_madorizu_thumb');
    $self->{_ref_hash}{'MANSION_PICS_TIZU_THUMB'} = $q->param('_mansion_pics_tizu_thumb') if $q->param('_mansion_pics_tizu_thumb');

    $self->{_ref_hash}{'MANSION_MOVIE_FILE_URL'} = $q->param('mansion_movie_file_url') if $q->param('mansion_movie_file_url');

    #$self->{_ref_hash}{'MANSION_TASYAKANRI'} = $q->param('mansion_tasyakanri');
    $self->{_ref_hash}{'MANSION_RYUUTUU'} = $q->param('mansion_ryuutuu') if $q->param('mansion_ryuutuu');

    $self->{_ref_hash}{'MANSION_BUNJYOU_KAISYA'} = $q->param('mansion_bunjyou_kaisya') if $q->param('mansion_bunjyou_kaisya');
    $self->{_ref_hash}{'MANSION_SEKOU_KAISYA'} = $q->param('mansion_sekou_kaisya') if $q->param('mansion_sekou_kaisya');

    $self->{_ref_hash}{'MANSION_KANRI_KEITAI'} = $q->param('mansion_kanri_keitai') if $q->param('mansion_kanri_keitai');
    $self->{_ref_hash}{'MANSION_KANRI_JININ'} = $q->param('mansion_kanri_jinin') if $q->param('mansion_kanri_jinin');

    $self->{_ref_hash}{'MANSION_KANRIKAISYA'} = $q->param('mansion_kanrikaisya') if $q->param('mansion_kanrikaisya');
    $self->{_ref_hash}{'MANSION_KANRIKAISYA_CONTACT'} = $q->param('mansion_kanrikaisya_contact') if $q->param('mansion_kanrikaisya_contact');

    $self->{_ref_hash}{'MANSION_CREATED'} = $q->param('mansion_created') if $q->param('mansion_created');

    $self->{_app}->convert_hash_charset($self->{_ref_hash});
    REPS::Util->convert_hash_zhk($self->{_ref_hash});
    
}



sub get_Create_Realestate_Form{
    my $self = shift;
    #my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    $q->delete('mansion_kanri_keitai');

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'mansion');
    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"マンション名: "), 
                $q->td($q->textfield(-name=>'mansion_name', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_NAME'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'mansion_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'mansion_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_STATION_1'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'mansion_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'mansion_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'mansion_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'mansion_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUSWALK_MINUTES_1'}"),'分'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'mansion_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_STATION_2'}")),
                
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'mansion_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'mansion_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUS_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'mansion_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'mansion_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUSWALK_MINUTES_2'}"),'分'),
            ),
#

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"価格: "), 
                $q->td($q->textfield(-name=>'mansion_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_PRICE'}"),'万円')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"税込み: "), 
                $q->td($q->checkbox(-name=>'mansion_price_tax_inc', -default=>'', -label=>'税込み', -checked=>"$self->{_ref_hash}{'MANSION_PRICE_TAX_INC'}"))
                
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"管理費: "), 
                $q->td($q->textfield(-name=>'mansion_price_kanrihi', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_PRICE_KANRIHI'}"),'円（月額）')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"間取り: "), 
                $q->td($q->popup_menu(-name=>'mansion_madori', -default=>$self->{_ref_hash}{'MANSION_MADORI'},  -values=>['','1R','1K','1DK','1LDK','2K','2DK','2LDK','3K','3DK','3LDK','4K','4DK','4LDK+'],-labels=>{''=>'指定なし','1R'=>'ワンルーム','1K'=>'1K','1DK'=>'1DK','1LDK'=>'1LDK','2K'=>'2K','2DK'=>'2DK','2LDK'=>'2LDK','3K'=>'3K','3DK'=>'3DK','3LDK'=>'3LDK','4K'=>'4K','4DK'=>'4DK','4LDK+'=>'4LDK以上'})),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り内訳: "), 
                $q->td($q->textfield(-name=>'mansion_madori_detail', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_MADORI_DETAIL'}"),''),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"専有面積(平米): "), 
                $q->td($q->textfield(-name=>'mansion_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"面積補足: "), 
                $q->td($q->textfield(-name=>'mansion_square_text', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SQUARE_TEXT'}"),'(実測・公簿・壁芯...)')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"専有面積(坪): "), 
                $q->td($q->textfield(-name=>'mansion_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SQUARE_TUBO'}"),'坪')
            ),

#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"建物構造: "), 
                $q->td($q->textfield(-name=>'mansion_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUILDING_STRUCTURE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"階建: "), 
                $q->td($q->textfield(-name=>'mansion_story', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_STORY'}"),'階建')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"階: "), 
                $q->td($q->textfield(-name=>'mansion_floor', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_FLOOR'}"),'階')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"築年月: "), 
                $q->td($q->textfield(-name=>'mansion_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_AGE'}"),'例： 2000/01'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"部屋番号: "), 
                $q->td($q->textfield(-name=>'mansion_room_number', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_ROOM_NUMBER'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"総戸数: "), 
                $q->td($q->textfield(-name=>'mansion_soukosuu', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SOUKOSUU'}"),'戸')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"主要採光面: "), 
                $q->td($q->textfield(-name=>'mansion_syuyousaikoumen', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SYUYOUSAIKOUMEN'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バルコニー面積: "), 
                $q->td($q->textfield(-name=>'mansion_barukoni_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BARUKONI_SQUARE'}"),'m&sup2'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バルコニー面積: "), 
                $q->td($q->textfield(-name=>'mansion_barukoni_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BARUKONI_SQUARE_TUBO'}"),'坪'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"外装年月: "), 
                $q->td($q->textfield(-name=>'mansion_gaisou_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_GAISOU_AGE'}"),'例：2003/07'),
                
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駐車場: "), 
                $q->td($q->textfield(-name=>'mansion_chusyajyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_CHUSYAJYOU'}"),'台'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"土地権利: "), 
                $q->td($q->textfield(-name=>'mansion_kenri', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_KENRI'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"修繕積立金: "), 
                $q->td($q->textfield(-name=>'mansion_syuuzentumitatekin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SYUUZENTUMITATEKIN'}"),'円（月額）')
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地勢: "), 
                $q->td($q->textfield(-name=>'mansion_tisei', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_TISEI'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"用途地域: "), 
                $q->td($q->textfield(-name=>'mansion_youtotiiki', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_YOUTOTIIKI'}"))
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"条件: "), 
                $q->td($q->textfield(-name=>'mansion_jyouken', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_JYOUKEN'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},

                        $q->Tr(    
                            $q->th('位置'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_kakubeya', -label=>'角部屋', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_KAKUBEYA'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')

                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_pet', -label=>'ペット相談', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_PET'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_autolock', -label=>'オートロック', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_AUTOLOCK'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_elevator', -label=>'エレベーター', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_ELEVATOR'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_system_kitchin', -label=>'システムキッチン', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_SYSTEM_KITCHIN'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_showertoilete', -label=>'シャワートイレ', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_SHOWERTOILETE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_walkin_closet', -label=>'ウォークイン クローゼット', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_WALKIN_CLOSET'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_yukadanbou', -label=>'床暖房', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_YUKADANBOU'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_senyouniwa', -label=>'専用庭', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_SENYOUNIWA'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_tosigasu', -label=>'都市ガス', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_TOSIGASU'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_parking_byke', -label=>'バイク置き場あり', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_PARKING_BYKE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_parking_jitensya', -label=>'駐輪場あり', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_PARKING_JITENSYA'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_barukoni', -label=>'バルコニー', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_BARUKONI'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_bariafuri', -label=>'バリアフリー', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_BARIAFURI'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_parking', -label=>'駐車場あり', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_PARKING'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_yukasita_syuunou', -label=>'床下収納', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_YUKASITA_SYUUNOU'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_tvphone', -label=>'TVフォン', -checked=>"$self->{_ref_hash}{'MANSION_OPTIONS_TVPHONE'}")
                            )
                        )
                    )


                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"設備: "), 
                $q->td($q->textarea(-name=>'mansion_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'MANSION_SETUBI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'mansion_bikou', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'MANSION_BIKOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡: "), 
                $q->td($q->textfield(-name=>'mansion_hikiwatasi', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_HIKIWATASI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"現況: "), 
                $q->td($q->textfield(-name=>'mansion_genkyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_GENKYOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'mansion_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_TORIHIKITAIYOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'mansion_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_YOUR_ID'}")),
                
            ),

            $q->Tr( {-align=>'left'},
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'mansion_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$self->{_ref_hash}{'MANSION_ADS_TEXT'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真１: "), 
                $q->td($q->filefield(-name=>'mansion_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>"$self->{_ref_hash}{'MANSION_PICS_OUTSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真２: "), 
                $q->td($q->filefield(-name=>'mansion_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_PICS_INSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り図: "), 
                $q->td($q->filefield(-name=>'mansion_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_PICS_MADORIZU'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'mansion_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_PICS_TIZU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL: "), 
                $q->td($q->textfield(-name=>'mansion_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_MOVIE_FILE_URL'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"分譲会社: "), 
                $q->td($q->textfield(-name=>'mansion_bunjyou_kaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_BUNJYOU_KAISYA'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"施工会社: "), 
                $q->td($q->textfield(-name=>'mansion_sekou_kaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_SEKOU_KAISYA'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理会社:"), 
                $q->td(

                    #$q->checkbox(-name=>'mansion_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'MANSION_TASYAKANRI'}"),
                    #$q->br,
                    $q->textfield(-name=>'mansion_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_KANRIKAISYA'}")
                    ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"&nbsp;"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                                $q->textfield(-name=>'mansion_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_KANRIKAISYA_CONTACT'}")
                            ),
                        ),
                    )
                ),
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理形態:"), 
                $q->td($q->radio_group(-name=>'mansion_kanri_keitai',
                                -default=>"$self->{_ref_hash}{'MANSION_KANRI_KEITAI'}",
                                -values=>['1','2','3'],
                                -labels=>{'1'=>'全て委託','2'=>'一部委託','3'=>'自主管理'}
                        )
                    ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理人員: "), 
                $q->td($q->textfield(-name=>'mansion_kanri_jinin', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_KANRI_JININ'}")),
                
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'mansion_ryuutuu',-label=>'流通可', -checked=>"$self->{_ref_hash}{'MANSION_RYUUTUU'}"),
            #    ),
            #),


            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_add'),
                    $q->hidden(-name => '_type', -value => 'bm'),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加する', -checked=>""),
                    $q->checkbox(-name=>'mansion_publish', -label=>'公開する', -checked=>"$self->{_ref_hash}{'MANSION_PUBLISHED'}"),
                    $q->submit(-name => 'add_new_object' ,-value => '新規追加', -class=>'submit')

                )
            )



        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.mansion.mansion_name.focus(); \n// --></script>";
    return $output;
}

sub create_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();

    #todo check each item
    #if ($$ref_hash{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        if ($$ref_hash{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){
            $result .= '異なるユーザーIDでは登録できません。<br />';
        }
    }
    $$ref_hash{'MANSION_USER_ID'} = $self->{_app}->param('user_id');

    if (!$$ref_hash{'MANSION_NAME'}) {$result .= 'マンション名称が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_PRICE'}) {$result .= '価格が入力されていません。<br />';}
    #if (!$$ref_hash{'MANSION_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}

    #if (!$$ref_hash{'MANSION_PRICE_TAX_INC'}) {$result .= '税込みが入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_PRICE_KANRIHI'}) {$result .= '管理費が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_MADORI'}) {$result .= '間取りが入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_STORY'}) {$result .= '階建てが入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_FLOOR'}) {$result .= '階が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_AGE'}) {$result .= '築年月が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'MANSION_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_STORY'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階建ての数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_FLOOR'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SOUKOSUU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '総戸数の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BARUKONI_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バルコニー面積(平米)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BARUKONI_SQUARE_TUBO'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バルコニー面積(坪)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_CHUSYAJYOU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駐車場（台）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '専有面積(平米)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SQUARE_TUBO'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '専有面積(坪)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SYUUZENTUMITATEKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '修繕積立金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'MANSION_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'MANSION_PRICE'}) {
        my $str = $$ref_hash{'MANSION_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{1,80}))$/){

        }else{
            $result .= '価格の値が不自然です。半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'MANSION_AGE'}){
        my $str = $$ref_hash{'MANSION_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />';
        }
    }

    if ($$ref_hash{'MANSION_SQUARE'}){
        unless($$ref_hash{'MANSION_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
            $result .= '面積は半角英数とピリオド（.）だけで入力してください。<br />'; #/31
        }
    }

    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'bm' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('mansion_pics_outside')){
        my $fh = $q->upload('mansion_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('mansion_pics_inside')){
        my $fh = $q->upload('mansion_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'MANSION_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('mansion_pics_madorizu')){
        my $fh = $q->upload('mansion_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'MANSION_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('mansion_pics_tizu')){
        my $fh = $q->upload('mansion_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'MANSION_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
    }else{
        $$ref_hash{'MANSION_CREATED'} = REPS::Util->get_datetime_now();
        my %mansion;
        my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');
        my $num_keys = 1;
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%mansion, 'MLDBM', $db_b_mansion_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        $num_keys = scalar keys (%mansion);
        $num_keys = sprintf('%06d', $num_keys++);
        if (exists $mansion{$num_keys}){
            #count up and add again. This could happen when export and import data.
            #$result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
            while (exists $mansion{$num_keys}) {
                $num_keys++;
                if ($num_keys >= 999999) {die "Reached lmit.";};
            }
        }
        if (!defined $mansion{$num_keys}){
            $$ref_hash{'MANSION_ID'} = $num_keys;
            eval {
                if ($q->param('mansion_pics_outside')){
                    my $tmp = $$ref_hash{'MANSION_PICS_OUTSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_OUTSIDE'},$dir.$tmp);
                    $$ref_hash{'MANSION_PICS_OUTSIDE'} = 'bm' . '/'.$tmp;
                    if ($$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'} = 'bm' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('mansion_pics_inside')){
                    my $tmp = $$ref_hash{'MANSION_PICS_INSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_INSIDE'},$dir.$tmp);
                    $$ref_hash{'MANSION_PICS_INSIDE'} = 'bm' . '/'.$tmp;
                    if ($$ref_hash{'MANSION_PICS_INSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'MANSION_PICS_INSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'MANSION_PICS_INSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'MANSION_PICS_INSIDE_THUMB'} = 'bm' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('mansion_pics_madorizu')){
                    my $tmp = $$ref_hash{'MANSION_PICS_MADORIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_MADORIZU'},$dir.$tmp);
                    $$ref_hash{'MANSION_PICS_MADORIZU'} = 'bm' . '/'.$tmp;
                    if ($$ref_hash{'MANSION_PICS_MADORIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'MANSION_PICS_MADORIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'MANSION_PICS_MADORIZU_THUMB'} = 'bm' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            eval {
                if ($q->param('mansion_pics_tizu')){
                    my $tmp = $$ref_hash{'MANSION_PICS_TIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_TIZU'},$dir.$tmp);
                    $$ref_hash{'MANSION_PICS_TIZU'} = 'bm' . '/'.$tmp;
                    if ($$ref_hash{'MANSION_PICS_TIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'MANSION_PICS_TIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_TIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'MANSION_PICS_TIZU_THUMB'} = 'bm' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            $mansion{$num_keys} = $ref_hash;
            $self->{_ref_hash} = $ref_hash;
        }else{
            $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
        }

        untie %mansion;
umask($old);
#                 my %hash_sp=(
#                         'BS_ID' => $$ref_hash{'MANSION_ID'},
#                         'BS_NAME' => $$ref_hash{'MANSION_NAME'},
#                         'BS_STATION_1' => $$ref_hash{'MANSION_STATION_1'},
#                         'BS_STATION_2' => $$ref_hash{'MANSION_STATION_2'},
#                         'BS_LOCATION' =>$$ref_hash{'MANSION_LOCATION'},
#                         'BS_PRICE' => REPS::Util->insert_comma($$ref_hash{'MANSION_PRICE'}),
#                         'BS_BUS_MINUTES_1' => $$ref_hash{'MANSION_BUS_MINUTES_1'},
#                         'BS_WALK_MINUTES_1' => $$ref_hash{'MANSION_WALK_MINUTES_1'},
#                         'BS_SQUARE' => $$ref_hash{'MANSION_SQUARE'},
#     
#     #                    'BS_PRICE_KANRIHI' => REPS::Util->insert_comma($$ref_hash{'LAND_PRICE_KANRIHI'}),
#     #                    'BS_PRICE_SIKIKIN' => $$ref_hash{'LAND_PRICE_SIKIKIN'},
#     #                    'BS_PRICE_REIKIN' => $$ref_hash{'LAND_PRICE_REIKIN'},
#                         'BS_MADORI' => $$ref_hash{'MANSION_MADORI'},
#                         'BS_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'},
#                         'BS_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_MADORIZU_THUMB'},
#                         'BS_ADS_TEXT' => $$ref_hash{'MANSION_ADS_TEXT'}
#                 );
#                 $hash_sp{'BS_KIND'}='マンション';
#                 $hash_sp{'_type'}='bm';

#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'MANSION_PUBLISHED'}){
#                 #Special
#     
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BM'.$$ref_hash{'MANSION_ID'},
#                                 \%hash_sp
#                             );
#         
#                 $special->add_special();
#     
#                 #$$ref_hash{'APART_IS_SPECIAL'} = '1';
#             }else{
#                 $result .="<div class=\"information\"><p>更新されましたが、非公開ですので、お勧め物件には登録できません。</p></div>";
#             }
#         }
#         #add to updates
#         if ($$ref_hash{'MANSION_PUBLISHED'}){
#             if (!$$ref_hash{'MANSION_LAST_UPDATED'}){
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'MANSION_CREATED'};
#             }else{
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'MANSION_LAST_UPDATED'};
#             }
#             my $updates = REPS::Updates::Updates->new(
#                             $self->{_app},
#                             $self->{_app}->param('db_bs_updates_path'),
#                             'BM'.$$ref_hash{'MANSION_ID'},
#                             \%hash_sp
#                         );
#     
#             $updates->add_updates();
#         }


    }


    return $result;

}

sub get_Realestate_List{
    my ($self,$sort_by,$off_set,$items_per_page,$only_this_user) = @_;

    my %sort_hash = ();
    my %tmp;
    my $key;
    my $value;
    my @loop_data;
    my $count = 0;

    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');
    if (-f $db_b_mansion_path){
        tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        my @sort_keys;
        while ( ($key, $value) = each(%mansion) ) {
            if ((defined $value) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'MANSION_USER_ID'}){
                    if ($only_this_user){
                        if ($only_this_user ne $tmp{'MANSION_USER_ID'}){
                            next;
                        }
                    }
                    
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($tmp{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')) {
                                next;
                            }
                        }
                    }else{
                        if (!$only_this_user){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($tmp{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')) {
                                    next;
                                }
                            }
                        }
                    }


    #                if ($tmp{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')){
                        #sort
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'price'){
                                $sort_hash{$key} = $tmp{'MANSION_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'MANSION_LAST_UPDATED'})&&($tmp{'MANSION_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'MANSION_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'MANSION_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'MANSION_LOCATION'};
                            }elsif($sort_by eq 'name'){
                                $sort_hash{$key} = $tmp{'MANSION_NAME'};
                            }
                        }else{
        
#                            my %hash = (
#                                'MANSION_ID' => "$key",
#                                'MANSION_PUBLISHED' => $tmp{'MANSION_PUBLISHED'},
#                                'MANSION_NAME' => $tmp{'MANSION_NAME'},
#                                'MANSION_LOCATION' => $tmp{'MANSION_LOCATION'},
#                                'MANSION_PRICE' => REPS::Util->insert_comma($tmp{'MANSION_PRICE'}),
#                                'MANSION_CREATED' => REPS::Util->get_date_as_string($tmp{'MANSION_CREATED'}),
#                                'MANSION_LAST_UPDATED' =>REPS::Util->get_date_as_string($tmp{'MANSION_LAST_UPDATED'}),
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
            #
        }
        $count = @sort_keys;
        #paging
        if (!$off_set){$off_set=0;}
        @sort_keys = splice( @sort_keys , $off_set,$items_per_page);

        foreach (@sort_keys){

            my %tmp = %{$mansion{$_}};

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

            my %hash = (
                'MANSION_ID' => "$_",
                'MANSION_PUBLISHED' => $tmp{'MANSION_PUBLISHED'},
                'MANSION_IS_SPECIAL' => $tmp{'MANSION_IS_SPECIAL'},
                'MANSION_NAME' => $tmp{'MANSION_NAME'},
                'MANSION_LOCATION' => $tmp{'MANSION_LOCATION'},
                'MANSION_ROOM_NUMBER' => $tmp{'MANSION_ROOM_NUMBER'},
                'MANSION_PRICE' => REPS::Util->insert_comma($tmp{'MANSION_PRICE'}),
                'MANSION_NEW' => $new,
                'MANSION_UPDATED' => $updated,
                'static_url' => $self->{_app}->cfg('static_url'),
                'MANSION_CREATED' => REPS::Util->get_date_as_string($tmp{'MANSION_CREATED'}),
                'MANSION_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'MANSION_LAST_UPDATED'}),
            );
    
            push(@loop_data, \%hash);
        }
    
        untie %mansion;
    }
    return \@loop_data,$count;
}

sub get_Realestate {
    my $self = shift;
    my $mansion_id = $_[0];

    my $ref_hash;
    my %hash;
    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');

    unless ($mansion_id =~ /[0-9]{6,10}/){Carp::croak "IDの形式が不正です。";}

    tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    if (exists $mansion{$mansion_id} ) {
        if ((defined $mansion{$mansion_id}) && ($mansion{$mansion_id})){
            $ref_hash = $mansion{$mansion_id};
            if ($self->{_app}->param('user_isAdmin') != 1){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($mansion{$mansion_id}{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')) {
                        untie %mansion;
                        Carp::croak "The ID [$mansion_id] does not belong to you.";
                    }
                }
            }
            #%hash = %$ref_hash;
#            if ($self->{_app}->param('user_id') eq $$ref_hash{'MANSION_USER_ID'}){

                $self->{_ref_hash} = $mansion{$mansion_id};
                
#            }else{
#                untie %mansion;
#                Carp::croak 'the ID does not belong to you.';
#            }
        }else{
            untie %mansion;
            return 0;
            #Carp::croak "The ID $mansion_id has no value. Possibly deleted.";
        }
    }else{
        untie %mansion;
        return 0;
        #Carp::croak "The ID [$mansion_id] does not exists.";
    }

    untie %mansion;

    return 1;
}

sub get_Edit_Realestate_Form{
    my $self = shift;
    my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();
    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $output = "<div class=\"warning\"><p>他のユーザーの物件はアクセス出来ません。 </p></div>";
                return $output;
            }
        }
    }
    #$q->delete('mansion_kanri_keitai');

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'mansion');

    my $ifView = '';
    if ($$ref_hash{'MANSION_IS_SPECIAL'}){
        $ifView .= '<img src="'.$self->{_app}->cfg('static_url').'icons/16-heart-gold-m.png" width="16" height="16" />';
    }
    if ($$ref_hash{'MANSION_PUBLISHED'}){
        $ifView .= "&nbsp;<a href=\"./search.cgi?_mode=mode_detail&_type=bm&_object_id=$$ref_hash{'MANSION_ID'}\" target=\"_blank\">公開ページ閲覧</a>";
    }

    #dummy var for delete pics
    $output .= $q->hidden(-name => 'delete_pic', -value => '');

    my $ifPicsOutside = '';
    if ($$ref_hash{'MANSION_PICS_OUTSIDE'}){
        if ($$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'}){
            $ifPicsOutside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'}."\" width=\"210\" align=\"left\" >".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_OUTSIDE\');" />';
        }else{
            $ifPicsOutside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_OUTSIDE'}."\">写真１</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_OUTSIDE\');" />';
        }
    }
    my $ifPicsInside = '';
    if ($$ref_hash{'MANSION_PICS_INSIDE'}){
        if ($$ref_hash{'MANSION_PICS_INSIDE_THUMB'}){
            $ifPicsInside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_INSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_INSIDE\');" />';
        }else{
            $ifPicsInside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_INSIDE'}."\">写真２</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_INSIDE\');" />';
        }
    }
    my $ifMadorizu = '';
    if ($$ref_hash{'MANSION_PICS_MADORIZU'}){
        if ($$ref_hash{'MANSION_PICS_MADORIZU_THUMB'}){
            $ifMadorizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_MADORIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_MADORIZU\');" />';
        }else{
            $ifMadorizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_MADORIZU'}."\">間取り図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_MADORIZU\');" />';
        }
    }
    my $ifTizu = '';
    if ($$ref_hash{'MANSION_PICS_TIZU'}){
        if ($$ref_hash{'MANSION_PICS_TIZU_THUMB'}){
            $ifTizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_TIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_TIZU\');" />';
        }else{
            $ifTizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_TIZU'}."\">地図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'MANSION_PICS_TIZU\');" />';
        }
    }

    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"物件番号："), 
                $q->th('[BM'.$$ref_hash{'MANSION_ID'}.']'.$ifView), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"マンション名: "), 
                $q->td($q->textfield(-name=>'mansion_name', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_NAME'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'mansion_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'mansion_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_STATION_1'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'mansion_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'MANSION_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'mansion_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'mansion_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'mansion_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUSWALK_MINUTES_1'}"),'分'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'mansion_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_STATION_2'}")),
                
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'mansion_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'MANSION_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'mansion_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUS_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'mansion_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'mansion_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUSWALK_MINUTES_2'}"),'分'),
            ),
#


            $q->Tr( {-align=>'left'}, 

                $q->td({-align=>'right', -class=>'required'},"価格: "), 
                $q->td($q->textfield(-name=>'mansion_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_PRICE'}"),'万円')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"税込み: "), 
                $q->td($q->checkbox(-name=>'mansion_price_tax_inc', -default=>'', -label=>'税込み', -checked=>"$$ref_hash{'MANSION_PRICE_TAX_INC'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"管理費: "), 
                $q->td($q->textfield(-name=>'mansion_price_kanrihi', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_PRICE_KANRIHI'}"),'円（月額）')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"間取り: "), 
                $q->td($q->popup_menu(-name=>'mansion_madori', -default=>$$ref_hash{'MANSION_MADORI'},  -values=>['','1R','1K','1DK','1LDK','2K','2DK','2LDK','3K','3DK','3LDK','4K','4DK','4LDK+'],-labels=>{''=>'指定なし','1R'=>'ワンルーム','1K'=>'1K','1DK'=>'1DK','1LDK'=>'1LDK','2K'=>'2K','2DK'=>'2DK','2LDK'=>'2LDK','3K'=>'3K','3DK'=>'3DK','3LDK'=>'3LDK','4K'=>'4K','4DK'=>'4DK','4LDK+'=>'4LDK以上'})),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り内訳: "), 
                $q->td($q->textfield(-name=>'mansion_madori_detail', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_MADORI_DETAIL'}"),''),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"専有面積(平米): "), 
                $q->td($q->textfield(-name=>'mansion_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"面積補足: "), 
                $q->td($q->textfield(-name=>'mansion_square_text', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SQUARE_TEXT'}"),'(実測・公簿・壁芯...)')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"専有面積(坪): "), 
                $q->td($q->textfield(-name=>'mansion_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SQUARE_TUBO'}"),'坪')
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"建物構造: "), 
                $q->td($q->textfield(-name=>'mansion_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUILDING_STRUCTURE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"階建: "), 
                $q->td($q->textfield(-name=>'mansion_story', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_STORY'}"),'階建')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"階: "), 
                $q->td($q->textfield(-name=>'mansion_floor', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_FLOOR'}"),'階')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"築年月: "), 
                $q->td($q->textfield(-name=>'mansion_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$$ref_hash{'MANSION_AGE'}"),'例： 2000/01'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"部屋番号: "), 
                $q->td($q->textfield(-name=>'mansion_room_number', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_ROOM_NUMBER'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"総戸数: "), 
                $q->td($q->textfield(-name=>'mansion_soukosuu', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SOUKOSUU'}"),'戸')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"主要採光面: "), 
                $q->td($q->textfield(-name=>'mansion_syuyousaikoumen', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SYUYOUSAIKOUMEN'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バルコニー面積: "), 
                $q->td($q->textfield(-name=>'mansion_barukoni_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BARUKONI_SQUARE'}"),'m&sup2'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バルコニー面積: "), 
                $q->td($q->textfield(-name=>'mansion_barukoni_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BARUKONI_SQUARE_TUBO'}"),'坪'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"外装年月: "), 
                $q->td($q->textfield(-name=>'mansion_gaisou_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$$ref_hash{'MANSION_GAISOU_AGE'}"),'例：2003/07'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駐車場: "), 
                $q->td($q->textfield(-name=>'mansion_chusyajyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_CHUSYAJYOU'}"),'台'),
                
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"土地権利: "), 
                $q->td($q->textfield(-name=>'mansion_kenri', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_KENRI'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"修繕積立金: "), 
                $q->td($q->textfield(-name=>'mansion_syuuzentumitatekin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SYUUZENTUMITATEKIN'}"),'円（月額）')
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地勢: "), 
                $q->td($q->textfield(-name=>'mansion_tisei', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_TISEI'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"用途地域: "), 
                $q->td($q->textfield(-name=>'mansion_youtotiiki', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_YOUTOTIIKI'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"条件: "), 
                $q->td($q->textfield(-name=>'mansion_jyouken', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_JYOUKEN'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(    
                            $q->th('位置'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_kakubeya', -label=>'角部屋', -checked=>"$$ref_hash{'MANSION_OPTIONS_KAKUBEYA'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')

                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_pet', -label=>'ペット相談', -checked=>"$$ref_hash{'MANSION_OPTIONS_PET'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_autolock', -label=>'オートロック', -checked=>"$$ref_hash{'MANSION_OPTIONS_AUTOLOCK'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_elevator', -label=>'エレベーター', -checked=>"$$ref_hash{'MANSION_OPTIONS_ELEVATOR'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_system_kitchin', -label=>'システムキッチン', -checked=>"$$ref_hash{'MANSION_OPTIONS_SYSTEM_KITCHIN'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_showertoilete', -label=>'シャワートイレ', -checked=>"$$ref_hash{'MANSION_OPTIONS_SHOWERTOILETE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_walkin_closet', -label=>'ウォークイン クローゼット', -checked=>"$$ref_hash{'MANSION_OPTIONS_WALKIN_CLOSET'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_yukadanbou', -label=>'床暖房', -checked=>"$$ref_hash{'MANSION_OPTIONS_YUKADANBOU'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_senyouniwa', -label=>'専用庭', -checked=>"$$ref_hash{'MANSION_OPTIONS_SENYOUNIWA'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_tosigasu', -label=>'都市ガス', -checked=>"$$ref_hash{'MANSION_OPTIONS_TOSIGASU'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_parking_byke', -label=>'バイク置き場あり', -checked=>"$$ref_hash{'MANSION_OPTIONS_PARKING_BYKE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_parking_jitensya', -label=>'駐輪場あり', -checked=>"$$ref_hash{'MANSION_OPTIONS_PARKING_JITENSYA'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_barukoni', -label=>'バルコニー', -checked=>"$$ref_hash{'MANSION_OPTIONS_BARUKONI'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_bariafuri', -label=>'バリアフリー', -checked=>"$$ref_hash{'MANSION_OPTIONS_BARIAFURI'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_parking', -label=>'駐車場あり', -checked=>"$$ref_hash{'MANSION_OPTIONS_PARKING'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_yukasita_syuunou', -label=>'床下収納', -checked=>"$$ref_hash{'MANSION_OPTIONS_YUKASITA_SYUUNOU'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'mansion_options_tvphone', -label=>'TVフォン', -checked=>"$$ref_hash{'MANSION_OPTIONS_TVPHONE'}")
                            )
                        )
                    )


                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"設備: "), 
                $q->td($q->textarea(-name=>'mansion_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'MANSION_SETUBI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'mansion_bikou', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'MANSION_BIKOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡: "), 
                $q->td($q->textfield(-name=>'mansion_hikiwatasi', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_HIKIWATASI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"現況: "), 
                $q->td($q->textfield(-name=>'mansion_genkyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_GENKYOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'mansion_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_TORIHIKITAIYOU'}"))
            ),



            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'mansion_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'MANSION_YOUR_ID'}")),
                
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'mansion_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$$ref_hash{'MANSION_ADS_TEXT'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真１: "), 
                $q->td($q->filefield(-name=>'mansion_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>""),
                    '<br />',
                    "$ifPicsOutside",
                    $q->hidden(-name => '_mansion_pics_outside', -value => "$$ref_hash{'MANSION_PICS_OUTSIDE'}"),
                    $q->hidden(-name => '_mansion_pics_outside_thumb', -value => "$$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真２: "), 
                $q->td($q->filefield(-name=>'mansion_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifPicsInside",
                    $q->hidden(-name => '_mansion_pics_inside', -value => "$$ref_hash{'MANSION_PICS_INSIDE'}"),
                    $q->hidden(-name => '_mansion_pics_inside_thumb', -value => "$$ref_hash{'MANSION_PICS_INSIDE_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り図: "), 
                $q->td($q->filefield(-name=>'mansion_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifMadorizu",
                    $q->hidden(-name => '_mansion_pics_madorizu', -value => "$$ref_hash{'MANSION_PICS_MADORIZU'}"),
                    $q->hidden(-name => '_mansion_pics_madorizu_thumb', -value => "$$ref_hash{'MANSION_PICS_MADORIZU_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'mansion_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifTizu",
                    $q->hidden(-name => '_mansion_pics_tizu', -value => "$$ref_hash{'MANSION_PICS_TIZU'}"),
                    $q->hidden(-name => '_mansion_pics_tizu_thumb', -value => "$$ref_hash{'MANSION_PICS_TIZU_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL: "), 
                $q->td($q->textfield(-name=>'mansion_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_MOVIE_FILE_URL'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"分譲会社: "), 
                $q->td($q->textfield(-name=>'mansion_bunjyou_kaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_BUNJYOU_KAISYA'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"施工会社: "), 
                $q->td($q->textfield(-name=>'mansion_sekou_kaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_SEKOU_KAISYA'}")),
                
            ),

#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"管理会社:<br />電話番号:"), 
#                $q->td(
#                    #$q->checkbox(-name=>'mansion_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'MANSION_TASYAKANRI'}"),
#                    #$q->br,
#                    $q->textfield(-name=>'mansion_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'mansion_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'MANSION_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理会社:"), 
                $q->td(

                    #$q->checkbox(-name=>'mansion_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'MANSION_TASYAKANRI'}"),
                    #$q->br,
                    $q->textfield(-name=>'mansion_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_KANRIKAISYA'}")
                    ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"&nbsp;"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                                $q->textfield(-name=>'mansion_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'MANSION_KANRIKAISYA_CONTACT'}")
                            ),
                        ),
                    )
                ),
            ),



            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理形態:"), 
                $q->td($q->radio_group(-name=>'mansion_kanri_keitai',
                            -default=>"$$ref_hash{'MANSION_KANRI_KEITAI'}",
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'全て委託','2'=>'一部委託','3'=>'自主管理'}
                        )
                    ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理人員: "), 
                $q->td($q->textfield(-name=>'mansion_kanri_jinin', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'MANSION_KANRI_JININ'}")),
                
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'mansion_ryuutuu',-label=>'流通可', -checked=>"$$ref_hash{'MANSION_RYUUTUU'}"),
            #    ),
            #),


            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_edit'),
                    $q->hidden(-name => '_type', -value => 'bm'),
                    $q->hidden(-name => '_object_id', -value => "$$ref_hash{'MANSION_ID'}"),
                    $q->hidden(-name => 'mansion_created', -value => "$$ref_hash{'MANSION_CREATED'}"),
                    $q->hidden(-name => 'add_to_special', -value => "$$ref_hash{'MANSION_IS_SPECIAL'}"),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加する', -checked=>"$self->{_ref_hash}{'MANSION_IS_SPECIAL'}"),
                    $q->checkbox(-name=>'mansion_publish', -label=>'公開する', -checked=>"$$ref_hash{'MANSION_PUBLISHED'}"),
                    $q->submit(-name => 'edit_object' ,-value => '編集更新', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.mansion.mansion_name.focus(); \n// --></script>";
    return $output;
}

sub update_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();

    #todo check each item
    unless ($$ref_hash{'MANSION_ID'}=~ /[0-9]{6,10}/){$result .= 'IDの形式が不正です。<br />';}
#    if ($$ref_hash{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $result = "<div class=\"warning\"><p>他のユーザーの物件は更新できません。更新されませんでした。</p></div>";
                return $result;
            }
        }
    }

    if (!$$ref_hash{'MANSION_NAME'}) {$result .= 'マンション名称が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_PRICE'}) {$result .= '価格が入力されていません。<br />';}
    #if (!$$ref_hash{'MANSION_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}

    #if (!$$ref_hash{'MANSION_PRICE_TAX_INC'}) {$result .= '税込みが入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_PRICE_KANRIHI'}) {$result .= '管理費が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_MADORI'}) {$result .= '間取りが入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_STORY'}) {$result .= '階建てが入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_FLOOR'}) {$result .= '階が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_AGE'}) {$result .= '築年月が入力されていません。<br />';}
    if (!$$ref_hash{'MANSION_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'MANSION_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_STORY'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階建ての数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_FLOOR'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SOUKOSUU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '総戸数の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BARUKONI_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バルコニー面積(平米)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BARUKONI_SQUARE_TUBO'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バルコニー面積(坪)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_CHUSYAJYOU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駐車場（台）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '専有面積(平米)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SQUARE_TUBO'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '専有面積(坪)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_SYUUZENTUMITATEKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '修繕積立金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'MANSION_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'MANSION_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'MANSION_PRICE'}) {
        my $str = $$ref_hash{'MANSION_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{1,80}))$/){

        }else{
            $result .= '価格の値が不自然です。半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'MANSION_AGE'}){
        my $str = $$ref_hash{'MANSION_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />';
        }
    }
    if ($$ref_hash{'MANSION_SQUARE'}){
        unless($$ref_hash{'MANSION_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
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

    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'bm' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('mansion_pics_outside')){
        my $fh = $q->upload('mansion_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('mansion_pics_inside')){
        my $fh = $q->upload('mansion_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'MANSION_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('mansion_pics_madorizu')){
        my $fh = $q->upload('mansion_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'MANSION_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('mansion_pics_tizu')){
        my $fh = $q->upload('mansion_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'MANSION_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'MANSION_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />更新されませんでした。</p></div>";
    }else{
        $$ref_hash{'MANSION_LAST_UPDATED'} = REPS::Util->get_datetime_now();
        my %mansion;
        my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');
        tie (%mansion, 'MLDBM', $db_b_mansion_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        
        if (!$mansion{$$ref_hash{'MANSION_ID'}}){
            $result = "<div class=\"warning\"><p>別のユーザー又は別の画面で削除された可能性があります。<br />更新されませんでした。</p></div>";
            return $result;
        }
#        if ($mansion{$$ref_hash{'MANSION_ID'}}{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')){
        if ($self->{_app}->param('user_isAdmin') != 1){
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($mansion{$$ref_hash{'MANSION_ID'}}{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){
                    $result = "<div class=\"warning\"><p>他のユーザーの物件は更新出来ません。 </p></div>";
                    untie %mansion;
                    return $result;
                }
            }
        }
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
        my $num_keys = REPS::Util->de_taint($$ref_hash{'MANSION_ID'});

        eval {
            if ($q->param('mansion_pics_outside')){
                my $tmp = $$ref_hash{'MANSION_PICS_OUTSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_OUTSIDE'},$dir.$tmp);
                $$ref_hash{'MANSION_PICS_OUTSIDE'} = 'bm' . '/'.$tmp;
                if ($$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'} = 'bm' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('mansion_pics_inside')){
                my $tmp = $$ref_hash{'MANSION_PICS_INSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_INSIDE'},$dir.$tmp);
                $$ref_hash{'MANSION_PICS_INSIDE'} = 'bm' . '/'.$tmp;
                if ($$ref_hash{'MANSION_PICS_INSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'MANSION_PICS_INSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'MANSION_PICS_INSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'MANSION_PICS_INSIDE_THUMB'} = 'bm' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('mansion_pics_madorizu')){
                my $tmp = $$ref_hash{'MANSION_PICS_MADORIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_MADORIZU'},$dir.$tmp);
                $$ref_hash{'MANSION_PICS_MADORIZU'} = 'bm' . '/'.$tmp;
                if ($$ref_hash{'MANSION_PICS_MADORIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'MANSION_PICS_MADORIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'MANSION_PICS_MADORIZU_THUMB'} = 'bm' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        eval {
            if ($q->param('mansion_pics_tizu')){
                my $tmp = $$ref_hash{'MANSION_PICS_TIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_TIZU'},$dir.$tmp);
                $$ref_hash{'MANSION_PICS_TIZU'} = 'bm' . '/'.$tmp;
                if ($$ref_hash{'MANSION_PICS_TIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'MANSION_PICS_TIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'MANSION_PICS_TIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'MANSION_PICS_TIZU_THUMB'} = 'bm' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        ##TODO:
        if (!$mansion{$$ref_hash{'MANSION_ID'}}{'MANSION_USER_ID'}){
            $$ref_hash{'MANSION_USER_ID'} = $self->{_app}->param('user_id');
        }else{
            $$ref_hash{'MANSION_USER_ID'} = $mansion{$$ref_hash{'MANSION_ID'}}{'MANSION_USER_ID'};
        }

        $mansion{$$ref_hash{'MANSION_ID'}} = $ref_hash;

        untie %mansion;

        #update recommend
        if ($$ref_hash{'MANSION_IS_SPECIAL'}) {
            $self->{_app}->recommend_static_write_file();
        }


#                 my %hash_sp=(
#                         'BS_ID' => $$ref_hash{'MANSION_ID'},
#                         'BS_NAME' => $$ref_hash{'MANSION_NAME'},
#                         'BS_STATION_1' => $$ref_hash{'MANSION_STATION_1'},
#                         'BS_STATION_2' => $$ref_hash{'MANSION_STATION_2'},
#                         'BS_LOCATION' =>$$ref_hash{'MANSION_LOCATION'},
#                         'BS_PRICE' => REPS::Util->insert_comma($$ref_hash{'MANSION_PRICE'}),
#                         'BS_BUS_MINUTES_1' => $$ref_hash{'MANSION_BUS_MINUTES_1'},
#                         'BS_WALK_MINUTES_1' => $$ref_hash{'MANSION_WALK_MINUTES_1'},
#                         'BS_SQUARE' => $$ref_hash{'MANSION_SQUARE'},
#     
#     #                    'BS_PRICE_KANRIHI' => REPS::Util->insert_comma($$ref_hash{'LAND_PRICE_KANRIHI'}),
#     #                    'BS_PRICE_SIKIKIN' => $$ref_hash{'LAND_PRICE_SIKIKIN'},
#     #                    'BS_PRICE_REIKIN' => $$ref_hash{'LAND_PRICE_REIKIN'},
#                         'BS_MADORI' => $$ref_hash{'MANSION_MADORI'},
#                         'BS_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_OUTSIDE_THUMB'},
#                         'BS_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'MANSION_PICS_MADORIZU_THUMB'},
#                         'BS_ADS_TEXT' => $$ref_hash{'MANSION_ADS_TEXT'}
#                 );
#                 $hash_sp{'BS_KIND'}='マンション';
#                 $hash_sp{'_type'}='bm';

#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'MANSION_PUBLISHED'}){
#                 #Special
#     
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BM'.$$ref_hash{'MANSION_ID'},
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
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BM'.$$ref_hash{'MANSION_ID'}
#                             );
#                 $special->delete_Realestate('BM'.$$ref_hash{'MANSION_ID'});
#         }
#         #add to updates
#         if ($$ref_hash{'MANSION_PUBLISHED'}){
#             if (!$$ref_hash{'MANSION_LAST_UPDATED'}){
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'MANSION_CREATED'};
#             }else{
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'MANSION_LAST_UPDATED'};
#             }
#             my $updates = REPS::Updates::Updates->new(
#                             $self->{_app},
#                             $self->{_app}->param('db_bs_updates_path'),
#                             'BM'.$$ref_hash{'MANSION_ID'},
#                             \%hash_sp
#                         );
#     
#             $updates->add_updates();
#         }

    }


    return $result;

}

sub delete_Realestate{
    my $self = shift;
    my @to_be_deleted = @_;
    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');

    tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $mansion{$_}){
                if (defined $mansion{$_} && ($mansion{$_})){
                    #my $ref_hash = $mansion{$_};
                    #my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($mansion{$_}{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')) {
                                undef $mansion{$_};
                            } else {
    #                            delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            undef $mansion{$_};
                        }
                    }else{
                        undef $mansion{$_};
                    }
#                    if ($hash{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')){
                        #delete $mansion{$_};
#                        $mansion{$_} = undef;
#                    }
                }

            }
        }
    }
    untie %mansion;

#     #delete dupe here
#     if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
#         my %delete_dupelicate;
#         @to_be_deleted = grep(!$delete_dupelicate{$_}++, @to_be_deleted);
#     }
#     #
#     my $special = REPS::Special::Special->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_special_path')
#                 );
#     $special->delete_Realestate((map {"BM". $_ } @to_be_deleted));
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_updates_path')
#                 );
# 
#     $updates->delete_Realestate((map {"BM". $_ } @to_be_deleted));
    #
#todo
#check and make sure it is owned by the user MANSION_USER_ID
    return 1;
}

sub dup_Realestate{
    my $self = shift;
    my @to_be_duped = @_;
    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');

    require REPS::Util;
    use File::Copy;
    use File::Basename;
    my $res_dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory'));

    tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_duped){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $mansion{$_}){
                if (defined $mansion{$_} && ($mansion{$_})){
                #    
                #    $apart{$_} = \%hash;
                    my $num_keys = scalar keys (%mansion);
                    $num_keys = sprintf('%06d', $num_keys++);
                    if (exists $mansion{$num_keys}){
                        #count up and add again. This could happen when export and import data.
                        while (exists $mansion{$num_keys}) {
                            $num_keys++;
                            if ($num_keys >= 999999) {die "Reached lmit.";}
                        }
                    }
                    my %hash = %{$mansion{$_}};
                    #物件IDをつける
                    $hash{'MANSION_ID'} = $num_keys;
                    #部屋番号を空にする。
                    #$hash{'MANSION_ROOM_NUMBER'} = '';

                    $hash{'MANSION_CREATED'} = REPS::Util->get_datetime_now();
                    $hash{'MANSION_LAST_UPDATED'} = '';

                    if ($hash{'MANSION_PICS_OUTSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_OUTSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_OUTSIDE'}, $res_dir.'bm/'.$num_keys.'_a'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_OUTSIDE'} = 'bm/'.$num_keys.'_a'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'MANSION_PICS_INSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_INSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_INSIDE'}, $res_dir.'bm/'.$num_keys.'_b'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_INSIDE'} = 'bm/'.$num_keys.'_b'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'MANSION_PICS_MADORIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_MADORIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_MADORIZU'}, $res_dir.'bm/'.$num_keys.'_c'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_MADORIZU'} = 'bm/'.$num_keys.'_c'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'MANSION_PICS_TIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_TIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_TIZU'}, $res_dir.'bm/'.$num_keys.'_d'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_TIZU'} = 'bm/'.$num_keys.'_d'.$ext;
                        };
                        if ($@){die $@;}
                    }

                    if ($hash{'MANSION_PICS_OUTSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_OUTSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_OUTSIDE_THUMB'}, $res_dir.'bm/'.$num_keys.'_a_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_OUTSIDE_THUMB'} = 'bm/'.$num_keys.'_a_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'MANSION_PICS_INSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_INSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_INSIDE_THUMB'}, $res_dir.'bm/'.$num_keys.'_b_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_INSIDE_THUMB'} = 'bm/'.$num_keys.'_b_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'MANSION_PICS_MADORIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_MADORIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_MADORIZU_THUMB'}, $res_dir.'bm/'.$num_keys.'_c_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_MADORIZU_THUMB'} = 'bm/'.$num_keys.'_c_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'MANSION_PICS_TIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'MANSION_PICS_TIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'MANSION_PICS_TIZU_THUMB'}, $res_dir.'bm/'.$num_keys.'_d_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'MANSION_PICS_TIZU_THUMB'} = 'bm/'.$num_keys.'_d_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }


                    #$apart{$num_keys} = $apart{$_};
                    $mansion{$num_keys} = \%hash;
                }
            }
        }
    }
    untie %mansion;

    return 1;
}

sub toggle_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');

    tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $mansion{$_}){
                if (defined $mansion{$_} && ($mansion{$_})){
                    #my $ref_hash = $mansion{$_};
                    #my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($mansion{$_}{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$mansion{$_}};
                                if ($boolean){
                                    $hash{'MANSION_PUBLISHED'}='On';
                                    $hash{'MANSION_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                                }else{
                                    $hash{'MANSION_PUBLISHED'}='';
                                }
                                $mansion{$_} = \%hash;
                            } else {
    #                            delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$mansion{$_}};
                            if ($boolean){
                                $hash{'MANSION_PUBLISHED'}='On';
                                $hash{'MANSION_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                            }else{
                                $hash{'MANSION_PUBLISHED'}='';
                            }
                            $mansion{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$mansion{$_}};
                        if ($boolean){
                            $hash{'MANSION_PUBLISHED'}='On';
                            $hash{'MANSION_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                        }else{
                            $hash{'MANSION_PUBLISHED'}='';
                        }
                        $mansion{$_} = \%hash;
                    }
#                    if ($hash{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')){
                        #delete $mansion{$_};
#                        $mansion{$_} = undef;
#                    }
                }

            }
        }
    }
    untie %mansion;

#     #delete dupe here
#     if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
#         my %delete_dupelicate;
#         @to_be_deleted = grep(!$delete_dupelicate{$_}++, @to_be_deleted);
#     }
#     #
#     my $special = REPS::Special::Special->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_special_path')
#                 );
#     $special->delete_Realestate((map {"BM". $_ } @to_be_deleted));
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_updates_path')
#                 );
# 
#     $updates->delete_Realestate((map {"BM". $_ } @to_be_deleted));
    #
#todo
#check and make sure it is owned by the user MANSION_USER_ID
    return 1;
}

sub special_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');

    tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $mansion{$_}){
                if (defined $mansion{$_} && ($mansion{$_})){
                    #my $ref_hash = $mansion{$_};
                    #my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($mansion{$_}{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$mansion{$_}};
                                if ($boolean){
                                    $hash{'MANSION_IS_SPECIAL'}='On';
                                }else{
                                    $hash{'MANSION_IS_SPECIAL'}='';
                                }
                                $mansion{$_} = \%hash;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$mansion{$_}};
                            if ($boolean){
                                $hash{'MANSION_IS_SPECIAL'}='On';
                            }else{
                                $hash{'MANSION_IS_SPECIAL'}='';
                            }
                            $mansion{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$mansion{$_}};
                        if ($boolean){
                            $hash{'MANSION_IS_SPECIAL'}='On';
                        }else{
                            $hash{'MANSION_IS_SPECIAL'}='';
                        }
                        $mansion{$_} = \%hash;
                    }

                }

            }
        }
    }
    untie %mansion;
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

    my $match = 0;

    my %mansion;
    my $db_b_mansion_path = $self->{_app}->param('db_b_mansion_path');
    if (-f $db_b_mansion_path){
        tie (%mansion, 'MLDBM', $db_b_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        while ( ($key, $value) = each(%mansion) ) {
    
            if ((defined $mansion{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'MANSION_USER_ID'}){
                    #match?
                    $match = 0;
    
                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($tmp{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')) {
                            next;
                        }
                    }
#                    if ($q->param("mansion_jisyakannri")){ #自社管理指定
    #                    if ($tmp{'MANSION_USER_ID'} eq $self->{_app}->param('user_id')){
                        #自社登録物件
#                            if ($tmp{'MANSION_TASYAKANRI'}){
                                #他社管理物件
#                                next;
#                            }else{
#                                $match = 1;
#                            }
    #                    }else{
    #                        next;
    #                    }
#                    }
    
#                    if ($q->param("mansion_jisyatouroku")){
#                        if ($tmp{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')){
#                            next;
#                        }else{$match = 1;}
#                    }else{
#                        $match = 1;
#                    }
                    if ($q->param("mansion_jisyatouroku") > 0){
                        if ($q->param("mansion_jisyatouroku") == 1){
                            if ($tmp{'MANSION_USER_ID'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif ($q->param("mansion_jisyatouroku") == 2){
                            if (!$tmp{'MANSION_USER_ID'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }
    
                    if ($q->param("mansion_public") > 0){
                        if ($q->param("mansion_public") == 1){
                            if ($tmp{'MANSION_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif ($q->param("mansion_public") == 2){
                            if (!$tmp{'MANSION_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("mansion_recommend") > 0){
                        if ($q->param("mansion_recommend") == 1) {
                            if ($tmp{'MANSION_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("mansion_recommend") == 2){
                            if (!$tmp{'MANSION_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
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

    
    
                    if ($q->param("mansion_walk_minutes")){
                        if (!$tmp{'MANSION_WALK_MINUTES_1'}){next;}
                        if ($tmp{'MANSION_WALK_MINUTES_1'} <= $q->param("mansion_walk_minutes")){
                            $match = 1;
                        }else{next;}
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
    
                    
    
                    
                    if ($q->param("mansion_address")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("mansion_address")));
                        if (REPS::Util->str_match($tmp{'MANSION_LOCATION'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
                    }
    
                    if ($q->param("mansion_name")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("mansion_name")));
                        if (REPS::Util->str_match($tmp{'MANSION_NAME'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
                    }
    
    
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
    
    
                    if ($q->param("mansion_station")){
                        my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("mansion_station")));
                        if (REPS::Util->str_match($tmp{'MANSION_STATION_1'},$search_by_key)){
                            $match = 1;
                        }elsif(REPS::Util->str_match($tmp{'MANSION_STATION_2'},$search_by_key)){
                            $match = 1;
                        }else{next;}
    
                    }
    
    
                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'MANSION_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'MANSION_LAST_UPDATED'})&&($tmp{'MANSION_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'MANSION_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'MANSION_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'MANSION_LOCATION'};
                            }elsif(($sort_by eq 'name')){
                                $sort_hash{$key} = $tmp{'MANSION_NAME'};
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
            if (($sort_by eq 'location')){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
            }elsif(($sort_by eq 'name')){
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
    
            my $c = @sort_keys;
    
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
                my $ref_hash = $mansion{$_};
                my %tmp = %$ref_hash;

                my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'MANSION_CREATED'});
                my $new = '';
                if ($dd <= 30) {
                    $new = 'ON';
                }
                my $updated = '';
                if ((!$new) && ($tmp{'MANSION_LAST_UPDATED'})){
                    $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'MANSION_LAST_UPDATED'});
                    if ($dd <= 10) {
                        $updated = 'ON';
                    }
                }

                my %hash = (
                    'MANSION_ID' => "$_",
                    'MANSION_PUBLISHED' => $tmp{'MANSION_PUBLISHED'},
                    'MANSION_IS_SPECIAL' => $tmp{'MANSION_IS_SPECIAL'},
                    'MANSION_NAME' => $tmp{'MANSION_NAME'},
                    'MANSION_LOCATION' => $tmp{'MANSION_LOCATION'},
    
                    'MANSION_PRICE' =>REPS::Util->insert_comma($tmp{'MANSION_PRICE'}),
                    'MANSION_ROOM_NUMBER' => $tmp{'MANSION_ROOM_NUMBER'},
                    'MANSION_CREATED' => REPS::Util->get_date_as_string($tmp{'MANSION_CREATED'}),
                    'MANSION_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'MANSION_LAST_UPDATED'}),
                    'MANSION_NEW' => $new,
                    'MANSION_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    '_type' => 'bm'
                );
        
                push(@loop_data, \%hash);
            }
    #    }
    
        untie %mansion;

        $Search->{'ref_result_loop'} = \@loop_data;
        $Search->{'count_result'} = $c;
    }else{
        $Search->{'ref_result_loop'} = \@loop_data;
        $Search->{'count_result'} = 0;
    }

    return 1;
}

sub get_Specials{
    my $self = shift;
    my %mansion;
    my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
    my ($key, $value);
    my @loop_data=();
    #my %hash;

    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');

    if (-f $db_mansion_path){
        tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        while ( ($key, $value) = each(%mansion) ) {
            if ((exists $mansion{$key}) && (defined $mansion{$key}) && ($value)){

                 if (($$value{'MANSION_PUBLISHED'}) && ($$value{'MANSION_IS_SPECIAL'})){
                    push(@loop_data, $key);
                    if ($limit < scalar(@loop_data)){last;}
                 }

            }
        }
        untie %mansion;

    }
    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');
    if (($limit) && ($limit>0)){
        @loop_data = @loop_data[0..$limit-1];
    }
    require REPS::Search::Realestate::B_Mansion;
    my $Realestate = REPS::Search::Realestate::B_Mansion->new($self->{_app});
    my $ref_loop = $Realestate->get_Detail_List(@loop_data);

    return $ref_loop;
}

sub get_Count{
    my $self = shift;
    my %mansion;
    my $db_mansion_path = $self->{_app}->param('db_b_mansion_path');
    my ($key, $value);
    my %hash;
    if (-f $db_mansion_path){
        tie (%mansion, 'MLDBM', $db_mansion_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        my $n=0;# = keys( %apart );
        my $p=0;
        my $l=0;
    
        my $t;
        while ( ($key, $value) = each(%mansion) ) {
            if ((exists $mansion{$key}) && (defined $mansion{$key}) && ($value)){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($$value{'MANSION_USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }
    
                if (exists $$value{'MANSION_PUBLISHED'}){
                    if ($$value{'MANSION_PUBLISHED'}){
                        $p++;
                    }else{
                        $n++;
                    }
                }
        
                if ((defined $$value{'MANSION_LAST_UPDATED'}&&($$value{'MANSION_LAST_UPDATED'}))){
                    $t=$$value{'MANSION_LAST_UPDATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'MANSION_LAST_UPDATED'};
                    }
        
                }else{
                    $t=$$value{'MANSION_CREATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'MANSION_CREATED'};
                    }
                }
            }
        }
        untie %mansion;
        %hash = ('count_all'=>$n+$p,'count_published'=>$p,'last_updated'=> REPS::Util->get_date_as_string($l));
    }
    return \%hash;
}

sub get_AccessLog{
    my $self = shift;
    my ($key, $value);
    my @loop_data = ();
    my $n = 0;
    my %access;
    my $db_access_path = $self->{_app}->param('db_b_mansion_access_path');
    my %hash;
    if (-f $db_access_path){
        tie (%access, 'MLDBM', $db_access_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        while ( ($key, $value) = each(%access) ) {

            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($$value{'USER_ID'} ne $self->{_app}->param('user_id')) {
                    next;
                }
            }
            $n = $n+$$value{'COUNT'};
        }
        if (uc($self->{_app}->cfg('detailed_stat')) eq 'ON') {
            my @sort_keys = sort {$access{$b}{'COUNT'} <=> $access{$a}{'COUNT'}} keys %access;
            @sort_keys = splice( @sort_keys , 0,5);
    
            foreach (@sort_keys){
    
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
    my $db_inquiry_path = $self->{_app}->param('db_b_mansion_inquiry_path');
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
        }
        if (uc($self->{_app}->cfg('detailed_stat')) eq 'ON') {
            my @sort_keys = sort {$inquiry{$b}{'COUNT'} <=> $inquiry{$a}{'COUNT'}} keys %inquiry;
            @sort_keys = splice( @sort_keys , 0,5);
    
            foreach (@sort_keys){
    
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
    my $feed_title = '売買マンション物件情報';
    $feed->title($UJ->set($feed_title,'euc')->utf8);
    # subtitle
    my $feed_subtitle = $$settings_info{'COMPANY_NAME'} . 'が配信する最新の売買マンション物件情報です';
    $feed->subtitle($UJ->set($feed_subtitle,'euc')->utf8);


    #create self link
    my $feed_link = XML::Atom::Syndication::Link->new();
    $feed_link->href($self->{_app}->cfg('site_url').'bm-atom.xml');
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
    $feed->id($self->{_app}->cfg('cgi_url').'bm');

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


    my %mansion;
    my $db_path = $self->{_app}->param('db_b_mansion_path');
    if (-e $db_path){
        tie (%mansion, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'write') or Carp::croak ("$! $db_path");#
        while ( ($key, $value) = each(%mansion) ) {
            if ($i > 15){last;}
            if ((defined $mansion{$key}) && ($value)){
                if ($$value{'MANSION_PUBLISHED'}){
                    $i++;
                    if ((defined $$value{'MANSION_LAST_UPDATED'}&&($$value{'MANSION_LAST_UPDATED'}))){
                        $sort_hash{$key} = $$value{'MANSION_LAST_UPDATED'};
                    }else{
                        $sort_hash{$key} = $$value{'MANSION_CREATED'};
                    }
                }
            }
        }

        #sort by update
        my @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
        @sort_keys = reverse @sort_keys;
        if (@sort_keys > 0){
            if ($mansion{$sort_keys[0]}{'MANSION_LAST_UPDATED'}. '+09:00'){
                $feed->updated($mansion{$sort_keys[0]}{'MANSION_LAST_UPDATED'}. '+09:00');
            }else{
                $feed->updated($mansion{$sort_keys[0]}{'MANSION_CREATED'}. '+09:00');
            }
        }else{
            $feed->updated(REPS::Util->get_datetime_now . '+09:00');
        }
        #for each
        foreach (@sort_keys){
            my $entry = XML::Atom::Syndication::Entry->new;
#TODO: create better id for entry.
            $entry->id($self->{_app}->cfg('cgi_url').'bm/'.$mansion{$_}{'MANSION_ID'});

            #title

            my $mansion_price = REPS::Util->insert_comma($mansion{$_}{'MANSION_PRICE'});
            my $entry_title = "[マンション][$mansion_price万円]";
            $entry->title($UJ->set($entry_title,'euc')->utf8);

            #create a link
            my $entry_link = XML::Atom::Syndication::Link->new();
            $entry_link->href($self->{_app}->cfg('cgi_url').'search.cgi?_mode=mode_detail&_type=bm&_object_id='.$mansion{$_}{'MANSION_ID'});
            $entry_link->rel('alternate');
            $entry_link->type('text/html');
            #set a feed link
            $entry->link($entry_link);
            #updated
            if ($mansion{$_}{'MANSION_LAST_UPDATED'}){
                $entry->updated($mansion{$_}{'MANSION_LAST_UPDATED'} . '+09:00');
                $entry->published($mansion{$_}{'MANSION_CREATED'}. '+09:00');
            }else{
                $entry->updated($mansion{$_}{'MANSION_CREATED'}. '+09:00');
            }
            #author
            my $entry_author = XML::Atom::Syndication::Person->new(Name=>'author');
            $entry_author->name($mansion{$_}{'MANSION_USER_ID'});
            $entry->author($entry_author);

            my $mansion_picture_1='';
            if ($mansion{$_}{'MANSION_PICS_OUTSIDE'}){
                $mansion_picture_1 = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$mansion{$_}{'MANSION_PICS_OUTSIDE_THUMB'};
                $mansion_picture_1 = '<img src="'.$mansion_picture_1.'" class="outside" />';
            }
            my $mansion_picture_2='';
            if ($mansion{$_}{'MANSION_PICS_MADORIZU'}){
                $mansion_picture_2 = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$mansion{$_}{'MANSION_PICS__MADORIZU_THUMB'};
                $mansion_picture_2 = '<img src="'.$mansion_picture_2.'" class="madorizu" />';
            }

            #my $entry_category = XML::Atom::Syndication::Category->new();
            #$entry_category->term($UJ->set($mansion_kind,'euc')->utf8);
            #$entry->category($entry_category);
#TODO: How to add more than one category?

my $entry_content = <<"_HTML_";
<div class="rl">
    <h4><span="tagline">$mansion{$_}{MANSION_ADS_TEXT}</span></h4>
    <ul>
        <li>価格：<span class="price">$mansion_price<span class="unit">万円</span></span></li>
        <li>所在地：<span class="location">$mansion{$_}{MANSION_LOCATION}</span></li>
        <li>最寄駅：<span class="station">$mansion{$_}{MANSION_STATION_1}</span></li>
    </ul>
    <div class="picture">
        <span class="outside">$mansion_picture_1</span>
        <span class="madorizu">$mansion_picture_2</span>
    </div>
</div>
_HTML_

            my $content = XML::Atom::Syndication::Content->new($UJ->set($entry_content,'euc')->utf8);
            $content->type('html');
            $entry->content($content);
            $feed->add_entry($entry);

        }
        untie %mansion;

        my $output = $feed->as_xml;
        my $file = $self->{_app}->cfg('site_path').'bm-atom.xml';

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
        close (OUT) || Carp::croak("$file : $!");

umask($old);

        return 1
    }
}






1
