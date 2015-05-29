package HookKeeper2;

use Dancer2;
use Dancer2::Plugin::Database;
use Dancer2::Plugin::Auth::Extensible;

get '/' => sub { "Hello World" };

dance;