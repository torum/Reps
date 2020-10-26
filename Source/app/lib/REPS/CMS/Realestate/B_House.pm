package REPS::CMS::Realestate::B_House;

use strict;
use base qw( REPS::CMS::Realestate );

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
            'HOUSE_SETUDOUJYOUKYOU' => '',
            'HOUSE_CHUSYAJYOU' => '',
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
            'HOUSE_TOSIKEIKAKU' => '',
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
            'HOUSE_OPTIONS_PARKING' => '',
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
            'HOUSE_USER_ID' => $app->param('user_id'),
            'HOUSE_CREATED' => '',
            'HOUSE_LAST_UPDATED' => ''
            }
        };    

    return bless $self,$class;
}

sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();
    
    $self->{_ref_hash}{'HOUSE_ID'} = $q->param('_object_id') if $q->param('_object_id');
    $self->{_ref_hash}{'HOUSE_PUBLISHED'} = $q->param('house_publish') if $q->param('house_publish');
    $self->{_ref_hash}{'HOUSE_IS_SPECIAL'} = $q->param('add_to_special') if $q->param('add_to_special');
    $self->{_ref_hash}{'HOUSE_LOCATION'} = REPS::Util->trim($q->param('house_location')) if $q->param('house_location');
    $self->{_ref_hash}{'HOUSE_STATION_1'} = $q->param('house_station1') if $q->param('house_station1');

    $self->{_ref_hash}{'HOUSE_BUS_1'} = $q->param('house_bus') if $q->param('house_bus');
    $self->{_ref_hash}{'HOUSE_WALK_MINUTES_1'} = $q->param('house_walk_minutes') if $q->param('house_walk_minutes');
    $self->{_ref_hash}{'HOUSE_BUS_MINUTES_1'} = $q->param('house_bus_minutes') if $q->param('house_bus_minutes');
    $self->{_ref_hash}{'HOUSE_BUSWALK_MINUTES_1'} = $q->param('house_buswalk_minutes') if $q->param('house_buswalk_minutes');

    $self->{_ref_hash}{'HOUSE_STATION_2'} = $q->param('house_station2') if $q->param('house_station2');
    $self->{_ref_hash}{'HOUSE_BUS_2'} = $q->param('house_bus2') if $q->param('house_bus2');
    $self->{_ref_hash}{'HOUSE_WALK_MINUTES_2'} = $q->param('house_walk_minutes2') if $q->param('house_walk_minutes2');
    $self->{_ref_hash}{'HOUSE_BUS_MINUTES_2'} = $q->param('house_bus_minutes2') if $q->param('house_bus_minutes2');
    $self->{_ref_hash}{'HOUSE_BUSWALK_MINUTES_2'} = $q->param('house_buswalk_minutes2') if $q->param('house_buswalk_minutes2');


    $self->{_ref_hash}{'HOUSE_PRICE'} = $q->param('house_price') if $q->param('house_price');
    $self->{_ref_hash}{'HOUSE_PRICE_TAX_INC'} = $q->param('house_price_tax_inc') if $q->param('house_price_tax_inc');
    $self->{_ref_hash}{'HOUSE_BUILDING_SQUARE'} = $q->param('house_building_square') if $q->param('house_building_square');
    $self->{_ref_hash}{'HOUSE_TOTI_SQUARE'} = $q->param('house_toti_square') if $q->param('house_toti_square');
    $self->{_ref_hash}{'HOUSE_TOTI_SQUARE_TEXT'} = $q->param('house_toti_square_text') if $q->param('house_toti_square_text');
    $self->{_ref_hash}{'HOUSE_TOTI_SQUARE_TUBO'} = $q->param('house_toti_square_tubo') if $q->param('house_toti_square_tubo');
    $self->{_ref_hash}{'HOUSE_MADORI' } = $q->param('house_madori') if $q->param('house_madori');
    $self->{_ref_hash}{'HOUSE_MADORI_DETAIL'} = $q->param('house_madori_detail') if $q->param('house_madori_detail');
    $self->{_ref_hash}{'HOUSE_BUILDING_STRUCTURE'} = $q->param('house_building_structure') if $q->param('house_building_structure');
    $self->{_ref_hash}{'HOUSE_AGE'} = $q->param('house_age') if $q->param('house_age');
    $self->{_ref_hash}{'HOUSE_SETUDOUJYOUKYOU'} = $q->param('house_setudoujyoukyou') if $q->param('house_setudoujyoukyou');
    $self->{_ref_hash}{'HOUSE_SYAKUTIRYOU'} = $q->param('house_syakutiryou') if $q->param('house_syakutiryou');
    $self->{_ref_hash}{'HOUSE_SYAKUTIKIKAN'} = $q->param('house_syakutikikan') if $q->param('house_syakutikikan');
    $self->{_ref_hash}{'HOUSE_SETBACK'} = $q->param('house_setback') if $q->param('house_setback');
    $self->{_ref_hash}{'HOUSE_SIDOUFUTAN_SQUARE'} = $q->param('house_sidoufutan_square') if $q->param('house_sidoufutan_square');
    $self->{_ref_hash}{'HOUSE_CHUSYAJYOU'} = $q->param('house_chusyajyou') if $q->param('house_chusyajyou');
    $self->{_ref_hash}{'HOUSE_SETUBI'} = $q->param('house_setubi') if $q->param('house_setubi');
    $self->{_ref_hash}{'HOUSE_JYOUKEN'} = $q->param('house_jyouken') if $q->param('house_jyouken');
    $self->{_ref_hash}{'HOUSE_OPTIONS_SINTIKU'} = $q->param('house_options_sintiku') if $q->param('house_options_sintiku');
    $self->{_ref_hash}{'HOUSE_OPTIONS_TVPHONE'} = $q->param('house_options_tvphone') if $q->param('house_options_tvphone');
    $self->{_ref_hash}{'HOUSE_OPTIONS_SYSTEM_KITCHIN'} = $q->param('house_options_system_kitchin') if $q->param('house_options_system_kitchin');
    $self->{_ref_hash}{'HOUSE_OPTIONS_SHOWERTOILETE'} = $q->param('house_options_showertoilete') if $q->param('house_options_showertoilete');
    $self->{_ref_hash}{'HOUSE_OPTIONS_WALKIN_CLOSET'} = $q->param('house_options_walkin_closet') if $q->param('house_options_walkin_closet');
    $self->{_ref_hash}{'HOUSE_OPTIONS_YUKASITA_SYUUNOU'} = $q->param('house_options_yukasita_syuunou') if $q->param('house_options_yukasita_syuunou');
    $self->{_ref_hash}{'HOUSE_OPTIONS_YUKADANBOU'} = $q->param('house_options_yukadanbou') if $q->param('house_options_yukadanbou');
    $self->{_ref_hash}{'HOUSE_OPTIONS_PARKING'} = $q->param('house_options_parking') if $q->param('house_options_parking');
    $self->{_ref_hash}{'HOUSE_OPTIONS_BARIAFURI'} = $q->param('house_options_bariafuri') if $q->param('house_options_bariafuri');
    $self->{_ref_hash}{'HOUSE_OPTIONS_TOSIGASU'} = $q->param('house_options_tosigasu') if $q->param('house_options_tosigasu');
    $self->{_ref_hash}{'HOUSE_TOTIKENRI'} = $q->param('house_totikenri') if $q->param('house_totikenri');
    $self->{_ref_hash}{'HOUSE_TISEI'} = $q->param('house_tisei') if $q->param('house_tisei');
    $self->{_ref_hash}{'HOUSE_TIMOKU'} = $q->param('house_timoku') if $q->param('house_timoku');
    $self->{_ref_hash}{'HOUSE_KENPEIRITU'} = $q->param('house_kenpeiritu') if $q->param('house_kenpeiritu');
    $self->{_ref_hash}{'HOUSE_YOUSEKIRITU'} = $q->param('house_yousekiritu') if $q->param('house_yousekiritu');
    $self->{_ref_hash}{'HOUSE_YOUTOTIIKI'} = $q->param('house_youtotiiki') if $q->param('house_youtotiiki');
    $self->{_ref_hash}{'HOUSE_TOSIKEIKAKU'} = $q->param('house_tosikeikaku') if $q->param('house_tosikeikaku');
    $self->{_ref_hash}{'HOUSE_KOKUDOHOUTODOKEDE'} = $q->param('house_kokudohoutodokede') if $q->param('house_kokudohoutodokede');
    $self->{_ref_hash}{'HOUSE_BIKOU'} = $q->param('house_bikou') if $q->param('house_bikou');
    $self->{_ref_hash}{'HOUSE_HIKIWATASI'} = $q->param('house_hikiwatasi') if $q->param('house_hikiwatasi');
    $self->{_ref_hash}{'HOUSE_GENKYOU'} = $q->param('house_genkyou') if $q->param('house_genkyou');
    $self->{_ref_hash}{'HOUSE_TORIHIKITAIYOU'} = $q->param('house_torihikitaiyou') if $q->param('house_torihikitaiyou');
    $self->{_ref_hash}{'HOUSE_YOUR_ID'} = $q->param('house_your_id') if $q->param('house_your_id');
    $self->{_ref_hash}{'HOUSE_ADS_TEXT'} = $q->param('house_ads_text') if $q->param('house_ads_text');
    $self->{_ref_hash}{'HOUSE_PICS_OUTSIDE'} = $q->param('_house_pics_outside') if $q->param('_house_pics_outside');
    $self->{_ref_hash}{'HOUSE_PICS_INSIDE'} = $q->param('_house_pics_inside') if $q->param('_house_pics_inside');
    $self->{_ref_hash}{'HOUSE_PICS_MADORIZU'} = $q->param('_house_pics_madorizu') if $q->param('_house_pics_madorizu');
    $self->{_ref_hash}{'HOUSE_PICS_TIZU'} = $q->param('_house_pics_tizu') if $q->param('_house_pics_tizu');
    $self->{_ref_hash}{'HOUSE_PICS_OUTSIDE_THUMB'} = $q->param('_house_pics_outside_thumb') if $q->param('_house_pics_outside_thumb');
    $self->{_ref_hash}{'HOUSE_PICS_INSIDE_THUMB'} = $q->param('_house_pics_inside_thumb') if $q->param('_house_pics_inside_thumb');
    $self->{_ref_hash}{'HOUSE_PICS_MADORIZU_THUMB'} = $q->param('_house_pics_madorizu_thumb') if $q->param('_house_pics_madorizu_thumb');
    $self->{_ref_hash}{'HOUSE_PICS_TIZU_THUMB'} = $q->param('_house_pics_tizu_thumb') if $q->param('_house_pics_tizu_thumb');
    $self->{_ref_hash}{'HOUSE_MOVIE_FILE_URL'} = $q->param('house_movie_file_url') if $q->param('house_movie_file_url');
    $self->{_ref_hash}{'HOUSE_TASYAKANRI'} = $q->param('house_tasyakanri') if $q->param('house_tasyakanri');
    $self->{_ref_hash}{'HOUSE_RYUUTUU'} = $q->param('house_ryuutuu') if $q->param('house_ryuutuu');
    $self->{_ref_hash}{'HOUSE_KANRIKAISYA'} = $q->param('house_kanrikaisya') if $q->param('house_kanrikaisya');
    $self->{_ref_hash}{'HOUSE_KANRIKAISYA_CONTACT'} = $q->param('house_kanrikaisya_contact') if $q->param('house_kanrikaisya_contact');
    $self->{_ref_hash}{'HOUSE_CREATED'} = $q->param('house_created') if $q->param('house_created');

    $self->{_app}->convert_hash_charset($self->{_ref_hash});
    REPS::Util->convert_hash_zhk($self->{_ref_hash});
    
}

sub get_Create_Realestate_Form{
    my $self = shift;
    #my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'house');
    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'house_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'house_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_STATION_1'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'house_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'house_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'house_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 

                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'house_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUSWALK_MINUTES_1'}"),'分'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'house_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_STATION_2'}")),
                
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'house_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'house_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUS_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'house_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'house_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUSWALK_MINUTES_2'}"),'分'),
            ),
#

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"価格: "), 
                $q->td($q->textfield(-name=>'house_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_PRICE'}"),'万円'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"税込み: "), 
                $q->td($q->checkbox(-name=>'house_price_tax_inc', -default=>'', -label=>'税込み', -checked=>"$self->{_ref_hash}{'HOUSE_PRICE_TAX_INC'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"間取り: "), 
                $q->td($q->popup_menu(-name=>'house_madori', -default=>"$self->{_ref_hash}{'HOUSE_MADORI'}",  -values=>['','1R','1K','1DK','1LDK','2K','2DK','2LDK','3K','3DK','3LDK','4K','4DK','4LDK+'],-labels=>{''=>'指定なし','1R'=>'ワンルーム','1K'=>'1K','1DK'=>'1DK','1LDK'=>'1LDK','2K'=>'2K','2DK'=>'2DK','2LDK'=>'2LDK','3K'=>'3K','3DK'=>'3DK','3LDK'=>'3LDK','4K'=>'4K','4DK'=>'4DK','4LDK+'=>'4LDK以上'})),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り内訳: "), 
                $q->td($q->textfield(-name=>'house_madori_detail', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_MADORI_DETAIL'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'}," 建物面積: "), 
                $q->td($q->textfield(-name=>'house_building_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUILDING_SQUARE'}"),'m&sup2&nbsp;（延べ）')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'}," 土地面積: "), 
                $q->td($q->textfield(-name=>'house_toti_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TOTI_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'}," 土地面積(補足): "), 
                $q->td($q->textfield(-name=>'house_toti_square_text', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TOTI_SQUARE_TEXT'}"),'(実測・公簿...)')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'}," 土地面積(坪): "), 
                $q->td($q->textfield(-name=>'house_toti_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TOTI_SQUARE_TUBO'}"),'坪')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"建物構造: "), 
                $q->td($q->textfield(-name=>'house_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_BUILDING_STRUCTURE'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"築年月: "), 
                $q->td($q->textfield(-name=>'house_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_AGE'}"),'例： 2000/01'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"接道状況: "), 
                $q->td($q->textfield(-name=>'house_setudoujyoukyou', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_SETUDOUJYOUKYOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駐車場: "), 
                $q->td($q->textfield(-name=>'house_chusyajyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_CHUSYAJYOU'}"),'台'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"借地料: "), 
                $q->td($q->textfield(-name=>'house_syakutiryou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_SYAKUTIRYOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"借地期間: "), 
                $q->td($q->textfield(-name=>'house_syakutikikan', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_SYAKUTIKIKAN'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"セットバック: "), 
                $q->td($q->textfield(-name=>'house_setback', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_SETBACK'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"私道負担面積: "), 
                $q->td($q->textfield(-name=>'house_sidoufutan_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_SIDOUFUTAN_SQUARE'}"),'m&sup2'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"土地権利: "), 
                $q->td($q->textfield(-name=>'house_totikenri', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TOTIKENRI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地目: "), 
                $q->td($q->textfield(-name=>'house_timoku', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TIMOKU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地勢: "), 
                $q->td($q->textfield(-name=>'house_tisei', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TISEI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"建蔽率: "), 
                $q->td($q->textfield(-name=>'house_kenpeiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KENPEIRITU'}"),'％')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"容積率: "), 
                $q->td($q->textfield(-name=>'house_yousekiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_YOUSEKIRITU'}"),'％')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"用途地域: "), 
                $q->td($q->textfield(-name=>'house_youtotiiki', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_YOUTOTIIKI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"都市計画: "), 
                $q->td($q->textfield(-name=>'house_tosikeikaku', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TOSIKEIKAKU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"国土法届出: "), 
                $q->td($q->textfield(-name=>'house_kokudohoutodokede', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KOKUDOHOUTODOKEDE'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"条件: "), 
                $q->td($q->textfield(-name=>'house_jyouken', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_JYOUKEN'}"))

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(
                            $q->th('新築'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_sintiku', -label=>'新築', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_SINTIKU'}")
                            ),

                            $q->td(''
                            ),
                            $q->td(''
                            )
                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_system_kitchin', -label=>'システムキッチン', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_SYSTEM_KITCHIN'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_showertoilete', -label=>'シャワートイレ', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_SHOWERTOILETE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_walkin_closet', -label=>'ウォークイン クローゼット', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_WALKIN_CLOSET'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_yukadanbou', -label=>'床暖房', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_YUKADANBOU'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_tvphone', -label=>'TVフォン', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_TVPHONE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_tosigasu', -label=>'都市ガス', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_TOSIGASU'}")
                            )
                        ),

                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_bariafuri', -label=>'バリアフリー', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_BARIAFURI'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_parking', -label=>'駐車場あり', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_PARKING'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_yukasita_syuunou', -label=>'床下収納', -checked=>"$self->{_ref_hash}{'HOUSE_OPTIONS_YUKASITA_SYUUNOU'}")
                            )
                        )
                    )


                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"設備: "), 
                $q->td($q->textarea(-name=>'house_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'HOUSE_SETUBI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'house_bikou', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'HOUSE_BIKOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡: "), 
                $q->td($q->textfield(-name=>'house_hikiwatasi', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_HIKIWATASI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"現況: "), 
                $q->td($q->textfield(-name=>'house_genkyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_GENKYOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'house_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_TORIHIKITAIYOU'}"))
            ),



            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'house_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_YOUR_ID'}")),
                
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'house_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$self->{_ref_hash}{'HOUSE_ADS_TEXT'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真１: "), 
                $q->td($q->filefield(-name=>'house_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>"$self->{_ref_hash}{'HOUSE_PICS_OUTSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真２: "), 
                $q->td($q->filefield(-name=>'house_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_PICS_INSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り図: "), 
                $q->td($q->filefield(-name=>'house_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_PICS_MADORIZU'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'house_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_PICS_TIZU'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL: "), 
                $q->td($q->textfield(-name=>'house_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_MOVIE_FILE_URL'}")),
            ),
#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"管理会社情報:<br />会社名:<br />電話番号:"), 
#                $q->td(
#                    $q->checkbox(-name=>'house_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'HOUSE_TASYAKANRI'}"),
#                    $q->br,
#                    $q->textfield(-name=>'house_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'house_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"他社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'house_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'HOUSE_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('会社名:'),
                            $q->td(
                    $q->textfield(-name=>'house_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                    $q->textfield(-name=>'house_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),

            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'house_ryuutuu',-label=>'流通可', -checked=>"$self->{_ref_hash}{'HOUSE_RYUUTUU'}"),
            #    ),
            #),

            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_add'),
                    $q->hidden(-name => '_type', -value => 'bh'),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加する', -checked=>""),
                    $q->checkbox(-name=>'house_publish', -label=>'公開する', -checked=>"$self->{_ref_hash}{'HOUSE_PUBLISHED'}"),
                    $q->submit(-name => 'add_new_object' ,-value => '新規追加', -class=>'submit')
                )
            )
        );

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.house.house_location.focus(); \n// --></script>";
    return $output;
}

sub create_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();
    
    #todo check each item
    #if ($$ref_hash{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        if ($$ref_hash{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){
            $result .= '異なるユーザーIDでは登録できません。<br />';
        }
    }
    $$ref_hash{'HOUSE_USER_ID'} = $self->{_app}->param('user_id');

    if (!$$ref_hash{'HOUSE_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_PRICE'}) {$result .= '価格が入力されていません。<br />';}
    #if (!$$ref_hash{'HOUSE_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}

    #if (!$$ref_hash{'HOUSE_PRICE_TAX_INC'}) {$result .= '税込みが入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_MADORI'}) {$result .= '間取りが入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_AGE'}) {$result .= '築年月が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_BUILDING_SQUARE'}) {$result .= '建物面積が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_TOTI_SQUARE'}) {$result .= '土地面積が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_TOTIKENRI'}) {$result .= '土地権利が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_KENPEIRITU'}) {$result .= '建蔽率が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_YOUSEKIRITU'}) {$result .= '容積率が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'HOUSE_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUILDING_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '建物面積の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_TOTI_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '土地面積(平米)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_TOTI_SQUARE_TUBO'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '土地面積(坪)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_CHUSYAJYOU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駐車場(台)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_SIDOUFUTAN_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        #要望により
        #$result .= '私道負担面積の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'HOUSE_KENPEIRITU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '建蔽率の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_YOUSEKIRITU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '容積率の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'HOUSE_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'HOUSE_PRICE'}) {
        my $str = $$ref_hash{'HOUSE_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{1,80}))$/){

        }else{
            $result .= '価格の値が不自然です。半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'HOUSE_AGE'}){
        my $str = $$ref_hash{'HOUSE_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){

        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />';
        }
    }

    if ($$ref_hash{'HOUSE_SQUARE'}){
        unless($$ref_hash{'HOUSE_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
            $result .= '面積は半角英数とピリオド（.）だけで入力してください。<br />'; #/31
        }
    }

    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'bh' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('house_pics_outside')){
        my $fh = $q->upload('house_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('house_pics_inside')){
        my $fh = $q->upload('house_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'HOUSE_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('house_pics_madorizu')){
        my $fh = $q->upload('house_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('house_pics_tizu')){
        my $fh = $q->upload('house_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'HOUSE_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
    }else{
        $$ref_hash{'HOUSE_CREATED'} = REPS::Util->get_datetime_now();
        my %house;
        my $db_b_house_path = $self->{_app}->param('db_b_house_path');
        my $num_keys = 1;
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%house, 'MLDBM', $db_b_house_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        $num_keys = scalar keys (%house);
        $num_keys = sprintf('%06d', $num_keys++);
        if (exists $house{$num_keys}){
            #count up and add again. This could happen when export and import data.
            #$result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
            while (exists $house{$num_keys}) {
                $num_keys++;
                if ($num_keys >= 999999) {die "Reached lmit.";};
            }
        }
        if (!defined $house{$num_keys}){
            $$ref_hash{'HOUSE_ID'} = $num_keys;
            eval {
                if ($q->param('house_pics_outside')){
                    my $tmp = $$ref_hash{'HOUSE_PICS_OUTSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_OUTSIDE'},$dir.$tmp);
                    $$ref_hash{'HOUSE_PICS_OUTSIDE'} = 'bh' . '/'.$tmp;
                    if ($$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'} = 'bh' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('house_pics_inside')){
                    my $tmp = $$ref_hash{'HOUSE_PICS_INSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_INSIDE'},$dir.$tmp);
                    $$ref_hash{'HOUSE_PICS_INSIDE'} = 'bh' . '/'.$tmp;
                    if ($$ref_hash{'HOUSE_PICS_INSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'HOUSE_PICS_INSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_INSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'HOUSE_PICS_INSIDE_THUMB'} = 'bh' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('house_pics_madorizu')){
                    my $tmp = $$ref_hash{'HOUSE_PICS_MADORIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_MADORIZU'},$dir.$tmp);
                    $$ref_hash{'HOUSE_PICS_MADORIZU'} = 'bh' . '/'.$tmp;
                    if ($$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'} = 'bh' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            eval {
                if ($q->param('house_pics_tizu')){
                    my $tmp = $$ref_hash{'HOUSE_PICS_TIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_TIZU'},$dir.$tmp);
                    $$ref_hash{'HOUSE_PICS_TIZU'} = 'bh' . '/'.$tmp;
                    if ($$ref_hash{'HOUSE_PICS_TIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'HOUSE_PICS_TIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_TIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'HOUSE_PICS_TIZU_THUMB'} = 'bh' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            $house{$num_keys} = $ref_hash;
            $self->{_ref_hash} = $ref_hash;
        }else{
            $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
        }

        untie %house;
umask($old);
#                 my %hash_sp=(
#                         'BS_ID' => $$ref_hash{'HOUSE_ID'},
#                         'BS_NAME' => $$ref_hash{'HOUSE_NAME'},
#                         'BS_STATION_1' => $$ref_hash{'HOUSE_STATION_1'},
#                         'BS_STATION_2' => $$ref_hash{'HOUSE_STATION_2'},
#                         'BS_LOCATION' =>$$ref_hash{'HOUSE_LOCATION'},
#                         'BS_PRICE' => REPS::Util->insert_comma($$ref_hash{'HOUSE_PRICE'}),
#                         'BS_BUS_MINUTES_1' => $$ref_hash{'HOUSE_BUS_MINUTES_1'},
#                         'BS_WALK_MINUTES_1' => $$ref_hash{'HOUSE_WALK_MINUTES_1'},
#                         'BS_SQUARE' => $$ref_hash{'HOUSE_TOTI_SQUARE'},
#     
#     #                    'BS_PRICE_KANRIHI' => REPS::Util->insert_comma($$ref_hash{'LAND_PRICE_KANRIHI'}),
#     #                    'BS_PRICE_SIKIKIN' => $$ref_hash{'LAND_PRICE_SIKIKIN'},
#     #                    'BS_PRICE_REIKIN' => $$ref_hash{'LAND_PRICE_REIKIN'},
#                         'BS_MADORI' => $$ref_hash{'HOUSE_MADORI'},
#                         'BS_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'},
#                         'BS_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'},
#                         'BS_ADS_TEXT' => $$ref_hash{'HOUSE_ADS_TEXT'}
#                 );
#                 $hash_sp{'BS_KIND'}='一戸建て';
#                 $hash_sp{'_type'}='bh';
#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'HOUSE_PUBLISHED'}){
#                 #Special
#     
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BH'.$$ref_hash{'HOUSE_ID'},
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
#         if ($$ref_hash{'HOUSE_PUBLISHED'}){
#             if (!$$ref_hash{'HOUSE_LAST_UPDATED'}){
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'HOUSE_CREATED'};
#             }else{
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'HOUSE_LAST_UPDATED'};
#             }
#             my $updates = REPS::Updates::Updates->new(
#                             $self->{_app},
#                             $self->{_app}->param('db_bs_updates_path'),
#                             'BH'.$$ref_hash{'HOUSE_ID'},
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

    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');
    if (-f $db_b_house_path){
        tie (%house, 'MLDBM', $db_b_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        my @sort_keys;
        while ( ($key, $value) = each(%house) ) {
            if ((defined $value) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'HOUSE_USER_ID'}){
                    if ($only_this_user){
                        if ($only_this_user ne $tmp{'HOUSE_USER_ID'}){
                            next;
                        }
                    }
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($tmp{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')) {
                                next;
                            }
                        }
                    }else{
                        if (!$only_this_user){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($tmp{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')) {
                                    next;
                                }
                            }
                        }
                    }

    #                if ($tmp{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')){
                        #sort
                        if (($sort_by eq 'station') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'price'){
                                $sort_hash{$key} = $tmp{'HOUSE_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'HOUSE_LAST_UPDATED'})&&($tmp{'HOUSE_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'HOUSE_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'HOUSE_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'HOUSE_LOCATION'};
                            }elsif($sort_by eq 'station'){
                                $sort_hash{$key} = $tmp{'HOUSE_STATION_1'};
                            }
                        }else{
        
#                            my %hash = (
#                                'HOUSE_ID' => "$key",
#                                'HOUSE_PUBLISHED' => $tmp{'HOUSE_PUBLISHED'},
#                                'HOUSE_STATION_1' => $tmp{'HOUSE_STATION_1'},
#                                'HOUSE_LOCATION' => $tmp{'HOUSE_LOCATION'},
#                                'HOUSE_PRICE' => REPS::Util->insert_comma($tmp{'HOUSE_PRICE'}),
#                                'HOUSE_CREATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_CREATED'}),
#                                'HOUSE_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_LAST_UPDATED'}),
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

        if (($sort_by eq 'station') || ($sort_by eq 'price') || ($sort_by eq 'date')|| ($sort_by eq 'location')){

            if (($sort_by eq 'station') || ($sort_by eq 'location')){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
            }elsif($sort_by eq 'date'){
                @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
                @sort_keys = reverse @sort_keys;
            }else{
                @sort_keys = sort {$sort_hash{$a} <=> $sort_hash{$b} || length($a) <=> length($b) || $a cmp $b} keys %sort_hash;
            }
        }
    
        $count = @sort_keys;
        #paging
        if (!$off_set){$off_set=0;}
        @sort_keys = splice( @sort_keys , $off_set,$items_per_page);    

        foreach (@sort_keys){

            my %tmp = %{$house{$_}};

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

            my %hash = (
                'HOUSE_ID' => "$_",
                'HOUSE_PUBLISHED' => $tmp{'HOUSE_PUBLISHED'},
                'HOUSE_IS_SPECIAL' => $tmp{'HOUSE_IS_SPECIAL'},
                'HOUSE_STATION_1' => $tmp{'HOUSE_STATION_1'},
                'HOUSE_STATION_2' => $tmp{'HOUSE_STATION_2'},
                'HOUSE_LOCATION' => $tmp{'HOUSE_LOCATION'},
                'HOUSE_PRICE' => REPS::Util->insert_comma($tmp{'HOUSE_PRICE'}),
                'HOUSE_CREATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_CREATED'}),
                'HOUSE_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_LAST_UPDATED'}),
                'HOUSE_NEW' => $new,
                'HOUSE_UPDATED' => $updated,
                'static_url' => $self->{_app}->cfg('static_url'),
            );
    
            push(@loop_data, \%hash);
        }
        untie %house;
    }
    return \@loop_data, $count;
}

sub get_Realestate {
    my $self = shift;
    my $house_id = $_[0];

    my $ref_hash;
    my %hash;
    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');

    unless ($house_id =~ /[0-9]{6,10}/){Carp::croak "IDの形式が不正です。";}

    tie (%house, 'MLDBM', $db_b_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    if (exists $house{$house_id} ) {
        if ((defined $house{$house_id}) && ($house{$house_id})){
            $ref_hash = $house{$house_id};
            if ($self->{_app}->param('user_isAdmin') != 1){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($house{$house_id}{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')) {
                        untie %house;
                        Carp::croak "The ID [$house_id] does not belong to you.";
                    }
                }
            }
#            if ($self->{_app}->param('user_id') eq $$ref_hash{'HOUSE_USER_ID'}){

                $self->{_ref_hash} = $house{$house_id};
                
#            }else{
#                untie %house;
#                die 'the ID does not belong to you.';
#            }
        }else{
            untie %house;
            return 0;
            #die "The ID [$house_id] has no value. Possibly deleted.";
        }
    }else{
        untie %house;
        return 0;
        #die "The ID [$house_id] does not exists.";
    }

    untie %house;


    return 1;
}


sub get_Edit_Realestate_Form{
    my $self = shift;
    my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $output = "<div class=\"warning\"><p>他のユーザーの物件はアクセス出来ません。 </p></div>";
                return $output;
            }
        }
    }

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'house');

    my $ifView = '';
    if ($$ref_hash{'HOUSE_IS_SPECIAL'}){
        $ifView .= '<img src="'.$self->{_app}->cfg('static_url').'icons/16-heart-gold-m.png" width="16" height="16" />';
    }
    if ($$ref_hash{'HOUSE_PUBLISHED'}){
        $ifView .= "&nbsp;<a href=\"./search.cgi?_mode=mode_detail&_type=bh&_object_id=$$ref_hash{'HOUSE_ID'}\" target=\"_blank\">公開ページ閲覧</a>";
    }

    #dummy var for delete pics
    $output .= $q->hidden(-name => 'delete_pic', -value => '');

    my $ifPicsOutside = '';
    if ($$ref_hash{'HOUSE_PICS_OUTSIDE'}){
        if ($$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'}){
            $ifPicsOutside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_OUTSIDE\');" />';
        }else{
            $ifPicsOutside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_OUTSIDE'}."\">写真１</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_OUTSIDE\');" />';
        }
    }
    my $ifPicsInside = '';
    if ($$ref_hash{'HOUSE_PICS_INSIDE'}){
        if ($$ref_hash{'HOUSE_PICS_INSIDE_THUMB'}){
            $ifPicsInside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_INSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_INSIDE\');" />';
        }else{
            $ifPicsInside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_INSIDE'}."\">写真２</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_INSIDE\');" />';
        }
    }
    my $ifMadorizu = '';
    if ($$ref_hash{'HOUSE_PICS_MADORIZU'}){
        if ($$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'}){
            $ifMadorizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_MADORIZU\');" />';
        }else{
            $ifMadorizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_MADORIZU'}."\">間取り図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_MADORIZU\');" />';
        }
    }
    my $ifTizu = '';
    if ($$ref_hash{'HOUSE_PICS_TIZU'}){
        if ($$ref_hash{'HOUSE_PICS_TIZU_THUMB'}){
            $ifTizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_TIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_TIZU\');" />';
        }else{
            $ifTizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_TIZU'}."\">地図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'HOUSE_PICS_TIZU\');" />';
        }
    }

    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"物件番号："), 
                $q->th('[BH'.$$ref_hash{'HOUSE_ID'}.']'.$ifView), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'house_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'house_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_STATION_1'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'house_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'house_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'house_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'house_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUSWALK_MINUTES_1'}"),'分'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'house_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_STATION_2'}")),
                
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'house_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'house_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUS_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'house_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'house_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUSWALK_MINUTES_2'}"),'分'),
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"価格: "), 
                $q->td($q->textfield(-name=>'house_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_PRICE'}"),'万円')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"税込み: "), 
                $q->td($q->checkbox(-name=>'house_price_tax_inc', -default=>'', -label=>'税込み', -checked=>"$$ref_hash{'HOUSE_PRICE_TAX_INC'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"間取り: "), 
                $q->td($q->popup_menu(-name=>'house_madori', -default=>$$ref_hash{'HOUSE_MADORI'},  -values=>['','1R','1K','1DK','1LDK','2K','2DK','2LDK','3K','3DK','3LDK','4K','4DK','4LDK+'],-labels=>{''=>'指定なし','1R'=>'ワンルーム','1K'=>'1K','1DK'=>'1DK','1LDK'=>'1LDK','2K'=>'2K','2DK'=>'2DK','2LDK'=>'2LDK','3K'=>'3K','3DK'=>'3DK','3LDK'=>'3LDK','4K'=>'4K','4DK'=>'4DK','4LDK+'=>'4LDK以上'})),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り内訳: "), 
                $q->td($q->textfield(-name=>'house_madori_detail', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_MADORI_DETAIL'}"),''),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'}," 建物面積: "), 
                $q->td($q->textfield(-name=>'house_building_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUILDING_SQUARE'}"),'m&sup2&nbsp;（延べ）')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'}," 土地面積: "), 
                $q->td($q->textfield(-name=>'house_toti_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TOTI_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'}," 土地面積(補足): "), 
                $q->td($q->textfield(-name=>'house_toti_square_text', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TOTI_SQUARE_TEXT'}"),'(実測・公簿...)')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'}," 土地面積(坪): "), 
                $q->td($q->textfield(-name=>'house_toti_square_tubo', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TOTI_SQUARE_TUBO'}"),'坪')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"建物構造: "), 
                $q->td($q->textfield(-name=>'house_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_BUILDING_STRUCTURE'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"築年月: "), 
                $q->td($q->textfield(-name=>'house_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_AGE'}"),'例： 2000/01'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"接道状況: "), 
                $q->td($q->textfield(-name=>'house_setudoujyoukyou', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_SETUDOUJYOUKYOU'}"))
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駐車場: "), 
                $q->td($q->textfield(-name=>'house_chusyajyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_CHUSYAJYOU'}"),'台'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"借地料: "), 
                $q->td($q->textfield(-name=>'house_syakutiryou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_SYAKUTIRYOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"借地期間: "), 
                $q->td($q->textfield(-name=>'house_syakutikikan', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_SYAKUTIKIKAN'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"セットバック: "), 
                $q->td($q->textfield(-name=>'house_setback', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_SETBACK'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"私道負担面積: "), 
                $q->td($q->textfield(-name=>'house_sidoufutan_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_SIDOUFUTAN_SQUARE'}"),'m&sup2'),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"土地権利: "), 
                $q->td($q->textfield(-name=>'house_totikenri', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TOTIKENRI'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地目: "), 
                $q->td($q->textfield(-name=>'house_timoku', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TIMOKU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地勢: "), 
                $q->td($q->textfield(-name=>'house_tisei', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TISEI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"建蔽率: "), 
                $q->td($q->textfield(-name=>'house_kenpeiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_KENPEIRITU'}"),'％')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"容積率: "), 
                $q->td($q->textfield(-name=>'house_yousekiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_YOUSEKIRITU'}"),'％')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"用途地域: "), 
                $q->td($q->textfield(-name=>'house_youtotiiki', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_YOUTOTIIKI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"都市計画: "), 
                $q->td($q->textfield(-name=>'house_tosikeikaku', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TOSIKEIKAKU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"国土法届出: "), 
                $q->td($q->textfield(-name=>'house_kokudohoutodokede', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_KOKUDOHOUTODOKEDE'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"条件: "), 
                $q->td($q->textfield(-name=>'house_jyouken', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_JYOUKEN'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(
                            $q->th('新築'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_sintiku', -label=>'新築', -checked=>"$$ref_hash{'HOUSE_OPTIONS_SINTIKU'}")
                            ),
                            $q->td(''
                            ),
                            $q->td(''
                            )
                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_system_kitchin', -label=>'システムキッチン', -checked=>"$$ref_hash{'HOUSE_OPTIONS_SYSTEM_KITCHIN'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_showertoilete', -label=>'シャワートイレ', -checked=>"$$ref_hash{'HOUSE_OPTIONS_SHOWERTOILETE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_walkin_closet', -label=>'ウォークイン クローゼット', -checked=>"$$ref_hash{'HOUSE_OPTIONS_WALKIN_CLOSET'}")
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_yukadanbou', -label=>'床暖房', -checked=>"$$ref_hash{'HOUSE_OPTIONS_YUKADANBOU'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_tvphone', -label=>'TVフォン', -checked=>"$$ref_hash{'HOUSE_OPTIONS_TVPHONE'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_tosigasu', -label=>'都市ガス', -checked=>"$$ref_hash{'HOUSE_OPTIONS_TOSIGASU'}")
                            )
                        ),

                        $q->Tr(
                            $q->th('&nbsp'),
                            $q->td(
                                $q->checkbox(-name=>'house_options_bariafuri', -label=>'バリアフリー', -checked=>"$$ref_hash{'HOUSE_OPTIONS_BARIAFURI'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_parking', -label=>'駐車場あり', -checked=>"$$ref_hash{'HOUSE_OPTIONS_PARKING'}")
                            ),
                            $q->td(
                                $q->checkbox(-name=>'house_options_yukasita_syuunou', -label=>'床下収納', -checked=>"$$ref_hash{'HOUSE_OPTIONS_YUKASITA_SYUUNOU'}")
                            )
                        )
                    )


                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"設備: "), 
                $q->td($q->textarea(-name=>'house_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'HOUSE_SETUBI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'house_bikou', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'HOUSE_BIKOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡: "), 
                $q->td($q->textfield(-name=>'house_hikiwatasi', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_HIKIWATASI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"現況: "), 
                $q->td($q->textfield(-name=>'house_genkyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_GENKYOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'house_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_TORIHIKITAIYOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'house_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_YOUR_ID'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'house_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$$ref_hash{'HOUSE_ADS_TEXT'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真１: "), 
                $q->td($q->filefield(-name=>'house_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>""),
                    '<br />',
                    "$ifPicsOutside",
                    $q->hidden(-name => '_house_pics_outside', -value => "$$ref_hash{'HOUSE_PICS_OUTSIDE'}"),
                    $q->hidden(-name => '_house_pics_outside_thumb', -value => "$$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真２: "), 
                $q->td($q->filefield(-name=>'house_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifPicsInside",
                    $q->hidden(-name => '_house_pics_inside', -value => "$$ref_hash{'HOUSE_PICS_INSIDE'}"),
                    $q->hidden(-name => '_house_pics_inside_thumb', -value => "$$ref_hash{'HOUSE_PICS_INSIDE_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り図: "), 
                $q->td($q->filefield(-name=>'house_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifMadorizu",
                    $q->hidden(-name => '_house_pics_madorizu', -value => "$$ref_hash{'HOUSE_PICS_MADORIZU'}"),
                    $q->hidden(-name => '_house_pics_madorizu_thumb', -value => "$$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'house_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifTizu",
                    $q->hidden(-name => '_house_pics_tizu', -value => "$$ref_hash{'HOUSE_PICS_TIZU'}"),
                    $q->hidden(-name => '_house_pics_tizu_thumb', -value => "$$ref_hash{'HOUSE_PICS_TIZU_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL: "), 
                $q->td($q->textfield(-name=>'house_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_MOVIE_FILE_URL'}")),
            ),
#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"管理会社情報:<br />会社名:<br />電話番号:"), 
#                $q->td(
#                    $q->checkbox(-name=>'house_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'HOUSE_TASYAKANRI'}"),
#                    $q->br,
#                    $q->textfield(-name=>'house_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'house_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'HOUSE_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"他社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'house_tasyakanri',-label=>'他社管理物件', -checked=>"$$ref_hash{'HOUSE_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('会社名:'),
                            $q->td(
                    $q->textfield(-name=>'house_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                    $q->textfield(-name=>'house_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'HOUSE_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),

            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'house_ryuutuu',-label=>'流通可', -checked=>"$$ref_hash{'HOUSE_RYUUTUU'}"),
            #    ),
            #),


            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_edit'),
                    $q->hidden(-name => '_type', -value => 'bh'),
                    $q->hidden(-name => '_object_id', -value => "$$ref_hash{'HOUSE_ID'}"),
                    $q->hidden(-name => 'house_created', -value => "$$ref_hash{'HOUSE_CREATED'}"),
                    $q->hidden(-name => 'add_to_special', -value => "$$ref_hash{'HOUSE_IS_SPECIAL'}"),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加する', -checked=>"$self->{_ref_hash}{'HOUSE_IS_SPECIAL'}"),
                    $q->checkbox(-name=>'house_publish', -label=>'公開する', -checked=>"$$ref_hash{'HOUSE_PUBLISHED'}"),
                    $q->submit(-name => 'edit_object' ,-value => '編集更新', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.house.house_location.focus(); \n// --></script>";
    return $output;
}

sub update_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();

    unless ($$ref_hash{'HOUSE_ID'}=~ /[0-9]{6,10}/){$result .= 'IDの形式が不正です。<br />';}
#    if ($$ref_hash{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $result = "<div class=\"warning\"><p>他のユーザーの物件は更新できません。更新されませんでした。</p></div>";
                return $result;
            }
        }
    }

    if (!$$ref_hash{'HOUSE_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_PRICE'}) {$result .= '価格が入力されていません。<br />';}
    #if (!$$ref_hash{'HOUSE_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}

    #if (!$$ref_hash{'HOUSE_PRICE_TAX_INC'}) {$result .= '税込みが入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_MADORI'}) {$result .= '間取りが入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_AGE'}) {$result .= '築年月が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_BUILDING_SQUARE'}) {$result .= '建物面積が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_TOTI_SQUARE'}) {$result .= '土地面積が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_TOTIKENRI'}) {$result .= '土地権利が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_KENPEIRITU'}) {$result .= '建蔽率が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_YOUSEKIRITU'}) {$result .= '容積率が入力されていません。<br />';}
    if (!$$ref_hash{'HOUSE_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'HOUSE_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUILDING_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '建物面積の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_TOTI_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '土地面積(平米)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_TOTI_SQUARE_TUBO'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '土地面積(坪)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_CHUSYAJYOU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駐車場(台)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_SIDOUFUTAN_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        #要望により
        #$result .= '私道負担面積の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'HOUSE_KENPEIRITU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '建蔽率の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_YOUSEKIRITU'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '容積率の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'HOUSE_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'HOUSE_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'HOUSE_PRICE'}) {
        my $str = $$ref_hash{'HOUSE_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{1,80}))$/){

        }else{
            $result .= '価格の値が不自然です。半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'HOUSE_AGE'}){
        my $str = $$ref_hash{'HOUSE_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />';
        }
    }
    if ($$ref_hash{'HOUSE_SQUARE'}){
        unless($$ref_hash{'HOUSE_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
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


    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'bh' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('house_pics_outside')){
        my $fh = $q->upload('house_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('house_pics_inside')){
        my $fh = $q->upload('house_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'HOUSE_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('house_pics_madorizu')){
        my $fh = $q->upload('house_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('house_pics_tizu')){
        my $fh = $q->upload('house_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'HOUSE_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'HOUSE_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />更新されませんでした。</p></div>";
    }else{
        $$ref_hash{'HOUSE_LAST_UPDATED'} = REPS::Util->get_datetime_now();
        my %house;
        my $db_b_house_path = $self->{_app}->param('db_b_house_path');
        tie (%house, 'MLDBM', $db_b_house_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        
        if (!$house{$$ref_hash{'HOUSE_ID'}}){
            $result = "<div class=\"warning\"><p>別のユーザー又は別の画面で削除された可能性があります。<br />更新されませんでした。</p></div>";
            return $result;
        }
#        if ($house{$$ref_hash{'HOUSE_ID'}}{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')){
        if ($self->{_app}->param('user_isAdmin') != 1){
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($house{$$ref_hash{'HOUSE_ID'}}{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){
                    $result = "<div class=\"warning\"><p>他のユーザーの物件は更新出来ません。 </p></div>";
                    untie %house;
                    return $result;
                }
            }
        }
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
        my $num_keys = REPS::Util->de_taint($$ref_hash{'HOUSE_ID'});

        eval {
            if ($q->param('house_pics_outside')){
                my $tmp = $$ref_hash{'HOUSE_PICS_OUTSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_OUTSIDE'},$dir.$tmp);
                $$ref_hash{'HOUSE_PICS_OUTSIDE'} = 'bh' . '/'.$tmp;

                my $tmp2 = $$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'};
                $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                $$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'} = 'bh' . '/'.$tmp2;
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('house_pics_inside')){
                my $tmp = $$ref_hash{'HOUSE_PICS_INSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_INSIDE'},$dir.$tmp);
                $$ref_hash{'HOUSE_PICS_INSIDE'} = 'bh' . '/'.$tmp;
                my $tmp2 = $$ref_hash{'HOUSE_PICS_INSIDE_THUMB'};
                $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_INSIDE_THUMB'},$dir.$tmp2);
                $$ref_hash{'HOUSE_PICS_INSIDE_THUMB'} = 'bh' . '/'.$tmp2;
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('house_pics_madorizu')){
                my $tmp = $$ref_hash{'HOUSE_PICS_MADORIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_MADORIZU'},$dir.$tmp);
                $$ref_hash{'HOUSE_PICS_MADORIZU'} = 'bh' . '/'.$tmp;
                my $tmp2 = $$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'};
                $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                $$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'} = 'bh' . '/'.$tmp2;
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('house_pics_tizu')){
                my $tmp = $$ref_hash{'HOUSE_PICS_TIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_TIZU'},$dir.$tmp);
                $$ref_hash{'HOUSE_PICS_TIZU'} = 'bh' . '/'.$tmp;
                my $tmp2 = $$ref_hash{'HOUSE_PICS_TIZU_THUMB'};
                $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'HOUSE_PICS_TIZU_THUMB'},$dir.$tmp2);
                $$ref_hash{'HOUSE_PICS_TIZU_THUMB'} = 'bh' . '/'.$tmp2;
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        if (!$house{$$ref_hash{'HOUSE_ID'}}{'HOUSE_USER_ID'}){
            $$ref_hash{'HOUSE_USER_ID'} = $self->{_app}->param('user_id');
            #$house{$$ref_hash{'HOUSE_ID'}}{'HOUSE_USER_ID'} = $self->{_app}->param('user_id');
        }else{
            $$ref_hash{'HOUSE_USER_ID'} = $house{$$ref_hash{'HOUSE_ID'}}{'HOUSE_USER_ID'};
        }

        $house{$$ref_hash{'HOUSE_ID'}} = $ref_hash;

        untie %house;

        #update recommend
        if ($$ref_hash{'HOUSE_IS_SPECIAL'}) {
            $self->{_app}->recommend_static_write_file();
        }


#                 my %hash_sp=(
#                         'BS_ID' => $$ref_hash{'HOUSE_ID'},
#                         'BS_NAME' => $$ref_hash{'HOUSE_NAME'},
#                         'BS_STATION_1' => $$ref_hash{'HOUSE_STATION_1'},
#                         'BS_STATION_2' => $$ref_hash{'HOUSE_STATION_2'},
#                         'BS_LOCATION' =>$$ref_hash{'HOUSE_LOCATION'},
#                         'BS_PRICE' => REPS::Util->insert_comma($$ref_hash{'HOUSE_PRICE'}),
#                         'BS_BUS_MINUTES_1' => $$ref_hash{'HOUSE_BUS_MINUTES_1'},
#                         'BS_WALK_MINUTES_1' => $$ref_hash{'HOUSE_WALK_MINUTES_1'},
#                         'BS_SQUARE' => $$ref_hash{'HOUSE_TOTI_SQUARE'},
#     
#     #                    'BS_PRICE_KANRIHI' => REPS::Util->insert_comma($$ref_hash{'LAND_PRICE_KANRIHI'}),
#     #                    'BS_PRICE_SIKIKIN' => $$ref_hash{'LAND_PRICE_SIKIKIN'},
#     #                    'BS_PRICE_REIKIN' => $$ref_hash{'LAND_PRICE_REIKIN'},
#                         'BS_MADORI' => $$ref_hash{'HOUSE_MADORI'},
#                         'BS_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_OUTSIDE_THUMB'},
#                         'BS_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'HOUSE_PICS_MADORIZU_THUMB'},
#                         'BS_ADS_TEXT' => $$ref_hash{'HOUSE_ADS_TEXT'}
#                 );
#                 $hash_sp{'BS_KIND'}='一戸建て';
#                 $hash_sp{'_type'}='bh';
#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'HOUSE_PUBLISHED'}){
#                 #Special
# 
#     
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BH'.$$ref_hash{'HOUSE_ID'},
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
#                                 'BH'.$$ref_hash{'HOUSE_ID'}
#                             );
#                 $special->delete_Realestate('BH'.$$ref_hash{'HOUSE_ID'});
#         }
# 
#         #add to updates
#         if ($$ref_hash{'HOUSE_PUBLISHED'}){
#             if (!$$ref_hash{'HOUSE_LAST_UPDATED'}){
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'HOUSE_CREATED'};
#             }else{
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'HOUSE_LAST_UPDATED'};
#             }
#             my $updates = REPS::Updates::Updates->new(
#                             $self->{_app},
#                             $self->{_app}->param('db_bs_updates_path'),
#                             'BH'.$$ref_hash{'HOUSE_ID'},
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
    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');

    tie (%house, 'MLDBM', $db_b_house_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    #$house{$$ref_hash{'HOUSE_ID'}} = $ref_hash;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $house{$_}){
                if (defined $house{$_} && ($house{$_})){
                    my $ref_hash = $house{$_};
                    my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($house{$_}{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')) {
                                undef $house{$_};
                            } else {
    #                            delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            undef $house{$_};
                        }
                    }else{
                        undef $house{$_};
                    }
#                    if ($hash{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')){
                        #delete $house{$_};
#                        $house{$_} = undef;
#                    }
                }

            }
        }
    }
    untie %house;

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
#     $special->delete_Realestate((map {"BH". $_ } @to_be_deleted));
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_updates_path')
#                 );
# 
#     $updates->delete_Realestate((map {"BH". $_ } @to_be_deleted));

#check and make sure it is owned by the user HOUSE_USER_ID
    return 1;
}

sub dup_Realestate{
    my $self = shift;
    my @to_be_duped = @_;
    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');

    require REPS::Util;
    use File::Copy;
    use File::Basename;
    my $res_dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory'));

    tie (%house, 'MLDBM', $db_b_house_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_duped){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $house{$_}){
                if (defined $house{$_} && ($house{$_})){
                #    
                #    $apart{$_} = \%hash;
                    my $num_keys = scalar keys (%house);
                    $num_keys = sprintf('%06d', $num_keys++);
                    if (exists $house{$num_keys}){
                        #count up and add again. This could happen when export and import data.
                        while (exists $house{$num_keys}) {
                            $num_keys++;
                            if ($num_keys >= 999999) {die "Reached lmit.";}
                        }
                    }
                    my %hash = %{$house{$_}};
                    #物件IDをつける
                    $hash{'HOUSE_ID'} = $num_keys;
                    #部屋番号を空にする。
                    #$hash{'HOUSE_ROOM_NUMBER'} = '';

                    $hash{'HOUSE_CREATED'} = REPS::Util->get_datetime_now();
                    $hash{'HOUSE_LAST_UPDATED'} = '';

                    if ($hash{'HOUSE_PICS_OUTSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_OUTSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_OUTSIDE'}, $res_dir.'bh/'.$num_keys.'_a'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_OUTSIDE'} = 'bh/'.$num_keys.'_a'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'HOUSE_PICS_INSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_INSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_INSIDE'}, $res_dir.'bh/'.$num_keys.'_b'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_INSIDE'} = 'bh/'.$num_keys.'_b'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'HOUSE_PICS_MADORIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_MADORIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_MADORIZU'}, $res_dir.'bh/'.$num_keys.'_c'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_MADORIZU'} = 'bh/'.$num_keys.'_c'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'HOUSE_PICS_TIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_TIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_TIZU'}, $res_dir.'bh/'.$num_keys.'_d'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_TIZU'} = 'bh/'.$num_keys.'_d'.$ext;
                        };
                        if ($@){die $@;}
                    }

                    if ($hash{'HOUSE_PICS_OUTSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_OUTSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_OUTSIDE_THUMB'}, $res_dir.'bh/'.$num_keys.'_a_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_OUTSIDE_THUMB'} = 'bh/'.$num_keys.'_a_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'HOUSE_PICS_INSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_INSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_INSIDE_THUMB'}, $res_dir.'bh/'.$num_keys.'_b_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_INSIDE_THUMB'} = 'bh/'.$num_keys.'_b_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'HOUSE_PICS_MADORIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_MADORIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_MADORIZU_THUMB'}, $res_dir.'bh/'.$num_keys.'_c_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_MADORIZU_THUMB'} = 'bh/'.$num_keys.'_c_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'HOUSE_PICS_TIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'HOUSE_PICS_TIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'HOUSE_PICS_TIZU_THUMB'}, $res_dir.'bh/'.$num_keys.'_d_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'HOUSE_PICS_TIZU_THUMB'} = 'bh/'.$num_keys.'_d_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }


                    #$apart{$num_keys} = $apart{$_};
                    $house{$num_keys} = \%hash;
                }
            }
        }
    }
    untie %house;

    return 1;
}

sub toggle_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');

    tie (%house, 'MLDBM', $db_b_house_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    #$house{$$ref_hash{'HOUSE_ID'}} = $ref_hash;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $house{$_}){
                if (defined $house{$_} && ($house{$_})){
                    my $ref_hash = $house{$_};
                    my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($house{$_}{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$house{$_}};
                                if ($boolean){
                                    $hash{'HOUSE_PUBLISHED'}='On';
                                    $hash{'HOUSE_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                                }else{
                                    $hash{'HOUSE_PUBLISHED'}='';
                                }
                                $house{$_} = \%hash;
                            } else {
    #                            delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$house{$_}};
                            if ($boolean){
                                $hash{'HOUSE_PUBLISHED'}='On';
                                $hash{'HOUSE_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                            }else{
                                $hash{'HOUSE_PUBLISHED'}='';
                            }
                            $house{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$house{$_}};
                        if ($boolean){
                            $hash{'HOUSE_PUBLISHED'}='On';
                            $hash{'HOUSE_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                        }else{
                            $hash{'HOUSE_PUBLISHED'}='';
                        }
                        $house{$_} = \%hash;
                    }
#                    if ($hash{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')){
                        #delete $house{$_};
#                        $house{$_} = undef;
#                    }
                }

            }
        }
    }
    untie %house;

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
#     $special->delete_Realestate((map {"BH". $_ } @to_be_deleted));
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_updates_path')
#                 );
# 
#     $updates->delete_Realestate((map {"BH". $_ } @to_be_deleted));

#check and make sure it is owned by the user HOUSE_USER_ID
    return 1;
}

sub special_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');

    tie (%house, 'MLDBM', $db_b_house_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    #$house{$$ref_hash{'HOUSE_ID'}} = $ref_hash;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $house{$_}){
                if (defined $house{$_} && ($house{$_})){
                    my $ref_hash = $house{$_};
                    my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($house{$_}{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$house{$_}};
                                if ($boolean){
                                    $hash{'HOUSE_IS_SPECIAL'}='On';
                                }else{
                                    $hash{'HOUSE_IS_SPECIAL'}='';
                                }
                                $house{$_} = \%hash;

                            }
                        }else{
                            my %hash = ();
                            %hash = %{$house{$_}};
                            if ($boolean){
                                $hash{'HOUSE_IS_SPECIAL'}='On';
                            }else{
                                $hash{'HOUSE_IS_SPECIAL'}='';
                            }
                            $house{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$house{$_}};
                        if ($boolean){
                            $hash{'HOUSE_IS_SPECIAL'}='On';
                        }else{
                            $hash{'HOUSE_IS_SPECIAL'}='';
                        }
                        $house{$_} = \%hash;
                    }

                }

            }
        }
    }
    untie %house;
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

    my %house;
    my $db_b_house_path = $self->{_app}->param('db_b_house_path');
    if (-f $db_b_house_path){
        tie (%house, 'MLDBM', $db_b_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        while ( ($key, $value) = each(%house) ) {
    
            if ((defined $house{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'HOUSE_USER_ID'}){
                    #match?
                    $match = 0;
    
                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($tmp{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')) {
                            next;
                        }
                    }
    
#                     if ($q->param("house_jisyakannri")){ #自社管理指定
#     #                    if ($tmp{'HOUSE_USER_ID'} eq $self->{_app}->param('user_id')){
#                         #自社登録物件
#                             if ($tmp{'HOUSE_TASYAKANRI'}){
#                                 #他社管理物件
#                                 next;
#                             }else{
#                                 $match = 1;
#                             }
#     #                    }else{
#     #                        next;
#     #                    }
#                     }
                    if ($q->param("house_jisyakannri") > 0){
                        if ($q->param("house_jisyakannri") == 1) {
                            if (!$tmp{'HOUSE_TASYAKANRI'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_jisyakannri") == 2){
                            if ($tmp{'HOUSE_TASYAKANRI'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }
    
#                    if ($q->param("house_jisyatouroku")){
#                        if ($tmp{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')){
#                            next;
#                        }else{$match = 1;}
#                    }else{
#                        $match = 1;
#                    }
                    if ($q->param("house_jisyatouroku") > 0){
                        if ($q->param("house_jisyatouroku") == 1) {
                            if ($tmp{'HOUSE_USER_ID'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_jisyatouroku") == 2){
                            if (!$tmp{'HOUSE_USER_ID'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }
    
#                    if ($q->param("house_public")){
#                        if ($tmp{'HOUSE_PUBLISHED'}){
#                            $match = 1;
#                        }else{
#                            next;
#                        }
#                    }else{
#                        $match = 1;
#                    }
                    if ($q->param("house_public") > 0){
                        if ($q->param("house_public") == 1) {
                            if ($tmp{'HOUSE_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_public") == 2){
                            if (!$tmp{'HOUSE_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("house_recommend") > 0){
                        if ($q->param("house_recommend") == 1) {
                            if ($tmp{'HOUSE_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("house_recommend") == 2){
                            if (!$tmp{'HOUSE_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
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
    
                    my $test = 0;
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
    
                    if ($q->param("house_address")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("house_address")));
                        if (REPS::Util->str_match($tmp{'HOUSE_LOCATION'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
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
    
                    if ($q->param("house_station")){
                        my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("house_station")));
                        if (REPS::Util->str_match($tmp{'HOUSE_STATION_1'},$search_by_key)){
                            $match = 1;
                        }elsif(REPS::Util->str_match($tmp{'HOUSE_STATION_2'},$search_by_key)){
                            $match = 1;
                        }else{next;}
                    }
    
                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'station') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'HOUSE_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'HOUSE_LAST_UPDATED'})&&($tmp{'HOUSE_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'HOUSE_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'HOUSE_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'HOUSE_LOCATION'};
                            }elsif(($sort_by eq 'station')){
                                $sort_hash{$key} = $tmp{'HOUSE_STATION_1'};
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
            }elsif(($sort_by eq 'station')){
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
                my $ref_hash = $house{$_};
                my %tmp = %$ref_hash;
    
                my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'HOUSE_CREATED'});
                my $new = '';
                if ($dd <= 30) {
                    $new = 'ON';
                }
                my $updated = '';
                if ((!$new) && ($tmp{'HOUSE_LAST_UPDATED'})){
                    $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'HOUSE_LAST_UPDATED'});
                    if ($dd <= 10) {
                        $updated = 'ON';
                    }
                }

                my %hash = (
                    'HOUSE_ID' => "$_",
                    'HOUSE_PUBLISHED' => $tmp{'HOUSE_PUBLISHED'},
                    'HOUSE_IS_SPECIAL' => $tmp{'HOUSE_IS_SPECIAL'},
                    'HOUSE_STATION_1' => $tmp{'HOUSE_STATION_1'},
                    'HOUSE_STATION_2' => $tmp{'HOUSE_STATION_2'},
                    'HOUSE_LOCATION' => $tmp{'HOUSE_LOCATION'},
                    'HOUSE_PRICE' => REPS::Util->insert_comma($tmp{'HOUSE_PRICE'}),
                    'HOUSE_CREATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_CREATED'}),
                    'HOUSE_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'HOUSE_LAST_UPDATED'}),
                    'HOUSE_NEW' => $new,
                    'HOUSE_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    '_type' => 'bh'
                );
        
                push(@loop_data, \%hash);
            }
    #    }
    
        untie %house;
    
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
    my %house;
    my $db_house_path = $self->{_app}->param('db_b_house_path');
    my ($key, $value);
    my @loop_data=();
    #my %hash;

    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');

    if (-f $db_house_path){
        tie (%house, 'MLDBM', $db_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        while ( ($key, $value) = each(%house) ) {
            if ((exists $house{$key}) && (defined $house{$key}) && ($value)){

                 if (($$value{'HOUSE_PUBLISHED'}) && ($$value{'HOUSE_IS_SPECIAL'})){
                    push(@loop_data, $key);
                    if ($limit < scalar(@loop_data)){last;}
                 }

            }
        }
        untie %house;

    }
    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');
    if (($limit) && ($limit>0)){
        @loop_data = @loop_data[0..$limit-1];
    }
    require REPS::Search::Realestate::B_House;
    my $Realestate = REPS::Search::Realestate::B_House->new($self->{_app});
    my $ref_loop = $Realestate->get_Detail_List(@loop_data);

    return $ref_loop;
}

sub get_Count{
    my $self = shift;
    my %house;
    my $db_house_path = $self->{_app}->param('db_b_house_path');
    my ($key, $value);
    my %hash;
    if (-f $db_house_path){
        tie (%house, 'MLDBM', $db_house_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        my $n=0;# = keys( %apart );
        my $p=0;
        my $l=0;
        my $t;
        while ( ($key, $value) = each(%house) ) {
            if ((exists $house{$key}) && (defined $house{$key}) && ($value)){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($$value{'HOUSE_USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }
    
                if (exists $$value{'HOUSE_PUBLISHED'}){
                    if ($$value{'HOUSE_PUBLISHED'}){
                        $p++;
                    }else{
                        $n++;
                    }
                }
        
                if ((defined $$value{'HOUSE_LAST_UPDATED'}&&($$value{'HOUSE_LAST_UPDATED'}))){
                    $t=$$value{'HOUSE_LAST_UPDATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'HOUSE_LAST_UPDATED'};
                    }
        ;
                }else{
                    $t=$$value{'HOUSE_CREATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'HOUSE_CREATED'};
                    }
                }
            }
        }
        untie %house;
    
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
    my $db_access_path = $self->{_app}->param('db_b_house_access_path');
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
    my $db_inquiry_path = $self->{_app}->param('db_b_house_inquiry_path');
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
    my $feed_title = '売買一戸建て物件情報';
    $feed->title($UJ->set($feed_title,'euc')->utf8);
    # subtitle
    my $feed_subtitle = $$settings_info{'COMPANY_NAME'} . 'が配信する最新の売買一戸建て物件情報です';
    $feed->subtitle($UJ->set($feed_subtitle,'euc')->utf8);


    #create self link
    my $feed_link = XML::Atom::Syndication::Link->new();
    $feed_link->href($self->{_app}->cfg('site_url').'bh-atom.xml');
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
    $feed->id($self->{_app}->cfg('cgi_url').'bh');

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

    my %house;
    my $db_path = $self->{_app}->param('db_b_house_path');
    if (-e $db_path){
        tie (%house, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'write') or Carp::croak ("$! $db_path");#
        while ( ($key, $value) = each(%house) ) {
            if ($i > 15){last;}
            if ((defined $house{$key}) && ($value)){
                if ($$value{'HOUSE_PUBLISHED'}){
                    $i++;
                    if ((defined $$value{'HOUSE_LAST_UPDATED'}&&($$value{'HOUSE_LAST_UPDATED'}))){
                        $sort_hash{$key} = $$value{'HOUSE_LAST_UPDATED'};
                    }else{
                        $sort_hash{$key} = $$value{'HOUSE_CREATED'};
                    }
                }
            }
        }

        #sort by update
        my @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
        @sort_keys = reverse @sort_keys;
        if (@sort_keys > 0){
            if ($house{$sort_keys[0]}{'HOUSE_LAST_UPDATED'}. '+09:00'){
                $feed->updated($house{$sort_keys[0]}{'HOUSE_LAST_UPDATED'}. '+09:00');
            }else{
                $feed->updated($house{$sort_keys[0]}{'HOUSE_CREATED'}. '+09:00');
            }
        }else{
            $feed->updated(REPS::Util->get_datetime_now . '+09:00');
        }
        #for each
        foreach (@sort_keys){
            my $entry = XML::Atom::Syndication::Entry->new;
#TODO: create better id for entry.
            $entry->id($self->{_app}->cfg('cgi_url').'bh/'.$house{$_}{'HOUSE_ID'});

            #title

            my $house_price = REPS::Util->insert_comma($house{$_}{'HOUSE_PRICE'});
            my $entry_title = "[一戸建て][$house_price万円]";
            $entry->title($UJ->set($entry_title,'euc')->utf8);

            #create a link
            my $entry_link = XML::Atom::Syndication::Link->new();
            $entry_link->href($self->{_app}->cfg('cgi_url').'search.cgi?_mode=mode_detail&_type=bh&_object_id='.$house{$_}{'HOUSE_ID'});
            $entry_link->rel('alternate');
            $entry_link->type('text/html');
            #set a feed link
            $entry->link($entry_link);
            #updated
            if ($house{$_}{'HOUSE_LAST_UPDATED'}){
                $entry->updated($house{$_}{'HOUSE_LAST_UPDATED'} . '+09:00');
                $entry->published($house{$_}{'HOUSE_CREATED'}. '+09:00');
            }else{
                $entry->updated($house{$_}{'HOUSE_CREATED'}. '+09:00');
            }
            #author
            my $entry_author = XML::Atom::Syndication::Person->new(Name=>'author');
            $entry_author->name($house{$_}{'HOUSE_USER_ID'});
            $entry->author($entry_author);

            my $house_picture_1='';
            if ($house{$_}{'HOUSE_PICS_OUTSIDE'}){
                $house_picture_1 = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$house{$_}{'HOUSE_PICS_OUTSIDE_THUMB'};
                $house_picture_1 = '<img src="'.$house_picture_1.'" class="outside" />';
            }
            my $house_picture_2='';
            if ($house{$_}{'HOUSE_PICS_MADORIZU'}){
                $house_picture_2 = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$house{$_}{'HOUSE_PICS__MADORIZU_THUMB'};
                $house_picture_2 = '<img src="'.$house_picture_2.'" class="madorizu" />';
            }

            #my $entry_category = XML::Atom::Syndication::Category->new();
            #$entry_category->term($UJ->set($house_kind,'euc')->utf8);
            #$entry->category($entry_category);
#TODO: How to add more than one category?

my $entry_content = <<"_HTML_";
<div class="rl">
    <h4><span="tagline">$house{$_}{HOUSE_ADS_TEXT}</span></h4>
    <ul>
        <li>価格：<span class="price">$house_price<span class="unit">万円</span></span></li>
        <li>所在地：<span class="location">$house{$_}{HOUSE_LOCATION}</span></li>
        <li>最寄駅：<span class="station">$house{$_}{HOUSE_STATION_1}</span></li>
    </ul>
    <div class="picture">
        <span class="outside">$house_picture_1</span>
        <span class="madorizu">$house_picture_2</span>
    </div>
</div>
_HTML_

            my $content = XML::Atom::Syndication::Content->new($UJ->set($entry_content,'euc')->utf8);
            $content->type('html');
            $entry->content($content);
            $feed->add_entry($entry);

        }
        untie %house;

        my $output = $feed->as_xml;
        my $file = $self->{_app}->cfg('site_path').'bh-atom.xml';

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
