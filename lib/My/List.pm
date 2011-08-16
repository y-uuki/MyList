package My::List;
use strict;
use warnings;


sub _new_item {
    return {value => undef, next => undef};
}

sub new {
    my ($class) = @_;

    my $data_structure = {
	length => 0,
	cur_item => undef,
	items => undef,
    };


    my $self = bless $data_structure, $class;
    return $self;
}

sub append {
    my ($self, $data) = @_;
   
    if (defined $self->{cur_item}) { 
	$self->{cur_item} = My::List::Item->new(\$data, $self->{cur_item}, undef);
	$self->{cur_item}->prev->set_next($self->{cur_item});
    } else {
	$self->{items} = My::List::Item->new(\$data, $self->{cur_item}, undef);
	# リストの先頭をポイントする
	$self->{cur_item} = $self->{items};
    }    
    $self->{length}++;
    return undef;
}

sub get {
    my ($self, $index) = @_;

    return undef if ($index < 0);
    return undef if ($self->{length} == 0);
    return undef if ($index > ($self->{length} - 1));

    my $target = $self->{items};
    if ($index > 0) {
	foreach (1 .. $index) {
	    $target = $target->next;
	}
    }
    return $target->value;
}

sub get_length {
    my ($self) = @_;

    return $self->{length};
}

sub pop {
    my ($self, $index) = @_;
    
    return undef if ($index < 0);
    return undef if ($self->{length} == 0);
    return undef if ($index >= $self->{length});

    if ($index == 0) {
	my $target = $self->{items};
	$self->{items} = $self->{items}->next;
	$self->{length}--;
	return $target->value;
    }

    # popしたい要素まで進める
    my $target = $self->{items};
    foreach (1 .. $index) {
	$target = $target->next;
    }

    $target->prev->set_next($target->next) if (defined $target->prev);
    $target->next->set_prev($target->prev) if (defined $target->next);
    $self->{length}--;
    my $value = $target->value;
    $target = undef;
    return $value;
}

sub iterator {
    my ($self) = @_;

    my $iter = My::List::Iterator->new($self->{items});
    return $iter;
}


{ package My::List::Iterator;
    sub new {
	my ($class, $item) = @_;

	my $data_structure = {
	    cur_item => $item,
	};
	my $self = bless $data_structure, $class;
	return $self;
    }

    sub has_next {
	my ($self) = @_;
	
	if ($self->{cur_item}) {
	    return 1;
	} else {
	    return 0;;
	}
    }
    
    sub next {
	my ($self) = @_;
 
	return undef if (not defined $self->{cur_item});

	my $item = $self->{cur_item};	
	$self->{cur_item} = $self->{cur_item}->next;

	return $item;
    }

}

{ package My::List::Item;
    sub new {
	my ($class, $value, $prev, $next) = @_;

	my $data_structure = {
	    value => $value,
	    prev => $prev,
	    next => $next,
	};
	return bless $data_structure, $class;
    }

    sub value {
	my ($self) = @_;

	return ${ $self->{value} };
    }
    
    sub next {
	my ($self) = @_;

	return $self->{next};
    }

    sub prev {
	my ($self) = @_;

	return $self->{prev};
    }

    sub set_next {
	my ($self, $item) = @_;

	$self->{next} = $item;
	return undef;
    }

    sub set_prev {
	my ($self, $item) = @_;

	$self->{prev} = $item;
	return undef;
    }
}

1;
