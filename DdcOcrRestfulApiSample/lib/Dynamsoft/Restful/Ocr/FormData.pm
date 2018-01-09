package Dynamsoft::Restful::Ocr::FormData;

use 5.000;
use strict;
use warnings;

sub new{
	my ($class) = @_;
	
	my $self = {
		_listFormData => [],
	};
	
	bless $self, $class;
	
	return $self;
}

sub append{
	my ($self, $strKey, $value, $strFileName) = @_;
	
	push @{$self->{_listFormData}}, [$strKey, $value, $strFileName];
	
	return;
}

sub clear{
	my ($self) = @_;
	@{$self->{_listFormData}} = ();
	return;
}

sub isValid{
	my ($self) = @_;
	return ref($self->{_listFormData}) eq "ARRAY";
}

sub getAll{
	my ($self) = @_;
	return @{$self->{_listFormData}};
}

1;