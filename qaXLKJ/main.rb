exit if no?("继续之前请确认 Dotenv 已经安装！[y/n]: ")

def source_paths
  Array(super) +
  [File.expand_path('../templates', __FILE__)]
end

append_to_file '.env.template' do
  <<-EOS.strip_heredoc
    #{app_name.upcase}_DATABASE_HOST=127.0.0.1
    #{app_name.upcase}_DATABASE_USERNAME=root
    #{app_name.upcase}_DATABASE_PASSWORD=
  EOS
end

run 'cp .env.template .env.development.local'

template 'mysql.yml.tt', 'config/database.yml'

rails_command "db:create"
rails_command "db:migrate"

git add: "."
git commit: %Q<-m 'MySQL Config'>