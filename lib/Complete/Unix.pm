package Complete::Unix;

use 5.010001;
use strict;
use warnings;
use Log::ger;

use Complete::Common qw(:all);
use Exporter qw(import);

# AUTHORITY
# DATE
# DIST
# VERSION

our @EXPORT_OK = qw(
                       complete_uid
                       complete_user
                       complete_gid
                       complete_group

                       complete_pid
                       complete_proc_name

                       complete_service_name
                       complete_service_port
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
        %arg_word,
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
    return unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array     => [map {$_->{uid}} @{ $res->[2] }],
        summaries => [map {$_->{user} . (length $_->{gecos} ? " ($_->{gecos})" : "") } @{ $res->[2] }],
        word=>$word);
}

$SPEC{complete_user} = {
    v => 1.1,
    summary => 'Complete from list of Unix users',
    args => {
        %arg_word,
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
    return unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array     => [map {$_->{user}} @{ $res->[2] }],
        summaries => [map {(length $_->{gecos} ? "$_->{gecos} " : "") . "(UID $_->{uid})" } @{ $res->[2] }],
        word=>$word);
}

$SPEC{complete_gid} = {
    v => 1.1,
    summary => 'Complete from list of Unix GID\'s',
    args => {
        %arg_word,
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
    return unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array     => [map {$_->{gid}} @{ $res->[2] }],
        summaries => [map {$_->{group}} @{ $res->[2] }],
        word=>$word);
}

$SPEC{complete_group} = {
    v => 1.1,
    summary => 'Complete from list of Unix groups',
    args => {
        %arg_word,
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
    return unless $res->[0] == 200;
    Complete::Util::complete_array_elem(
        array     => [map {$_->{group}} @{ $res->[2] }],
        summaries => [map {"(GID $_->{gid})"} @{ $res->[2] }],
        word=>$word);
}

$SPEC{complete_pid} = {
    v => 1.1,
    summary => 'Complete from list of running PIDs',
    args => {
        %arg_word,
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

    my $procs = Proc::Find::find_proc(detail => 1);

    Complete::Util::complete_array_elem(
        array     => [map {$_->{pid}} @$procs],
        summaries => [map {$_->{cmndline}} @$procs],
        word=>$word);
}

$SPEC{complete_proc_name} = {
    v => 1.1,
    summary => 'Complete from list of process names',
    args => {
        %arg_word,
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

    Complete::Util::complete_array_elem(
        array=>[List::MoreUtils::uniq(
            grep {length}
                map { $_->{name} }
                    @{ Proc::Find::find_proc(detail=>1) })],
        word=>$word);
}

$SPEC{complete_service_name} = {
    v => 1.1,
    summary => 'Complete from list of service names from /etc/services',
    args => {
        %arg_word,
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_service_name {
    require Parse::Services;

    my %args  = @_;
    my $word  = $args{word} // "";

    my %services;

    # from /etc/services
    {
        my $res = Parse::Services::parse_services();
        last if $res->[0] != 200;
        for my $row (@{ $res->[2] }) {
            $services{$row->{name}} = "$row->{proto} port $row->{port}".(@{$row->{aliases}} ? " (aliases: ".join(", ", @{$row->{aliases}}).")" : "");
            $services{$_} = "$row->{proto} port $row->{port} (alias for $row->{name})" for @{$row->{aliases}};
        }
    }

    require Complete::Util;
    Complete::Util::complete_hash_key(
        word => $word,
        hash => \%services,
        summaries_from_hash_values => 1,
    );
}

$SPEC{complete_service_port} = {
    v => 1.1,
    summary => 'Complete from list of service ports from /etc/services',
    args => {
        %arg_word,
    },
    result_naked => 1,
    result => {
        schema => 'array',
    },
};
sub complete_service_port {
    require Parse::Services;

    my %args  = @_;
    my $word  = $args{word} // "";

    my %services;

    # from /etc/services
    {
        my $res = Parse::Services::parse_services();
        last if $res->[0] != 200;
        for my $row (@{ $res->[2] }) {
            $services{$row->{port}} = "$row->{name}".(@{$row->{aliases}} ? "/".join("/", @{$row->{aliases}}) : "")." ($row->{proto})";
        }
    }

    require Complete::Util;
    Complete::Util::complete_hash_key(
        word => $word,
        hash => \%services,
        summaries_from_hash_values => 1,
    );
}

1;
# ABSTRACT:

=head1 DESCRIPTION


=head1 SEE ALSO

L<Complete::Util>
