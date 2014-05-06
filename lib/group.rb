require 'yaml'

class Group
  def self.all
    @all ||= YAML.load(File.read("./config/categories.yml"))
  end

  def self.find(id)
    group = all.find { |group| group['id'] == id }
    group || raise("Group '#{id}' not found.")
  end
end
