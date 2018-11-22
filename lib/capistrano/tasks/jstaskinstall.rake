
namespace :deploy do
  desc "Install saml2-node libraries"
  task :saml2_node_libraries do
    sh"npm install --prefix ./vendor/saml2-node"
  end
end

after("puma:restart", "deploy:saml2_node_libraries")