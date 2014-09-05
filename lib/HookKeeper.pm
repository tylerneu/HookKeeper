package HookKeeper;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::CRUD;
use Data::Dumper;

get '/' => sub {
  redirect '/pulls';
};

resource 'pull(s)' =>
  index  => sub {
    my @pulls = database->quick_select('pull', {}, { order_by => { asc => 'date' } });
    template 'pulls', { pulls => \@pulls };
  },
  create => sub {
    my $name = params->{name};
    my $date = params->{date};
    database->quick_insert('pull', { name => $name, date => $date });    
    redirect '/pulls';
  },
  read => sub {
    my $pull = database->quick_select('pull', { id => captures()->{'pull_id'}});
    template 'pull', { pull => $pull };
  },
  delete => sub {
    database->quick_delete('pull', { id => captures()->{'pull_id'}});
  };

true;