# Function: dotenv

module Puppet::Parser::Functions
  newfunction(:dotenv, type: :rvalue, doc: <<-EOS
Convert a Puppet hash into a dotenv-format file contents string
EOS
  ) do |argv|
    if argv.empty? || !argv[0].is_a?(Hash)
      raise(Puppet::ParseError, 'dotenv(): requires a hash argument')
    end
    if argv.size > 2
      raise(Puppet::ParseError, 'dotenv(): too many arguments')
    end

    quoting_style = argv[1] || 'double'
    dotenv_format_value = lambda do |value|
      string = value.to_s

      case quoting_style
      when 'double'
        escaped = string.gsub('\\', '\\\\').gsub('"', '\"')
        "\"#{escaped}\""
      when 'single'
        if string.include?("'")
          escaped = string.gsub('\\', '\\\\').gsub('"', '\"')
          "\"#{escaped}\""
        else
          "'#{string}'"
        end
      else
        raise(Puppet::ParseError, 'dotenv(): quoting_style must be "single" or "double"')
      end
    end

    lines = []
    lines << '# Managed by Puppet' << nil

    argv[0].each do |key, val|
      lines << "#{key}=#{dotenv_format_value.call(val)}"
    end

    lines << nil
    return lines.join("\n")
  end
end

# vim: ts=2 sw=2 et
