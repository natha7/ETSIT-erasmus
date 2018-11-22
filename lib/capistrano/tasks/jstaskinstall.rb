
namespace :deploy do
  desc "Install saml2-node libraries"
  task :saml2_node_libraries do
    Terrapin::CommandLine.new("npm install;")
  end
end

after("deploy:cleanup", "deploy:saml2_node_libraries")