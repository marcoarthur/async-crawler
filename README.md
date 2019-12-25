# NAME

Async::Crawler - An async web scraper/crawler

# SYNOPSIS

    #!/usr/bin/env perl 
    use Async::Crawler;

    my $ac = Async::Crawler->new(
        targets => [ 'https://example.com/' ],
        elements => [
            {
                selector => 'p',
                key => 'paragraphs[]',
                attr => 'TEXT',
            },
            {
                selector => 'a',
                key => 'links[]',
                attr => '@href',
                filter => sub { s/www/w3/ },
            },
        ]
    );

    $ac->run;

# DESCRIPTION

This crawl the target and by default print what it takes.

# ATTRIBUTES

## elements \[ {} \]

HTML Elements you want to select. Accepts a list of hashrefs. 

the selector, the key where this data will be saved, any attribute to be extracted
(text, href, src, etc..) and optionally the filter used to process the data

## targets

The sites to run against.

# METHODS

## data\_handler

Overwrite this to save the data found. The data will be passed as an argument.

## run

fires the process.

# AUTHOR

Marco Arthur

# COPYRIGHT AND LICENSE

Same as perl itself.

# SEE ALSO

This was mostly stolen from:
[http://blogs.perl.org/users/stas/2013/02/web-scraping-with-modern-perl-part-2---speed-edition.html](http://blogs.perl.org/users/stas/2013/02/web-scraping-with-modern-perl-part-2---speed-edition.html)
