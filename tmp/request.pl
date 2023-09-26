#!/usr/bin/perl

# Original command
my $original_command = "ls$IFS-l";

# Encode the command in hexadecimal
my $encoded_command = unpack('H*', $original_command);

# Print the encoded command
print $encoded_command;
