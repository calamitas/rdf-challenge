# ruby -J-Xmx2048m -J-Xms512m -S rake rdf:load_dataset --trace

namespace :rdf do
  
  desc "Order the data set from linkedct"
  task :order_dataset do
    order = lambda do |line|
      if line
        if /\A<([^>]+)> <([^>]+)> (.+)/ === line
          [$3[0, 1] == "<" ? 1 : 0, $1] # Sort attributes first, then relations. Sort attributes per subject URL
        else
          puts "Can't parse #{line.inspect}"
        end
      else
        [2] # Select nils last
      end
    end
    # First we split the file in 10 more or less equal but sorted pieces that can be loaded into memory
    lines_per_part = 703598
    counter = 0
    part_counter = 0
    per_part_counter = 0
    File.open("dataset/linkedct-dump-10032009.nt") do |f|
      write_out = lambda do |data|
        part_counter += 1
        File.open("dataset/linkedct.#{part_counter}", "w") do |output|
          data.sort_by(&order).each { |line| output.puts line }
        end
      end
      data = []
      while line = f.gets
        data << line
        counter += 1
        per_part_counter += 1
        if counter % 1000 == 0
          p counter
        end
        if per_part_counter >= lines_per_part
          per_part_counter = 0
          write_out[data]
          data = []
        end
      end
      write_out[data]
    end
    # Then we merge the 10 files
    files = (1..10).map { |i| File.open("dataset/linkedct.#{i}", "r") }
    lines = files.map { |f| f.gets }
    counter = 0
    File.open("dataset/linkedct.nt", "w") do |f|
      loop do
        counter += 1
        if counter % 1000 == 0
          p counter
        end
        if min = lines.min_by(&order)
          min_index = lines.index(min)
          f.puts min
          lines[min_index] = files[min_index].gets
        else
          break
        end
      end
    end
    files.each(&:close)
  end
  
  desc "Load the data set from linkedct"
  task :load_dataset => :environment do
    log_file = File.open("log/load_dataset.log", "w")
    system "rm -rf db/neo4j-development"
    # /Users/peter/Desktop/linkedct-dump-10032009.nt
    # linkedct.nt
    RDF::Reader.open("dataset/linkedct.nt", :format => :ntriples) do |reader|
      inserter = Neo4j::Batch::Inserter.new
      begin
        counter = 0
        start_time = Time.now
        times = [Time.now]
        total_lines = 7035974.0
        object_map = {}
        old_from_key = nil
        current_attributes = {}
        reader.each_statement do |statement|
          from_key = statement.subject.to_s.sub(/\Ahttp:\/\/data.linkedct.org\/resource\//, "")
          if old_from_key && from_key != old_from_key
            current_attributes["rdf_url"] = "http://data.linkedct.org/resource/" + old_from_key
            object_map[old_from_key] = inserter.create_node(current_attributes, File.dirname(old_from_key).camelize.constantize)
            current_attributes = {}
            old_from_key = nil
          end
          case statement.predicate.to_s
          when /\Ahttp:\/\/data\.linkedct\.org\/resource\/linkedct\/(.+)/
            attr_name = $1
            if RDF::URI === statement.object
              to_key = statement.object.to_s.sub(/\Ahttp:\/\/data.linkedct.org\/resource\//, "")
              from = object_map[from_key]
              to = object_map[to_key]
              if !to || !from
                log_file.puts "Can't create rel #{attr_name} from #{from_key} to #{to_key}"
              else
                rel_name = attr_name.to_sym
                inserter.create_rel(rel_name, from, to)
              end
            else
              old_from_key = from_key
              value = RDF::XSD.int == statement.object.datatype ? statement.object.value.to_i : statement.object.value
              current_attributes[attr_name] = value
            end
          when "http://www.w3.org/2000/01/rdf-schema#label"
          when "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
          when "http://xmlns.com/foaf/0.1/page"
          when "http://xmlns.com/foaf/0.1/based_near"
          when "http://www.w3.org/2002/07/owl#sameAs"
          when "http://www.w3.org/2000/01/rdf-schema#seeAlso"
          else
            raise "unsupported predicate #{statement.predicate.inspect}"
          end
          counter += 1
          if counter % 1000 == 0
            duration_formatter = lambda do |f|
              "%02d:%02d:%04.1f" % [f / 3600, (f / 60) % 60, f % 60]
            end
            now = Time.now
            sample_time = now - times.first
            sample_count = times.length * 1000
            sample_speed = sample_time / sample_count
            times << now
            times.shift if times.length > 100
            fraction_complete = counter / total_lines
            time_elapsed = now - start_time
            p [counter, "%.2f%%" % (fraction_complete * 100), duration_formatter[time_elapsed], duration_formatter[(total_lines - counter) * sample_speed]]
          end
        end
      ensure
        inserter.shutdown
      end
    end
    log_file.close
  end

end
