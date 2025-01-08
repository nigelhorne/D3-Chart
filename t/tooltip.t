#!/usr/bin/env perl

use warnings;
use strict;

use HTML::D3;
use Test::HTML::T5;
use Test::Most tests => 13;

# Test object creation
my $chart = HTML::D3->new(
	width => 800,
	height => 600,
	title => 'Monthly Revenue Trends (With Tooltips)',
);

my $data = [
	['January', 1000],
	['February', 1200],
	['March', 950],
	['April', 1100],
	['May', 1250],
];

isa_ok($chart, 'HTML::D3', 'Chart object is created');

# Check default values
is($chart->{width}, 800, 'Width is set correctly');
is($chart->{height}, 600, 'Height is set correctly');
is($chart->{title}, 'Monthly Revenue Trends (With Tooltips)', 'Title is set correctly');

# Test chart rendering
my $html;
lives_ok { $html = $chart->render_line_chart_with_tooltips($data) } 'Tooltip chart renders without error';
like($html, qr/<svg id="chart"/, 'HTML contains SVG element for chart');
like($html, qr/January/, 'HTML contains data label');
like($html, qr/1000/, 'HTML contains data value');

like($html, qr/<html/, 'Output contains <html> tag for HTML format');
html_tidy_ok($html, 'Output is valid HTML');
like($html, qr/Monthly Revenue .+<\/h1>/, 'Title is included');
like($html, qr/<div class="tooltip" id="tooltip">/, 'Tooltips included');

# Test for invalid data
throws_ok {
	$chart->render_line_chart_with_tooltips('Invalid data');
} qr/Data must be an array of arrays/, 'Dies on invalid data';
