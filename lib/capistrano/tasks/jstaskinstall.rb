
namespace :deploy do
  desc "Install saml2-node libraries"
  task :saml2_node_libraries do
    Terrapin::CommandLine.new("npm install;")
  end

  after("deploy:cleanup", "saml2_node_libraries")
end