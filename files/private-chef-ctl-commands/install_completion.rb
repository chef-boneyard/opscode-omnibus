add_command "install-completion", "Create and install bash completion for the 'chef-server-ctl' command.", 2 do
  if Process.uid != 0
    STDERR.puts "This command should be run as root."
    exit 1
  end

  base = File.expand_path("/etc")
  completion_load_path = File.join(base, "profile.d")
  completion_file_path = File.join(completion_load_path, "_chef-server-ctl.sh")
  sub_commands = []

  command_map.keys.sort.each do |command|
    sub_commands << command
  end

  completion_template = <<-COMPLETION
_chef-server-ctl()
{
  local cur=${COMP_WORDS[COMP_CWORD]}
  sub_commands=(#{sub_commands.join(' ')})
  if [ $COMP_CWORD -eq 1 ]; then
    COMPREPLY=( $(compgen -W "${sub_commands[*]}" -- $cur) )
  elif [ $COMP_CWORD -eq 2 ]; then
    COMPREPLY=( $(compgen -W "${sub_commands[*]}" -- $cur) )
  else
    COMPREPLY=()
  fi
}
complete -F _chef-server-ctl private-chef-ctl chef-server-ctl
COMPLETION

  if Dir.exists?(completion_load_path)
    STDOUT.puts "\"#{completion_load_path}\" already exists."
  else
    STDOUT.puts "Created #{completion_load_path} directory." if FileUtils.mkdir_p(completion_load_path)
  end

  if File.exists?(completion_file_path)
    STDOUT.puts "\"#{completion_file_path}\" already exists."
  else
    STDOUT.puts "Created \"#{completion_file_path}\"." if File.open(completion_file_path, 'w') { |file| file.write(completion_template) }
  end
end
