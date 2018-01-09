#!/usr/bin/perl

use 5.000;
use strict;
use warnings;

use File::Slurp; 
use JSON;

use File::Basename qw(dirname);
use Cwd qw(abs_path);
use File::Spec;
use lib File::Spec->catdir(((dirname abs_path $0), "lib"));
use Dynamsoft::Restful::Ocr::Comm;
use Dynamsoft::Restful::Ocr::FormData;
use Dynamsoft::Restful::Ocr::HttpMultiPartRequest;

# sample entry
sub main{
	# setup ocr url and api key
	my $configFile = File::Spec->catfile(((dirname abs_path $0)), "config.json");
	my $configPropsText = read_file($configFile);
	my $configProps = decode_json($configPropsText);
	my %dicHeader = ("x-api-key" => $configProps->{"apiKey"});
	my $strOcrBaseUri = $configProps->{"ocrBaseUri"};
	
	# 1. upload file
	Dynamsoft::Restful::Ocr::Comm->printLine("-----------------------------------------------------------------------");
	Dynamsoft::Restful::Ocr::Comm->printLine("1. Upload file...");
	
	my $formData = Dynamsoft::Restful::Ocr::FormData->new();
	$formData->append("method", $Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"upload"});	
	$formData->append("file", File::Spec->catfile(((dirname abs_path $0), "data"), "example.jpg"), "example.jpg");
	
	my ($httpWebResponse, $restfulApiResponse, $strFileName);	
	
	my $strCode = q|
		$httpWebResponse = Dynamsoft::Restful::Ocr::HttpMultiPartRequest->post($strOcrBaseUri, \%dicHeader, $formData);
		$restfulApiResponse = Dynamsoft::Restful::Ocr::Comm->parseHttpWebResponseToRestfulApiResult($httpWebResponse, 
			$Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"upload"});
		$strFileName = Dynamsoft::Restful::Ocr::Comm->handleRestfulApiResponse($restfulApiResponse, 
			$Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"upload"});		
	|;
	
	unless(eval($strCode)){
		Dynamsoft::Restful::Ocr::Comm->printLine($@);
		return;
	}
	
	if(!defined $strFileName) {
		return;
	}
	
	# 2. recognize the uploaded file
	Dynamsoft::Restful::Ocr::Comm->printLine("");
	Dynamsoft::Restful::Ocr::Comm->printLine("-----------------------------------------------------------------------");
	Dynamsoft::Restful::Ocr::Comm->printLine("2. Recognize the uploaded file...");
	
	$formData->clear;
	$formData->append("method", $Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"recognize"});
	$formData->append("file_name", $strFileName);
	$formData->append("language", "eng");
	$formData->append("output_format", "UFormattedTxt");
	$formData->append("page_range", "1-10");
	
	$strCode = q|
		$httpWebResponse = Dynamsoft::Restful::Ocr::HttpMultiPartRequest->post($strOcrBaseUri, \%dicHeader, $formData);
		$restfulApiResponse = Dynamsoft::Restful::Ocr::Comm->parseHttpWebResponseToRestfulApiResult($httpWebResponse, 
			$Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"recognize"});
		$strFileName = Dynamsoft::Restful::Ocr::Comm->handleRestfulApiResponse($restfulApiResponse, 
			$Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"recognize"});		
	|;
	
	unless(eval($strCode)){
		Dynamsoft::Restful::Ocr::Comm->printLine($@);
		return;
	}
	
	if(!defined $strFileName) {
		return;
	}
	
	# 3. download the recognized file
	Dynamsoft::Restful::Ocr::Comm->printLine("");
	Dynamsoft::Restful::Ocr::Comm->printLine("-----------------------------------------------------------------------");
	Dynamsoft::Restful::Ocr::Comm->printLine("3. Download the recognized file...");
	
	$formData->clear;
	$formData->append("method", $Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"download"});
	$formData->append("file_name", $strFileName);
	
	$strCode = q|
		$httpWebResponse = Dynamsoft::Restful::Ocr::HttpMultiPartRequest->post($strOcrBaseUri, \%dicHeader, $formData);
		$restfulApiResponse = Dynamsoft::Restful::Ocr::Comm->parseHttpWebResponseToRestfulApiResult($httpWebResponse, 
			$Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"download"});
		$strFileName = Dynamsoft::Restful::Ocr::Comm->handleRestfulApiResponse($restfulApiResponse, 
			$Dynamsoft::Restful::Ocr::Comm::enumOcrFileMethod{"download"});
	|;

	unless(eval($strCode)){
		Dynamsoft::Restful::Ocr::Comm->printLine($@);
	}
	
	return;
}

main;


