package REPS::CMS::Realestate::R_Business;

use strict;
use base qw( REPS::CMS::Realestate );

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
#            'BUSINESS_TUBOTANKA' => '',

            'BUSINESS_PRICE_KANRIHI' => '',
            'BUSINESS_PRICE_SIKIKIN' => '',
            'BUSINESS_PRICE_SIKIKIN_UNIT' => $app->param('user_pref_price_sikikin_unit'),
            'BUSINESS_PRICE_REIKIN' => '',
            'BUSINESS_PRICE_REIKIN_UNIT' => $app->param('user_pref_price_reikin_unit'),
            'BUSINESS_PRICE_HOSYOUKIN' => '',
            'BUSINESS_PRICE_SYOUKYAKU' => '',
            'BUSINESS_PRICE_SIKIBIKI' => '',
            'BUSINESS_PRICE_OTHER' => '',
            'BUSINESS_INSURANCE' => '',
            #'BUSINESS_CHUUTOKAIYAKU' => '',
            'BUSINESS_TOTI_SQUARE' => '',
            'BUSINESS_SENYUU_SQUARE' => '',
            'BUSINESS_KIND' => '',
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
            'BUSINESS_BIKOU' => '',
            'BUSINESS_TASYAKANRI' => '',
            'BUSINESS_RYUUTUU' => '',
            'BUSINESS_KANRIKAISYA' => '',
            'BUSINESS_KANRIKAISYA_CONTACT' => '',
            'BUSINESS_USER_ID' => $app->param('user_id'),,
            'BUSINESS_CREATED' => '',
            'BUSINESS_LAST_UPDATED' => ''
            }


        };
    return bless $self,$class;
}

sub set_Query {
    my $self = shift;
    my $q = $self->{_app}->query();
    
    $self->{_ref_hash}{'BUSINESS_ID'} =  $q->param('_object_id') if $q->param('_object_id');
    $self->{_ref_hash}{'BUSINESS_PUBLISHED'} = $q->param('business_publish') if $q->param('business_publish');
    $self->{_ref_hash}{'BUSINESS_IS_SPECIAL'} = $q->param('add_to_special') if $q->param('add_to_special');

    $self->{_ref_hash}{'BUSINESS_NAME'} = REPS::Util->trim($q->param('business_name')) if $q->param('business_name');
    $self->{_ref_hash}{'BUSINESS_LOCATION'} =  $q->param('business_location') if $q->param('business_location');
    $self->{_ref_hash}{'BUSINESS_STATION_1'} =  $q->param('business_station1') if $q->param('business_station1');
    $self->{_ref_hash}{'BUSINESS_BUS_1'} =  $q->param('business_bus') if $q->param('business_bus');
    $self->{_ref_hash}{'BUSINESS_WALK_MINUTES_1'} =  $q->param('business_walk_minutes') if $q->param('business_walk_minutes');
    $self->{_ref_hash}{'BUSINESS_BUS_MINUTES_1'} =  $q->param('business_bus_minutes') if  $q->param('business_bus_minutes');
    $self->{_ref_hash}{'BUSINESS_BUSWALK_MINUTES_1'} =  $q->param('business_buswalk_minutes') if $q->param('business_buswalk_minutes');
    $self->{_ref_hash}{'BUSINESS_STATION_2'} =  $q->param('business_station2') if $q->param('business_station2');
    $self->{_ref_hash}{'BUSINESS_BUS_2'} =  $q->param('business_bus2') if $q->param('business_bus2');
    $self->{_ref_hash}{'BUSINESS_WALK_MINUTES_2'} =  $q->param('business_walk_minutes2') if $q->param('business_walk_minutes2');
    $self->{_ref_hash}{'BUSINESS_BUS_MINUTES_2'} =  $q->param('business_bus_minutes2') if $q->param('business_bus_minutes2');
    $self->{_ref_hash}{'BUSINESS_BUSWALK_MINUTES_2'} =  $q->param('business_buswalk_minutes2') if $q->param('business_buswalk_minutes2');
    $self->{_ref_hash}{'BUSINESS_PRICE'} =  $q->param('business_price') if $q->param('business_price');
    $self->{_ref_hash}{'BUSINESS_TUBOTANKA'} =  $q->param('business_tubotanka') if $q->param('business_tubotanka');

    $self->{_ref_hash}{'BUSINESS_PRICE_KANRIHI'} =  $q->param('business_price_kanrihi') if $q->param('business_price_kanrihi');
    $self->{_ref_hash}{'BUSINESS_PRICE_SIKIKIN'} =  $q->param('business_price_sikikin') if $q->param('business_price_sikikin');
    $self->{_ref_hash}{'BUSINESS_PRICE_REIKIN'} =  $q->param('business_price_reikin') if $q->param('business_price_reikin');
    $self->{_ref_hash}{'BUSINESS_PRICE_SIKIKIN_UNIT'} =  $q->param('business_price_sikikin_unit') if $q->param('business_price_sikikin_unit');
    $self->{_ref_hash}{'BUSINESS_PRICE_REIKIN_UNIT'} =  $q->param('business_price_reikin_unit') if $q->param('business_price_reikin_unit');

    $self->{_ref_hash}{'BUSINESS_PRICE_HOSYOUKIN'} =  $q->param('business_price_hosyoukin') if $q->param('business_price_hosyoukin');
    $self->{_ref_hash}{'BUSINESS_PRICE_SYOUKYAKU'} =  $q->param('business_price_syoukyaku') if $q->param('business_price_syoukyaku');
    $self->{_ref_hash}{'BUSINESS_PRICE_SIKIBIKI'} =  $q->param('business_price_sikibiki') if $q->param('business_price_sikibiki');
    $self->{_ref_hash}{'BUSINESS_PRICE_OTHER'} =  $q->param('business_price_other') if $q->param('business_price_other');
    $self->{_ref_hash}{'BUSINESS_INSURANCE'} =  $q->param('business_price_insurance') if $q->param('business_price_insurance');
    #$self->{_ref_hash}{'BUSINESS_CHUUTOKAIYAKU'} =  $q->param('business_chuutokaiyaku') if $q->param('business_chuutokaiyaku');
    $self->{_ref_hash}{'BUSINESS_TOTI_SQUARE'} =  $q->param('business_toti_square') if $q->param('business_toti_square');
    $self->{_ref_hash}{'BUSINESS_SENYUU_SQUARE'} =  $q->param('business_senyuu_square') if $q->param('business_senyuu_square');
    $self->{_ref_hash}{'BUSINESS_KIND'} = join (',',$q->param('business_kind')) if $q->param('business_kind');
    $self->{_ref_hash}{'BUSINESS_BUILDING_STRUCTURE'} =  $q->param('business_building_structure') if $q->param('business_building_structure');
    $self->{_ref_hash}{'BUSINESS_STORY'} =  $q->param('business_story') if $q->param('business_story');
    $self->{_ref_hash}{'BUSINESS_FLOOR'} =  $q->param('business_floor') if $q->param('business_floor');
    $self->{_ref_hash}{'BUSINESS_AGE'} =  $q->param('business_age') if $q->param('business_age');
    $self->{_ref_hash}{'BUSINESS_CONDITION'} =  $q->param('business_condition') if $q->param('business_condition');
    $self->{_ref_hash}{'BUSINESS_TORIHIKITAIYOU'} =  $q->param('business_torihikitaiyou') if $q->param('business_torihikitaiyou');
    $self->{_ref_hash}{'BUSINESS_YOUR_ID'} =  $q->param('business_your_id') if $q->param('business_your_id');
    $self->{_ref_hash}{'BUSINESS_OPTIONS_PARKING'} =  $q->param('business_options_parking') if $q->param('business_options_parking');
    $self->{_ref_hash}{'BUSINESS_ADS_TEXT'} =  $q->param('business_ads_text') if $q->param('business_ads_text');
    $self->{_ref_hash}{'BUSINESS_SETUBI'} =  $q->param('business_setubi') if $q->param('business_setubi');
    $self->{_ref_hash}{'BUSINESS_PICS_OUTSIDE'} =  $q->param('_business_pics_outside') if $q->param('_business_pics_outside');
    $self->{_ref_hash}{'BUSINESS_PICS_INSIDE'} =  $q->param('_business_pics_inside') if $q->param('_business_pics_inside');
    $self->{_ref_hash}{'BUSINESS_PICS_MADORIZU'} =  $q->param('_business_pics_madorizu') if $q->param('_business_pics_madorizu');
    $self->{_ref_hash}{'BUSINESS_PICS_TIZU'} =  $q->param('_business_pics_tizu') if $q->param('_business_pics_tizu');
    $self->{_ref_hash}{'BUSINESS_PICS_OUTSIDE_THUMB'} =  $q->param('_business_pics_outside_thumb') if $q->param('_business_pics_outside_thumb');
    $self->{_ref_hash}{'BUSINESS_PICS_INSIDE_THUMB'} =  $q->param('_business_pics_inside_thumb') if $q->param('_business_pics_inside_thumb');
    $self->{_ref_hash}{'BUSINESS_PICS_MADORIZU_THUMB'} =  $q->param('_business_pics_madorizu_thumb') if $q->param('_business_pics_madorizu_thumb');
    $self->{_ref_hash}{'BUSINESS_PICS_TIZU_THUMB'} =  $q->param('_business_pics_tizu_thumb') if $q->param('_business_pics_tizu_thumb');
    $self->{_ref_hash}{'BUSINESS_MOVIE_FILE_URL'} =  $q->param('business_movie_file_url') if $q->param('business_movie_file_url');
    $self->{_ref_hash}{'BUSINESS_BIKOU'} =  $q->param('business_bikou') if $q->param('business_bikou');
    $self->{_ref_hash}{'BUSINESS_TASYAKANRI'} =  $q->param('business_tasyakanri') if $q->param('business_tasyakanri');
    $self->{_ref_hash}{'BUSINESS_RYUUTUU'} =  $q->param('business_ryuutuu') if $q->param('business_ryuutuu');
    $self->{_ref_hash}{'BUSINESS_KANRIKAISYA'} =  $q->param('business_kanrikaisya') if $q->param('business_kanrikaisya');
    $self->{_ref_hash}{'BUSINESS_KANRIKAISYA_CONTACT'} =  $q->param('business_kanrikaisya_contact') if $q->param('business_kanrikaisya_contact');
    $self->{_ref_hash}{'BUSINESS_CREATED'} =  $q->param('business_created') if $q->param('business_created');

    $self->{_app}->convert_hash_charset($self->{_ref_hash});
    REPS::Util->convert_hash_zhk($self->{_ref_hash});
}

sub get_Create_Realestate_Form{
    my $self = shift;
    #my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'business');
    $output .= $q-> table( {-border => 1,class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件名: "), 
                $q->td($q->textfield(-name=>'business_name', -default=>'',-size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_NAME'}")),
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'business_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'business_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_STATION_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'business_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'business_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'business_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'business_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUSWALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'business_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_STATION_2'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'business_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'business_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUS_2'}")),
                

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'business_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'business_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUSWALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-class=>'required'},"物件種目: "),
                $q->td(
                    $q->checkbox_group(-name=>'business_kind', -defaults=>"$self->{_ref_hash}{'BUSINESS_KIND'}",-values=>[1,2,3],-labels=>{'1'=>'店舗','2'=>'事務所','3'=>'他'}),
                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"賃料: "), 
                $q->td($q->textfield(-name=>'business_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE'}"),'円'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"坪単価: "), 
                $q->td($q->textfield(-name=>'business_tubotanka', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_TUBOTANKA'}"),'円'),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理費等: "), 
                $q->td($q->textfield(-name=>'business_price_kanrihi', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_KANRIHI'}"),'円'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"敷金: "), 
                $q->td($q->textfield(-name=>'business_price_sikikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_SIKIKIN'}"),
                        $q->popup_menu(-name=>'business_price_sikikin_unit', 
                            -default=>$self->{_ref_hash}{'BUSINESS_PRICE_SIKIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                    ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"礼金: "), 
                $q->td($q->textfield(-name=>'business_price_reikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_REIKIN'}"),
                        $q->popup_menu(-name=>'business_price_reikin_unit', 
                            -default=>$self->{_ref_hash}{'BUSINESS_PRICE_REIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                    ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"保証金: "), 
                $q->td($q->textfield(-name=>'business_price_hosyoukin', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_HOSYOUKIN'}"),'円'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"償却: "), 
                $q->td($q->textfield(-name=>'business_price_syoukyaku', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_SYOUKYAKU'}"),'(例：解約時、10万円)'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"敷引: "), 
                $q->td($q->textfield(-name=>'business_price_sikibiki', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_SIKIBIKI'}"),'円'),
                
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"中途解約: "), 
            #    $q->td($q->textfield(-name=>'business_chuutokaiyaku', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_CHUUTOKAIYAKU'}"),'ヵ月'),    
            #),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"その他一時金: "), 
                $q->td($q->textfield(-name=>'business_price_other', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PRICE_OTHER'}"),'(ヶ月)'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"保険等: "), 
                $q->td($q->textfield(-name=>'business_price_insurance', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_INSURANCE'}"),''),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"土地面積: "), 
                $q->td($q->textfield(-name=>'business_toti_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_TOTI_SQUARE'}"),'m&sup2'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"専有面積: "), 
                $q->td($q->textfield(-name=>'business_senyuu_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_SENYUU_SQUARE'}"),'m&sup2'),
                
            ),

            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"建物名: "), 
            #    $q->td($q->textfield(-name=>'business_building_name', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUILDING_NAME'}")),
                
            #),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"建物構造: "), 
                $q->td($q->textfield(-name=>'business_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUILDING_STRUCTURE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"階建: "), 
                $q->td($q->textfield(-name=>'business_story', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_STORY'}"),'階建'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"階: "), 
                $q->td($q->textfield(-name=>'business_floor', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_FLOOR'}"),'階'),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"築年月: "), 
                $q->td($q->textfield(-name=>'business_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_AGE'}"),'(例： 2000/01)'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"条件等: "), 
                $q->td($q->textfield(-name=>'business_condition', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_CONDITION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'business_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_TORIHIKITAIYOU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'business_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_YOUR_ID'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'business_options_parking', -label=>'駐車場あり', -checked=>"$self->{_ref_hash}{'BUSINESS_OPTIONS_PARKING'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        )
                    )
                ),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"その他設備:"), 
                $q->td($q->textarea(-name=>'business_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$self->{_ref_hash}{'BUSINESS_SETUBI'}")),
                
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'business_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$self->{_ref_hash}{'BUSINESS_ADS_TEXT'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"外観写真: "), 
                $q->td($q->filefield(-name=>'business_pics_outside', -default=>'', -size=>42, -maxlength=>80, -value=>"$self->{_ref_hash}{'BUSINESS_PICS_OUTSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"内観写真: "), 
                $q->td($q->filefield(-name=>'business_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PICS_INSIDE'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り図: "), 
                $q->td($q->filefield(-name=>'business_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PICS_MADORIZU'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'business_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_PICS_tizu'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL:<br />(http://＊＊＊)"), 
                $q->td($q->textfield(-name=>'business_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_MOVIE_FILE_URL'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'business_bikou', -default=>'', -rows=>3, -columns=>41, -value=>"$self->{_ref_hash}{'BUSINESS_BIKOU'}")),
            ),

#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"管理会社情報:<br />会社名:<br />電話番号:"), 
#                $q->td(
#                    $q->checkbox(-name=>'business_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'BUSINESS_TASYAKANRI'}"),
#                    $q->br,
#                    $q->textfield(-name=>'business_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'business_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"他社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                    $q->checkbox(-name=>'business_tasyakanri',-label=>'他社管理', -checked=>"$self->{_ref_hash}{'BUSINESS_TASYAKANRI'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('会社名:'),
                            $q->td(
                    $q->textfield(-name=>'business_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_KANRIKAISYA'}")
                            ),
                        ),
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                    $q->textfield(-name=>'business_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),


            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'business_ryuutuu',-label=>'流通可', -checked=>"$self->{_ref_hash}{'BUSINESS_RYUUTUU'}"),
            #    ),
            #),

            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_add'),
                    $q->hidden(-name => '_type', -value => 'rb'),
                    $q->checkbox(-name=>'business_publish', -label=>'公開する', -checked=>"$self->{_ref_hash}{'BUSINESS_PUBLISHED'}"),
                    $q->submit(-name => 'add_new_object' ,-value => '新規追加', -class=>'submit')
                )
            )


        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.business.business_name.focus(); \n// --></script>";
    return $output;
}

sub create_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();


    $$ref_hash{'BUSINESS_USER_ID'} = $self->{_app}->param('user_id');


    #if (!$$ref_hash{'BUSINESS_NAME'}) {$result .= '物件名が入力されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_PRICE'}) {$result .= '賃料が入力されていません。<br />';}
    #if (!$$ref_hash{'BUSINESS_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_KIND'}) {$result .= '物件種目が選択されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}


    if ($$ref_hash{'BUSINESS_PRICE'}) {
        my $str = $$ref_hash{'BUSINESS_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{3,6}))$/){

        }else{
            $result .= '賃料の値が不自然です。4桁から7桁以内の半角数字であるか確認してください。<br />';
        }
    }

    if (!($$ref_hash{'BUSINESS_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_TUBOTANKA'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '坪単価(円)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_KANRIHI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '管理費(円)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_SIKIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_REIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '礼金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_HOSYOUKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '保証金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_SIKIBIKI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷引の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_OTHER'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'その他一時金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_STORY'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階建ての数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    # B1等の地下を入力したいから。下記のは不要。
    #if (!($$ref_hash{'BUSINESS_FLOOR'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
    #    $result .= '階の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    #}


    if ($$ref_hash{'BUSINESS_AGE'}){
        my $str = $$ref_hash{'BUSINESS_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />'; 
        }
    }

    if ($$ref_hash{'BUSINESS_SQUARE'}){
        unless($$ref_hash{'BUSINESS_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
            $result .= '面積は半角英数とピリオド（.）だけで入力してください。<br />'; #/31
        }
    }

    my $resource_directory = REPS::Util->de_taint(REPS->cfg('resource_directory') . 'rb' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('business_pics_outside')){
        my $fh = $q->upload('business_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_OUTSIDE'} = $saved->{'_image'};

    }
    if ($q->param('business_pics_inside')){
        my $fh = $q->upload('business_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_INSIDE'} = $saved->{'_image'};

    }
    if ($q->param('business_pics_madorizu')){
        my $fh = $q->upload('business_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('business_pics_tizu')){
        my $fh = $q->upload('business_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'BUSINESS_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
    }else{
        $$ref_hash{'BUSINESS_CREATED'} = REPS::Util->get_datetime_now();
        my %business;
        my $db_business_path = $self->{_app}->param('db_r_business_path');
        my $num_keys = 1;
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
my $umask;
if ($self->{_app}->cfg('DBUmask')){
    $umask = oct $self->{_app}->cfg('DBUmask');
}else{
    $umask = oct 0111;
}
my $old = umask($umask);
        tie (%business, 'MLDBM', $db_business_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        $num_keys = scalar keys (%business);
        $num_keys = sprintf('%06d', $num_keys++);
        if (exists $business{$num_keys}){
            #count up and add again. This could happen when export and import data.
            #$result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
            while (exists $business{$num_keys}) {
                $num_keys++;
                if ($num_keys >= 999999) {die "Reached lmit.";};
            }
        }
        if (!defined $business{$num_keys}){
            $$ref_hash{'BUSINESS_ID'} = $num_keys;
            eval {
                if ($q->param('business_pics_outside')){
                    my $tmp = $$ref_hash{'BUSINESS_PICS_OUTSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_OUTSIDE'},$dir.$tmp);
                    $$ref_hash{'BUSINESS_PICS_OUTSIDE'} = 'rb' . '/'.$tmp;
                    if ($$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'} = 'rb' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('business_pics_inside')){
                    my $tmp = $$ref_hash{'BUSINESS_PICS_INSIDE'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_INSIDE'},$dir.$tmp);
                    $$ref_hash{'BUSINESS_PICS_INSIDE'} = 'rb' . '/'.$tmp;
                    if ($$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'}){
                        my $tmp2 = $$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'},$dir.$tmp2);
                        $$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'} = 'rb' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }
            eval {
                if ($q->param('business_pics_madorizu')){
                    my $tmp = $$ref_hash{'BUSINESS_PICS_MADORIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'BUSINESS_PICS_MADORIZU'},$dir.$tmp);
                    $$ref_hash{'BUSINESS_PICS_MADORIZU'} ='rb' . '/'.$tmp;
                    if ($$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'} = 'rb' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            eval {
                if ($q->param('business_pics_tizu')){
                    my $tmp = $$ref_hash{'BUSINESS_PICS_TIZU'};
                    $tmp =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'BUSINESS_PICS_TIZU'},$dir.$tmp);
                    $$ref_hash{'BUSINESS_PICS_TIZU'} ='rb' . '/'.$tmp;
                    if ($$ref_hash{'BUSINESS_PICS_TIZU_THUMB'}){
                        my $tmp2 = $$ref_hash{'BUSINESS_PICS_TIZU_THUMB'};
                        $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                        Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'BUSINESS_PICS_TIZU_THUMB'},$dir.$tmp2);
                        $$ref_hash{'BUSINESS_PICS_TIZU_THUMB'} = 'rb' . '/'.$tmp2;
                    }
                }
            };
            if ($@) {
            $result .= "$@<br />";
            }

            $business{$num_keys} = $ref_hash;
            $self->{_ref_hash} = $ref_hash;
        }else{
            $result = "<div class=\"warning\"><p>$result<br />追加されませんでした。</p></div>";
        }


        untie %business;
umask($old);
        #now publish
        eval {
            
        };
        if ($@) {
        $result .= "$@<br />";
        }

    }

    return $result;

}

sub get_Realestate_List{
    my ($self,$sort_by,$off_set,$items_per_page,$only_this_user) = @_;
    #my $self = shift;
    #my $sort_by = $_[0];
    #my $only_this_user = $_[1];

    my %sort_hash = ();
    my %tmp;
    my $key;
    my $value;
    my @loop_data;
    my $count = 0;

    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
        my @sort_keys;
        while ( ($key, $value) = each(%business) ) {
            if ((defined $value) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'BUSINESS_USER_ID'}){
                    if ($only_this_user){
                        if ($only_this_user ne $tmp{'BUSINESS_USER_ID'}){
                            next;
                        }
                    }
                    if ($self->{_app}->param('user_isAdmin') != 1){
                        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                            if ($tmp{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')) {
                                next;
                            }
                        }
                    }else{
                        if (!$only_this_user){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($tmp{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')) {
                                    next;
                                }
                            }
                        }
                    }



    #                if ($tmp{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')){
                        #sort
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'name'){
                                $sort_hash{$key} = $tmp{'BUSINESS_NAME'};
                            }elsif (($sort_by eq 'price')){
                                $sort_hash{$key} = $tmp{'BUSINESS_PRICE'};
                            }elsif (($sort_by eq 'date')){
                                if ((defined $tmp{'BUSINESS_LAST_UPDATED'})&&($tmp{'BUSINESS_LAST_UPDATED'})){

                                    $sort_hash{$key} = $tmp{'BUSINESS_LAST_UPDATED'};

                                }else{

                                    $sort_hash{$key} = $tmp{'BUSINESS_CREATED'};
                                }
                            }elsif(($sort_by eq 'location')){
                                $sort_hash{$key} = $tmp{'BUSINESS_LOCATION'};
                            }
                        }else{

#                            my %hash = (
#                                'BUSINESS_ID' => "$key",
#                                'BUSINESS_PUBLISHED' => $tmp{'BUSINESS_PUBLISHED'},
#                                'BUSINESS_NAME' => $tmp{'BUSINESS_NAME'},
#                                'BUSINESS_LOCATION' => $tmp{'BUSINESS_LOCATION'},
#                                'BUSINESS_PRICE' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE'}),
#                                'BUSINESS_CREATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_CREATED'}),
#                                'BUSINESS_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_LAST_UPDATED'}),
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
        }
    
        $count = @sort_keys;
        #paging
        if (!$off_set){$off_set=0;}
        @sort_keys = splice( @sort_keys , $off_set,$items_per_page);

        foreach (@sort_keys){

            my %tmp = %{$business{$_}};

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

            my %hash = (
                'BUSINESS_ID' => "$_",
                'BUSINESS_PUBLISHED' => $tmp{'BUSINESS_PUBLISHED'},
                'BUSINESS_IS_SPECIAL' => $tmp{'BUSINESS_IS_SPECIAL'},
                'BUSINESS_NAME' => $tmp{'BUSINESS_NAME'},
                'BUSINESS_LOCATION' => $tmp{'BUSINESS_LOCATION'},
                'BUSINESS_PRICE' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE'}),
                'BUSINESS_CREATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_CREATED'}),
                'BUSINESS_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_LAST_UPDATED'}),
                    'BUSINESS_NEW' => $new,
                    'BUSINESS_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
            );
    
            push(@loop_data, \%hash);
        }


        untie %business;
    }
    return \@loop_data,$count;;
}

sub get_Realestate {
    my $self = shift;
    my $business_id = $_[0];

    my $ref_hash;
    my %hash;
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');

    unless ($business_id =~ /[0-9]{6,10}/){Carp::croak "IDの形式が不正です。";}

    tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    if (exists $business{$business_id} ) {
        if ((defined $business{$business_id}) && ($business{$business_id})){
            if ($self->{_app}->param('user_isAdmin') != 1){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($business{$business_id}{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')) {
                        untie %business;
                        Carp::croak "The ID [$business_id] does not belong to you.";
                    }
                }
            }
            $ref_hash = $business{$business_id};
            
            #%hash = %$ref_hash;
#            if ($self->{_app}->param('user_id') eq $$ref_hash{'BUSINESS_USER_ID'}){

                $self->{_ref_hash} = $business{$business_id};
                
#            }else{
#                untie %business;
#                die 'the ID does not belong to you.';
#            }
        }else{
            untie %business;
            return 0;
            #die "The ID [$business_id] has no value. Possibly deleted.";
        }
    }else{
        untie %business;
        return 0;
        #die "The ID [$business_id] does not exists.";
    }

    untie %business;

    return 1;
}

sub get_Edit_Realestate_Form{
    my $self = shift;
    my $ref_hash = $self->{_ref_hash};
    my $output = "";
    my $q = $self->{_app}->query();

    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $output = "<div class=\"warning\"><p>他のユーザーの物件はアクセス出来ません。 </p></div>";
                return $output;
            }
        }
    }
    $output .= $q->start_form(-action => $self->{_app}->param('script_name'), -enctype=> 'multipart/form-data',-name=>'business');

    if ($$ref_hash{'BUSINESS_PUBLISHED'}){
        $output .= '<div align="right" style="margin-right:10px;"></div>';
    }

    my $ifView = '';
    if ($$ref_hash{'BUSINESS_IS_SPECIAL'}){
        $ifView .= '<img src="'.$self->{_app}->cfg('static_url').'icons/16-heart-gold-m.png" width="16" height="16" />';
    }
    if ($$ref_hash{'BUSINESS_PUBLISHED'}){
        $ifView .= '&nbsp;<a href="./search.cgi?_mode=mode_detail&_type=rb&_object_id='.$$ref_hash{'BUSINESS_ID'}.'" target=\"_blank\">公開ページ閲覧</a>';
    }

    my @bKind = split (',',$$ref_hash{'BUSINESS_KIND'});

    #dummy var for delete pics
    $output .= $q->hidden(-name => 'delete_pic', -value => '');

    my $ifPicsOutside = '';
    if ($$ref_hash{'BUSINESS_PICS_OUTSIDE'}){
        if ($$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'}){
            $ifPicsOutside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_OUTSIDE\');" />';
        }else{
            $ifPicsOutside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_OUTSIDE'}."\">外観画像</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_OUTSIDE\');" />';
        }
    }
    my $ifPicsInside = '';
    if ($$ref_hash{'BUSINESS_PICS_INSIDE'}){
        if ($$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'}){
            $ifPicsInside = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_INSIDE\');" />';
        }else{
            $ifPicsInside = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_INSIDE'}."\">内観画像</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_INSIDE\');" />';
        }
    }
    my $ifMadorizu = '';
    if ($$ref_hash{'BUSINESS_PICS_MADORIZU'}){
        if ($$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'}){
            $ifMadorizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_MADORIZU\');" />';
        }else{
            $ifMadorizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_MADORIZU'}."\">間取り図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_MADORIZU\');" />';
        }
    }
    my $ifTizu = '';
    if ($$ref_hash{'BUSINESS_PICS_TIZU'}){
        if ($$ref_hash{'BUSINESS_PICS_TIZU_THUMB'}){
            $ifTizu = "<img src=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_TIZU_THUMB'}."\" width=\"210\" align=\"left\" />".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_TIZU\');" />';
        }else{
            $ifTizu = "<a href=\"".$self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$$ref_hash{'BUSINESS_PICS_TIZU'}."\">地図</a>".'<input type="button" name="edit_object" value="削除" onclick="confirmDeletePicture(this.form,\'BUSINESS_PICS_TIZU\');" />';
        }
    }

    $output .= $q-> table( {-border => 1,-class=>'main_table'},
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"物件番号："), 
                $q->th('[RB'.$$ref_hash{'BUSINESS_ID'}.']'.$ifView), 
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件名: "), 
                $q->td($q->textfield(-name=>'business_name', -default=>'',-size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_NAME'}")),
            ), 
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"物件所在地: "), 
                $q->td($q->textfield(-name=>'business_location', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_LOCATION'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 1: "), 
                $q->td($q->textfield(-name=>'business_station1', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_STATION_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 1: "), 
                $q->td($q->textfield(-name=>'business_walk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_WALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 1: "), 
                $q->td($q->textfield(-name=>'business_bus', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUS_1'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 1: "), 
                $q->td($q->textfield(-name=>'business_bus_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUS_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 1: "), 
                $q->td($q->textfield(-name=>'business_buswalk_minutes', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUSWALK_MINUTES_1'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"最寄駅 2: "), 
                $q->td($q->textfield(-name=>'business_station2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_STATION_2'}")),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"駅徒歩 2: "), 
                $q->td($q->textfield(-name=>'business_walk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_WALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス停名 2: "), 
                $q->td($q->textfield(-name=>'business_bus2', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUS_2'}")),
                

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"バス分 2: "), 
                $q->td($q->textfield(-name=>'business_bus_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUS_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"停歩 2: "), 
                $q->td($q->textfield(-name=>'business_buswalk_minutes2', -default=>'', -size=>7, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUSWALK_MINUTES_2'}"),'分'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-class=>'required'},"物件種目: "), 
                $q->td(
                    $q->checkbox_group(-name=>'business_kind', -defaults=>\@bKind,-values=>[1,2,3],-labels=>{'1'=>'店舗','2'=>'事務所','3'=>'他'}),
                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right', -class=>'required'},"賃料: "), 
                $q->td($q->textfield(-name=>'business_price', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE'}"),'円'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"坪単価: "), 
                $q->td($q->textfield(-name=>'business_tubotanka', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_TUBOTANKA'}"),'円'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理費等: "), 
                $q->td($q->textfield(-name=>'business_price_kanrihi', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_KANRIHI'}"),'円'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"敷金: "), 
                $q->td($q->textfield(-name=>'business_price_sikikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_SIKIKIN'}"),
                        $q->popup_menu(-name=>'business_price_sikikin_unit', 
                            -default=>$$ref_hash{'BUSINESS_PRICE_SIKIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                ),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"礼金: "), 
                $q->td($q->textfield(-name=>'business_price_reikin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_REIKIN'}"),
                        $q->popup_menu(-name=>'business_price_reikin_unit', 
                            -default=>$$ref_hash{'BUSINESS_PRICE_REIKIN_UNIT'},
                            -values=>['1','2','3'],
                            -labels=>{'1'=>'ヶ月','2'=>'円','3'=>'万円'})    
                ),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"保証金: "), 
                $q->td($q->textfield(-name=>'business_price_hosyoukin', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_HOSYOUKIN'}"),'円'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"償却: "), 
                $q->td($q->textfield(-name=>'business_price_syoukyaku', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_SYOUKYAKU'}"),'(例：解約時、10万円)'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"敷引: "), 
                $q->td($q->textfield(-name=>'business_price_sikibiki', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_SIKIBIKI'}"),'円'),
                
            ),
            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"中途解約: "), 
            #    $q->td($q->textfield(-name=>'business_chuutokaiyaku', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_CHUUTOKAIYAKU'}"),'ヵ月'),
                
            #),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"その他一時金: "), 
                $q->td($q->textfield(-name=>'business_price_other', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_PRICE_OTHER'}"),'(ヶ月)'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"保険等: "), 
                $q->td($q->textfield(-name=>'business_price_insurance', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_INSURANCE'}"),''),    
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"土地面積: "), 
                $q->td($q->textfield(-name=>'business_toti_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_TOTI_SQUARE'}"),'m&sup2'),
                
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"専有面積: "), 
                $q->td($q->textfield(-name=>'business_senyuu_square', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_SENYUU_SQUARE'}"),'m&sup2'),
                
            ),

            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"建物名: "), 
            #    $q->td($q->textfield(-name=>'business_building_name', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_BUILDING_NAME'}")),
                
            #),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"建物構造: "), 
                $q->td($q->textfield(-name=>'business_building_structure', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_BUILDING_STRUCTURE'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"階建: "), 
                $q->td($q->textfield(-name=>'business_story', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_STORY'}"),'階建'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"階: "), 
                $q->td($q->textfield(-name=>'business_floor', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_FLOOR'}"),'階'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"築年月: "), 
                $q->td($q->textfield(-name=>'business_age', -default=>'', -size=>12, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_AGE'}"),'(例： 2000/01)'),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"条件等: "), 
                $q->td($q->textfield(-name=>'business_condition', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_CONDITION'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-class=>'required'},"取引態様: "), 
                $q->td($q->textfield(-name=>'business_torihikitaiyou', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_TORIHIKITAIYOU'}")),    
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"管理番号: "), 
                $q->td($q->textfield(-name=>'business_your_id', -default=>'', -size=>10, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_YOUR_ID'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"オプション: "), 
                $q->td(
                    $q->table({-border => 0},
                        $q->Tr(
                            $q->th('&nbsp;'),
                            $q->td(
                                $q->checkbox(-name=>'business_options_parking', -label=>'駐車場あり', -checked=>"$$ref_hash{'BUSINESS_OPTIONS_PARKING'}")
                            ),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;'),
                            $q->td('&nbsp;')
                        )
                    )
                ),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"その他設備:"), 
                $q->td($q->textarea(-name=>'business_setubi', -default=>'', -rows=>2, -columns=>41, -value=>"$$ref_hash{'BUSINESS_SETUBI'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"宣伝文句: "), 
                $q->td($q->textfield(-name=>'business_ads_text', -default=>'', -size=>50, -columns=>50, -value=>"$$ref_hash{'BUSINESS_ADS_TEXT'}")),
            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"外観写真: "), 
                $q->td($q->filefield(-name=>'business_pics_outside', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifPicsOutside",
                    $q->hidden(-name => '_business_pics_outside', -value => "$$ref_hash{'BUSINESS_PICS_OUTSIDE'}"),
                    $q->hidden(-name => '_business_pics_outside_thumb', -value => "$$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"内観写真: "), 
                $q->td($q->filefield(-name=>'business_pics_inside', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifPicsInside",
                    $q->hidden(-name => '_business_pics_inside', -value => "$$ref_hash{'BUSINESS_PICS_INSIDE'}"),
                    $q->hidden(-name => '_business_pics_inside_thumb', -value => "$$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"間取り図: "), 
                $q->td($q->filefield(-name=>'business_pics_madorizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifMadorizu",
                    $q->hidden(-name => '_business_pics_madorizu', -value => "$$ref_hash{'BUSINESS_PICS_MADORIZU'}"),
                    $q->hidden(-name => '_business_pics_madorizu_thumb', -value => "$$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"地図: "), 
                $q->td($q->filefield(-name=>'business_pics_tizu', -default=>'', -size=>42, -maxlength=>250, -value=>""),
                    '<br />',
                    "$ifTizu",
                    $q->hidden(-name => '_business_pics_tizu', -value => "$$ref_hash{'BUSINESS_PICS_TIZU'}"),
                    $q->hidden(-name => '_business_pics_tizu_thumb', -value => "$$ref_hash{'BUSINESS_PICS_TIZU_THUMB'}")),
            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"動画URL:<br />(http://＊＊＊)"), 
                $q->td($q->textfield(-name=>'business_movie_file_url', -default=>'', -size=>50, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_MOVIE_FILE_URL'}")),

            ),
            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right'},"備考: "), 
                $q->td($q->textarea(-name=>'business_bikou', -default=>'', -rows=>3, -columns=>41, -value=>"$$ref_hash{'BUSINESS_BIKOU'}")),
            ),


#            $q->Tr( {-align=>'left'}, 
#                $q->td({-align=>'right'},"管理会社情報:<br />会社名:<br />電話番号:"), 
#                $q->td(
#                    $q->checkbox(-name=>'business_tasyakanri',-label=>'他社管理物件', -checked=>"$self->{_ref_hash}{'BUSINESS_TASYAKANRI'}"),
#                    $q->br,
#                    $q->textfield(-name=>'business_kanrikaisya', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_KANRIKAISYA'}"),
#                    $q->br,
#                    $q->textfield(-name=>'business_kanrikaisya_contact', -default=>'', -size=>50, -maxlength=>250, -value=>"$self->{_ref_hash}{'BUSINESS_KANRIKAISYA_CONTACT'}")
#                    ),
#            ),

            $q->Tr( {-align=>'left'}, 
                $q->td({-align=>'right',-valign=>'top'},"他社情報:"), 
                $q->td(
                    $q->table({-border => '0'},
                        $q->Tr(
                            $q->td({-colspan=>'2'},
                                $q->checkbox(-name=>'business_tasyakanri',-label=>'他社管理', -checked=>"$$ref_hash{'BUSINESS_TASYAKANRI'}"),
                            ),
                        ),
                        $q->Tr(
                            $q->td('会社名:'),
                            $q->td(
                                $q->textfield(-name=>'business_kanrikaisya', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_KANRIKAISYA'}"),
                            ),
                        ),
                        $q->Tr(
                            $q->td('電話番号:'),
                            $q->td(
                                $q->textfield(-name=>'business_kanrikaisya_contact', -default=>'', -size=>40, -maxlength=>250, -value=>"$$ref_hash{'BUSINESS_KANRIKAISYA_CONTACT'}")

                            ),
                        )
                    )
                )
            ),




            #$q->Tr( {-align=>'left'}, 
            #    $q->td({-align=>'right'},"他社付け: "), 
            #    $q->td(
            #        $q->checkbox(-name=>'business_ryuutuu',-label=>'流通可', -checked=>"$$ref_hash{'BUSINESS_RYUUTUU'}"),
            #    ),
            #),

            $q->Tr( {-align=>'left', -valign=>'middle'}, 
                $q->td({colspan=>'2',-align=>'center', -valign=>'middle'},
                    $q->br,
                    $q->hidden(-name => '_mode', -value => 'mode_edit'),
                    $q->hidden(-name => '_type', -value => 'rb'),
                    $q->hidden(-name => '_object_id', -value => "$$ref_hash{'BUSINESS_ID'}"),
                    $q->hidden(-name => 'business_created', -value => "$$ref_hash{'BUSINESS_CREATED'}"),
                    $q->hidden(-name => 'add_to_special', -value => "$$ref_hash{'BUSINESS_IS_SPECIAL'}"),

                    #$q->checkbox(-name=>'add_to_special', -label=>'お勧め物件に追加する', -checked=>"$self->{_ref_hash}{'BUSINESS_IS_SPECIAL'}"),
                    $q->checkbox(-name=>'business_publish', -label=>'公開する', -checked=>"$$ref_hash{'BUSINESS_PUBLISHED'}"),
                    $q->submit(-name => 'edit_object' ,-value => '編集更新', -class=>'submit')
                )
            )
        ); 

    $output .= $q->end_form();
    $output .= "<script type=\"text/javascript\"><!-- \ndocument.business.business_name.focus(); \n// --></script>";
    return $output;
}

sub update_Realestate{
    my $self = shift;
    my $result = "";
    my $ref_hash = $self->{_ref_hash};
    my $q = $self->{_app}->query();
    #my $image = Image::Magick->new;
    #todo check each item
    unless ($$ref_hash{'BUSINESS_ID'}=~ /[0-9]{6,10}/){$result .= 'IDの形式が不正です。<br />';}
#    if ($$ref_hash{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')){$result .= '異なるユーザーIDでは登録できません。<br />';}
    if ($self->{_app}->param('user_isAdmin') != 1){
        if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
            if ($$ref_hash{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')){
                #$result .= '異なるユーザーIDでは登録できません。<br />';
                $result = "<div class=\"warning\"><p>他のユーザーの物件は更新できません。更新されませんでした。</p></div>";
                return $result;
            }
        }
    }
    #if (!$$ref_hash{'BUSINESS_NAME'}) {$result .= '物件名が入力されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_LOCATION'}) {$result .= '物件所在地が入力されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_PRICE'}) {$result .= '賃料が入力されていません。<br />';}
    #if (!$$ref_hash{'BUSINESS_STATION_1'}) {$result .= '最寄駅1が入力されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_KIND'}) {$result .= '物件種目が選択されていません。<br />';}
    if (!$$ref_hash{'BUSINESS_TORIHIKITAIYOU'}) {$result .= '取引態様が入力されていません。<br />';}

    if (!($$ref_hash{'BUSINESS_WALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUS_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUSWALK_MINUTES_1'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_WALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '駅徒歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUS_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'バス_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_BUSWALK_MINUTES_2'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '停歩_2（分）の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_TUBOTANKA'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '坪単価(円)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_KANRIHI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '管理費(円)の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_SIKIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_REIKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '礼金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_HOSYOUKIN'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '保証金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_SIKIBIKI'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '敷引の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_PRICE_OTHER'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= 'その他一時金の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }
    if (!($$ref_hash{'BUSINESS_STORY'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
        $result .= '階建ての数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    }

    # B1等の地下を入力したいから。下記のは不要。
    #if (!($$ref_hash{'BUSINESS_FLOOR'} =~ m/^[0-9]*([0-9]\.)?[0-9]*$/)){
    #    $result .= '階の数値が不正です。半角数字とピリオド（.）であるか確認してください。<br />';
    #}

    if ($$ref_hash{'BUSINESS_PRICE'}) {
        my $str = $$ref_hash{'BUSINESS_PRICE'};
        if ($str =~ m/^([1-9]([0-9]{3,6}))$/){

        }else{
            $result .= '賃料の値が不自然です。4桁から7桁以内の半角数字であるか確認してください。<br />';
        }
    }
    if ($$ref_hash{'BUSINESS_AGE'}){
        my $str = $$ref_hash{'BUSINESS_AGE'};
        if ($str =~ m/^([12][0-9][0-9][0-9])\/(0[1-9]|1[0-2])$/){
        }else{
            $result .= '日付形式が「例： 2000/01」と異なります。<br />';
        }
    }
    if ($$ref_hash{'BUSINESS_SQUARE'}){
        unless($$ref_hash{'BUSINESS_SQUARE'} =~ m/^[0-9]+\.?[0-9]*$/){
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

    my $resource_directory = REPS::Util->de_taint($self->{_app}->cfg('resource_directory') . 'rb' . '/');
    my $dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$resource_directory);
    require REPS::CMS::Thumbnail;
    my $saved = REPS::CMS::Thumbnail->new($self->{_app});

    if ($q->param('business_pics_outside')){
        my $fh = $q->upload('business_pics_outside');
        $result .= $saved->save_Thumbnail($fh,$dir,'a');
        $$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_OUTSIDE'} = $saved->{'_image'};
    }
    if ($q->param('business_pics_inside')){
        my $fh = $q->upload('business_pics_inside');
        $result .= $saved->save_Thumbnail($fh,$dir,'b');
        $$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_INSIDE'} = $saved->{'_image'};
    }
    if ($q->param('business_pics_madorizu')){
        my $fh = $q->upload('business_pics_madorizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'c');
        $$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_MADORIZU'} = $saved->{'_image'};
    }
    if ($q->param('business_pics_tizu')){
        my $fh = $q->upload('business_pics_tizu');
        $result .= $saved->save_Thumbnail($fh,$dir,'d');
        $$ref_hash{'BUSINESS_PICS_TIZU_THUMB'} = $saved->{'_thumbnail'};
        $$ref_hash{'BUSINESS_PICS_TIZU'} = $saved->{'_image'};
    }

    if ($result){
        $result = "<div class=\"warning\"><p>$result<br />更新されませんでした。</p></div>";
    }else{
        $$ref_hash{'BUSINESS_LAST_UPDATED'} = REPS::Util->get_datetime_now();
        my %business;
        my $db_business_path = $self->{_app}->param('db_r_business_path');
        tie (%business, 'MLDBM', $db_business_path, O_CREAT|O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;
        
        if (!$business{$$ref_hash{'BUSINESS_ID'}}){
            $result = "<div class=\"warning\"><p>別のユーザー又は別の画面で削除された可能性があります。<br />更新されませんでした。</p></div>";
            return $result;
        }

#        if ($business{$$ref_hash{'BUSINESS_ID'}}{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')){
        if ($self->{_app}->param('user_isAdmin') != 1){
            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                if ($business{$$ref_hash{'BUSINESS_ID'}}{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')){
                    $result = "<div class=\"warning\"><p>他のユーザーの物件は更新出来ません。 </p></div>";
                    untie %business;
                    return $result;
                }
            }
        }
        my $tmp_file_key = REPS::Util->de_taint($self->{_app}->param('user_id'));
        my $num_keys = REPS::Util->de_taint($$ref_hash{'BUSINESS_ID'});

        eval {
            if ($q->param('business_pics_outside')){
                my $tmp = $$ref_hash{'BUSINESS_PICS_OUTSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_OUTSIDE'},$dir.$tmp);
                $$ref_hash{'BUSINESS_PICS_OUTSIDE'} = 'rb' . '/'.$tmp;
                if ($$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'BUSINESS_PICS_OUTSIDE_THUMB'} = 'rb' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('business_pics_inside')){
                my $tmp = $$ref_hash{'BUSINESS_PICS_INSIDE'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_INSIDE'},$dir.$tmp);
                $$ref_hash{'BUSINESS_PICS_INSIDE'} = 'rb' . '/'.$tmp;
                if ($$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'}){
                    my $tmp2 = $$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'},$dir.$tmp2);
                    $$ref_hash{'BUSINESS_PICS_INSIDE_THUMB'} = 'rb' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }
        eval {
            if ($q->param('business_pics_madorizu')){
                my $tmp = $$ref_hash{'BUSINESS_PICS_MADORIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'BUSINESS_PICS_MADORIZU'},$dir.$tmp);
                $$ref_hash{'BUSINESS_PICS_MADORIZU'} = 'rb' . '/'.$tmp;
                if ($$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'BUSINESS_PICS_MADORIZU_THUMB'} = 'rb' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        eval {
            if ($q->param('business_pics_tizu')){
                my $tmp = $$ref_hash{'BUSINESS_PICS_TIZU'};
                $tmp =~ s/$tmp_file_key/$num_keys/g; 
                Carp::croak "Cannot rename an image. $!" unless  rename($dir.$$ref_hash{'BUSINESS_PICS_TIZU'},$dir.$tmp);
                $$ref_hash{'BUSINESS_PICS_TIZU'} = 'rb' . '/'.$tmp;
                if ($$ref_hash{'BUSINESS_PICS_TIZU_THUMB'}){
                    my $tmp2 = $$ref_hash{'BUSINESS_PICS_TIZU_THUMB'};
                    $tmp2 =~ s/$tmp_file_key/$num_keys/g; 
                    Carp::croak "Cannot rename an image. $!" unless rename($dir.$$ref_hash{'BUSINESS_PICS_TIZU_THUMB'},$dir.$tmp2);
                    $$ref_hash{'BUSINESS_PICS_TIZU_THUMB'} = 'rb' . '/'.$tmp2;
                }
            }
        };
        if ($@) {
        $result .= "$@<br />";
        }

        ##TODO:
        if (!$business{$$ref_hash{'BUSINESS_ID'}}{'BUSINESS_USER_ID'}){
            $$ref_hash{'BUSINESS_USER_ID'} = $self->{_app}->param('user_id');
        }else{
            $$ref_hash{'BUSINESS_USER_ID'} = $business{$$ref_hash{'BUSINESS_ID'}}{'BUSINESS_USER_ID'};
        }

        $business{$$ref_hash{'BUSINESS_ID'}} = $ref_hash;

        untie %business;


        #update recommend
        if ($$ref_hash{'BUSINESS_IS_SPECIAL'}) {
            $self->{_app}->recommend_static_write_file();
        }


    }


    return $result;

}

sub delete_Realestate{
    my $self = shift;
    my @to_be_deleted = @_;
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

        foreach (@to_be_deleted){
            if ($_ =~ /[0-9]{6,10}/){
                if (exists $business{$_}){
                    if (defined $business{$_} && ($business{$_})){
                        #my $ref_hash = $business{$_};
                        #my %hash = %$ref_hash;
                        if ($self->{_app}->param('user_isAdmin') != 1){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($business{$_}{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')) {
                                    undef $business{$_};
                                } else {
                                    #delete $_ from @to_be_deleted
                                    #delete dupe later
#                                    push @to_be_deleted ,$_;
                                    #do nothing
                                }
                            }else{
                                undef $business{$_};
                            }
                        }else{
                            undef $business{$_};
                        }
    #                    if ($hash{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')){
                            #delete $business{$_};
                            #$business{$_} = undef;
    #                    }
                    }
                }
            }
        }
        untie %business;
    }

#TODO:add to updates??


#todo
#check and make sure it is owned by the user BUSINESS_USER_ID
#    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
#        my %delete_dupelicate;
#        @to_be_deleted = grep(!$delete_dupelicate{$_}++, @to_be_deleted);
#    }

    return 1;
}

sub dup_Realestate{
    my $self = shift;
    my @to_be_duped = @_;
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');


    require REPS::Util;
    use File::Copy;
    use File::Basename;
    my $res_dir = REPS::Util->de_taint($self->{_app}->cfg('site_path').$self->{_app}->cfg('resource_directory'));

    tie (%business, 'MLDBM', $db_business_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

    foreach (@to_be_duped){
        if ($_ =~ /[0-9]{6,10}/){
            if (exists $business{$_}){
                if (defined $business{$_} && ($business{$_})){
                #    
                #    $apart{$_} = \%hash;
                    my $num_keys = scalar keys (%business);
                    $num_keys = sprintf('%06d', $num_keys++);
                    if (exists $business{$num_keys}){
                        #count up and add again. This could happen when export and import data.
                        while (exists $business{$num_keys}) {
                            $num_keys++;
                            if ($num_keys >= 999999) {die "Reached lmit.";}
                        }
                    }
                    my %hash = %{$business{$_}};
                    #物件IDをつける
                    $hash{'BUSINESS_ID'} = $num_keys;
                    #部屋番号を空にする。
                    #$hash{'BUSINESS_ROOM_NUMBER'} = '';

                    $hash{'BUSINESS_CREATED'} = REPS::Util->get_datetime_now();
                    $hash{'BUSINESS_LAST_UPDATED'} = '';

                    if ($hash{'BUSINESS_PICS_OUTSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_OUTSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_OUTSIDE'}, $res_dir.'rb/'.$num_keys.'_a'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_OUTSIDE'} = 'rb/'.$num_keys.'_a'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'BUSINESS_PICS_INSIDE'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_INSIDE'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_INSIDE'}, $res_dir.'rb/'.$num_keys.'_b'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_INSIDE'} = 'rb/'.$num_keys.'_b'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'BUSINESS_PICS_MADORIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_MADORIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_MADORIZU'}, $res_dir.'rb/'.$num_keys.'_c'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_MADORIZU'} = 'rb/'.$num_keys.'_c'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'BUSINESS_PICS_TIZU'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_TIZU'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_TIZU'}, $res_dir.'rb/'.$num_keys.'_d'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_TIZU'} = 'rb/'.$num_keys.'_d'.$ext;
                        };
                        if ($@){die $@;}
                    }

                    if ($hash{'BUSINESS_PICS_OUTSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_OUTSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_OUTSIDE_THUMB'}, $res_dir.'rb/'.$num_keys.'_a_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_OUTSIDE_THUMB'} = 'rb/'.$num_keys.'_a_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'BUSINESS_PICS_INSIDE_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_INSIDE_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_INSIDE_THUMB'}, $res_dir.'rb/'.$num_keys.'_b_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_INSIDE_THUMB'} = 'rb/'.$num_keys.'_b_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'BUSINESS_PICS_MADORIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_MADORIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_MADORIZU_THUMB'}, $res_dir.'rb/'.$num_keys.'_c_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_MADORIZU_THUMB'} = 'rb/'.$num_keys.'_c_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }
                    if ($hash{'BUSINESS_PICS_TIZU_THUMB'}){
                        my ($file,$dir,$ext) = fileparse($hash{'BUSINESS_PICS_TIZU_THUMB'}, qr/\.[^.]*/);
                        eval{
                            copy($res_dir.$hash{'BUSINESS_PICS_TIZU_THUMB'}, $res_dir.'rb/'.$num_keys.'_d_thumb'.$ext) or die "画像ファイルのコピーに失敗しました: $!";
                            $hash{'BUSINESS_PICS_TIZU_THUMB'} = 'rb/'.$num_keys.'_d_thumb'.$ext;
                        };
                        if ($@){die $@;}
                    }


                    #$apart{$num_keys} = $apart{$_};
                    $business{$num_keys} = \%hash;
                }
            }
        }
    }
    untie %business;

    return 1;
}

sub toggle_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

        foreach (@to_be_deleted){
            if ($_ =~ /[0-9]{6,10}/){
                if (exists $business{$_}){
                    if (defined $business{$_} && ($business{$_})){
                        #my $ref_hash = $business{$_};
                        #my %hash = %$ref_hash;
                        if ($self->{_app}->param('user_isAdmin') != 1){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($business{$_}{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')) {
                                    my %hash = ();
                                    %hash = %{$business{$_}};
                                    if ($boolean){
                                        $hash{'BUSINESS_PUBLISHED'}='On';
                                        $hash{'BUSINESS_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                                    }else{
                                        $hash{'BUSINESS_PUBLISHED'}='';
                                    }
                                    $business{$_} = \%hash;
                                } else {
                                    #delete $_ from @to_be_deleted
                                    #delete dupe later
#                                    push @to_be_deleted ,$_;
                                    #do nothing
                                }
                            }else{
                                my %hash = ();
                                %hash = %{$business{$_}};
                                if ($boolean){
                                    $hash{'BUSINESS_PUBLISHED'}='On';
                                    $hash{'BUSINESS_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                                }else{
                                    $hash{'BUSINESS_PUBLISHED'}='';
                                }
                                $business{$_} = \%hash;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$business{$_}};
                            if ($boolean){
                                $hash{'BUSINESS_PUBLISHED'}='On';
                                $hash{'BUSINESS_LAST_UPDATED'} = REPS::Util->get_datetime_now();
                            }else{
                                $hash{'BUSINESS_PUBLISHED'}='';
                            }
                            $business{$_} = \%hash;
                        }
    #                    if ($hash{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')){
                            #delete $business{$_};
                            #$business{$_} = undef;
    #                    }
                    }
                }
            }
        }
        untie %business;
    }

#TODO:add to updates??


#todo
#check and make sure it is owned by the user BUSINESS_USER_ID
#    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
#        my %delete_dupelicate;
#        @to_be_deleted = grep(!$delete_dupelicate{$_}++, @to_be_deleted);
#    }

    return 1;
}

sub special_Realestate{
    my $self = shift;
    my $boolean = shift;
    my @to_be_deleted = @_;
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDWR, 0660, $DB_BTREE, 'write') or Carp::croak $!;

        foreach (@to_be_deleted){
            if ($_ =~ /[0-9]{6,10}/){
                if (exists $business{$_}){
                    if (defined $business{$_} && ($business{$_})){
                        #my $ref_hash = $business{$_};
                        #my %hash = %$ref_hash;
                        if ($self->{_app}->param('user_isAdmin') != 1){
                            if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                                if ($business{$_}{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')) {
                                    my %hash = ();
                                    %hash = %{$business{$_}};
                                    if ($boolean){
                                        $hash{'BUSINESS_IS_SPECIAL'}='On';
                                    }else{
                                        $hash{'BUSINESS_IS_SPECIAL'}='';
                                    }
                                    $business{$_} = \%hash;
                                }
                            }else{
                                my %hash = ();
                                %hash = %{$business{$_}};
                                if ($boolean){
                                    $hash{'BUSINESS_IS_SPECIAL'}='On';
                                }else{
                                    $hash{'BUSINESS_IS_SPECIAL'}='';
                                }
                                $business{$_} = \%hash;
                            }
                        }else{
                            my %hash = ();
                            %hash = %{$business{$_}};
                            if ($boolean){
                                $hash{'BUSINESS_IS_SPECIAL'}='On';
                            }else{
                                $hash{'BUSINESS_IS_SPECIAL'}='';
                            }
                            $business{$_} = \%hash;
                        }
    #                    if ($hash{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')){
                            #delete $business{$_};
                            #$business{$_} = undef;
    #                    }
                    }
                }
            }
        }
        untie %business;
    }
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

    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        while ( ($key, $value) = each(%business) ) {
    
            if ((defined $business{$key}) && ($value)){
                my %tmp = %$value;
                if (exists $tmp{'BUSINESS_USER_ID'}){
                    #match?
                    $match = 0;
    
                    if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                        if ($tmp{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')) {
                            next;
                        }
                    }

                    if ($q->param("business_jisyakannri") > 0){ #自社管理指定
                        if ($q->param("business_jisyakannri") == 1) {
                            if ($tmp{'BUSINESS_TASYAKANRI'}){
                                next;
                            }else{
                                $match = 1;
                            }
                        }elsif($q->param("business_jisyakannri") == 2){
                            if ($tmp{'BUSINESS_TASYAKANRI'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("business_jisyatouroku") > 0){
                        if ($q->param("business_jisyatouroku") == 1){
                            if ($tmp{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')){
                                next;
                            }else{$match = 1;}
                        }elsif ($q->param("business_jisyatouroku") == 2){
                            if ($tmp{'BUSINESS_USER_ID'} eq $self->{_app}->param('user_id')){
                                next;
                            }else{$match = 1;}
                        }
                    }else{
                        $match = 1;
                    }
    
                    if ($q->param("business_public") > 0){
                        if ($q->param("business_public") == 1){
                            if ($tmp{'BUSINESS_PUBLISHED'}){
                                $match = 1;
                            }else{next;}
                        }elsif($q->param("business_public") == 2){
                            if (!$tmp{'BUSINESS_PUBLISHED'}){
                                $match = 1;
                            }else{next;}
                        }
                    }else{
                        $match = 1;
                    }

                    if ($q->param("business_recommend") > 0){
                        if ($q->param("business_recommend") == 1) {
                            if ($tmp{'BUSINESS_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }elsif($q->param("business_recommend") == 2){
                            if (!$tmp{'BUSINESS_IS_SPECIAL'}){
                                $match = 1;
                            }else{
                                next;
                            }
                        }
                    }else{
                        $match = 1;
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
    
                    
                    if ($q->param("business_address")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("business_address")));
                        if (REPS::Util->str_match($tmp{'BUSINESS_LOCATION'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
                    }
    
                    if ($q->param("business_name")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("business_name")));
                        if (REPS::Util->str_match($tmp{'BUSINESS_NAME'},$search_by_key)){
                            $match = 1;
                        }else{
                            next;
                        }
                    }
    
                    $test = 0;
                    
                    if ($q->param("business_school")){
                        my $search_by_key = REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("business_school")));
                        if (REPS::Util->str_match($tmp{'BUSINESS_SHOUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
                        if (REPS::Util->str_match($tmp{'BUSINESS_CYUUGAKKOUKU'},$search_by_key)){
                            $test = 1;
                        }
    
                        my $tstr =  join(' ',$tmp{'BUSINESS_DAIGAKU_LIST'}); 
    
                        if (REPS::Util->str_match($tstr,$search_by_key)){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }
    
                    $test = 0;
                    if ($q->param("business_station")){
                        my $search_by_key =REPS::Util->convert_zhk( $self->{_app}->convert_charset($q->param("business_station")));

                        if (REPS::Util->str_match($tmp{'BUSINESS_STATION_1'},$search_by_key)){
                            $test = 1;
                        }
                        if(REPS::Util->str_match($tmp{'BUSINESS_STATION_2'},$search_by_key)){
                            $test = 1;
                        }
                        if ($test){$match = 1;}else{next;}
                    }
    
    
                    if ($match){
    
                        #add to sort_hash
                        if (($sort_by eq 'name') || ($sort_by eq 'price') || ($sort_by eq 'date') || ($sort_by eq 'location')){
                            if ($sort_by eq 'name'){
                                $sort_hash{$key} = $tmp{'BUSINESS_NAME'};
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
    
                my $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'BUSINESS_CREATED'});
                my $new = '';
                if ($dd <= 30) {
                    $new = 'ON';
                }
                my $updated = '';
                if ((!$new) && ($tmp{'BUSINESS_LAST_UPDATED'})){
                    $dd = REPS::Util->get_date_delta_from_httpDate($tmp{'BUSINESS_LAST_UPDATED'});
                    if ($dd <= 10) {
                        $updated = 'ON';
                    }
                }

                my %hash = (
                    'BUSINESS_ID' => "$_",
                    'BUSINESS_PUBLISHED' => $tmp{'BUSINESS_PUBLISHED'},
                    'BUSINESS_IS_SPECIAL' => $tmp{'BUSINESS_IS_SPECIAL'},
                    'BUSINESS_NAME' => $tmp{'BUSINESS_NAME'},
                    'BUSINESS_LOCATION' => $tmp{'BUSINESS_LOCATION'},
                    'BUSINESS_PRICE' => REPS::Util->insert_comma($tmp{'BUSINESS_PRICE'}),
                    #'BUSINESS_ROOM_NUMBER' => $tmp{'BUSINESS_ROOM_NUMBER'},
                    'BUSINESS_CREATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_CREATED'}),
                    'BUSINESS_LAST_UPDATED' => REPS::Util->get_date_as_string($tmp{'BUSINESS_LAST_UPDATED'}),
                    'BUSINESS_NEW' => $new,
                    'BUSINESS_UPDATED' => $updated,
                    'static_url' => $self->{_app}->cfg('static_url'),
                    '_type' => 'rb'
                );
        
                push(@loop_data, \%hash);
            }
    #    }
        
        untie %business;
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
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    my ($key, $value);
    my @loop_data=();
    #my %hash;

    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');

    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;


        while ( ($key, $value) = each(%business) ) {
            if ((exists $business{$key}) && (defined $business{$key}) && ($value)){

                 if (($$value{'BUSINESS_PUBLISHED'}) && ($$value{'BUSINESS_IS_SPECIAL'})){
                    push(@loop_data, $key);
                    if ($limit < scalar(@loop_data)){last;}
                 }

            }
        }
        untie %business;

    }
    my $limit =  $self->{_app}->cfg('recommend_static_display_limit');
    if (($limit) && ($limit>0)){
        @loop_data = @loop_data[0..$limit-1];
    }
    require REPS::Search::Realestate::R_Business;
    my $Realestate = REPS::Search::Realestate::R_Business->new($self->{_app});
    my $ref_loop = $Realestate->get_Detail_List(@loop_data);

    return $ref_loop;
}

sub get_Count{
    my $self = shift;
    my %business;
    my $db_business_path = $self->{_app}->param('db_r_business_path');
    my ($key, $value);
    my %hash;
    if (-f $db_business_path){
        tie (%business, 'MLDBM', $db_business_path, O_RDONLY, 0660, $DB_BTREE, 'read') or Carp::croak $!;
    
        my $n=0;# = keys( %apart );
        my $p=0;
        my $l=0;
        my $t;
        while ( ($key, $value) = each(%business) ) {
            if ((exists $business{$key}) && (defined $business{$key}) && ($value)){
                if (uc($self->{_app}->cfg('independent_users')) eq 'ON') {
                    if ($$value{'BUSINESS_USER_ID'} ne $self->{_app}->param('user_id')) {
                        next;
                    }
                }
    
                if (exists $$value{'BUSINESS_PUBLISHED'}){
                    if ($$value{'BUSINESS_PUBLISHED'}){
                        $p++;
                    }else{
                        $n++;
                    }
                }
        
                if ((defined $$value{'BUSINESS_LAST_UPDATED'}&&($$value{'BUSINESS_LAST_UPDATED'}))){
                    $t=$$value{'BUSINESS_LAST_UPDATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'BUSINESS_LAST_UPDATED'};
                    }
        
                }else{
                    $t=$$value{'BUSINESS_CREATED'};
                    $t =~ s/\D//gi;
                    my $tmp_num = $l;
                    $tmp_num =~ s/\D//gi;
                    if ($t > $tmp_num){
                        $l=$$value{'BUSINESS_CREATED'};
                    }
                }
            }
        }
        untie %business;
        %hash = ('count_all'=>$n+$p,'count_published'=>$p,'last_updated' => REPS::Util->get_date_as_string($l));
    }
    return \%hash;
}


sub get_AccessLog{
    my $self = shift;
    my ($key, $value);
    my @loop_data = ();
    my $n =0;
    my %access;
    my $db_access_path = $self->{_app}->param('db_r_business_access_path');
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
    my $n = 0;
    my %inquiry;
    my $db_inquiry_path = $self->{_app}->param('db_r_business_inquiry_path');
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
    my $feed_title = '賃貸事業用物件情報';
    $feed->title($UJ->set($feed_title,'euc')->utf8);
    # subtitle
    my $feed_subtitle = $$settings_info{'COMPANY_NAME'} . 'が配信する最新の賃貸事業用物件情報です';
    $feed->subtitle($UJ->set($feed_subtitle,'euc')->utf8);

    #create self link
    my $feed_link = XML::Atom::Syndication::Link->new();
    $feed_link->href($self->{_app}->cfg('site_url').'rb-atom.xml');
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
    $feed->id($self->{_app}->cfg('cgi_url').'rb');

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


######
##

    my %business;
    my $db_path = $self->{_app}->param('db_r_business_path');
    if (-e $db_path){
        tie (%business, 'MLDBM', $db_path, O_RDONLY, 0660, $DB_BTREE, 'write') or Carp::croak ("$! $db_path");#
        while ( ($key, $value) = each(%business) ) {
            if ($i > 15){last;}
            if ((defined $business{$key}) && ($value)){
                if ($$value{'BUSINESS_PUBLISHED'}){
                    $i++;
                    if ((defined $$value{'BUSINESS_LAST_UPDATED'}&&($$value{'BUSINESS_LAST_UPDATED'}))){
                        $sort_hash{$key} = $$value{'BUSINESS_LAST_UPDATED'};
                    }else{
                        $sort_hash{$key} = $$value{'BUSINESS_CREATED'};
                    }
                }
            }
        }

        #sort by update
        my @sort_keys = sort {$sort_hash{$a} cmp $sort_hash{$b}} keys %sort_hash;
        @sort_keys = reverse @sort_keys;
        if (@sort_keys > 0){
            if ($business{$sort_keys[0]}{'BUSINESS_LAST_UPDATED'}. '+09:00'){
                $feed->updated($business{$sort_keys[0]}{'BUSINESS_LAST_UPDATED'}. '+09:00');
            }else{
                $feed->updated($business{$sort_keys[0]}{'BUSINESS_CREATED'}. '+09:00');
            }
        }else{
            $feed->updated(REPS::Util->get_datetime_now . '+09:00');
        }
        #for each
        foreach (@sort_keys){
            my $entry = XML::Atom::Syndication::Entry->new;
#TODO: create better id for entry.
            $entry->id($self->{_app}->cfg('cgi_url').'rb/'.$business{$_}{'BUSINESS_ID'});

            #title
            my $business_kind='';
            foreach (split(',',$business{$_}{'BUSINESS_KIND'})){
                if ($business_kind){$business_kind.='・'}
                if ($_ == 1){$business_kind .= '店舗'}
                elsif($_ == 2){$business_kind .= '事務所'}
                elsif($_ == 3){$business_kind .= '他'}else {$business_kind='賃貸物件';}
            }
            my $business_price = REPS::Util->insert_comma($business{$_}{'BUSINESS_PRICE'});
            my $entry_title = "[$business_kind][$business_price円]";
            $entry->title($UJ->set($entry_title,'euc')->utf8);

            #create a link
            my $entry_link = XML::Atom::Syndication::Link->new();
            $entry_link->href($self->{_app}->cfg('cgi_url').'search.cgi?_mode=mode_detail&_type=rb&_object_id='.$business{$_}{'BUSINESS_ID'});
            $entry_link->rel('alternate');
            $entry_link->type('text/html');
            #set a feed link
            $entry->link($entry_link);
            #updated
            if ($business{$_}{'BUSINESS_LAST_UPDATED'}){
                $entry->updated($business{$_}{'BUSINESS_LAST_UPDATED'} . '+09:00');
                $entry->published($business{$_}{'BUSINESS_CREATED'}. '+09:00');
            }else{
                $entry->updated($business{$_}{'BUSINESS_CREATED'}. '+09:00');
            }
            #author
            my $entry_author = XML::Atom::Syndication::Person->new(Name=>'author');
            $entry_author->name($business{$_}{'BUSINESS_USER_ID'});
            $entry->author($entry_author);

            my $business_picture_outside='';
            if ($business{$_}{'BUSINESS_PICS_OUTSIDE'}){
                $business_picture_outside = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$business{$_}{'BUSINESS_PICS_OUTSIDE_THUMB'};
                $business_picture_outside = '<img src="'.$business_picture_outside.'" class="outside" />';
            }
            my $business_picture_madorizu='';
            if ($business{$_}{'BUSINESS_PICS_MADORIZU'}){
                $business_picture_madorizu = $self->{_app}->cfg('site_url').$self->{_app}->cfg('resource_directory').$business{$_}{'BUSINESS_PICS_MADORIZU_THUMB'};
                $business_picture_madorizu = '<img src="'.$business_picture_madorizu.'" class="madorizu" />';
            }

            my $entry_category = XML::Atom::Syndication::Category->new();
            $entry_category->term($UJ->set($business_kind,'euc')->utf8);
            $entry->category($entry_category);
#TODO: How to add more than one category?


my $entry_content = <<"_HTML_";
<div class="rl">
    <h4><span="tagline">$business{$_}{BUSINESS_ADS_TEXT}</span></h4>
    <ul>
        <li>種別：<span class="type">$business_kind</span></li>
        <li>価格：<span class="price">$business_price<span class="unit">円</span></span></li>
        <li>所在地：<span class="location">$business{$_}{BUSINESS_LOCATION}</span></li>
        <li>最寄駅：<span class="station">$business{$_}{BUSINESS_STATION_1}</span></li>
    </ul>
    <div class="picture">
        <span class="outside">$business_picture_outside</span>
        <span class="madorizu">$business_picture_madorizu</span>
    </div>
</div>
_HTML_

            my $content = XML::Atom::Syndication::Content->new($UJ->set($entry_content,'euc')->utf8);
            $content->type('html');
            $entry->content($content);
            $feed->add_entry($entry);

        }
        untie %business;

        my $output = $feed->as_xml;
        my $file = $self->{_app}->cfg('site_path').'rb-atom.xml';

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

