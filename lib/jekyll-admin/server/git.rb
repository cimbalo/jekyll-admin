require 'git'
module JekyllAdmin
  class Server < Sinatra::Base
    namespace "/git" do
      get "/status" do
        begin
          json(@@repo.status.changed do |file|
           puts file.path
          end)
        rescue Git::GitExecuteError => error
          json(error)
        end
      end

      get "/pull" do
        json @@repo.pull
      end

      get "/commit" do
        json [@@repo.add(:all => true), @@repo.commit(DateTime.now)]
      end

      get "/push" do
        json @@repo.push
      end

      get "/publish" do
        json [@@repo.add(:all => true), @@repo.commit(DateTime.now), @@repo.push]
      end
      @@repo = Git.open(JekyllAdmin.site.source)
    end
  end
end
