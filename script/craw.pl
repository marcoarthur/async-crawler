#!/usr/bin/env perl 
use strict;
use warnings;
use lib qw(./lib);
use Async::Crawler;

my $site = $ARGV[0] || 'https://www.folha.uol.com.br/fsp';

my $ac = Async::Crawler->new(
    targets => [ $site ],
    elements => [
        {
            selector => '.c-news__body > p',
            key => 'paragraphs[]',
            attr => 'TEXT',
        },
        {
            selector => 'a',
            key => 'links[]',
            attr => '@href',
        },
    ]
);

$ac->run;
