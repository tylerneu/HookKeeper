#!/usr/bin/env perl

use strict;
use warnings;

use AnyEvent;

my $cv = AnyEvent->condvar;

print ">> Water boiling...\n";

my $water = AnyEvent->timer( after => 10, cb => sub {
  print ">> Water boiled\n";
  print ">> Potatoes being prepared\n";
  my $potatoes; $potatoes = AnyEvent->time( after => 30, cd => sub {
    undef $potatoes;
    print "<< Potatoes ready!\n";
  });
});

$cv->recv;