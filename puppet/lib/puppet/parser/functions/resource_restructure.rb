
module Puppet::Parser::Functions
  newfunction(:resource_restructure, :type => :rvalue) do |argv|
    hash = argv[0]
    property = argv[1]
    result = Hash.new
    if not hash.is_a? Hash
      raise Puppet::Error.new("resource_restructure: argument must be a Hash")
    end
    hash.each do |key, value|
      result[key] = Hash[property, value]
    end
    return result
  end
end
