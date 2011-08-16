#! /usr/bin/env perl
# -*- coding: utf-8 -*-

use strict;
use warnings;
use My::List;

my $list = My::List->new;

$list->append("Hello");
$list->append("World");
$list->append(2011);

$list->pop(0);
$list->pop(1);
$list->get(0);

my $iter = $list->iterator;
while ($iter->has_next) {
    print $iter->next->value;
}

