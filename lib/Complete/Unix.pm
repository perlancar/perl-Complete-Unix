package Complete::Unix;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;
#use Log::Any '$log';

use Complete::Setting;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_uid
                       complete_user
                       complete_gid
                       complete_group

                       complete_pid
                       complete_proc_name
                );

our %SPEC;

our %common_args = (
    word    => { schema=>[str=>{default=>''}], pos=>0, req=>1 },
    ci      => { schema=>['bool'] },
);

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Unix-related completion routines',
};

$SPEC{complete_uid} = {
    v => 1.1,
    summary => 'Complete from list of Unix UID\'s',
    args => {
        %common_args,
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
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;

    my $res = Unix::Passwd::File::list_users(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{uid}} @{ $res->[2] }],
                word=>$word, ci=>$ci);
}

$SPEC{complete_user} = {
    v => 1.1,
    summary => 'Complete from list of Unix users',
    args => {
        %common_args,
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
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;

    my $res = Unix::Passwd::File::list_users(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{user}} @{ $res->[2] }],
                word=>$word, ci=>$ci);
}

$SPEC{complete_gid} = {
    v => 1.1,
    summary => 'Complete from list of Unix GID\'s',
    args => {
        %common_args,
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
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;

    my $res = Unix::Passwd::File::list_groups(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{gid}} @{ $res->[2] }],
                word=>$word, ci=>$ci);
}

$SPEC{complete_group} = {
    v => 1.1,
    summary => 'Complete from list of Unix groups',
    args => {
        %common_args,
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
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;

    my $res = Unix::Passwd::File::list_groups(
        etc_dir=>$args{etc_dir}, detail=>1);
    return undef unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array=>[map {$_->{group}} @{ $res->[2] }],
                word=>$word, ci=>$ci);
}

$SPEC{complete_pid} = {
    v => 1.1,
    summary => 'Complete from list of running PIDs',
    args => {
        %common_args,
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_pid {
    require Complete::Util;
    require Proc::Find;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;

    Complete::Util::complete_array_elem(
        array=>Proc::Find::find_proc(),
                word=>$word, ci=>$ci);
}

$SPEC{complete_proc_name} = {
    v => 1.1,
    summary => 'Complete from list of process names',
    args => {
        %common_args,
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_proc_name {
    require Complete::Util;
    require List::MoreUtils;
    require Proc::Find;

    my %args  = @_;
    my $word  = $args{word} // "";
    my $ci    = $args{ci} // $Complete::Setting::OPT_CI;

    Complete::Util::complete_array_elem(
        array=>[List::MoreUtils::uniq(
            grep {length}
                map { $_->{name} }
                    @{ Proc::Find::find_proc(detail=>1) })],
        word=>$word, ci=>$ci);
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete::Util>
