package HookKeeper;

use Dancer ':syntax';
use Dancer::Plugin::Database;
use Dancer::Plugin::CRUD;
use Data::Dumper;

# prepare_serializer_for_format;

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
    my @classes = database->quick_select('class', { pull_id => captures()->{'pull_id'}});
    template 'pull', { pull => $pull, classes => \@classes };
  },
  update => sub {
    
  },
  delete => sub {
    database->quick_delete('pull', { id => captures()->{'pull_id'}});
  };
  
resource 'class' => 
  create => sub {
    database->quick_insert('class', { name => params->{name}, pull_id => params->{pull_id} });    
    redirect "/pull/".params->{pull_id};
  },
  delete => sub {
    database->quick_delete('class', { id => captures()->{'class_id'}});
  },
  read => sub {
    my $class = database->quick_select('class', { id => captures()->{'class_id'}});
    my $pull = database->quick_select('pull', { id => $class->{'pull_id'}});
    my @tractors = database->quick_select('tractor', { class_id => captures()->{'class_id'}});
    template 'class', { class => $class, pull => $pull, tractors => \@tractors };
  };
  
resource 'tractor' => 
  create => sub {
    database->quick_insert('tractor', { name => params->{name}, make => params->{make}, model => params->{model}, class_id => params->{class_id} });    
    redirect "/class/".params->{class_id};
  },
  delete => sub {
    database->quick_delete('tractor', { id => captures()->{'tractor_id'}});
  };

true;