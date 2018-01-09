package Dynamsoft::Restful::Ocr::HttpMultiPartRequest;

use 5.000;
use strict;
use warnings;

use HTTP::Request::Common;
use LWP::UserAgent;

# post multi-part form data
sub post{
	my ($class, $strUrl, $dicHeaderRef, $formDataRef) = @_;
	
	if(!defined $strUrl){
		die "Url is invalid.";
	}
	
	# setup request headers
	my $strBoundary = "DdcOrcRestfulApiSample" . (join '', map int rand 10, 1..6);	
	my @headers = (Content_Type => "multipart/form-data; " . $strBoundary);
	if(ref($dicHeaderRef) eq "HASH"){
		while(my($k, $v) = each %{$dicHeaderRef}) {
			push @headers, $k => $v;
		}
	}	

	# setup request content
	my $requestContent = [];
	if(defined $formDataRef and $formDataRef->isValid){
		foreach my $formDataItem ($formDataRef->getAll) {
			my ($strKey, $value, $strFileName) = @{$formDataItem};
			
			$strKey = defined $strKey ? $strKey : "";
			$value = defined $value ? $value : "";
			
			# write file data
			if(defined $strFileName){
				if(-f $value){
					push @{$requestContent}, $strKey => [$value, $strFileName, "Content-Type" => "application/octet-stream"];
				}
				else{
					push @{$requestContent}, $strKey => [undef, $strFileName, "Content-Type" => "text/plain", Content => $value];	
				}				
			}
			# write key value pair
			else
			{
				push @{$requestContent}, $strKey => $value;
			}
		}
	}

	# post request and get response
	my $ua = LWP::UserAgent->new;
	my $request = POST $strUrl, @headers, Content => $requestContent;	
	my $response = $ua->request($request);	
	
	die $response->message unless $response->is_success( );
	
	return $response;
}


1;