package WebSockets;

use Dancer ':syntax';
use Dancer::Plugin::WebSocket;
use Dancer::Plugin::Database;
use Data::Dumper;

our $w;
$w = AnyEvent->timer(after => 1, interval => 1, cb => sub {
#  debug 'timer msg';
});

get '/' => sub {
  
  template 'index', { pulls => get_pulls() };
};

get '/admin' => sub {

  template 'admin', { pulls => get_pulls(), success => 0 };
  
};

post '/admin' => sub {
  
  my $pull_id = params->{pull_id};
  my $pull_distance = params->{pull_distance};
  
  debug "$pull_id : $pull_distance";
  
  my $return = database->do("UPDATE `pulls` SET `distance` = ?, `notified` = 1 WHERE id = ?", undef, $pull_distance, $pull_id);
  debug "RETURN: $return";
  
  my $json = to_json { pull_id => $pull_id, pull_distance => $pull_distance };
  
  ws_send $json;
  
  template 'admin', { pulls => get_pulls(), success => 1 };
};

sub get_pulls {
  
  my $sth = database->prepare("SELECT * FROM `pulls`;");
  $sth->execute();
  my $pulls = $sth->fetchall_hashref(['id']);
  return $pulls;
  
}

true;