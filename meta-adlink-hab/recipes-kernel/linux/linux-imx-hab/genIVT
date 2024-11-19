#! /usr/bin/perl -w
use strict;

if ( @ARGV != 2 ) {
	print "\nUsage: $0 <loadaadr> <aligned_image_size>\n\n";
	exit;
}

my $loadaddr = hex(shift);
my $img_size = hex(shift);

my $entry = $loadaddr + 0x1000;
my $ivt_addr = $loadaddr + $img_size;
my $csf_addr = $ivt_addr + 0x20;

open(my $out, '>:raw', 'ivt.bin') or die "Unable to open: $!";
print $out pack("V", 0x412000D1); # IVT Header
print $out pack("V", $entry); # Jump Location
print $out pack("V", 0x0); # Reserved
print $out pack("V", 0x0); # DCD pointer
print $out pack("V", 0x0); # Boot Data
print $out pack("V", $ivt_addr); # Self Pointer
print $out pack("V", $csf_addr); # CSF Pointer
print $out pack("V", 0x0); # Reserved
close($out);