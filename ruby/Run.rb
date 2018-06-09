#!/usr/bin/env ruby

require './AmazonAPI'
require './Product'
require 'HTTParty'

browsenode = "318949011"
category = "SportingGoods"

search = AmazonAPI.new
url = search.by_browsenode_and_category(browsenode,category)
results = HTTParty.get(url)

first_matching_item_hash = results["ItemSearchResponse"]["Items"]["Item"][1]
matching_product = Product.new_from_hash(first_matching_item_hash)

matching_product.display
