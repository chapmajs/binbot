#!/usr/bin/perl

# BinRev IRC stats collector
# 2014 systems_glitch
#
# Based on the (broken) Munin ircu plugin.

use strict;
use warnings;
use Net::IRC;

my $irc = new Net::IRC;
my $conn = $irc->newconn(Nick => 'statsbot',
			 Server => 'irc.binrev.net');

my %result;

sub luserclient {
  my($self, $event) = @_;
  if(($event->args)[1] =~  /There are (\d+) users and (\d+) invisible on (\d+) servers/) {
    $result{'clients'} = $1 + $2 - 1; # don't count this script
    $result{'servers'} = $3;
  }
}

sub luserchannels {
  my($self, $event) = @_;
  if(($event->args)[1] =~  /^(\d+)/) {
    $result{'channels'} = $1 - 1; # off by one error?
  }
}

sub quit {
  my($self, $event) = @_;
  open(STDERR, ">/dev/null");
  $self->quit();
  open INDEX_TEMPLATE, "binrev_index.html.template";
  open INDEX_OUTPUT, ">", "index.html";

  while (<INDEX_TEMPLATE>) {
    $_ =~ s/NUM_USERS/$result{'clients'}/g;
    $_ =~ s/NUM_CHANNELS/$result{'channels'}/g;
    print INDEX_OUTPUT $_;
  }

  close INDEX_TEMPLATE;
  close INDEX_OUTPUT;
}

$conn->add_global_handler('endofmotd', \&quit);
$conn->add_global_handler('luserclient', \&luserclient);
$conn->add_global_handler('luserchannels', \&luserchannels);


while(1) {
    $irc->do_one_loop();
}		 

