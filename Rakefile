require 'bundler'
Bundler::GemHelper.install_tasks

# Example session:
# [1] pry(main)> mod = What::Modules::Disk.new({}, nil)
# => #<Celluloid::ActorProxy(What::Modules::Disk:0x3fe77443812c) ... >
# [2] pry(main)> mod.check
# => {"size"=>"391Gi",
#  "used"=>"251Gi",
#  "avail"=>"139Gi",
#  "use%"=>65,
#  "warning%"=>90,
#  "alert%"=>99,
#  "regexp"=>"/$"}
# [3] pry(main)> mod.status
# => {"type"=>"disk",
#  "health"=>"ok",
#  "details"=>
#   {"size"=>"391Gi",
#    "used"=>"251Gi",
#    "avail"=>"139Gi",
#    "use%"=>65,
#    "warning%"=>90,
#    "alert%"=>99,
#    "regexp"=>"/$"}}
desc "Start a REPL with all Bunch modules loaded"
task :repl do
  require "pry"
  require "what"
  What::Modules.load_all
  Pry.start
end
