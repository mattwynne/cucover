Logging.configure do
  logger('Cucover') do
    level     :debug
    appenders 'logfile'
  end

  appender('logfile') do
     type      'File'
     level     :debug
     filename  File.dirname(__FILE__) + '/../../tmp/cucover.log'
     layout do
       type        'Pattern'
       pattern     '[%d] %l  %c : %m\n'
     end
   end  
end
