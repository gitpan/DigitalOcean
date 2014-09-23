#!/usr/bin/perl
use lib './lib';
use DigitalOcean;
my $do = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY});


print $_->name . "\n" for (@{$do->droplets});
exit;

my $droplet = $do->droplet(207887);

$droplet->disable_backups;

print $droplet->name . "\n";
exit;

my $do2 = DigitalOcean->new(client_id=> $ENV{CLIENT_ID}, api_key => $ENV{API_KEY}, wait_on_events => 1);

print $do->wait_on_events . "\n";

#\$do = $do2;

print $do->wait_on_events . "\n";

exit;
print $_->name . "\n" for @{$do->droplets}; 
exit;

$do->wait_on_events(1);


#my $event = $do->event(13060225);

my $droplet = $do->droplet(207887);

print "WAITING\n";
my $event = $droplet->reboot;
print "DONE\n";

print "ID " . $event->id . "\n";
print "action_status " . $event->action_status . "\n";
print "droplet_id " . $event->droplet_id . "\n";
print "event_type_id " . $event->event_type_id . "\n";
print "percentage " . $event->percentage . "\n";

if($event->complete) { 
	print "EVENT FINISHED! YAY\n";
}
else { 
	print "EVENT NOT FINISHED :( BOOOO\n";
}

exit;

for(@{$do->droplets}) {
	print $_->name . " = " . $_->id . "\n";
}

for(@{$do->sizes}) {
	print $_->name . " = " . $_->id . "\n";
}



my $droplet = $do->droplet(207887);

print $droplet->name . "\n";

#$droplet->reboot;
$droplet->snapshot_reboot;
print "NOW HERE\n";
#$droplet->power_cycle;
#$droplet->resize_reboot(size_id=>63);

#print droplets() . "\n";

#sub droplets {
#	return $do->droplets;
#}
