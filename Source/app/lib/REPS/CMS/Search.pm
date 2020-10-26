package REPS::CMS::Search;

use strict;

sub new{
    my ($class,$sort_by,$off_set,$items_per_page) = @_;
    my $self = {
        'sort_by'=> $sort_by,
        'off_set'=> $off_set,
        'items_per_page'=> $items_per_page,
        'ref_result_loop'=> '',
        'count_result' =>''
    };

    return bless $self,$class;
}



1