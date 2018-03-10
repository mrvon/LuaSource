# Data validation
NF != 3 {
    print $0, "number of fields is not equal to 3"
}
$2 < 3.35 {
    print $0, "rate is below minimum wage"
}
$2 > 10 {
    print $0, "rate exceeds $10 per hour"
}
$3 < 0 {
    print $0, "negative hours worked"
}
$3 > 60 {
    print $0, "too many hours worked"
}

BEGIN {
    print "Name     RATE    HOURS";
    print "";
}
{
    print $0
}
$3 > 15 {
    emp = emp + 1
}
{
    pay = pay + $2 * $3
}
$2 > maxrate {
    maxrate = $2;
    maxemp = $1;
}
{
    names = names $1 " "
}
END {
    print emp, "employees worked more than 15 hours";
    print NR, "employees";
    print "total pay is", pay;
    print "average pay is", pay/NR;
    print "highest hourly rate:", maxrate, "for", maxemp;
    print names;
}
