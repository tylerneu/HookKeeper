package HookKeeper;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Data::Dumper;

get '/' => sub {
  redirect '/pulls';
};

get '/pulls' => sub {
  
	my @pulls = database->quick_select('pull', {}, { order_by => { asc => 'date' } });
  
  template 'pulls', { pulls => \@pulls };
};

post '/pulls' => sub {
  
  my $name = params->{name};
  my $date = params->{date};
  
  database->quick_insert('pull', { name => $name, date => $date });
  
  redirect '/pulls';
};

true;