package Complete::Unix;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
#use Log::Any '$log';

use Complete;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_uid
                       complete_user
                       complete_gid
                       complete_group

                       complete_pid
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Unix-related completion routines',
};

$SPEC{complete_uid} = {
    v => 1.1,
    summary => 'Complete from list of Unix UID\'s',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>['bool'] },
        etc_dir => { schema=>['str*'] },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_uid {
    require Complete::Util;
    require Unix::Passwd::File;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::OPT_CI;

    my $res = Unix::Passwd::File::list_users(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{uid}} @{ $res->[2] }],
                word=>$args{word}, ci=>$ci);
}

$SPEC{complete_user} = {
    v => 1.1,
    summary => 'Complete from list of Unix users',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>['bool'] },
        etc_dir => { schema=>['str*'] },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_user {
    require Complete::Util;
    require Unix::Passwd::File;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::OPT_CI;

    my $res = Unix::Passwd::File::list_users(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{user}} @{ $res->[2] }],
                word=>$args{word}, ci=>$ci);
}

$SPEC{complete_gid} = {
    v => 1.1,
    summary => 'Complete from list of Unix GID\'s',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>['bool'] },
        etc_dir => { schema=>['str*'] },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_gid {
    require Complete::Util;
    require Unix::Passwd::File;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::OPT_CI;

    my $res = Unix::Passwd::File::list_groups(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{gid}} @{ $res->[2] }],
                word=>$args{word}, ci=>$ci);
}

$SPEC{complete_group} = {
    v => 1.1,
    summary => 'Complete from list of Unix groups',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>['bool'] },
        etc_dir => { schema=>['str*'] },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_group {
    require Complete::Util;
    require Unix::Passwd::File;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::OPT_CI;

    my $res = Unix::Passwd::File::list_groups(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{group}} @{ $res->[2] }],
                word=>$args{word}, ci=>$ci);
}

$SPEC{complete_pid} = {
    v => 1.1,
    summary => 'Complete from list of running PIDs',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>['bool'] },
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_pid {
    require Complete::Util;
    require Proc::ProcessTable;

    state $pt = Proc::ProcessTable->new;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::OPT_CI;

    my $procs = $pt->table;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{pid}} @$procs],
                word=>$args{word}, ci=>$ci);
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete::Util>
