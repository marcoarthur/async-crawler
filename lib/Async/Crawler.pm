package Async::Crawler;

use 5.016;
use Mojo::Base -base, -signatures;
use common::sense;
use utf8::all;
use EV;
use Web::Scraper::LibXML;
use YADA;
use DDP;
use constant {MAX_LEVELS => 3,};

# sites we are crawling
has targets => sub { [] };

# html elements to be searched
# links are mandatory
has elements =>
  sub { 
    [
      {
        selector => 'a',
        key => 'links[]',
        attr => '@href',
      }
    ]
};

# handler to data collected
sub data_handler ($self, $doc) {
  # TODO: save it
  p $doc;
}

# worker
sub run($self) {
  return unless $self->targets;

  my $downloader = YADA->new(
    common_opts   => {encoding => '', followlocation => 1, maxredirs => 5,},
    http_response => 1,
    max           => 4,
  );

  $downloader->append(
    $self->targets,
    {retry => 3, opts => {verbose => 1}},
    sub {
      my $yada = shift;
      return
           if $yada->has_error
        or not $yada->response->is_success
        or not $yada->response->content_is_html;

      # Declare the scraper once and then reuse it
      state $scraper = scraper {
        for my $el (@{$self->elements}) {
          $el->{filter} ? 
          process $el->{selector}, $el->{key} => [$el->{attr} , $el->{filter}]:
          process $el->{selector}, $el->{key} => $el->{attr};
        }
      };

      # parse response data
      my $doc
        = $scraper->scrape($yada->response->decoded_content, $yada->final_url);

      # TODO: handle the data
      $self->data_handler($doc);

      # Enqueue links from the parsed page
      # The rules guarantees:
      # 1) url has a host in the same place we are crawling
      # 2) using http or https protocol
      my @links = grep {
        $_->can('host') and $_->host eq $yada->initial_url->host    #1
          and $_->scheme =~ m{^https?$}x                            #2
      } @{$doc->{links} // []};

      $yada->queue->prepend([@links] => __SUB__);
    }
  )->wait;
}

1;

__END__

Stolen from:
http://blogs.perl.org/users/stas/2013/02/web-scraping-with-modern-perl-part-2---speed-edition.html
