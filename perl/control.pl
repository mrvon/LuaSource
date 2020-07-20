$zippy = 1;

print "Yow A!", "\n" if $zippy;
if ($zippy) {
    print "Yow B!", "\n";
}

print "Yow C!", "\n" unless $zippy;
unless ($zippy) {
    print "Yow D!", "\n";
}

my $max = 5;
for my $i (0 .. $max) {
    print "index is $i", "\n";
}

my @elements = ("hello", "world");
for my $element (@elements) {
    print $element, "\n";
}

map {print} @elements, "\n";

my %fruit_color = (
    apple => 'red',
    banana => 'yellow',
    orange => 'orange',
    watermelon => 'green',
);

foreach my $key (keys %fruit_color) {
    $value = %fruit_color{$key};
    print $key, ' : ', $value, "\n";
};

print $_, "\n" for @elements;
print $_, "\n" for keys %fruit_color;
print $_, "\n" for values %fruit_color;

$x = "hello foo foo foo world";
print $x, "\n";

$x =~ s/foo/bar/;
print $x, "\n";

$x =~ s/foo/bar/g;
print $x, "\n";

open (my $in, "<", "input") or die "Can't open input: $!";
open (my $out, ">", "output") or die "Can't open output: $!";
open (my $log, ">>", "log") or die "Can't open log: $!";

# my $line = <$in>;
my @lines = <$in>;

print $out @lines, "\n";
print $log $msg, "\n";

sub logger {
    my $logmessage = shift;
    open my $logfile, ">>", "log" or die "Cound not open my.log: $!";
    print $logfile $logmessage;
}

logger("We have a logger subroutine!");
