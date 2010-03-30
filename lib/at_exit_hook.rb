at_exit do
  exit(Cucover::CliCommands::Cucumber.exit_status || 0)
end