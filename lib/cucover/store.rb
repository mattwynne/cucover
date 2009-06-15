module Cucover
  class Store
    def keep(recording)
      
    end
    
    def fetch_recordings_covering(source_file)
      [ FakeRecording.new ]
    end
    
    class FakeRecording
      def feature_filename
        "features/call_foo.feature"
      end
      def covers_line?(line_number)
        true unless [5,6,7,8].include?(line_number)
      end
    end
    
  end
end


#   class Cache
#     def initialize(test_identifier)
#       @test_identifier = test_identifier
#     end
#     
#     def exists?
#       File.exist?(cache_file)
#     end
#     
#     private
#     
#     def cache_file
#       cache_folder + '/' + cache_filename
#     end
#     
#     def cache_folder
#       @test_identifier.file.gsub(/([^\/]*\.feature)/, ".coverage/\\1/#{@test_identifier.line.to_s}")
#     end
#     
#     def time
#       File.mtime(cache_file)
#     end
# 
#     def write_to_cache
#       FileUtils.mkdir_p File.dirname(cache_file)
#       File.open(cache_file, "w") do |file|
#         yield file
#       end
#     end
#     
#     def cache_content
#       File.readlines(cache_file)
#     end
#   end
#   
#   class StatusCache < Cache
#     def last_run_status
#       cache_content.to_s.strip
#     end
#     
#     def record(status)
#       write_to_cache do |file|
#         file.puts status
#       end
#     end
#     
#     private
# 
#     def cache_filename
#       'last_run_status'
#     end
#   end
#   
#   class SourceFileCache < Cache
#     def save(analyzed_files)
#       write_to_cache do |file|
#         file.puts analyzed_files
#       end
#     end
#     
#     def any_dirty_files?
#       not dirty_files.empty?
#     end
#     
#     private
#     
#     def cache_filename
#       'covered_source_files'
#     end
# 
#     def source_files
#       cache_content
#     end
# 
#     def dirty_files
#       source_files.select do |source_file|
#         !File.exist?(source_file.strip) or (File.mtime(source_file.strip) >= time)
#       end
#     end
#   end