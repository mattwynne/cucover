module Cucover
  module FeatureElement
    def reset_skipped_steps!
      return unless @steps
      @steps.each do |step|
        step.instance_variable_set("@skip_invoke", nil)
      end
    end
  end
end

module Cucover
  include FeatureElement

  module ExampleRowExtensions
    def file_colon_line
      "#{file}:#{line}"
    end

    def file
      @scenario_outline.file_colon_line.split(':').first
    end
  end
end

Cucover::Monkey.extend_every Cucumber::Ast::Scenario => Cucover::FeatureElement
Cucover::Monkey.extend_every Cucumber::Ast::OutlineTable::ExampleRow => Cucover::ExampleRowExtensions

Before do |scenario_or_table_row|
  scenario_or_table_row.reset_skipped_steps!

  Cucover.logger.info("Starting #{scenario_or_table_row.class} #{scenario_or_table_row.file_colon_line}")
  Cucover::Rails.patch_if_necessary

  if Cucover.should_execute?(scenario_or_table_row)
    Cucover.start_recording!(scenario_or_table_row)
  else
    announce "[ Cucover - Skipping clean scenario ]"
    scenario_or_table_row.skip_invoke!
  end
end

After do
  Cucover.stop_recording!
end
