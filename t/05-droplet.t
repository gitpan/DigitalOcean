#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

unless($ENV{API_KEY} and $ENV{CLIENT_ID}) {
	plan skip_all => 'API_KEY and CLIENT_ID not set';
}
else {
	plan tests => 16;
}

use_ok( 'DigitalOcean' ) || print "Bail out!\n";

my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);

my $sizes = $do->sizes;
my $regions = $do->regions;
my $images = $do->images;

my $size_id = $sizes->[0]->id;
my $resize_id = $sizes->[1]->id;
my $region_id = $regions->[0]->id;

#get last image since user created images come first in array
#and may not be available in the region we chose
my $image_id = $images->[-1]->id;

my $droplet_name = 'test-' . time() . '-' . int(rand(100));

my $droplet = $do->create_droplet(
	name => $droplet_name,
    size_id => $size_id,
    image_id => $image_id,
    region_id => $region_id,
);

isa_ok($droplet, 'DigitalOcean::Droplet');

#reboot
ok(($droplet->reboot)->isa("DigitalOcean::Event"), 'Droplet sucessfully rebooted');

#power cycle
ok(($droplet->power_cycle)->isa("DigitalOcean::Event"), 'Droplet sucessfully power cycled');

#shutdown and power on
ok(($droplet->shutdown)->isa("DigitalOcean::Event"), 'Droplet sucessfully shut down');

ok(($droplet->power_on)->isa("DigitalOcean::Event"), 'Droplet sucessfully powered on');

#power off and power on
ok(($droplet->power_off)->isa("DigitalOcean::Event"), 'Droplet sucessfully powered off');

ok(($droplet->power_on)->isa("DigitalOcean::Event"), 'Droplet sucessfully powered on');

#reset password
ok(($droplet->password_reset)->isa("DigitalOcean::Event"), 'Password reset sucessfully');

#resize droplet
ok(($droplet->resize_reboot(size_id => $resize_id))->isa("DigitalOcean::Event"), 'Droplet successfully resized');

#snapshot
ok(($droplet->snapshot_reboot)->isa("DigitalOcean::Event"), 'Snapshot successfully taken');

my $snapshot_id = @{$droplet->snapshots}[0]->{id};
my $image_to_del = $do->image($snapshot_id);
$image_to_del->destroy;

#restore
ok(($droplet->restore(image_id => $image_id))->isa("DigitalOcean::Event"), 'Droplet successfully restored');

#rebuild
ok(($droplet->rebuild(image_id => $image_id))->isa("DigitalOcean::Event"), 'Droplet successfully rebuilt');

#rename
my $new_droplet_name = "new-$droplet_name";
ok(($droplet->rename(name => $new_droplet_name))->isa("DigitalOcean::Event"), 'Droplet successfully renamed');
ok($droplet->name eq $new_droplet_name, 'Droplet new name matches');

ok(($droplet->destroy)->isa("DigitalOcean::Event"), 'Droplet sucessfully destroyed');
