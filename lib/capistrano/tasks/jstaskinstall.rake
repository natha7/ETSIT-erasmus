
namespace :deploy do
  desc "Install saml2-node libraries"
  task :saml2_node_libraries do
    execute "cd vendor/saml2-node; npm install"
  end
end

after("puma:restart", "deploy:saml2_node_libraries")