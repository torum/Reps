package REPS::Search::Search;

use strict;

sub new{
    my ($class) = @_;
    my $self = {
        'sort_by'=> '',
        'off_set'=> '',
        'items_per_page'=> '',
        'ref_result_loop'=> '',
        'count_result'=> ''
    };

    return bless $self,$class;
}



1