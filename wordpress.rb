# Installation d'Apache
include_recipe 'apache2'

# Installation de MySQL et création d'une base de données et d'un utilisateur pour WordPress
include_recipe 'mysql2_chef_gem'
include_recipe 'database'
mysql_service 'default' do
  initial_root_password 'votre_mot_de_passe_ic'
  action [:create, :start]
end
mysql_database 'wordpress' do
  connection(
    :host => 'localhost',
    :username => 'root',
    :password => 'votre_mot_de_passe_ic'
  )
  action :create
end
mysql_database_user 'wordpressuser' do
  connection(
    :host => 'localhost',
    :username => 'root',
    :password => 'votre_mot_de_passe_ic'
  )
  password 'votre_mot_de_passe_wordpress_ic'
  database_name 'wordpress'
  action [:create, :grant]
end

# Installation de PHP et des modules requis pour WordPress
include_recipe 'php'
include_recipe 'php::module_mysql'
include_recipe 'php::module_gd'
include_recipe 'php::module_curl'

# Installation de WordPress
include_recipe 'wordpress'

# Configuration d'Apache pour servir WordPress
web_app 'wordpress' do
  server_name 'wordpress.domain'
  server_aliases ['www.wordpress.domain']
  docroot '/var/www/wordpress'
  allow_override 'All'
  directory_options 'Indexes FollowSymLinks'
end
