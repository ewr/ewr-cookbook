name             "ewr"
maintainer       "Eric Richardson"
maintainer_email "e@ewr.is"
license          "BSD"
description      "Installs/Configures services used at ewr.is"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.15"

depends "nginx_passenger"
depends "apt"
depends "lifeguard"