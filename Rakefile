require 'yaml'

CONFIG = YAML.load_file('build.yml')

task default: :specs

def system_or_exit(cmd, stdout = nil)
  puts "Executing #{cmd}"
  cmd += " >#{stdout}" if stdout
  system(cmd) || fail('******** Build failed ********')
end

def destination_platform
  specs_config = CONFIG["Specs"]
  platform = specs_config["Device"]
  simulator = specs_config["SimulatorVersion"]
  destination = "name=#{platform},OS=#{simulator}"
  "-destination \"platform=iOS Simulator,#{destination}\""
end

def project_scheme_argumets
  workspace = CONFIG["Workspace"]
  "-workspace #{workspace}.xcworkspace -scheme #{workspace}"
end

desc 'Runs xcodebuild clean'
task :clean do
  system_or_exit("xcodebuild #{project_scheme_argumets} clean | xcpretty -c")
end

desc 'Runs specs'
task :specs do
  system_or_exit("xcodebuild test #{project_scheme_argumets} -sdk iphonesimulator #{destination_platform} | xcpretty -c --no-utf --test")
end
