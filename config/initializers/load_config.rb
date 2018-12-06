require 'json'
APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")
RELATIVE_URL = "/erasmus"
REQUESTED_EIDAS_ATTRS = JSON.parse(File.read(Rails.root + 'vendor/saml2-node/requested_attributes.json'))
 