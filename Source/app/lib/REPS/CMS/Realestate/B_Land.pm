package REPS::CMS::Realestate::B_Land;

use strict;
use base qw( REPS::CMS::Realestate );

use DB_File::Lock;
use File::Path;

sub new{
    my ($class,$app) = @_;
    my $self = {
        _app => $app,
        _ref_hash => {
            'LAND_ID' => '',
            'LAND_PUBLISHED' => '',
            'LAND_IS_SPECIAL' => '',
            'LAND_LOCATION' => '',

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

sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();
    
    $self->{_ref_hash}{'LAND_ID'} = $q->param('_object_id') if $q->param('_object_id');
    $self->{_ref_hash}{'LAND_PUBLISHED'} = $q->param('land_publish') if $q->param('land_publish');
    $self->{_ref_hash}{'LAND_IS_SPECIAL'} = $q->param('add_to_special') if $q->param('add_to_special');

    $self->{_ref_hash}{'LAND_LOCATION'} = REPS::Util->trim($q->param('land_location')) if $q->param('land_location');
    $self->{_ref_hash}{'LAND_STATION_1'} = $q->param('land_station1') if $q->param('land_station1');

    $self->{_ref_hash}{'LAND_BUS_1'} = $q->param('land_bus') if $q->param('land_bus');
    $self->{_ref_hash}{'LAND_WALK_MINUTES_1'} = $q->param('land_walk_minutes') if $q->param('land_walk_minutes');
    $self->{_ref_hash}{'LAND_BUS_MINUTES_1'} = $q->param('land_bus_minutes') if $q->param('land_bus_minutes');
    $self->{_ref_hash}{'LAND_BUSWALK_MINUTES_1'} = $q->param('land_buswalk_minutes') if $q->param('land_buswalk_minutes');

    $self->{_ref_hash}{'LAND_STATION_2'} = $q->param('land_station2') if $q->param('land_station2');
    $self->{_ref_hash}{'LAND_BUS_2'} = $q->param('land_bus2') if $q->param('land_bus2');
    $self->{_ref_hash}{'LAND_WALK_MINUTES_2'} = $q->param('land_walk_minutes2') if $q->param('land_walk_minutes2');
    $self->{_ref_hash}{'LAND_BUS_MINUTES_2'} = $q->param('land_bus_minutes2') if $q->param('land_bus_minutes2');
    $self->{_ref_hash}{'LAND_BUSWALK_MINUTES_2'} = $q->param('land_buswalk_minutes2') if $q->param('land_buswalk_minutes2');


    $self->{_ref_hash}{'LAND_PRICE'} = $q->param('land_price') if $q->param('land_price');

    $self->{_ref_hash}{'LAND_TUBOTANKA'} = $q->param('land_tubotanka') if $q->param('land_tubotanka');
    $self->{_ref_hash}{'LAND_SQUARE_M'} = $q->param('land_square_m') if $q->param('land_square_m');
    $self->{_ref_hash}{'LAND_SQUARE_TEXT'} = $q->param('land_square_text') if $q->param('land_square_text');
    $self->{_ref_hash}{'LAND_SQUARE_T'} = $q->param('land_square_t') if $q->param('land_square_t');
    $self->{_ref_hash}{'LAND_SETUDOU'} = $q->param('land_setudou') if $q->param('land_setudou');
    $self->{_ref_hash}{'LAND_KENRI'} = $q->param('land_kenri') if $q->param('land_kenri');
    $self->{_ref_hash}{'LAND_SETBACK'} = $q->param('land_setback') if $q->param('land_setback');
    $self->{_ref_hash}{'LAND_SIDOUFUTAN_SQUARE'} = $q->param('land_sidoufutan_square') if $q->param('land_sidoufutan_square');
    $self->{_ref_hash}{'LAND_TIMOKU'} = $q->param('land_timoku') if $q->param('land_timoku');
    $self->{_ref_hash}{'LAND_TISEI'} = $q->param('land_tisei') if $q->param('land_tisei');
    $self->{_ref_hash}{'LAND_KENPEIRITU'} = $q->param('land_kenpeiritu') if $q->param('land_kenpeiritu');
    $self->{_ref_hash}{'LAND_YOUSEKIRITU'} = $q->param('land_yousekiritu') if $q->param('land_yousekiritu');
    $self->{_ref_hash}{'LAND_YOUTOTIIKI'} = $q->param('land_youtotiiki') if $q->param('land_youtotiiki');
    $self->{_ref_hash}{'LAND_TOSIKEIKAKU'} = $q->param('land_tosikeikaku') if $q->param('land_tosikeikaku');
    $self->{_ref_hash}{'LAND_KOKUDOHOUTODOKEDE'} = $q->param('land_kokudohoutodokede') if $q->param('land_kokudohoutodokede');
    $self->{_ref_hash}{'LAND_JYOUKEN'} = $q->param('land_jyouken') if $q->param('land_jyouken');

    $self->{_ref_hash}{'LAND_OPTIONS_KAKUTI'} = $q->param('land_options_kakuti') if $q->param('land_options_kakuti');

    $self->{_ref_hash}{'LAND_OPTIONS_GUS'} = $q->param('land_options_gus') if $q->param('land_options_gus');
    $self->{_ref_hash}{'LAND_OPTIONS_SUIDOU'} = $q->param('land_options_suidou') if $q->param('land_options_suidou');
    $self->{_ref_hash}{'LAND_OPTIONS_OSUI'} = $q->param('land_options_osui') if $q->param('land_options_osui');
    $self->{_ref_hash}{'LAND_OPTIONS_HAISUI'} = $q->param('land_options_haisui') if $q->param('land_options_haisui');

    $self->{_ref_hash}{'LAND_SETUBI'} = $q->param('land_setubi') if $q->param('land_setubi');
    $self->{_ref_hash}{'LAND_BIKOU'} = $q->param('land_bikou') if $q->param('land_bikou');
    $self->{_ref_hash}{'LAND_HIKIWATASI'} = $q->param('land_hikiwatasi') if $q->param('land_hikiwatasi');
    $self->{_ref_hash}{'LAND_GENKYOU'} = $q->param('land_genkyou') if $q->param('land_genkyou');
    $self->{_ref_hash}{'LAND_TORIHIKITAIYOU'} = $q->param('land_torihikitaiyou') if $q->param('land_torihikitaiyou');

    $self->{_ref_hash}{'LAND_YOUR_ID'} = $q->param('land_your_id') if $q->param('land_your_id');

    $self->{_ref_hash}{'LAND_ADS_TEXT'} = $q->param('land_ads_text') if $q->param('land_ads_text');

    $self->{_ref_hash}{'LAND_PICS_OUTSIDE'} = $q->param('_land_pics_outside') if $q->param('_land_pics_outside');
    $self->{_ref_hash}{'LAND_PICS_INSIDE'} = $q->param('_land_pics_inside') if $q->param('_land_pics_inside');
    $self->{_ref_hash}{'LAND_PICS_TIZU'} = $q->param('_land_pics_tizu') if $q->param('_land_pics_tizu');


    $self->{_ref_hash}{'LAND_PICS_OUTSIDE_THUMB'} = $q->param('_land_pics_outside_thumb') if $q->param('_land_pics_outside_thumb');
    $self->{_ref_hash}{'LAND_PICS_INSIDE_THUMB'} = $q->param('_land_pics_inside_thumb') if $q->param('_land_pics_inside_thumb');
    $self->{_ref_hash}{'LAND_PICS_TIZU_THUMB'} = $q->param('_land_pics_tizu_thumb') if $q->param('_land_pics_tizu_thumb');

    $self->{_ref_hash}{'LAND_MOVIE_FILE_URL'} = $q->param('land_movie_file_url') if $q->param('land_movie_file_url');

    $self->{_ref_hash}{'LAND_TASYAKANRI'} = $q->param('land_tasyakanri') if $q->param('land_tasyakanri');
    $self->{_ref_hash}{'LAND_RYUUTUU'} = $q->param('land_ryuutuu') if $q->param('land_ryuutuu');
    $self->{_ref_hash}{'LAND_KANRIKAISYA'} = $q->param('land_kanrikaisya') if $q->param('land_kanrikaisya');
    $self->{_ref_hash}{'LAND_KANRIKAISYA_CONTACT'} = $q->param('land_kanrikaisya_contact') if $q->param('land_kanrikaisya_contact');

    $self->{_ref_hash}{'LAND_CREATED'} = $q->param('land_created') if $q->param('land_created');

    $self->{_app}->convert_hash_charset($self->{_ref_hash});
    REPS::Util->convert_hash_zhk($self->{_ref_hash});
    
}

sub get_Create_Realestate_Form{
    my $self = shift;
    #my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    $q->delete('land_options_gus');
    $q->delete('land_options_suidou');
    $q->delete('land_options_osui');
    $q->delete('land_options_haisui');

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'land');
    $output .= $q-> table( {-border => 1,class=>'main_table'},

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'land_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_LOCATION'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'land_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_STATION_1'}"))
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'land_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_WALK_MINUTES_1'}"),'分')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'land_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_BUS_1'}"))
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'land_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_BUS_MINUTES_1'}"),'分')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'land_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_BUSWALK_MINUTES_1'}"),'分')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'land_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_STATION_2'}"))
                
            ),

#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'land_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'land_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_BUS_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'land_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'land_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_BUSWALK_MINUTES_2'}"),'分'),
            ),
#

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"価格: "), 
                $q->td($q->textfield(-name=>'land_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_PRICE'}"),'万円')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"坪単価: "), 
                $q->td($q->textfield(-name=>'land_tubotanka', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_TUBOTANKA'}"),'円')
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"面積(平米): "), 
                $q->td($q->textfield(-name=>'land_square_m', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_SQUARE_M'}"),'m&sup2')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"面積補足: "), 
                $q->td($q->textfield(-name=>'land_square_text', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_SQUARE_TEXT'}"),'(実測・公簿...)')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"面積(坪): "), 
                $q->td($q->textfield(-name=>'land_square_t', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_SQUARE_T'}"),'坪')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"接道状況: "), 
                $q->td($q->textfield(-name=>'land_setudou', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_SETUDOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"土地権利: "), 
                $q->td($q->textfield(-name=>'land_kenri', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KENRI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"セットバック: "), 
                $q->td($q->textfield(-name=>'land_setback', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_SETBACK'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"私道負担面積: "), 
                $q->td($q->textfield(-name=>'land_sidoufutan_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_SIDOUFUTAN_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地目: "), 
                $q->td($q->textfield(-name=>'land_timoku', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_TIMOKU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地勢: "), 
                $q->td($q->textfield(-name=>'land_tisei', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_TISEI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"建蔽率: "), 
                $q->td($q->textfield(-name=>'land_kenpeiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KENPEIRITU'}"),'％')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"容積率: "), 
                $q->td($q->textfield(-name=>'land_yousekiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_YOUSEKIRITU'}"),'％')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"用途地域: "), 
                $q->td($q->textfield(-name=>'land_youtotiiki', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_YOUTOTIIKI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"都市計画: "), 
                $q->td($q->textfield(-name=>'land_tosikeikaku', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_TOSIKEIKAKU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"国土法届出: "), 
                $q->td($q->textfield(-name=>'land_kokudohoutodokede', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KOKUDOHOUTODOKEDE'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡条件: "), 
                $q->td($q->textfield(-name=>'land_jyouken', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_JYOUKEN'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(    
                            $q->th('位置'),
                            $q->td(
                                $q->checkbox(-name=>'land_options_kakuti', -label=>'角地', -checked=>"$self->{_ref_hash}{'LAND_OPTIONS_KAKUTI'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td({-colspan=>4},
                                'ガス:',$q->radio_group(-name=>'land_options_gus',
                                    -default=>"$self->{_ref_hash}{'LAND_OPTIONS_GUS'}",
                                    -values=>['1','2','3','4','5'],
                                    -labels=>{'1'=>'都市ガス','2'=>'個別プロパンガス','3'=>'集中プロパンガス','4'=>'その他','5'=>'無し'})
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td({-colspan=>4},
                                '水道:',$q->radio_group(-name=>'land_options_suidou',
                                    -default=>"$self->{_ref_hash}{'LAND_OPTIONS_SUIDOU'}",
                                    -values=>['1','2','3','4'],
                                    -labels=>{'1'=>'公営水道','2'=>'私営水道','3'=>'その他','4'=>'無し'})
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td({-colspan=>4},
                                '汚水:',$q->radio_group(-name=>'land_options_osui',
                                    -default=>"$self->{_ref_hash}{'LAND_OPTIONS_OSUI'}",
                                    -values=>['1','2','3','4','5'],
                                    -labels=>{'1'=>'本下水','2'=>'集中浄化槽','3'=>'個別浄化槽','4'=>'その他','5'=>'無し'})
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td({-colspan=>4},
                                '雑排水:',$q->radio_group(-name=>'land_options_haisui',
                                    -default=>"$self->{_ref_hash}{'LAND_OPTIONS_HAISUI'}",
                                    -values=>['1','2','3','4','5'],
                                    -labels=>{'1'=>'本下水','2'=>'側溝等','3'=>'浸透','4'=>'その他','5'=>'無し'})
                            )
                        )
                    )
                )
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"その他設備: "), 
                $q->td($q->textarea(-name=>'land_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'LAND_SETUBI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'land_bikou', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'LAND_BIKOU'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡日: "), 
                $q->td($q->textfield(-name=>'land_hikiwatasi', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_HIKIWATASI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"現況: "), 
                $q->td($q->textfield(-name=>'land_genkyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_GENKYOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'land_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_TORIHIKITAIYOU'}"))
            ),



            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'land_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_YOUR_ID'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'land_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$self->{_ref_hash}{'LAND_ADS_TEXT'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真１: "), 
                $q->td($q->filefield(-name=>'land_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>"$self->{_ref_hash}{'LAND_PICS_OUTSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真２: "), 
                $q->td($q->filefield(-name=>'land_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_PICS_INSIDE'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'land_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_PICS_TIZU'}")),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL: "), 
                $q->td($q->textfield(-name=>'land_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_MOVIE_FILE_URL'}")),
            ),


#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"物元会社情報:<br />会社名:<br />電話番号:"), 
#                $q->td(
#                    $q->checkbox(-name=>'land_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'LAND_TASYAKANRI'}"),
#                    $q->br,
#                    $q->textfield(-name=>'land_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'land_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"物元会社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'land_tasyakanri',-label=>'他社管理', -checked=>"$self->{_ref_hash}{'LAND_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('会社名:'),
                            $q->td(
                    $q->textfield(-name=>'land_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                    $q->textfield(-name=>'land_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),


            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'land_ryuutuu',-label=>'流通可', -checked=>"$self->{_ref_hash}{'LAND_RYUUTUU'}"),
            #    ),
            #),

            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_add'),
                    $q->hidden(-name => '_type', -value => 'bl'),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加', -checked=>""),
                    '&nbsp;',
                    $q->checkbox(-name=>'land_publish', -label=>'公開する', -checked=>"$self->{_ref_hash}{'LAND_PUBLISHED'}"),
                    $q->submit(-name => 'add_new_object' ,-value => '新規追加', -class=>'submit')
                )
            )



        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.land.land_location.focus(); \n// --></script>";
    return $output;
}

sub create_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();

    #todo check each item
#    if ($$ref_hash{'LAND_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
        if ($$ref_hash{'LAND_USER_ID'} ne $self->{_app}->param('user_id')){
            $result .= '異なるユーザーIDでは登録できません。<br />';
        }
    }

    $$ref_hash{'LAND_USER_ID'} = $self->{_app}->param('user_id');

    if (!$$ref_hash{'LAND_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_PRICE'}) {$result .= '価格が入力されていません。<br />';}
    #if (!$$ref_hash{'LAND_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}

    if (!$$ref_hash{'LAND_TUBOTANKA'}) {$result .= '坪単価が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_SQUARE_M'}) {$result .= '面積(平米)が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_SQUARE_T'}) {$result .= '面積(坪)が入力されていません。<br />';}

    if (!$$ref_hash{'LAND_KENRI'}) {$result .= '土地権利が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_KENPEIRITU'}) {$result .= '建蔽率が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_YOUSEKIRITU'}) {$result .= '容積率が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'LAND_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_SIDOUFUTAN_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        #要望により
        #$result .= '私道負担面積の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'LAND_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'LAND_PRICE'}) {
        my $str = $$ref_hash{'LAND_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{1,80}))$/){

        }else{
            $result .= '価格の値が不自然です。半角数字であるか確認してください。<br />';
        }
    }

    if ($$ref_hash{'LAND_SQUARE'}){
        unless($$ref_hash{'LAND_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
            $result .= '面積は半角英数とピリオド（.）だけで入力してください。<br />'; #/31
        }
    }

    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'bl' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('land_pics_outside')){
        my $fh = $q->upload('land_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'LAND_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'LAND_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('land_pics_inside')){
        my $fh = $q->upload('land_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'LAND_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'LAND_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('land_pics_tizu')){
        my $fh = $q->upload('land_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'LAND_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'LAND_PICS_TIZU'} = $saved->{'_image'};
    }


    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
    }else{
        $$ref_hash{'LAND_CREATED'} = REPS::Util->get_datetime_now();
        my %land;
        my $db_b_land_path = $self->{_app}->param('db_b_land_path');
        my $num_keys = 1;
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%land, 'MLDBM', $db_b_land_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        $num_keys = scalar keys (%land);
        $num_keys = sprintf('%06d', $num_keys++);
        if (exists $land{$num_keys}){
            #count up and add again. This could happen when export and import data.
            #$result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
            while (exists $land{$num_keys}) {
                $num_keys++;
                if ($num_keys >= 999999) {die "Reached lmit.";};
            }
        }
        if (!defined $land{$num_keys}){
            $$ref_hash{'LAND_ID'} = $num_keys;
            eval {
                if ($q->param('land_pics_outside')){
                    my $tmp = $$ref_hash{'LAND_PICS_OUTSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_OUTSIDE'},$dir.$tmp);
                    $$ref_hash{'LAND_PICS_OUTSIDE'} = 'bl' . '/'.$tmp;
                    if ($$ref_hash{'LAND_PICS_OUTSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'LAND_PICS_OUTSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'LAND_PICS_OUTSIDE_THUMB'} = 'bl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('land_pics_inside')){
                    my $tmp = $$ref_hash{'LAND_PICS_INSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_INSIDE'},$dir.$tmp);
                    $$ref_hash{'LAND_PICS_INSIDE'} = 'bl' . '/'.$tmp;
                    if ($$ref_hash{'LAND_PICS_INSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'LAND_PICS_INSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_INSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'LAND_PICS_INSIDE_THUMB'} = 'bl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            eval {
                if ($q->param('land_pics_tizu')){
                    my $tmp = $$ref_hash{'LAND_PICS_TIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_TIZU'},$dir.$tmp);
                    $$ref_hash{'LAND_PICS_TIZU'} = 'bl' . '/'.$tmp;
                    if ($$ref_hash{'LAND_PICS_TIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'LAND_PICS_TIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_TIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'LAND_PICS_TIZU_THUMB'} = 'bl' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            $land{$num_keys} = $ref_hash;
            $self->{_ref_hash} = $ref_hash;
        }else{
            $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
        }

        untie %land;
umask($old);
#         my %hash_sp=(
#                 'BS_ID' => $$ref_hash{'LAND_ID'},
#                 'BS_NAME' => '',
#                 'BS_STATION_1' => $$ref_hash{'LAND_STATION_1'},
#                 'BS_STATION_2' => $$ref_hash{'LAND_STATION_2'},
#                 'BS_LOCATION' =>$$ref_hash{'LAND_LOCATION'},
#                 'BS_PRICE' => REPS::Util->insert_comma($$ref_hash{'LAND_PRICE'}),
#                 'BS_BUS_MINUTES_1' => $$ref_hash{'LAND_BUS_MINUTES_1'},
#                 'BS_WALK_MINUTES_1' => $$ref_hash{'LAND_WALK_MINUTES_1'},
#                 'BS_SQUARE' => $$ref_hash{'LAND_SQUARE_M'},
# 
#                 'BS_MADORI' => $$ref_hash{'LAND_MADORI'},
#                 'BS_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_OUTSIDE_THUMB'},
#                 'BS_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_MADORIZU_THUMB'},
#                 'BS_ADS_TEXT' => $$ref_hash{'LAND_ADS_TEXT'}
#         );
#         $hash_sp{'BS_KIND'}='土地';
#         $hash_sp{'_type'}='bl';

#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'LAND_PUBLISHED'}){
#                 #Special
#     
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BL'.$$ref_hash{'LAND_ID'},
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
#         if ($$ref_hash{'LAND_PUBLISHED'}){
#             if (!$$ref_hash{'LAND_LAST_UPDATED'}){
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'LAND_CREATED'};
#             }else{
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'LAND_LAST_UPDATED'};
#             }
#             my $updates = REPS::Updates::Updates->new(
#                             $self->{_app},
#                             $self->{_app}->param('db_bs_updates_path'),
#                             'BL'.$$ref_hash{'LAND_ID'},
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


    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');
    if (-f $db_b_land_path){
        tie (%land, 'MLDBM', $db_b_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        my @sort_keys;
        while ( ($key, $value) = each(%land) ) {
            if ((defined $value) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'LAND_USER_ID'}){
                    if ($only_this_user){
                        if ($only_this_user ne $tmp{'LAND_USER_ID'}){
                            next;
                        }
                    }
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($tmp{'LAND_USER_ID'} ne $self->{_app}->param('user_id')) {
                                next;
                            }
                        }
                    }else{
                        if (!$only_this_user){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($tmp{'LAND_USER_ID'} ne $self->{_app}->param('user_id')) {
                                    next;
                                }
                            }
                        }
                    }
    #                if ($tmp{'LAND_USER_ID'} eq $self->{_app}->param('user_id')){
                        #sort
                        if (($sort_by eq 'station') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'price'){
                                $sort_hash{$key} = $tmp{'LAND_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'LAND_LAST_UPDATED'})&&($tmp{'LAND_LAST_UPDATED'})){
                                    $sort_hash{$key} = $tmp{'LAND_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'LAND_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'LAND_LOCATION'};
                            }elsif($sort_by eq 'station'){
                                $sort_hash{$key} = $tmp{'LAND_STATION_1'};
                            }
                        }else{
        
#                            my %hash = (
#                                'LAND_ID' => "$key",
#                                'LAND_PUBLISHED' => $tmp{'LAND_PUBLISHED'},
#                                'LAND_STATION_1' => $tmp{'LAND_STATION_1'},
#                                'LAND_LOCATION' => $tmp{'LAND_LOCATION'},
#                                'LAND_PRICE' => REPS::Util->insert_comma($tmp{'LAND_PRICE'}),
#                                'LAND_CREATED' => REPS::Util->get_date_as_string($tmp{'LAND_CREATED'}),
#                                'LAND_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'LAND_LAST_UPDATED'}),
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

            my %tmp = %{$land{$_}};


            my $updated = '';
            my $new = '';
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

            my %hash = (
                'LAND_ID' => "$_",
                'LAND_PUBLISHED' => $tmp{'LAND_PUBLISHED'},
                'LAND_IS_SPECIAL' => $tmp{'LAND_IS_SPECIAL'},
                'LAND_STATION_1' => $tmp{'LAND_STATION_1'},
                'LAND_STATION_2' => $tmp{'LAND_STATION_2'},
                'LAND_LOCATION' => $tmp{'LAND_LOCATION'},
                'LAND_PRICE' => REPS::Util->insert_comma($tmp{'LAND_PRICE'}),
                'LAND_NEW' => $new,
                'LAND_UPDATED' => $updated,
                'static_url' => $self->{_app}->cfg('static_url'),
                'LAND_CREATED' => REPS::Util->get_date_as_string($tmp{'LAND_CREATED'}),
                'LAND_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'LAND_LAST_UPDATED'}),
            );
    
            push(@loop_data, \%hash);
        }

    
        untie %land;
    }
    return \@loop_data,$count;;
}

sub get_Realestate {
    my $self = shift;
    my $land_id = $_[0];

    my $ref_hash;
    my %hash;
    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');

    unless ($land_id =~ /[0-9]{6,10}/){Carp::croak "IDの形式が不正です。";}

    if (-f $db_b_land_path){
        tie (%land, 'MLDBM', $db_b_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        if (exists $land{$land_id} ) {
            if ((defined $land{$land_id}) && ($land{$land_id})){
                $ref_hash = $land{$land_id};
                if ($self->{_app}->param('user_isAdmin') != 1){
                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($land{$land_id}{'LAND_USER_ID'} ne $self->{_app}->param('user_id')) {
                            untie %land;
                            Carp::croak "The ID [$land_id] does not belong to you.";
                        }
                    }
                }
                #%hash = %$ref_hash;
    #            if ($self->{_app}->param('user_id') eq $$ref_hash{'LAND_USER_ID'}){
    
                    $self->{_ref_hash} = $land{$land_id};
                    
    #            }else{
    #                untie %land;
    #                die 'the ID does not belong to you.';
    #            }
            }else{
                untie %land;
                return 0;
                #die "The ID [$land_id] has no value. Possibly deleted.";
            }
        }else{
            untie %land;
            return 0;
            #die "The ID [$land_id] does not exists.";
        }
        untie %land;
    }

    return 1;
}


sub get_Edit_Realestate_Form{
    my $self = shift;
    my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'LAND_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $output = "<div class=\"warning\"><p>他のユーザーの物件はアクセス出来ません。 </p></div>";
                return $output;
            }
        }
    }

    $q->delete('land_options_gus');
    $q->delete('land_options_suidou');
    $q->delete('land_options_osui');
    $q->delete('land_options_haisui');

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'land');

    my $ifView = '';
    if ($$ref_hash{'LAND_IS_SPECIAL'}){
        $ifView .= '<img src="'.$self->{_app}->cfg('static_url').'icons/16-heart-gold-m.png" width="16" height="16" />';
    }
    if ($$ref_hash{'LAND_PUBLISHED'}){
        $ifView .= "&nbsp;<a href=\"./search.cgi?_mode=mode_detail&_type=bl&_object_id=$$ref_hash{'LAND_ID'}\" target=\"_blank\">公開ページ閲覧</a>";
    }

    #dummy var for delete pics
    $output .= $q->hidden(-name => 'delete_pic', -value => '');

    my $ifPicsOutside = '';
    if ($$ref_hash{'LAND_PICS_OUTSIDE'}){
        if ($$ref_hash{'LAND_PICS_OUTSIDE_THUMB'}){
            $ifPicsOutside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_OUTSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'LAND_PICS_OUTSIDE\');" />';
        }else{
            $ifPicsOutside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_OUTSIDE'}."\">写真１</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'LAND_PICS_OUTSIDE\');" />';
        }
    }
    my $ifPicsInside = '';
    if ($$ref_hash{'LAND_PICS_INSIDE'}){
        if ($$ref_hash{'LAND_PICS_INSIDE_THUMB'}){
            $ifPicsInside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_INSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'LAND_PICS_INSIDE\');" />';
        }else{
            $ifPicsInside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_INSIDE'}."\">写真2</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'LAND_PICS_INSIDE\');" />';
        }
    }
    my $ifPicsTizu = '';
    if ($$ref_hash{'LAND_PICS_TIZU'}){
        if ($$ref_hash{'LAND_PICS_TIZU_THUMB'}){
            $ifPicsTizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_TIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'LAND_PICS_TIZU\');" />';
        }else{
            $ifPicsTizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_TIZU'}."\">地図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'LAND_PICS_TIZU\');" />';
        }
    }

    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"物件番号："), 
                $q->th('[BL'.$$ref_hash{'LAND_ID'}.']'.$ifView), 
            ), 

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'land_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'land_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_STATION_1'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'land_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'LAND_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'land_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'land_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'LAND_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'land_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'LAND_BUSWALK_MINUTES_1'}"),'分'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'land_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_STATION_2'}")),
                
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'land_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'LAND_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'land_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_BUS_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'land_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'LAND_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'land_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'LAND_BUSWALK_MINUTES_2'}"),'分'),
            ),
#
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"価格: "), 
                $q->td($q->textfield(-name=>'land_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_PRICE'}"),'万円')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"坪単価: "), 
                $q->td($q->textfield(-name=>'land_tubotanka', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_TUBOTANKA'}"),'円')
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"面積(平米): "), 
                $q->td($q->textfield(-name=>'land_square_m', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_SQUARE_M'}"),'m&sup2')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"面積補足: "), 
                $q->td($q->textfield(-name=>'land_square_text', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_SQUARE_TEXT'}"),'(実測・公簿...)')
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"面積(坪): "), 
                $q->td($q->textfield(-name=>'land_square_t', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_SQUARE_T'}"),'坪')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"接道状況: "), 
                $q->td($q->textfield(-name=>'land_setudou', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_SETUDOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"土地権利: "), 
                $q->td($q->textfield(-name=>'land_kenri', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_KENRI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"セットバック: "), 
                $q->td($q->textfield(-name=>'land_setback', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_SETBACK'}"))
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"私道負担面積: "), 
                $q->td($q->textfield(-name=>'land_sidoufutan_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_SIDOUFUTAN_SQUARE'}"),'m&sup2')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地目: "), 
                $q->td($q->textfield(-name=>'land_timoku', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_TIMOKU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地勢: "), 
                $q->td($q->textfield(-name=>'land_tisei', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_TISEI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"建蔽率: "), 
                $q->td($q->textfield(-name=>'land_kenpeiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_KENPEIRITU'}"),'%')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"容積率: "), 
                $q->td($q->textfield(-name=>'land_yousekiritu', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_YOUSEKIRITU'}"),'%')
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"用途地域: "), 
                $q->td($q->textfield(-name=>'land_youtotiiki', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_YOUTOTIIKI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"都市計画: "), 
                $q->td($q->textfield(-name=>'land_tosikeikaku', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_TOSIKEIKAKU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"国土法届出: "), 
                $q->td($q->textfield(-name=>'land_kokudohoutodokede', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_KOKUDOHOUTODOKEDE'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡条件: "), 
                $q->td($q->textfield(-name=>'land_jyouken', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_JYOUKEN'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(    
                            $q->th('位置'),
                            $q->td(
                                $q->checkbox(-name=>'land_options_kakuti', -label=>'角地', -checked=>"$$ref_hash{'LAND_OPTIONS_KAKUTI'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        ),
                        $q->Tr(
                            $q->th('設備'),
                            $q->td({-colspan=>4},
                                'ガス:',$q->radio_group(-name=>'land_options_gus',
                                        -default=>"$$ref_hash{'LAND_OPTIONS_GUS'}",
                                        -values=>['1','2','3','4','5'],
                                        -labels=>{'1'=>'都市ガス','2'=>'個別プロパンガス','3'=>'集中プロパンガス','4'=>'その他','5'=>'無し'})
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td({-colspan=>4},
                                '水道:',$q->radio_group(-name=>'land_options_suidou',
                                        -default=>"$$ref_hash{'LAND_OPTIONS_SUIDOU'}",
                                        -values=>['1','2','3','4'],
                                        -labels=>{'1'=>'公営水道','2'=>'私営水道','3'=>'その他','4'=>'無し'})
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td({-colspan=>4},
                                '汚水:',$q->radio_group(-name=>'land_options_osui',
                                        -default=>"$$ref_hash{'LAND_OPTIONS_OSUI'}",
                                        -values=>['1','2','3','4','5'],
                                        -labels=>{'1'=>'本下水','2'=>'集中浄化槽','3'=>'個別浄化槽','4'=>'その他','5'=>'無し'})
                            )
                        ),
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td({-colspan=>4},
                                '雑排水:',$q->radio_group(-name=>'land_options_haisui',
                                        -default=>"$$ref_hash{'LAND_OPTIONS_HAISUI'}",
                                        -values=>['1','2','3','4','5'],
                                        -labels=>{'1'=>'本下水','2'=>'側溝等','3'=>'浸透','4'=>'その他','5'=>'無し'})
                            )
                        )
                    )
                )
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"その他設備: "), 
                $q->td($q->textarea(-name=>'land_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'LAND_SETUBI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'land_bikou', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'LAND_BIKOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"引渡日: "), 
                $q->td($q->textfield(-name=>'land_hikiwatasi', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'LAND_HIKIWATASI'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"現況: "), 
                $q->td($q->textfield(-name=>'land_genkyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_GENKYOU'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'land_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_TORIHIKITAIYOU'}"))
            ),



            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'land_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'LAND_YOUR_ID'}")),
                
            ),


            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'land_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$$ref_hash{'LAND_ADS_TEXT'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真１: "), 
                $q->td($q->filefield(-name=>'land_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>"$$ref_hash{'LAND_PICS_OUTSIDE'}"),
                    '<br />',
                    "$ifPicsOutside",
                    $q->hidden(-name => '_land_pics_outside', -value => "$$ref_hash{'LAND_PICS_OUTSIDE'}"),
                    $q->hidden(-name => '_land_pics_outside_thumb', -value => "$$ref_hash{'LAND_PICS_OUTSIDE_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"写真２: "), 
                $q->td($q->filefield(-name=>'land_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>"$$ref_hash{'LAND_PICS_INSIDE'}"),
                    '<br />',
                    "$ifPicsInside",
                    $q->hidden(-name => '_land_pics_inside', -value => "$$ref_hash{'LAND_PICS_INSIDE'}"),
                    $q->hidden(-name => '_land_pics_inside_thumb', -value => "$$ref_hash{'LAND_PICS_INSIDE_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'land_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$$ref_hash{'LAND_PICS_TIZU'}"),
                    '<br />',
                    "$ifPicsTizu",
                    $q->hidden(-name => '_land_pics_tizu', -value => "$$ref_hash{'LAND_PICS_TIZU'}"),
                    $q->hidden(-name => '_land_pics_tizu_thumb', -value => "$$ref_hash{'LAND_PICS_TIZU_THUMB'}"))
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL: "), 
                $q->td($q->textfield(-name=>'land_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_MOVIE_FILE_URL'}")),
            ),

#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"物元会社情報:<br />会社名:<br />電話番号:"), 
#                $q->td(
#                    $q->checkbox(-name=>'land_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'LAND_TASYAKANRI'}"),
#                    $q->br,
#                    $q->textfield(-name=>'land_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'land_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'LAND_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"物元会社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'land_tasyakanri',-label=>'他社管理', -checked=>"$$ref_hash{'LAND_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('会社名:'),
                            $q->td(
                    $q->textfield(-name=>'land_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'LAND_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                    $q->textfield(-name=>'land_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'LAND_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),


            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'land_ryuutuu',-label=>'流通可', -checked=>"$$ref_hash{'LAND_RYUUTUU'}"),
            #    ),
            #),


            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_edit'),
                    $q->hidden(-name => '_type', -value => 'bl'),
                    $q->hidden(-name => '_object_id', -value => "$$ref_hash{'LAND_ID'}"),
                    $q->hidden(-name => 'land_created', -value => "$$ref_hash{'LAND_CREATED'}"),
                    $q->hidden(-name => 'add_to_special', -value => "$$ref_hash{'LAND_IS_SPECIAL'}"),
                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加', -checked=>"$self->{_ref_hash}{'LAND_IS_SPECIAL'}"),
                    '&nbsp;',
                    $q->checkbox(-name=>'land_publish', -label=>'公開する', -checked=>"$$ref_hash{'LAND_PUBLISHED'}"),
                    $q->submit(-name => 'edit_object' ,-value => '編集更新', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.land.land_location.focus(); \n// --></script>";
    return $output;
}

sub update_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();
    #my $image = Image::Magick->new;
    #todo check each item
    unless ($$ref_hash{'LAND_ID'}=~ /[0-9]{6,10}/){$result .= 'IDの形式が不正です。<br />';}

    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'LAND_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $result = "<div class=\"warning\"><p>他のユーザーの物件は更新できません。更新されませんでした。</p></div>";
                return $result;
            }
        }
    }

    if (!$$ref_hash{'LAND_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_PRICE'}) {$result .= '価格が入力されていません。<br />';}
    #if (!$$ref_hash{'LAND_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}

    if (!$$ref_hash{'LAND_TUBOTANKA'}) {$result .= '坪単価が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_SQUARE_M'}) {$result .= '面積(平米)が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_SQUARE_T'}) {$result .= '面積(坪)が入力されていません。<br />';}

    if (!$$ref_hash{'LAND_KENRI'}) {$result .= '土地権利が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_KENPEIRITU'}) {$result .= '建蔽率が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_YOUSEKIRITU'}) {$result .= '容積率が入力されていません。<br />';}
    if (!$$ref_hash{'LAND_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'LAND_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_SIDOUFUTAN_SQUARE'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        #要望により
        #$result .= '私道負担面積の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if (!($$ref_hash{'LAND_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'LAND_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）2の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    if ($$ref_hash{'LAND_PRICE'}) {
        my $str = $$ref_hash{'LAND_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{1,80}))$/){

        }else{
            $result .= '価格の値が不自然です。半角数字であるか確認してください。<br />';
        }
    }

    if ($$ref_hash{'LAND_SQUARE'}){
        unless($$ref_hash{'LAND_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
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


    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'bl' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('land_pics_outside')){
        my $fh = $q->upload('land_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'LAND_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'LAND_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('land_pics_inside')){
        my $fh = $q->upload('land_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'LAND_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'LAND_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('land_pics_tizu')){
        my $fh = $q->upload('land_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'LAND_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'LAND_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />更新されませんでした。</p></div>";
    }else{
        $$ref_hash{'LAND_LAST_UPDATED'} =REPS::Util->get_datetime_now();
        my %land;
        my $db_b_land_path = $self->{_app}->param('db_b_land_path');
        tie (%land, 'MLDBM', $db_b_land_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        
        if (!$land{$$ref_hash{'LAND_ID'}}){
            $result = "<div class=\"warning\"><p>別のユーザー又は別の画面で削除された可能性があります。<br />更新されませんでした。</p></div>";
            return $result;
        }
#        if ($land{$$ref_hash{'LAND_ID'}}{'LAND_USER_ID'} eq $self->{_app}->param('user_id')){
        if ($self->{_app}->param('user_isAdmin') != 1){
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($land{$$ref_hash{'LAND_ID'}}{'LAND_USER_ID'} ne $self->{_app}->param('user_id')){
                    $result = "<div class=\"warning\"><p>他のユーザーの物件は更新出来ません。 </p></div>";
                    untie %land;
                    return $result;
                }
            }
        }
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
        my $num_keys = REPS::Util->de_taint($$ref_hash{'LAND_ID'});

        eval {
            if ($q->param('land_pics_outside')){
                my $tmp = $$ref_hash{'LAND_PICS_OUTSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_OUTSIDE'},$dir.$tmp);
                $$ref_hash{'LAND_PICS_OUTSIDE'} = 'bl' . '/'.$tmp;
                if ($$ref_hash{'LAND_PICS_OUTSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'LAND_PICS_OUTSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'LAND_PICS_OUTSIDE_THUMB'} = 'bl' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('land_pics_inside')){
                my $tmp = $$ref_hash{'LAND_PICS_INSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_INSIDE'},$dir.$tmp);
                $$ref_hash{'LAND_PICS_INSIDE'} = 'bl' . '/'.$tmp;
                if ($$ref_hash{'LAND_PICS_INSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'LAND_PICS_INSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_INSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'LAND_PICS_INSIDE_THUMB'} = 'bl' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        eval {
            if ($q->param('land_pics_tizu')){
                my $tmp = $$ref_hash{'LAND_PICS_TIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_TIZU'},$dir.$tmp);
                $$ref_hash{'LAND_PICS_TIZU'} = 'bl' . '/'.$tmp;
                if ($$ref_hash{'LAND_PICS_TIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'LAND_PICS_TIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'LAND_PICS_TIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'LAND_PICS_TIZU_THUMB'} = 'bl' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        if (!$land{$$ref_hash{'LAND_ID'}}{'LAND_USER_ID'}){
            $$ref_hash{'LAND_USER_ID'} = $self->{_app}->param('user_id');
        }else{
            $$ref_hash{'LAND_USER_ID'} = $land{$$ref_hash{'LAND_ID'}}{'LAND_USER_ID'};
        }

        $land{$$ref_hash{'LAND_ID'}} = $ref_hash;

        untie %land;

        #update recommend
        if ($$ref_hash{'LAND_IS_SPECIAL'}) {
            $self->{_app}->recommend_static_write_file();
        }

#         my %hash_sp=(
#                 'BS_ID' => $$ref_hash{'LAND_ID'},
#                 'BS_NAME' => '',
#                 'BS_STATION_1' => $$ref_hash{'LAND_STATION_1'},
#                 'BS_STATION_2' => $$ref_hash{'LAND_STATION_2'},
#                 'BS_LOCATION' =>$$ref_hash{'LAND_LOCATION'},
#                 'BS_PRICE' => REPS::Util->insert_comma($$ref_hash{'LAND_PRICE'}),
#                 'BS_BUS_MINUTES_1' => $$ref_hash{'LAND_BUS_MINUTES_1'},
#                 'BS_WALK_MINUTES_1' => $$ref_hash{'LAND_WALK_MINUTES_1'},
#                 'BS_SQUARE' => $$ref_hash{'LAND_SQUARE_M'},
# 
#                 'BS_MADORI' => $$ref_hash{'LAND_MADORI'},
#                 'BS_PICS_OUTSIDE_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_OUTSIDE_THUMB'},
#                 'BS_PICS_MADORIZU_THUMB' => $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'LAND_PICS_MADORIZU_THUMB'},
#                 'BS_ADS_TEXT' => $$ref_hash{'LAND_ADS_TEXT'}
#         );
#         $hash_sp{'BS_KIND'}='土地';
#         $hash_sp{'_type'}='bl';

#         if ($q->param('add_to_special')){
#             if ($$ref_hash{'LAND_PUBLISHED'}){
#                 #Special
#     
#                 my $special = REPS::Special::Special->new(
#                                 $self->{_app},
#                                 $self->{_app}->param('db_bs_special_path'),
#                                 'BL'.$$ref_hash{'LAND_ID'},
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
#                                 'BL'.$$ref_hash{'LAND_ID'}
#                             );
#                 $special->delete_Realestate('BL'.$$ref_hash{'LAND_ID'});
#         }
#         #add to updates
#         if ($$ref_hash{'LAND_PUBLISHED'}){
#             if (!$$ref_hash{'LAND_LAST_UPDATED'}){
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'LAND_CREATED'};
#             }else{
#                 $hash_sp{'LAST_UPDATED'} = $$ref_hash{'LAND_LAST_UPDATED'};
#             }
#             my $updates = REPS::Updates::Updates->new(
#                             $self->{_app},
#                             $self->{_app}->param('db_bs_updates_path'),
#                             'BL'.$$ref_hash{'LAND_ID'},
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
    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');

    tie (%land, 'MLDBM', $db_b_land_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $land{$_}){
                if (defined $land{$_} && ($land{$_})){
                    #my $ref_hash = $land{$_};
                    #my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($land{$_}{'LAND_USER_ID'} eq $self->{_app}->param('user_id')) {
                                undef $land{$_};
                            } else {
    #                            delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            undef $land{$_};
                        }
                    }else{
                        undef $land{$_};
                    }
#                    if ($hash{'LAND_USER_ID'} eq $self->{_app}->param('user_id')){
                        #delete $land{$_};
#                        $land{$_} = undef;
#                    }
                }
            }

        }
    }
    untie %land;

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
#     $special->delete_Realestate((map {"BL". $_ } @to_be_deleted));
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_updates_path')
#                 );
# 
#     $updates->delete_Realestate((map {"BL". $_ } @to_be_deleted));
    #
#check and make sure it is owned by the user LAND_USER_ID

    return 1;
}

sub dup_Realestate{
    my $self = shift;
    my @to_be_duped = @_;
    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');

    require REPS::Util;
    use File::Copy;
    use File::Basename;
    my $res_dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory'));

    tie (%land, 'MLDBM', $db_b_land_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_duped){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $land{$_}){
                if (defined $land{$_} && ($land{$_})){
                #    
                #    $apart{$_} = \%hash;
                    my $num_keys = scalar keys (%land);
                    $num_keys = sprintf('%06d', $num_keys++);
                    if (exists $land{$num_keys}){
                        #count up and add again. This could happen when export and import data.
                        while (exists $land{$num_keys}) {
                            $num_keys++;
                            if ($num_keys >= 999999) {die "Reached lmit.";}
                        }
                    }
                    my %hash = %{$land{$_}};
                    #物件IDをつける
                    $hash{'LAND_ID'} = $num_keys;
                    #部屋番号を空にする。
                    #$hash{'LAND_ROOM_NUMBER'} = '';

                    $hash{'LAND_CREATED'} = REPS::Util->get_datetime_now();
                    $hash{'LAND_LAST_UPDATED'} = '';

                    if ($hash{'LAND_PICS_OUTSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'LAND_PICS_OUTSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'LAND_PICS_OUTSIDE'}, $res_dir.'bl/'.$num_keys.'_a'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'LAND_PICS_OUTSIDE'} = 'bl/'.$num_keys.'_a'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'LAND_PICS_INSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'LAND_PICS_INSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'LAND_PICS_INSIDE'}, $res_dir.'bl/'.$num_keys.'_b'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'LAND_PICS_INSIDE'} = 'bl/'.$num_keys.'_b'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'LAND_PICS_TIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'LAND_PICS_TIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'LAND_PICS_TIZU'}, $res_dir.'bl/'.$num_keys.'_d'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'LAND_PICS_TIZU'} = 'bl/'.$num_keys.'_d'.$ext;
                        };
                        if ($@){die $@;}
                    }

                    if ($hash{'LAND_PICS_OUTSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'LAND_PICS_OUTSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'LAND_PICS_OUTSIDE_THUMB'}, $res_dir.'bl/'.$num_keys.'_a_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'LAND_PICS_OUTSIDE_THUMB'} = 'bl/'.$num_keys.'_a_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'LAND_PICS_INSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'LAND_PICS_INSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'LAND_PICS_INSIDE_THUMB'}, $res_dir.'bl/'.$num_keys.'_b_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'LAND_PICS_INSIDE_THUMB'} = 'bl/'.$num_keys.'_b_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'LAND_PICS_TIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'LAND_PICS_TIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'LAND_PICS_TIZU_THUMB'}, $res_dir.'bl/'.$num_keys.'_d_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'LAND_PICS_TIZU_THUMB'} = 'bl/'.$num_keys.'_d_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }


                    #$apart{$num_keys} = $apart{$_};
                    $land{$num_keys} = \%hash;
                }
            }
        }
    }
    untie %land;

    return 1;
}

sub toggle_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');

    tie (%land, 'MLDBM', $db_b_land_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $land{$_}){
                if (defined $land{$_} && ($land{$_})){
                    #my $ref_hash = $land{$_};
                    #my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($land{$_}{'LAND_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$land{$_}};
                                if ($boolean){
                                    $hash{'LAND_PUBLISHED'}='On';
                                    $hash{'LAND_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                                }else{
                                    $hash{'LAND_PUBLISHED'}='';
                                }
                                $land{$_} = \%hash;
                            } else {
    #                            delete $_ from @to_be_deleted
                                #delete dupe later
                                #push @to_be_deleted ,$_;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$land{$_}};
                            if ($boolean){
                                $hash{'LAND_PUBLISHED'}='On';
                                $hash{'LAND_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                            }else{
                                $hash{'LAND_PUBLISHED'}='';
                            }
                            $land{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$land{$_}};
                        if ($boolean){
                            $hash{'LAND_PUBLISHED'}='On';
                            $hash{'LAND_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                        }else{
                            $hash{'LAND_PUBLISHED'}='';
                        }
                        $land{$_} = \%hash;
                    }
#                    if ($hash{'LAND_USER_ID'} eq $self->{_app}->param('user_id')){
                        #delete $land{$_};
#                        $land{$_} = undef;
#                    }
                }
            }

        }
    }
    untie %land;

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
#     $special->delete_Realestate((map {"BL". $_ } @to_be_deleted));
#     #
#     my $updates = REPS::Updates::Updates->new(
#                     $self->{_app},
#                     $self->{_app}->param('db_bs_updates_path')
#                 );
# 
#     $updates->delete_Realestate((map {"BL". $_ } @to_be_deleted));
    #
#check and make sure it is owned by the user LAND_USER_ID

    return 1;
}

sub special_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');

    tie (%land, 'MLDBM', $db_b_land_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_deleted){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $land{$_}){
                if (defined $land{$_} && ($land{$_})){
                    #my $ref_hash = $land{$_};
                    #my %hash = %$ref_hash;
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($land{$_}{'LAND_USER_ID'} eq $self->{_app}->param('user_id')) {
                                my %hash = ();
                                %hash = %{$land{$_}};
                                if ($boolean){
                                    $hash{'LAND_IS_SPECIAL'}='On';
                                }else{
                                    $hash{'LAND_IS_SPECIAL'}='';
                                }
                                $land{$_} = \%hash;

                            }
                        }else{
                            my %hash = ();
                            %hash = %{$land{$_}};
                            if ($boolean){
                                $hash{'LAND_IS_SPECIAL'}='On';
                            }else{
                                $hash{'LAND_IS_SPECIAL'}='';
                            }
                            $land{$_} = \%hash;
                        }
                    }else{
                        my %hash = ();
                        %hash = %{$land{$_}};
                        if ($boolean){
                            $hash{'LAND_IS_SPECIAL'}='On';
                        }else{
                            $hash{'LAND_IS_SPECIAL'}='';
                        }
                        $land{$_} = \%hash;
                    }
                }
            }

        }
    }
    untie %land;
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
    my $c;
    my %land;
    my $db_b_land_path = $self->{_app}->param('db_b_land_path');
    if (-f $db_b_land_path){
        tie (%land, 'MLDBM', $db_b_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        while ( ($key, $value) = each(%land) ) {
    
            if ((defined $land{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'LAND_USER_ID'}){
                    #match?
                    $match = 0;
    
                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($tmp{'LAND_USER_ID'} ne $self->{_app}->param('user_id')) {
                            next;
                        }
                    }
    
#                    if ($q->param("land_jisyakannri")){ #自社管理指定
#    #                    if ($tmp{'LAND_USER_ID'} eq $self->{_app}->param('user_id')){
#                        #自社登録物件
#                            if ($tmp{'LAND_TASYAKANRI'}){
#                                #他社管理物件
#                                next;
#                            }else{
#                                $match = 1;
#                            }
#    #                    }else{
#    #                        next;
#    #                    }
#                    }
                    if ($q->param("land_jisyakannri") > 0){
                        if ($q->param("land_jisyakannri") == 1) {
                            if (!$tmp{'LAND_TASYAKANRI'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_jisyakannri") == 2){
                            if ($tmp{'LAND_TASYAKANRI'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }
    
    
#                    if ($q->param("land_jisyatouroku")){
#                        if ($tmp{'LAND_USER_ID'} ne $self->{_app}->param('user_id')){
#                            next;
#                        }else{$match = 1;}
#                    }else{
#                        $match = 1;
#                    }
                    if ($q->param("land_jisyatouroku") > 0){
                        if ($q->param("land_jisyatouroku") == 1) {
                            if ($tmp{'LAND_USER_ID'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_jisyatouroku") == 2){
                            if (!$tmp{'LAND_USER_ID'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }
    
#                    if ($q->param("land_public")){
#                        if ($tmp{'LAND_PUBLISHED'}){
#                            $match = 1;
#                        }else{
#                            next;
#                        }
#                    }else{
#                        $match = 1;
#                    }

                    if ($q->param("land_public") > 0){
                        if ($q->param("land_public") == 1) {
                            if ($tmp{'LAND_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_public") == 2){
                            if (!$tmp{'LAND_PUBLISHED'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }


                    if ($q->param("land_recommend") > 0){
                        if ($q->param("land_recommend") == 1) {
                            if ($tmp{'LAND_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("land_recommend") == 2){
                            if (!$tmp{'LAND_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
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
    
                    
    
                    
                    if ($q->param("land_address")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("land_address")));
                        if (REPS::Util->str_match($tmp{'LAND_LOCATION'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
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
    
    
                    if ($q->param("land_station")){
                        my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("land_station")));
                        if (REPS::Util->str_match($tmp{'LAND_STATION_1'},$search_by_key)){
                            $match = 1;
                        }elsif(REPS::Util->str_match($tmp{'LAND_STATION_2'},$search_by_key)){
                            $match = 1;
                        }else{next;}
                    }
    
    
                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'station') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'LAND_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'LAND_LAST_UPDATED'}&&($tmp{'LAND_LAST_UPDATED'}))){
                                    $sort_hash{$key} = $tmp{'LAND_LAST_UPDATED'};
                                }else{
                                    $sort_hash{$key} = $tmp{'LAND_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'LAND_LOCATION'};
                            }elsif(($sort_by eq 'station')){
                                $sort_hash{$key} = $tmp{'LAND_STATION_1'};
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
    
            $c = @sort_keys;
    
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
                my $ref_hash = $land{$_};
                my %tmp = %$ref_hash;
    
                my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'LAND_CREATED'});
                my $new = '';
                if ($dd <= 30) {
                    $new = 'ON';
                }
                my $updated = '';
                if ((!$new) && ($tmp{'LAND_LAST_UPDATED'})){
                    $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'LAND_LAST_UPDATED'});
                    if ($dd <= 10) {
                        $updated = 'ON';
                    }
                }
                my %hash = (
                    'LAND_ID' => "$_",
                    'LAND_PUBLISHED' => $tmp{'LAND_PUBLISHED'},
                    'LAND_IS_SPECIAL' => $tmp{'LAND_IS_SPECIAL'},
                    'LAND_STATION_1' => $tmp{'LAND_STATION_1'},
                    'LAND_STATION_2' => $tmp{'LAND_STATION_2'},
                    'LAND_LOCATION' => $tmp{'LAND_LOCATION'},
                    'LAND_PRICE' => REPS::Util->insert_comma($tmp{'LAND_PRICE'}),
                    'LAND_NEW' => $new,
                    'LAND_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    'LAND_CREATED' => REPS::Util->get_date_as_string($tmp{'LAND_CREATED'}),
                    'LAND_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'LAND_LAST_UPDATED'}),
                    '_type' => 'bl'
                );
        
                push(@loop_data, \%hash);
            }
    #    }
    
        untie %land;
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
    my %land;
    my $db_land_path = $self->{_app}->param('db_b_land_path');
    my ($key, $value);
    my @loop_data=();
    #my %hash;

    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');

    if (-f $db_land_path){
        tie (%land, 'MLDBM', $db_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;

        while ( ($key, $value) = each(%land) ) {
            if ((exists $land{$key}) && (defined $land{$key}) && ($value)){

                 if (($$value{'LAND_PUBLISHED'}) && ($$value{'LAND_IS_SPECIAL'})){
                    push(@loop_data, $key);
                    if ($limit < scalar(@loop_data)){last;}
                 }

            }
        }
        untie %land;

    }
    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');
    if (($limit) && ($limit>0)){
        @loop_data = @loop_data[0..$limit-1];
    }
    require REPS::Search::Realestate::B_Land;
    my $Realestate = REPS::Search::Realestate::B_Land->new($self->{_app});
    my $ref_loop = $Realestate->get_Detail_List(@loop_data);

    return $ref_loop;
}

sub get_Count{
    my $self = shift;
    my %land;
    my $db_land_path = $self->{_app}->param('db_b_land_path');
    my ($key, $value);
    my %hash;
    if (-f $db_land_path){
        tie (%land, 'MLDBM', $db_land_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        my $n=0;# = keys( %apart );
        my $p=0;
        my $l=0;
        my $t;
        while ( ($key, $value) = each(%land) ) {
            if ((exists $land{$key}) && (defined $land{$key}) && ($value)){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($$value{'LAND_USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }
    
                if (exists $$value{'LAND_PUBLISHED'}){
                    if ($$value{'LAND_PUBLISHED'}){
                        $p++;
                    }else{
                        $n++;
                    }
                }
        
                if ((defined $$value{'LAND_LAST_UPDATED'}&&($$value{'LAND_LAST_UPDATED'}))){
                    $t=$$value{'LAND_LAST_UPDATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'LAND_LAST_UPDATED'};
                    }
        
                }else{
                    $t=$$value{'LAND_CREATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'LAND_CREATED'};
                    }
                }
            }
        }
        untie %land;
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
    my $db_access_path = $self->{_app}->param('db_b_land_access_path');
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
#        while ( ($key, $value) = each(%access) ) {
#            $n = $n+$value;
#        }
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
    my $db_inquiry_path = $self->{_app}->param('db_b_land_inquiry_path');
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
#        while ( ($key, $value) = each(%inquiry) ) {
#            $n = $n+$value;
#        }
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
    my $feed_title = '売買土地物件情報';
    $feed->title($UJ->set($feed_title,'euc')->utf8);
    # subtitle
    my $feed_subtitle = $$settings_info{'COMPANY_NAME'} . 'が配信する最新の売買土地物件情報です';
    $feed->subtitle($UJ->set($feed_subtitle,'euc')->utf8);

    #create self link
    my $feed_link = XML::Atom::Syndication::Link->new();
    $feed_link->href($self->{_app}->cfg('site_url').'bl-atom.xml');
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
    $feed->id($self->{_app}->cfg('cgi_url').'bl');

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


    my %land;
    my $db_path = $self->{_app}->param('db_b_land_path');
    if (-e $db_path){
        tie (%land, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'write') or Carp::croak ("$! $db_path");#
        while ( ($key, $value) = each(%land) ) {
            if ($i > 15){last;}
            if ((defined $land{$key}) && ($value)){
                if ($$value{'LAND_PUBLISHED'}){
                    $i++;
                    if ((defined $$value{'LAND_LAST_UPDATED'}&&($$value{'LAND_LAST_UPDATED'}))){
                        $sort_hash{$key} = $$value{'LAND_LAST_UPDATED'};
                    }else{
                        $sort_hash{$key} = $$value{'LAND_CREATED'};
                    }
                }
            }
        }

        #sort by update
        my @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
        @sort_keys = reverse @sort_keys;
        if (@sort_keys > 0){
            if ($land{$sort_keys[0]}{'LAND_LAST_UPDATED'}. '+09:00'){
                $feed->updated($land{$sort_keys[0]}{'LAND_LAST_UPDATED'}. '+09:00');
            }else{
                $feed->updated($land{$sort_keys[0]}{'LAND_CREATED'}. '+09:00');
            }
        }else{
            $feed->updated(REPS::Util->get_datetime_now . '+09:00');
        }
        #for each
        foreach (@sort_keys){
            my $entry = XML::Atom::Syndication::Entry->new;
#TODO: create better id for entry.
            $entry->id($self->{_app}->cfg('cgi_url').'bl/'.$land{$_}{'LAND_ID'});

            #title

            my $land_price = REPS::Util->insert_comma($land{$_}{'LAND_PRICE'});
            my $entry_title = "[土地][$land_price万円]";
            $entry->title($UJ->set($entry_title,'euc')->utf8);

            #create a link
            my $entry_link = XML::Atom::Syndication::Link->new();
            $entry_link->href($self->{_app}->cfg('cgi_url').'search.cgi?_mode=mode_detail&_type=bl&_object_id='.$land{$_}{'LAND_ID'});
            $entry_link->rel('alternate');
            $entry_link->type('text/html');
            #set a feed link
            $entry->link($entry_link);
            #updated
            if ($land{$_}{'LAND_LAST_UPDATED'}){
                $entry->updated($land{$_}{'LAND_LAST_UPDATED'} . '+09:00');
                $entry->published($land{$_}{'LAND_CREATED'}. '+09:00');
            }else{
                $entry->updated($land{$_}{'LAND_CREATED'}. '+09:00');
            }
            #author
            my $entry_author = XML::Atom::Syndication::Person->new(Name=>'author');
            $entry_author->name($land{$_}{'LAND_USER_ID'});
            $entry->author($entry_author);

            my $land_picture_1='';
            if ($land{$_}{'LAND_PICS_OUTSIDE'}){
                $land_picture_1 = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$land{$_}{'LAND_PICS_OUTSIDE_THUMB'};
                $land_picture_1 = '<img src="'.$land_picture_1.'" class="outside" />';
            }
            my $land_picture_2='';
            if ($land{$_}{'LAND_PICS_INSIDE'}){
                $land_picture_2 = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$land{$_}{'LAND_PICS_INSIDE_THUMB'};
                $land_picture_2 = '<img src="'.$land_picture_2.'" class="outside" />';
            }

            #my $entry_category = XML::Atom::Syndication::Category->new();
            #$entry_category->term($UJ->set($land_kind,'euc')->utf8);
            #$entry->category($entry_category);
#TODO: How to add more than one category?

my $entry_content = <<"_HTML_";
<div class="rl">
    <h4><span="tagline">$land{$_}{LAND_ADS_TEXT}</span></h4>
    <ul>
        <li>価格：<span class="price">$land_price<span class="unit">万円</span></span></li>
        <li>所在地：<span class="location">$land{$_}{LAND_LOCATION}</span></li>
        <li>最寄駅：<span class="station">$land{$_}{LAND_STATION_1}</span></li>
    </ul>
    <div class="picture">
        <span class="outside">$land_picture_1</span>
        <span class="outside">$land_picture_2</span>
    </div>
</div>
_HTML_

            my $content = XML::Atom::Syndication::Content->new($UJ->set($entry_content,'euc')->utf8);
            $content->type('html');
            $entry->content($content);
            $feed->add_entry($entry);

        }
        untie %land;

        my $output = $feed->as_xml;
        my $file = $self->{_app}->cfg('site_path').'bl-atom.xml';

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
