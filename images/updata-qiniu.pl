#!/usr/bin/env perl

use strict;
use warnings;

foreach my $doc (@ARGV) {
    open FHD, "<$doc"     or die "Can not open the file: $doc\n";
    open IN,  ">$doc.bak" or die "Can not open the file: $doc.bak\n";

    while (<FHD>) {
        chomp;
        my $line = $_;
        if ( $line =~ /\!\[[\D\d]+\]\(([\D\d]+)\)/ ) {
            my $file_name = time;
            my $url       = $1;
            `wget $1 -O ./$file_name`;
            `qboxrsctl put -c blog $file_name ./$file_name`;
            `rm -f $file_name`;
            $line =~
              s/\!\[([\D\d]+)\]\(([\D\d]+)\)/\!\[$1\]\(http:\/\/7xjv88\.com1\.z0\.glb\.clouddn\.com\/$file_name\)/;
        }
        print IN $line . "\n";
    }
    close FHD;
    close IN;
    `mv $doc.bak $doc`;
}
