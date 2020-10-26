package REPS::CMS::Realestate;
#Virtual Abstract Base Class

use strict;
use base qw( Class::ErrorHandler );
use REPS::Util;
#use REPS::CMS::Thumbnail;
use REPS::CMS::Search;

#Public class methods are only implemented in subclasses
sub new{}

sub set_Query {}

sub get_Create_Realestate_Form{}

sub create_Realestate{}

sub get_Realestate_List{}

sub get_Edit_Realestate_Form{}

sub update_Realestate{}

sub delete_Realestate{}

sub toggle_Realestate{}

sub dup_Realestate{}

sub special_Realestate{}

sub get_Search_Result {}

sub get_Specials{}

sub get_Count{}

sub get_AccessLog{}

sub get_InquiryLog{}

sub syndicate{};

1
