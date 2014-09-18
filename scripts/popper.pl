#!/usr/bin/env perl

# SET FOREIGN_KEY_CHECKS = 0;
# truncate tractor;
# truncate hook;
# truncate class;
# truncate pull;
# SET FOREIGN_KEY_CHECKS = 1;

use strict;
use warnings;

use DBI;
use Data::Maker;
use Data::Maker::Field::Set;
use Data::Maker::Field::Number;
use Data::Maker::Field::DateTime;
use Data::Maker::Field::Lorem;
use POSIX;
use List::Util qw(shuffle);

use constant PULL_COUNT => 10;
use constant MAX_CLASS_COUNT => 19;
use constant MAX_TRACTOR_COUNT => 20;

my $dbh = DBI->connect('DBI:mysql:HookKeeper', 'root', '9ClJ8Wt1') or die "Couldn't connect to database: " . DBI->errstr;

my $pull_maker = Data::Maker->new(
  record_count => PULL_COUNT,
  delimiter => "\t",
  fields => [
    {
      name => 'city',
      class => 'Data::Maker::Field::Set',
      args => {
        set => [ 'Adams','Adamsville','Alamo','Alcoa','Alexandria','Algood','Allardt','Altamont','Ardmore','Arlington','Ashland City','Athens','Atoka','Atwood','Auburntown','Baileyton','Baneberry','Bartlett','Baxter','Bean Station','Beersheba Springs','Bell Buckle','Belle Meade','Bells','Benton','Berry Hill','Bethel Springs','Big Sandy','Blaine','Bluff City','Bolivar','Braden','Bradford','Brentwood','Brighton','Bristol','Brownsville','Bruceton','Bulls Gap','Burlison','Burns','Byrdstown','Calhoun','Camden','Carthage','Caryville','Cedar Hill','Celina','Centertown','Centerville','Chapel Hill','Charleston','Charlotte','Chattanooga','Church Hill','Clarksburg','Clarksville','Cleveland','Clifton','Clinton','Coalmont','Collegedale','Collierville','Collinwood','Columbia','Cookeville','Coopertown','Copperhill','Cornersville','Cottage Grove','Covington','Cowan','Crab Orchard','Cross Plains','Crossville','Crump','Cumberland City','Cumberland Gap','Dandridge','Dayton','Decatur','Decaturville','Decherd','Dickson','Dover','Dowelltown','Doyle','Dresden','Ducktown','Dunlap','Dyer','Dyersburg','Eagleville','East Ridge','Eastview','Elizabethton','Elkton','Englewood','Enville','Erin','Erwin','Estill Springs','Ethridge','Etowah','Fairview','Farragut','Fayetteville','Finger','Forest Hills','Franklin','Friendship','Friendsville','Gadsden','Gainesboro','Gallatin','Gallaway','Garland','Gates','Gatlinburg','Germantown','Gibson','Gilt Edge','Gleason','Goodlettsville','Gordonsville','Grand Junction','Graysville','Greenback','Greenbrier','Greeneville','Greenfield','Gruetli-Laager','Guys','Halls','Harriman','Harrogate','Hartsville','Henderson','Hendersonville','Henning','Henry','Hickory Valley','Hohenwald','Hollow Rock','Hornbeak','Hornsby','Humboldt','Huntingdon','Huntland','Huntsville','Iron City','Jacksboro','Jackson','Jamestown','Jasper','Jefferson City','Jellico','Johnson City','Jonesborough','Kenton','Kimball','Kingsport','Kingston','Kingston Springs','Knoxville','Lafayette','La Follette','LaGrange','Lakeland','Lakesite','La Vergne','Lawrenceburg','Lebanon','Lenoir City','Lewisburg','Lexington','Liberty','Linden','Livingston','Lobelville','Lookout Mountain','Loretto','Loudon','Louisville','Luttrell','Lynchburg','Lynnville','Madisonville','Manchester','Martin','Maryville','Mason','Maury City','Maynardville','McEwen','McKenzie','McLemoresville','McMinnville','Medina','Medon','Memphis','Michie','Middleton','Milan','Milledgeville','Millersville','Millington','Minor Hill','Mitchellville','Monteagle','Monterey','Morrison','Morristown','Moscow','Mosheim','Mount Carmel','Mount Juliet','Mount Pleasant','Mountain City','Munford','Murfreesboro','Nashville','New Hope','New Johnsonville','New Market','New Tazewell','Newbern','Newport','Niota','Nolensville','Normandy','Norris','Oak Hill','Oak Ridge','Oakdale','Oakland','Obion','Oliver Springs','Oneida','Orlinda','Orme','Palmer','Paris','Parker\'s Crossroads','Parrottsville','Parsons','Pegram','Petersburg','Philadelphia','Pigeon Forge','Pikeville','Piperton','Pittman Center','Plainview','Pleasant Hill','Pleasant View','Portland','Powell\'s Crossroads','Pulaski','Puryear','Ramer','Red Bank','Red Boiling Springs','Ridgely','Ridgeside','Ridgetop','Ripley','Rives','Rockford','Rockwood','Rocky Top','Rogersville','Rossville','Rutherford','Rutledge','st. Joseph','saltillo','samburg','sardis','saulsbury','savannah','scotts Hill','Decatur County','selmer','sevierville','sharon','shelbyville','signal Mountain','silerton','Chester County','slayden','smithville','smyrna','sneedville','soddy-Daisy','somerville','south Carthage','south Fulton','south Pittsburg','sparta','spencer	Van','spring City','spring Hill','Maury County','springfield','stanton','stantonville','sunbright','surgoinsville','sweetwater','Tazewell','Tellico Plains','Tennessee Ridge','Thompson\'s Station','Three Way','Tiptonville','Toone','Townsend','Tracy City','Trenton','Trezevant','Trimble','Troy','Tullahoma','Tusculum','Unicoi','Union City','Vanleer','Viola','Vonore','Walden','Wartburg','Wartrace','Watauga','Watertown','Waverly','Waynesboro','Westmoreland','White Bluff','White House','White Pine','Whiteville','Whitwell','Williston','Winchester','Winfield','Woodbury','Woodland Mills','Yorkville' ]
      }
    },
    {
      name => 'noun',
      class => 'Data::Maker::Field::Set',
      args => {
        set => [ 'apple','baby','back','ball','bear','bed','bell','bird','birthday','boat','box','boy','bread','brother','cake','car','cat','chair','chicken','children','Christmas','coat','corn','cow','day','dog','doll','door','duck','egg','eye','farm','farmer','father','feet','fire','fish','floor','flower','game','garden','girl','good-bye','grass','ground','hand','head','hill','home','horse','house','kitty','leg','letter','man','men','milk','money','morning','mother','name','nest','night','paper','party','picture','pig','rabbit','rain','ring','robin','Santa Claus','school','seed','sheep','shoe','sister','snow','song','squirrel','stick','street','sun','table','thing','time','top','toy','tree','watch','water','way','wind','window','wood' ]
      }
    },
    {
      name => 'event_type',
      class => 'Data::Maker::Field::Set',
      args => {
        set => [ 'fair','carnival','fiesta','jamboree','celebrations','festivities','fest','gathering','function','get-together','affair','celebration','after-party','festivity','reception','frolic','soiree','carousal','carouse','fete','informal bash','shindig','rave','shebang','bop','hop','blast','wingding' ]
      }
    },
    { 
      name => 'date', 
      class => 'Data::Maker::Field::DateTime',
      args => {
        relative_to => 'now',
        add => { days => [0..365] },
      }
    },
    {
      name => 'class_count',
      class => 'Data::Maker::Field::Number',
      args => {
        precision => 1,
        min => 1,
        max => 19,
      }
    },
  ]
);

my $sth;
while (my $record = $pull_maker->next_record) {
  my $pull_name = ucfirst $record->city->value . ' ' . ucfirst $record->noun->value . ' ' . ucfirst $record->event_type->value;
  
  $sth = $dbh->prepare('INSERT INTO pull (name, date) VALUES (?, ?)');
  $sth->execute($pull_name, $record->date->value);
  
  my $pull_id = $sth->{mysql_insertid};

  my @classes = shuffle (
    '1050 Super Stock Garden Tractors',
    '1800 Limited Mini Rods',
    '2000 Mini Rods',
    '5500 Antique Tractors',
    '5500 Classic Tractors',
    '6000 Super Stock Tractors',
    '8000 Pro Stock Diesel Trucks',
    '8200 Super Stock Tractors',
    '8200 Limited Pro Stock',
    '9700 Super Stock Tractors',
    '6200 Four Wheel Drive Trucks',
    '6200 Two Wheel Drive Trucks',
    '5800 Modified Tractors',
    '7700 Modified Tractors',
    '9500 Pro Farm Tractors',
    '12000 Pro Farm Tractors',
    '10000 Pro Stock Tractors',
    '9300 Super Farm Tractors',
    '20000 Pro Stock Semi',
  );  
  
  my $class_count = ceil $record->class_count->value;
  
  my @random_classes = splice(@classes, 0, $class_count );
  
  foreach my $class_name (@random_classes) {
    $sth = $dbh->prepare('INSERT INTO class (name, pull_id) VALUES (?, ?)');
    $sth->execute($class_name, $pull_id);
    
    my $class_id = $sth->{mysql_insertid};
    
    my $vehicle_maker = Data::Maker->new(
      record_count => int(rand(MAX_TRACTOR_COUNT)) + 1,
      delimiter => "\t",
      fields => [
        {
          name => 'name',
          class => 'Data::Maker::Field::Lorem',
          args => {
            words => 2,
          }
        },
        {
          name => 'make',
          class => 'Data::Maker::Field::Set',
          args => {
            set => ['Ford', 'John Deere', 'Allis Chalmers', 'Peterbilt', 'Kenworth', 'Chevrolet', 'Dodge', 'Oliver', 'Case IH', 'Farmall'],
          }
        },
        {
          name => 'model',
          class => 'Data::Maker::Field::Number',
          args => {
            precision => 1,
            min => 1000,
            max => 9999,
          }
        },
      ]
    );
    
    while (my $vehicle = $vehicle_maker->next_record) {
      $sth = $dbh->prepare('INSERT INTO tractor (name, make, model, class_id) VALUES (?, ?, ?, ?)');
      $sth->execute($vehicle->name->value, $vehicle->make->value, int $vehicle->model->value, $class_id);
    }
    
  }
  
}




