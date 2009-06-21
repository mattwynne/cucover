module Cucover
  module ExampleRowExtensions
    def file_colon_line
      "#{file}:#{line}"
    end
    
    def file
      @scenario_outline.file_colon_line.split(':').first
    end
  end
end

Cucover::Monkey.extend_every Cucumber::Ast::OutlineTable::ExampleRow => Cucover::ExampleRowExtensions

Before do |scenario_or_table_row|
  Cucover.logger.info("Starting #{scenario_or_table_row.class} #{scenario_or_table_row.file_colon_line}")
  Cucover::Rails.patch_if_necessary
  
  if Cucover::Controller[scenario_or_table_row].should_execute?    
    Cucover::Recording.start(scenario_or_table_row)
  else
    announce "[ Cucover - Skipping clean scenario ]"
    scenario_or_table_row.skip_invoke!
  end
end

After do
  Cucover::Recording.stop
end
