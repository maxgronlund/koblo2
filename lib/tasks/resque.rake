namespace :queue do
  task :restart_workers => :environment do
    pids = Array.new
    
    Resque.workers.each do |worker|
      pids.concat(worker.worker_pids)
    end
    
    system("kill -QUIT #{pids.join(' ')} && rm -f /var/run/god/resque-*.pid")
  end
end

