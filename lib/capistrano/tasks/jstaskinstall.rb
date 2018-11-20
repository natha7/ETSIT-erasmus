desc "Install saml2-node libraries"
task :saml2_node_libraries do

end

after("deploy:cleanup", "saml2_node_libraries")