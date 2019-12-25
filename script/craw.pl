#!/usr/bin/env perl 
use strict;
use warnings;
use lib qw(./lib);
use Async::Crawler;

my $ac = Async::Crawler->new(
    targets => [ 'https://www.folha.uol.com.br/fsp' ],
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
