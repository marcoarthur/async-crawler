#!/usr/bin/env perl 
use strict;
use warnings;
use lib qw(./lib);
use Async::Crawler;

my $as = Async::Crawler->new(
    targets => [ @ARGV ],
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

$as->run;
