# @summary dotenv defined type
# @param entries Specifies the key value pairs for the dotenv file
# @param ensure Whether the file should exist or not.
# @param path Path for the file to be created
# @param force Perform the file operation even if it will destroy one or more directories.  
# @param mode The desired permissions mode for the file, in symbolic or numeric notation. 
# This value must be specified as a string; do not use un-quoted numbers to represent file modes.
# @param owner The user to whom the file should belong. Argument can be a user name or a user ID.
# @param group Which group should own the file. Argument can be either a group name or a group ID.
# @param quoting_style Quote values with either single or double quotes.
#
# Defined file-like type to manage .env files
#
# @example
#   dotenv { '/var/www/mpab/.env':
#     mode    => '0400',
#     owner   => 'www-data',
#     group   => 'www-data',
#     entries => {
#       'APP_NAME' => 'M-Pab',
#       'APP_DESC' => 'Mental Pabulum',
#     },
#   }

# dotenv defined type
define dotenv (
  Hash                       $entries,
  Enum['present', 'absent']  $ensure  = 'present',
  Stdlib::Absolutepath       $path    = $name,
  Boolean                    $force   = false,
  Optional[Stdlib::Filemode] $mode    = undef,
  Optional[String[1]]        $owner   = undef,
  Optional[String[1]]        $group   = undef,
  Enum['single', 'double']   $quoting_style = 'double',
) {
  file { $name:
    ensure  => $ensure,
    path    => $path,
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    force   => $force,
    content => dotenv($entries, $quoting_style),
  }
}

# vim: ts=2 sw=2 et
