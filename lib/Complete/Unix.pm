package Complete::Unix;

use 5.010001;
use strict;
use warnings;
#use Log::Any '$log';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_uid
                       complete_user
                       complete_gid
                       complete_group

                       complete_pid
               );

# DATE
# VERSION

our %SPEC;

$SPEC{complete_uid} = {
    v => 1.1,
    summary => 'Complete from list of Unix UID\'s',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>[bool=>{default=>0}] },
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

    my $res = Unix::Passwd::File::list_users(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{uid}} @{ $res->[2] }],
                word=>$args{word}, ci=>$args{ci});
}

$SPEC{complete_user} = {
    v => 1.1,
    summary => 'Complete from list of Unix users',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>[bool=>{default=>0}] },
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

    my $res = Unix::Passwd::File::list_users(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{user}} @{ $res->[2] }],
                word=>$args{word}, ci=>$args{ci});
}

$SPEC{complete_gid} = {
    v => 1.1,
    summary => 'Complete from list of Unix GID\'s',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>[bool=>{default=>0}] },
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

    my $res = Unix::Passwd::File::list_groups(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{gid}} @{ $res->[2] }],
                word=>$args{word}, ci=>$args{ci});
}

$SPEC{complete_group} = {
    v => 1.1,
    summary => 'Complete from list of Unix groups',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>[bool=>{default=>0}] },
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

    my $res = Unix::Passwd::File::list_groups(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{group}} @{ $res->[2] }],
                word=>$args{word}, ci=>$args{ci});
}

$SPEC{complete_pid} = {
    v => 1.1,
    summary => 'Complete from list of running PIDs',
    args => {
        word    => { schema=>[str=>{default=>''}], pos=>0 },
        ci      => { schema=>[bool=>{default=>0}] },
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

    my $procs = $pt->table;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{pid}} @$procs],
                word=>$args{word}, ci=>$args{ci});
}

1;
# ABSTRACT: Unix-related completion routines

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete::Util>
