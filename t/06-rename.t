#!perl

use lib qw(t/lib);

use Test::Base;
use Catalyst::Model::MogileFS::Client;
use Test::Catalyst::Model::MogileFS::Client::Utils;

plan tests => 4;

my $utils = Test::Catalyst::Model::MogileFS::Client::Utils->new;

{
		$utils->create_domain_unless_exists;

		my $key = 'test.key';
		my $to_key = 'test.alter.key';
		my $content = 'foo bar baz';

		my $mogile = Catalyst::Model::MogileFS::Client->new({
				domain => $utils->domain,
				hosts => $utils->hosts
		});

		my $bytes = $mogile->store_content($key, $utils->class, $content);

		ok($mogile->rename($key, $to_key), 'rename');

		$mogile->rename($key, $to_key);
		is($mogile->errcode, 'unknown_key', 'errcode check');

		ok($mogile->delete($key), 'delete file');
		ok($mogile->delete($to_key), 'delete file');

		$utils->delete_domain;
}
