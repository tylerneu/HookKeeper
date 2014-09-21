#!/usr/bin/env perl

use strict;
use warnings;

use Crypt::SaltedHash;
use DBI;

my $username = 'tneu';
my $password = 'tneu';

my $csh = Crypt::SaltedHash->new(algorithm => 'SHA-1');
$csh->add($password);
my $salted = $csh->generate;

my $dbh = DBI->connect('DBI:mysql:HookKeeper', 'root', '9ClJ8Wt1') or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare('INSERT INTO users (username, password) VALUES (?, ?)');
$sth->execute($username, $salted);
my $user_id = $sth->{mysql_insertid};

$sth = $dbh->prepare('INSERT INTO user_roles (user_id, role_id) VALUES (?, ?)');
$sth->execute($user_id, 1);