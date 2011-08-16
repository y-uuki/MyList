package test::My::List;
use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use My::List;

sub init : Test(1) {
    new_ok 'My::List';
}

sub append : Tests {
    my $list = My::List->new;

    is_deeply [$list->get(0)], [undef];
    is_deeply [$list->get(-1)], [undef];

    $list->append("Hello");
    is_deeply [$list->get(1)], [undef];
    is_deeply [$list->get(0)], ["Hello"];

    $list->append(2011);
    is_deeply [$list->get(1)], [2011];
    
    my @value = (1, 2, 3); 
    $list->append(\@value);
    is $list->get(2), \@value;
}

sub pop : Tests {
    my $list = My::List->new;

    is_deeply [$list->pop(0)], [undef];
    is_deeply [$list->pop(-1)], [undef];

    $list->append("Hello");
    $list->append("World");
    $list->append(2011);
    is_deeply [$list->pop(0)], ["Hello"];
    is_deeply [$list->pop(1)], [2011];
    is_deeply [$list->get(0)], ["World"];
}

sub iterator : Tests {
    my $list = My::List->new;

    my $iter = $list->iterator;
    is_deeply [$iter->has_next], [0];

    $list->append("Hello");
    $list->append("World");
    $list->append(2011);

    $iter = $list->iterator;
    is_deeply [$iter->has_next], [1];
    is_deeply [$iter->next->value], ["Hello"];

    is_deeply [$iter->has_next], [1];
    is_deeply [$iter->next->value], ["World"];
    
    is_deeply [$iter->has_next], [1];
    is_deeply [$iter->next->value], [2011];

    is_deeply [$iter->has_next], [0];
    is_deeply [$iter->next], [undef];
	
}

__PACKAGE__->runtests;

1;
