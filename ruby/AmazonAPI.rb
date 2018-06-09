#!/usr/bin/env ruby

require 'time'
require 'uri'
require 'openssl'
require 'base64'

AWS_ACCESS_KEY_ID = "YOUR-ACCESS-KEY-GOES-HERE"
AWS_SECRET_KEY = "YOUR-SECRET-KEY-GOES-HERE"
AWS_ASSOCIATES_TAG = "YOUR-ASSOCIATES-TAG-GOES-HERE"

class AmazonAPI

  ENDPOINT = "webservices.amazon.co.uk"
  REQUEST_URI = "/onca/xml"

  def generate_request_url(params)
    params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
    canonical_query_string = params.sort.collect do |key, value|
    [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")),
      URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
    end.join('&')
    string_to_sign = "GET\n#{ENDPOINT}\n#{REQUEST_URI}\n#{canonical_query_string}"
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'),
    AWS_SECRET_KEY, string_to_sign)).strip()
    request_url = "http://#{ENDPOINT}#{REQUEST_URI}?#{canonical_query_string}&Signature=#{URI.escape(signature,
    Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
  end

  def by_browsenode_and_category(browsenode, category)
    params = {
      "Service" => "AWSECommerceService",
      "Operation" => "ItemSearch",
      "AWSAccessKeyId" => AWS_ACCESS_KEY_ID,
      "AssociateTag" => AWS_ASSOCIATES_TAG,
      "SearchIndex" => category,
      "ResponseGroup" => "Offers,BrowseNodes,ItemAttributes,SalesRank",
      "BrowseNode" => browsenode
    }
    generate_request_url(params)
  end

end
