CONFIG = begin
           YAML.load_file("#{Rails.root}/config/misc.yml").freeze
         rescue
           {}.freeze
         end
