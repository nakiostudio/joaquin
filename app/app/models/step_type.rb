class StepType < ActiveRecord::Base

  def payload
    return {
      id: self.id,
      slug: self.slug,
      name: self.name,
      plugin: self.plugin_payload
    }
  end

  def payload_with_script
    payload = self.payload()
    payload[:script] = self.script
    return payload
  end

  def plugin_payload
    plugin_id = self.plugin_path.split('/').last.camelize
    plugins_directory = Rails.root.join('plugins')
    require File.join(plugins_directory, self.plugin_path)
    payload = "Plugins::#{plugin_id.camelize}".constantize.send("payload")
    payload.reverse_merge!({
      path: self.plugin_path,
      data: JSON.parse(self.plugin_data ? self.plugin_data : '{}')
    })
    return payload
  end

end
