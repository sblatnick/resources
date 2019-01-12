require "base64"

module Puppet::Parser::Functions
  newfunction(:p12_restructure, :type => :rvalue) do |argv|
    hash = argv[0]
    result = Hash.new
    if not hash.is_a? Hash
      raise Puppet::Error.new("p12_restructure: argument must be a Hash")
    end
    hash.each do |key, value|
      result[key] = {"content" => Base64.decode64(value)}
    end
    return result
  end
end
