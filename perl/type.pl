use strict;
use warnings;

my $animal = "camel";
my $answer = 42;
my $display = "You have $answer ${animal}s.\n";

my @animals = ("camel", "llama", "owl");
my @numbers = (23, 42, 69);
my @mixed = ("camel", 42, 1.23);

my $first = $animals[0];
my $second = $animals[1];

print $animal, "\n";
print @animals, "\n";
print $first, "\n";
print $second, "\n";

my $number_animals = @animals;
print "Number of numbers: ", $number_animals, "\n";
print "Number of numbers: ", scalar(@numbers), "\n";

print "We have these numbers: @numbers\n";

my @example = ('secret', 'array');
my $oops_email = "foo@example.com";
my $ok_email = 'foo@example.com';

print $oops_email, "\n";
print $ok_email, "\n";

# my %fruit_color = ("apple", "red", "banana", "yellow");
my %fruit_color = (
    apple => "red",
    banana => "yellow",
);

print %fruit_color, "\n";

print %fruit_color, "\n";

my $color = $fruit_color{apple};

print $color, "\n";
print $fruit_color{apple}, "\n";
print $fruit_color{banana}, "\n";

my @fruits = keys %fruit_color;
my @colors = values %fruit_color;
print @fruits, "\n";
print @colors, "\n";

my $fruits_ref = ["apple", "banana"];
my $colors_ref = {
    apple => "red",
    banana => "yellow",
};

print $fruits_ref->[0], "\n";
print $colors_ref->{apple}, "\n";

my @fruits_array = @$fruits_ref;
my %colors_hash = %$colors_ref;

print @fruits_array[0], "\n";
print @fruits_array[1], "\n";
print %colors_hash{apple}, "\n";
print %colors_hash{banana}, "\n";
