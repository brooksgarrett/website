desc "clean"
task :clean do
  rm_rf '_site'
  FileList['**/*.bak'].clear_exclude.each do |f|
    rm_f f
  end
end

desc "build the site"
task :build do
  sh "bundle exec jekyll build"
end

desc "rebuild, then deploy to remote"
task :deploy => [ :clean, :build ] do
  sh "bundle exec s3_website push"
end
